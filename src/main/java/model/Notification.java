package model;

import java.time.LocalDateTime;

/**
 * Notification class representing task reminders.
 * Implements the Reminder interface, demonstrating interface implementation and polymorphism.
 */
public class Notification implements Reminder {
    private int notificationId;
    private String message;
    private LocalDateTime reminderTime;
    private int taskId; // Links to Task as per ER diagram and SQL schema

    public Notification() {
    }

    public Notification(int notificationId, String message, LocalDateTime reminderTime) {
        this.notificationId = notificationId;
        this.message = message;
        this.reminderTime = reminderTime;
    }

    // Getters and Setters
    public int getNotificationId() {
        return notificationId;
    }

    public void setNotificationId(int notificationId) {
        this.notificationId = notificationId;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public LocalDateTime getReminderTime() {
        return reminderTime;
    }

    public void setReminderTime(LocalDateTime reminderTime) {
        this.reminderTime = reminderTime;
    }

    public int getTaskId() {
        return taskId;
    }

    public void setTaskId(int taskId) {
        this.taskId = taskId;
    }

    // Business Methods matching UML
    public void sendNotification() {
        System.out.println("[NOTIFICATION SENT] ID: " + notificationId + " | Message: " + message + " | Time: " + reminderTime);
    }

    @Override
    public void sendReminder() {
        System.out.println("[REMINDER TRIGGERED] Task ID: " + taskId + " | Msg: " + message);
        sendNotification();
    }

    @Override
    public String toString() {
        return "Notification{" +
                "notificationId=" + notificationId +
                ", message='" + message + '\'' +
                ", reminderTime=" + reminderTime +
                ", taskId=" + taskId +
                '}';
    }
}
