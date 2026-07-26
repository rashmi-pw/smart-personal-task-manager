package model;

import java.util.ArrayList;
import dao.TaskDAO;

/**
 * TaskManager class acting as a controller/wrapper for collection-level task operations.
 * Manages an ArrayList of Tasks, demonstrating encapsulation and collection handling.
 */
public class TaskManager {
    private ArrayList<Task> taskList;
    private TaskDAO taskDAO;

    public TaskManager() {
        this.taskList = new ArrayList<>();
        this.taskDAO = new TaskDAO();
    }

    /**
     * Initializes TaskManager for a specific user, pre-loading their tasks.
     * @param userId the ID of the user whose tasks are loaded
     */
    public TaskManager(int userId) {
        this();
        this.taskList = taskDAO.getTasksByUserId(userId);
    }

    public ArrayList<Task> getTaskList() {
        return taskList;
    }

    public void setTaskList(ArrayList<Task> taskList) {
        this.taskList = taskList;
    }

    // Business Methods matching UML
    public void addTask(Task task) {
        if (taskDAO.create(task)) {
            taskList.add(task);
        }
    }

    public void removeTask(int taskId) {
        if (taskDAO.delete(taskId)) {
            taskList.removeIf(t -> t.getTaskId() == taskId);
        }
    }

    public void updateTask(Task task) {
        if (taskDAO.update(task)) {
            for (int i = 0; i < taskList.size(); i++) {
                if (taskList.get(i).getTaskId() == task.getTaskId()) {
                    taskList.set(i, task);
                    break;
                }
            }
        }
    }

    public Task searchTask(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return null;
        }
        String lowerKeyword = keyword.toLowerCase();
        for (Task task : taskList) {
            if (task.getTitle().toLowerCase().contains(lowerKeyword) || 
                (task.getDescription() != null && task.getDescription().toLowerCase().contains(lowerKeyword))) {
                return task;
            }
        }
        return null;
    }

    public ArrayList<Task> filterByPriority(String priority) {
        ArrayList<Task> filtered = new ArrayList<>();
        if (priority == null || priority.trim().isEmpty()) {
            return filtered;
        }
        for (Task task : taskList) {
            if (task.getPriority().equalsIgnoreCase(priority)) {
                filtered.add(task);
            }
        }
        return filtered;
    }

    public ArrayList<Task> viewAllTasks() {
        return this.taskList;
    }
}
