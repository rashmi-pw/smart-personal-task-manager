<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="model.Notification" %>
<%@ page import="model.Task" %>
<%@ page import="util.DateConverter" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reminders - Smart Task Manager</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- FontAwesome Icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <!-- Custom Style -->
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
</head>
<body>

    <div class="app-container">
        <!-- Sidebar Navigation -->
        <%@ include file="sidebar.jsp" %>

        <!-- Main Content Area -->
        <main class="app-content">
            <div class="page-header">
                <div class="page-title">
                    <h2>Task Reminders</h2>
                    <p>Schedule notification reminders for your active tasks.</p>
                </div>
                <div>
                    <button class="btn btn-primary-custom px-4 py-2" data-bs-toggle="modal" data-bs-target="#addNotificationModal">
                        <i class="fa-solid fa-plus me-1"></i> Add Reminder
                    </button>
                </div>
            </div>

            <!-- Notifications Table -->
            <div class="content-card">
                <div class="table-responsive">
                    <table class="table table-custom table-hover align-middle mb-0">
                        <thead>
                            <tr>
                                <th>Reminder Message</th>
                                <th>Associated Task</th>
                                <th>Scheduled Time</th>
                                <th style="text-align: right; width: 30%;">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                ArrayList<Notification> notificationsList = (ArrayList<Notification>) request.getAttribute("notificationsList");
                                ArrayList<Task> tasksList = (ArrayList<Task>) request.getAttribute("tasksList");
                                
                                if (notificationsList != null && !notificationsList.isEmpty()) {
                                    for (Notification n : notificationsList) {
                                        String taskTitle = "Unknown Task";
                                        if (tasksList != null) {
                                            for (Task t : tasksList) {
                                                if (t.getTaskId() == n.getTaskId()) {
                                                    taskTitle = t.getTitle();
                                                    break;
                                                }
                                            }
                                        }
                            %>
                                        <tr>
                                            <td class="font-weight-600 text-white"><%= n.getMessage() %></td>
                                            <td><span class="text-secondary"><%= taskTitle %></span></td>
                                            <td class="text-warning">
                                                <i class="fa-regular fa-clock me-1"></i> <%= DateConverter.formatDateTime(n.getReminderTime()) %>
                                            </td>
                                            <td style="text-align: right;">
                                                <a href="${pageContext.request.contextPath}/notification?action=trigger&notificationId=<%= n.getNotificationId() %>" 
                                                   class="btn btn-sm btn-outline-warning me-2" title="Trigger Reminder Simulation">
                                                    <i class="fa-solid fa-volume-high me-1"></i> Trigger
                                                </a>
                                                <button class="btn btn-sm btn-outline-light me-2" 
                                                        data-bs-toggle="modal" 
                                                        data-bs-target="#editNotificationModal"
                                                        onclick="editNotification(
                                                            <%= n.getNotificationId() %>, 
                                                            '<%= n.getMessage().replace("'", "\\'") %>', 
                                                            '<%= DateConverter.formatDateTime(n.getReminderTime()) %>', 
                                                            <%= n.getTaskId() %>
                                                        )">
                                                    <i class="fa-regular fa-pen-to-square me-1"></i> Edit
                                                </button>
                                                <a href="${pageContext.request.contextPath}/notification?action=delete&notificationId=<%= n.getNotificationId() %>" 
                                                   class="btn btn-sm btn-outline-danger" 
                                                   onclick="return confirm('Are you sure you want to delete this reminder?');">
                                                    <i class="fa-regular fa-trash-can me-1"></i> Delete
                                                </a>
                                            </td>
                                        </tr>
                            <%
                                    }
                                } else {
                            %>
                                <tr>
                                    <td colspan="4" class="text-center py-5 text-secondary">
                                        <i class="fa-regular fa-bell-slash d-block mb-3" style="font-size: 2.5rem;"></i>
                                        No reminders set. Click "Add Reminder" to schedule one!
                                    </td>
                                </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>

    <!-- ADD NOTIFICATION MODAL -->
    <div class="modal fade" id="addNotificationModal" tabindex="-1" aria-labelledby="addNotificationModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content modal-content-custom">
                <div class="modal-header modal-header-custom">
                    <h5 class="modal-title font-weight-700" id="addNotificationModalLabel"><i class="fa-solid fa-bell-plus text-primary me-2"></i>Add Reminder</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="${pageContext.request.contextPath}/notification" method="POST">
                    <input type="hidden" name="action" value="add">
                    <div class="modal-body p-4 row g-3">
                        <div class="col-12">
                            <label for="addTaskId" class="form-label text-secondary">Associate with Task</label>
                            <select class="form-select form-control-custom" id="addTaskId" name="taskId" required>
                                <option value="" disabled selected>Select task...</option>
                                <%
                                    if (tasksList != null) {
                                        for (Task t : tasksList) {
                                %>
                                            <option value="<%= t.getTaskId() %>"><%= t.getTitle() %></option>
                                <%
                                        }
                                    }
                                %>
                            </select>
                        </div>
                        <div class="col-12">
                            <label for="addMessage" class="form-label text-secondary">Reminder Message</label>
                            <input type="text" class="form-control form-control-custom" id="addMessage" name="message" required placeholder="e.g. Finish coding the database connection">
                        </div>
                        <div class="col-12">
                            <label for="addReminderTime" class="form-label text-secondary">Reminder Date & Time</label>
                            <input type="datetime-local" class="form-control form-control-custom" id="addReminderTime" name="reminderTime" required>
                        </div>
                    </div>
                    <div class="modal-footer modal-footer-custom">
                        <button type="button" class="btn btn-outline-secondary px-4" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary px-4">Set Reminder</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- EDIT NOTIFICATION MODAL -->
    <div class="modal fade" id="editNotificationModal" tabindex="-1" aria-labelledby="editNotificationModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content modal-content-custom">
                <div class="modal-header modal-header-custom">
                    <h5 class="modal-title font-weight-700" id="editNotificationModalLabel"><i class="fa-regular fa-pen-to-square text-primary me-2"></i>Edit Reminder</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="${pageContext.request.contextPath}/notification" method="POST">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" id="editNotificationId" name="notificationId">
                    <div class="modal-body p-4 row g-3">
                        <div class="col-12">
                            <label for="editTaskId" class="form-label text-secondary">Associate with Task</label>
                            <select class="form-select form-control-custom" id="editTaskId" name="taskId" required>
                                <%
                                    if (tasksList != null) {
                                        for (Task t : tasksList) {
                                %>
                                            <option value="<%= t.getTaskId() %>"><%= t.getTitle() %></option>
                                <%
                                        }
                                    }
                                %>
                            </select>
                        </div>
                        <div class="col-12">
                            <label for="editMessage" class="form-label text-secondary">Reminder Message</label>
                            <input type="text" class="form-control form-control-custom" id="editMessage" name="message" required>
                        </div>
                        <div class="col-12">
                            <label for="editReminderTime" class="form-label text-secondary">Reminder Date & Time</label>
                            <input type="datetime-local" class="form-control form-control-custom" id="editReminderTime" name="reminderTime" required>
                        </div>
                    </div>
                    <div class="modal-footer modal-footer-custom">
                        <button type="button" class="btn btn-outline-secondary px-4" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary px-4">Save Changes</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Custom Script & Bootstrap 5 JS -->
    <script src="${pageContext.request.contextPath}/js/main.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
