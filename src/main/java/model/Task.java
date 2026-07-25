package model;

import java.time.LocalDate;
import dao.TaskDAO;

/**
 * Task model class representing tasks in the system.
 */
public class Task {
    private int taskId;
    private String title;
    private String description;
    private LocalDate dueDate;
    private String priority;
    private String status;
    private Category category;
    private int userId; // Links to User as per ER diagram and SQL

    public Task() {
    }

    public Task(int taskId, String title, String description, LocalDate dueDate, String priority, String status, Category category) {
        this.taskId = taskId;
        this.title = title;
        this.description = description;
        this.dueDate = dueDate;
        this.priority = priority;
        this.status = status;
        this.category = category;
    }

    // Getters and Setters
    public int getTaskId() {
        return taskId;
    }

    public void setTaskId(int taskId) {
        this.taskId = taskId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public LocalDate getDueDate() {
        return dueDate;
    }

    public void setDueDate(LocalDate dueDate) {
        this.dueDate = dueDate;
    }

    public String getPriority() {
        return priority;
    }

    public void setPriority(String priority) {
        this.priority = priority;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Category getCategory() {
        return category;
    }

    public void setCategory(Category category) {
        this.category = category;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    // Business Methods matching UML
    public void updateTask() {
        TaskDAO taskDAO = new TaskDAO();
        taskDAO.update(this);
    }

    public void markCompleted() {
        this.status = "Completed";
        TaskDAO taskDAO = new TaskDAO();
        taskDAO.updateStatus(this.taskId, "Completed");
    }

    @Override
    public String toString() {
        return "Task{" +
                "taskId=" + taskId +
                ", title='" + title + '\'' +
                ", dueDate=" + dueDate +
                ", priority='" + priority + '\'' +
                ", status='" + status + '\'' +
                ", category=" + category +
                ", userId=" + userId +
                '}';
    }
}
