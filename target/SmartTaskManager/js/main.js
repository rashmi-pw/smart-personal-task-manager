// Main JavaScript Helpers for Smart Personal Task Manager

// Validate registration passwords match
function validateRegistration() {
    const password = document.getElementById('regPassword').value;
    const confirm = document.getElementById('regConfirmPassword').value;
    const errorDiv = document.getElementById('regError');

    if (password !== confirm) {
        errorDiv.textContent = "Passwords do not match.";
        errorDiv.classList.remove('d-none');
        return false;
    }
    errorDiv.classList.add('d-none');
    return true;
}

// Populate Category Edit Modal
function editCategory(categoryId, categoryName) {
    document.getElementById('editCategoryId').value = categoryId;
    document.getElementById('editCategoryName').value = categoryName;
}

// Populate Task Edit Modal
function editTask(taskId, title, description, dueDate, priority, status, categoryId, recurrenceType) {
    document.getElementById('editTaskId').value = taskId;
    document.getElementById('editTitle').value = title;
    document.getElementById('editDescription').value = description;
    document.getElementById('editDueDate').value = dueDate;
    document.getElementById('editPriority').value = priority;
    document.getElementById('editStatus').value = status;
    document.getElementById('editCategoryId').value = categoryId;
    
    const recSelect = document.getElementById('editRecurrenceType');
    if (recSelect) {
        if (!recurrenceType || recurrenceType === 'null' || recurrenceType === '') {
            recSelect.value = 'none';
        } else {
            recSelect.value = recurrenceType.toLowerCase();
        }
    }
}

// Populate Notification Edit Modal
function editNotification(notificationId, message, reminderTime, taskId) {
    document.getElementById('editNotificationId').value = notificationId;
    document.getElementById('editMessage').value = message;
    
    // Convert LocalDateTime format to fit datetime-local input (yyyy-MM-ddThh:mm)
    if (reminderTime) {
        const formattedTime = reminderTime.replace(' ', 'T');
        document.getElementById('editReminderTime').value = formattedTime;
    }
    
    document.getElementById('editTaskId').value = taskId;
}
