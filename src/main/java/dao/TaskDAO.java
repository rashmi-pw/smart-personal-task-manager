package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import database.DBConnection;
import model.Category;
import model.Task;
import model.RecurringTask;
import util.DateConverter;

/**
 * Data Access Object for Task and RecurringTask operations.
 * Demonstrates manual ORM (Object-Relational Mapping) and Polymorphism.
 */
public class TaskDAO {

    /**
     * Creates a new Task or RecurringTask in the database.
     * @param task the Task object to insert
     * @return true if successful
     */
    public boolean create(Task task) {
        String insertTaskSql = "INSERT INTO tasks (title, description, dueDate, priority, status, userId, categoryId) VALUES (?, ?, ?, ?, ?, ?, ?)";
        String insertRecurringSql = "INSERT INTO recurring_tasks (taskId, recurrenceType) VALUES (?, ?)";
        
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Start transaction

            try (PreparedStatement psTask = conn.prepareStatement(insertTaskSql, PreparedStatement.RETURN_GENERATED_KEYS)) {
                psTask.setString(1, task.getTitle());
                psTask.setString(2, task.getDescription());
                psTask.setDate(3, DateConverter.toSqlDate(task.getDueDate()));
                psTask.setString(4, task.getPriority());
                psTask.setString(5, task.getStatus());
                psTask.setInt(6, task.getUserId());
                psTask.setInt(7, task.getCategory().getCategoryId());

                int affected = psTask.executeUpdate();
                if (affected > 0) {
                    try (ResultSet rs = psTask.getGeneratedKeys()) {
                        if (rs.next()) {
                            task.setTaskId(rs.getInt(1));
                        }
                    }

                    // If it is a RecurringTask, insert into recurring_tasks table
                    if (task instanceof RecurringTask) {
                        RecurringTask recTask = (RecurringTask) task;
                        try (PreparedStatement psRec = conn.prepareStatement(insertRecurringSql)) {
                            psRec.setInt(1, recTask.getTaskId());
                            psRec.setString(2, recTask.getRecurrenceType());
                            psRec.executeUpdate();
                        }
                    }
                    conn.commit(); // Commit transaction
                    return true;
                }
            } catch (SQLException e) {
                if (conn != null) {
                    conn.rollback();
                }
                throw e;
            }
        } catch (SQLException e) {
            System.err.println("Error creating task: " + e.getMessage());
            e.printStackTrace();
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        }
        return false;
    }

    /**
     * Updates an existing Task or RecurringTask.
     * @param task the Task to update
     * @return true if successful
     */
    public boolean update(Task task) {
        String updateTaskSql = "UPDATE tasks SET title = ?, description = ?, dueDate = ?, priority = ?, status = ?, categoryId = ? WHERE taskId = ?";
        String insertOrUpdateRecurringSql = "INSERT INTO recurring_tasks (taskId, recurrenceType) VALUES (?, ?) ON DUPLICATE KEY UPDATE recurrenceType = ?";
        String deleteRecurringSql = "DELETE FROM recurring_tasks WHERE taskId = ?";

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Start transaction

            try (PreparedStatement psTask = conn.prepareStatement(updateTaskSql)) {
                psTask.setString(1, task.getTitle());
                psTask.setString(2, task.getDescription());
                psTask.setDate(3, DateConverter.toSqlDate(task.getDueDate()));
                psTask.setString(4, task.getPriority());
                psTask.setString(5, task.getStatus());
                psTask.setInt(6, task.getCategory().getCategoryId());
                psTask.setInt(7, task.getTaskId());

                int affected = psTask.executeUpdate();
                if (affected > 0) {
                    if (task instanceof RecurringTask) {
                        RecurringTask recTask = (RecurringTask) task;
                        try (PreparedStatement psRec = conn.prepareStatement(insertOrUpdateRecurringSql)) {
                            psRec.setInt(1, recTask.getTaskId());
                            psRec.setString(2, recTask.getRecurrenceType());
                            psRec.setString(3, recTask.getRecurrenceType());
                            psRec.executeUpdate();
                        }
                    } else {
                        // In case it was previously a recurring task, clean it up
                        try (PreparedStatement psDel = conn.prepareStatement(deleteRecurringSql)) {
                            psDel.setInt(1, task.getTaskId());
                            psDel.executeUpdate();
                        }
                    }
                    conn.commit();
                    return true;
                }
            } catch (SQLException e) {
                if (conn != null) {
                    conn.rollback();
                }
                throw e;
            }
        } catch (SQLException e) {
            System.err.println("Error updating task: " + e.getMessage());
            e.printStackTrace();
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        }
        return false;
    }

    /**
     * Deletes a task by ID.
     * Due to foreign key cascades (ON DELETE CASCADE), this automatically deletes related recurring_tasks and notifications.
     * @param taskId the task ID
     * @return true if successful
     */
    public boolean delete(int taskId) {
        String sql = "DELETE FROM tasks WHERE taskId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, taskId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error deleting task: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Updates the status of a task.
     * @param taskId the task ID
     * @param status the new status
     * @return true if successful
     */
    public boolean updateStatus(int taskId, String status) {
        String sql = "UPDATE tasks SET status = ? WHERE taskId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, taskId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error updating task status: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Retrieves all tasks for a specific user.
     * Uses LEFT JOIN to load recurrence fields and construct the correct polymorphic class.
     * @param userId the user ID
     * @return list of tasks
     */
    public ArrayList<Task> getTasksByUserId(int userId) {
        ArrayList<Task> list = new ArrayList<>();
        String sql = "SELECT t.taskId, t.title, t.description, t.dueDate, t.priority, t.status, t.userId, t.categoryId, " +
                     "c.categoryName, r.recurrenceType " +
                     "FROM tasks t " +
                     "INNER JOIN categories c ON t.categoryId = c.categoryId " +
                     "LEFT JOIN recurring_tasks r ON t.taskId = r.taskId " +
                     "WHERE t.userId = ? " +
                     "ORDER BY t.dueDate ASC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int taskId = rs.getInt("taskId");
                    String title = rs.getString("title");
                    String description = rs.getString("description");
                    LocalDate dueDate = DateConverter.toLocalDate(rs.getDate("dueDate"));
                    String priority = rs.getString("priority");
                    String status = rs.getString("status");
                    
                    Category category = new Category(
                        rs.getInt("categoryId"),
                        rs.getString("categoryName")
                    );
                    
                    String recurrenceType = rs.getString("recurrenceType");
                    Task task;
                    if (recurrenceType != null) {
                        task = new RecurringTask(taskId, title, description, dueDate, priority, status, recurrenceType);
                    } else {
                        task = new Task(taskId, title, description, dueDate, priority, status, category);
                    }
                    task.setCategory(category);
                    task.setUserId(rs.getInt("userId"));
                    list.add(task);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting tasks by user ID: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Retrieves a single task by ID.
     * @param taskId the task ID
     * @return Task or RecurringTask object, or null
     */
    public Task getById(int taskId) {
        String sql = "SELECT t.taskId, t.title, t.description, t.dueDate, t.priority, t.status, t.userId, t.categoryId, " +
                     "c.categoryName, r.recurrenceType " +
                     "FROM tasks t " +
                     "INNER JOIN categories c ON t.categoryId = c.categoryId " +
                     "LEFT JOIN recurring_tasks r ON t.taskId = r.taskId " +
                     "WHERE t.taskId = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, taskId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String title = rs.getString("title");
                    String description = rs.getString("description");
                    LocalDate dueDate = DateConverter.toLocalDate(rs.getDate("dueDate"));
                    String priority = rs.getString("priority");
                    String status = rs.getString("status");
                    
                    Category category = new Category(
                        rs.getInt("categoryId"),
                        rs.getString("categoryName")
                    );
                    
                    String recurrenceType = rs.getString("recurrenceType");
                    Task task;
                    if (recurrenceType != null) {
                        task = new RecurringTask(taskId, title, description, dueDate, priority, status, recurrenceType);
                    } else {
                        task = new Task(taskId, title, description, dueDate, priority, status, category);
                    }
                    task.setCategory(category);
                    task.setUserId(rs.getInt("userId"));
                    return task;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting task by ID: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
}
