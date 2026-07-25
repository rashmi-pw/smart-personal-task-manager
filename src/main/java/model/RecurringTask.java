package model;

import java.time.LocalDate;

/**
 * RecurringTask class representing tasks that repeat on a regular schedule.
 * Demonstrates inheritance and polymorphism in OOP.
 */
public class RecurringTask extends Task {
    private String recurrenceType; // Daily, Weekly, Monthly

    public RecurringTask() {
        super();
    }

    public RecurringTask(int taskId, String title, String description, LocalDate dueDate, String priority, String status, String recurrenceType) {
        // Call superclass constructor without Category (category can be set via setter)
        super(taskId, title, description, dueDate, priority, status, null);
        this.recurrenceType = recurrenceType;
    }

    public String getRecurrenceType() {
        return recurrenceType;
    }

    public void setRecurrenceType(String recurrenceType) {
        this.recurrenceType = recurrenceType;
    }

    /**
     * Calculates the next occurrence of the task based on recurrenceType and dueDate.
     * @return LocalDate of the next occurrence
     */
    public LocalDate getNextOccurrence() {
        LocalDate currentDueDate = getDueDate();
        if (currentDueDate == null) {
            return LocalDate.now();
        }
        
        if (recurrenceType == null) {
            return currentDueDate;
        }

        switch (recurrenceType.toLowerCase()) {
            case "daily":
                return currentDueDate.plusDays(1);
            case "weekly":
                return currentDueDate.plusWeeks(1);
            case "monthly":
                return currentDueDate.plusMonths(1);
            default:
                return currentDueDate;
        }
    }

    @Override
    public String toString() {
        return "RecurringTask{" +
                "taskId=" + getTaskId() +
                ", title='" + getTitle() + '\'' +
                ", dueDate=" + getDueDate() +
                ", priority='" + getPriority() + '\'' +
                ", status='" + getStatus() + '\'' +
                ", category=" + getCategory() +
                ", recurrenceType='" + recurrenceType + '\'' +
                '}';
    }
}
