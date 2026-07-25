package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import database.DBConnection;
import model.Notification;
import util.DateConverter;

/**
 * Data Access Object for Notification/Reminder operations.
 */
public class NotificationDAO {

    /**
     * Creates a new notification reminder in the database.
     * @param notification Notification to create
     * @return true if successful
     */
    public boolean create(Notification notification) {
        String sql = "INSERT INTO notifications (message, reminderTime, taskId) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            
            ps.setString(1, notification.getMessage());
            ps.setTimestamp(2, DateConverter.toTimestamp(notification.getReminderTime()));
            ps.setInt(3, notification.getTaskId());
            
            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        notification.setNotificationId(rs.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            System.err.println("Error creating notification: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Updates an existing notification reminder.
     * @param notification Notification with updated details
     * @return true if successful
     */
    public boolean update(Notification notification) {
        String sql = "UPDATE notifications SET message = ?, reminderTime = ?, taskId = ? WHERE notificationId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, notification.getMessage());
            ps.setTimestamp(2, DateConverter.toTimestamp(notification.getReminderTime()));
            ps.setInt(3, notification.getTaskId());
            ps.setInt(4, notification.getNotificationId());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error updating notification: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Deletes a notification reminder by ID.
     * @param notificationId ID of the notification
     * @return true if successful
     */
    public boolean delete(int notificationId) {
        String sql = "DELETE FROM notifications WHERE notificationId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, notificationId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error deleting notification: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Retrieves a notification reminder by ID.
     * @param notificationId ID of the notification
     * @return Notification object or null
     */
    public Notification getById(int notificationId) {
        String sql = "SELECT notificationId, message, reminderTime, taskId FROM notifications WHERE notificationId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, notificationId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Notification n = new Notification(
                        rs.getInt("notificationId"),
                        rs.getString("message"),
                        DateConverter.toLocalDateTime(rs.getTimestamp("reminderTime"))
                    );
                    n.setTaskId(rs.getInt("taskId"));
                    return n;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error retrieving notification: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Retrieves all notifications for a specific user's tasks.
     * Joins notifications with tasks to filter by userId.
     * @param userId ID of the user
     * @return list of notifications
     */
    public ArrayList<Notification> getNotificationsByUserId(int userId) {
        ArrayList<Notification> list = new ArrayList<>();
        String sql = "SELECT n.notificationId, n.message, n.reminderTime, n.taskId " +
                     "FROM notifications n " +
                     "INNER JOIN tasks t ON n.taskId = t.taskId " +
                     "WHERE t.userId = ? " +
                     "ORDER BY n.reminderTime ASC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Notification n = new Notification(
                        rs.getInt("notificationId"),
                        rs.getString("message"),
                        DateConverter.toLocalDateTime(rs.getTimestamp("reminderTime"))
                    );
                    n.setTaskId(rs.getInt("taskId"));
                    list.add(n);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error retrieving user notifications: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Retrieves all notifications for a specific task.
     * @param taskId ID of the task
     * @return list of notifications
     */
    public ArrayList<Notification> getNotificationsByTaskId(int taskId) {
        ArrayList<Notification> list = new ArrayList<>();
        String sql = "SELECT notificationId, message, reminderTime, taskId " +
                     "FROM notifications " +
                     "WHERE taskId = ? " +
                     "ORDER BY reminderTime ASC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, taskId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Notification n = new Notification(
                        rs.getInt("notificationId"),
                        rs.getString("message"),
                        DateConverter.toLocalDateTime(rs.getTimestamp("reminderTime"))
                    );
                    n.setTaskId(rs.getInt("taskId"));
                    list.add(n);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error retrieving task notifications: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }
}
