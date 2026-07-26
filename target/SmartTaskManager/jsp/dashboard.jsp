<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="model.Task" %>
<%@ page import="model.Category" %>
<%@ page import="model.Notification" %>
<%@ page import="util.DateConverter" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Smart Task Manager</title>
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
                    <h2>Overview Dashboard</h2>
                    <p>Welcome back, <%= sessionUser.getName() %>! Here is your task digest.</p>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/task?action=list" class="btn btn-primary-custom px-4 py-2">
                        <i class="fa-solid fa-plus me-1"></i> Add New Task
                    </a>
                </div>
            </div>

            <!-- Statistics Grid -->
            <section class="stats-grid">
                <div class="stats-card">
                    <div class="stats-icon tasks"><i class="fa-solid fa-list-check"></i></div>
                    <div class="stats-details">
                        <h3><%= request.getAttribute("totalTasks") %></h3>
                        <p>Total Tasks</p>
                    </div>
                </div>
                <div class="stats-card">
                    <div class="stats-icon pending"><i class="fa-regular fa-clock"></i></div>
                    <div class="stats-details">
                        <h3><%= request.getAttribute("pendingTasks") %></h3>
                        <p>Pending</p>
                    </div>
                </div>
                <div class="stats-card">
                    <div class="stats-icon completed"><i class="fa-regular fa-circle-check"></i></div>
                    <div class="stats-details">
                        <h3><%= request.getAttribute("completedTasks") %></h3>
                        <p>Completed</p>
                    </div>
                </div>
                <div class="stats-card">
                    <div class="stats-icon recurring"><i class="fa-solid fa-rotate"></i></div>
                    <div class="stats-details">
                        <h3><%= request.getAttribute("recurringCount") %></h3>
                        <p>Recurring</p>
                    </div>
                </div>
            </section>

            <!-- Dashboard Content Grid -->
            <div class="row g-4">
                <!-- Upcoming Tasks Column -->
                <div class="col-lg-7">
                    <div class="content-card">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h4 class="mb-0 font-weight-700" style="font-size: 1.15rem;"><i class="fa-solid fa-calendar-day text-primary me-2"></i>Upcoming Pending Tasks</h4>
                            <a href="${pageContext.request.contextPath}/task?action=list" class="text-primary text-decoration-none small">View all</a>
                        </div>
                        
                        <div class="table-responsive">
                            <table class="table table-custom table-borderless align-middle mb-0">
                                <thead>
                                    <tr>
                                        <th>Task Title</th>
                                        <th>Due Date</th>
                                        <th>Priority</th>
                                        <th>Category</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        ArrayList<Task> tasks = (ArrayList<Task>) request.getAttribute("tasks");
                                        boolean hasUpcoming = false;
                                        if (tasks != null && !tasks.isEmpty()) {
                                            int count = 0;
                                            for (Task t : tasks) {
                                                if (!"completed".equalsIgnoreCase(t.getStatus()) && count < 5) {
                                                    hasUpcoming = true;
                                                    count++;
                                                    String priorityClass = "badge-low";
                                                    if ("high".equalsIgnoreCase(t.getPriority())) priorityClass = "badge-high";
                                                    else if ("medium".equalsIgnoreCase(t.getPriority())) priorityClass = "badge-medium";
                                    %>
                                                    <tr>
                                                        <td class="font-weight-600"><%= t.getTitle() %></td>
                                                        <td class="text-secondary"><%= DateConverter.formatDate(t.getDueDate()) %></td>
                                                        <td><span class="badge-custom <%= priorityClass %>"><%= t.getPriority() %></span></td>
                                                        <td><span class="text-secondary"><%= t.getCategory().getCategoryName() %></span></td>
                                                        <td>
                                                            <a href="${pageContext.request.contextPath}/task?action=complete&taskId=<%= t.getTaskId() %>" class="btn btn-outline-success btn-sm rounded-circle p-1" style="width: 28px; height: 28px;" title="Mark Completed">
                                                                <i class="fa-solid fa-check"></i>
                                                            </a>
                                                        </td>
                                                    </tr>
                                    <%
                                                }
                                            }
                                        }
                                        if (!hasUpcoming) {
                                    %>
                                        <tr>
                                            <td colspan="5" class="text-center py-4 text-secondary">
                                                <i class="fa-regular fa-folder-open d-block mb-2" style="font-size: 2rem;"></i>
                                                No pending tasks. Great job!
                                            </td>
                                        </tr>
                                    <%
                                        }
                                    %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Recent Notifications/Reminders Column -->
                <div class="col-lg-5">
                    <div class="content-card">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h4 class="mb-0 font-weight-700" style="font-size: 1.15rem;"><i class="fa-solid fa-clock text-warning me-2"></i>Active Reminders</h4>
                            <a href="${pageContext.request.contextPath}/notification?action=list" class="text-primary text-decoration-none small">Manage</a>
                        </div>
                        
                        <div class="list-group list-group-flush bg-transparent">
                            <%
                                ArrayList<Notification> notifications = (ArrayList<Notification>) request.getAttribute("notifications");
                                boolean hasReminders = false;
                                if (notifications != null && !notifications.isEmpty()) {
                                    int count = 0;
                                    for (Notification n : notifications) {
                                        if (count < 4) {
                                            hasReminders = true;
                                            count++;
                            %>
                                            <div class="list-group-item bg-transparent border-0 px-0 pb-3 mb-2 d-flex align-items-start border-bottom border-secondary border-opacity-20">
                                                <div class="rounded bg-warning bg-opacity-15 p-2 text-warning me-3">
                                                    <i class="fa-regular fa-bell"></i>
                                                </div>
                                                <div class="flex-grow-1 overflow-hidden">
                                                    <h6 class="text-white mb-1 small text-truncate"><%= n.getMessage() %></h6>
                                                    <div class="text-secondary small d-flex align-items-center" style="font-size: 0.75rem;">
                                                        <i class="fa-regular fa-calendar-check me-1"></i> <%= DateConverter.formatDateTime(n.getReminderTime()) %>
                                                    </div>
                                                </div>
                                                <div>
                                                    <a href="${pageContext.request.contextPath}/notification?action=trigger&notificationId=<%= n.getNotificationId() %>" class="btn btn-sm btn-outline-warning" title="Simulate Alarm">
                                                        <i class="fa-solid fa-volume-high"></i>
                                                    </a>
                                                </div>
                                            </div>
                            <%
                                        }
                                    }
                                }
                                if (!hasReminders) {
                            %>
                                <div class="text-center py-4 text-secondary">
                                    <i class="fa-regular fa-bell-slash d-block mb-2" style="font-size: 2rem;"></i>
                                    No reminders configured.
                                </div>
                            <%
                                }
                            %>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <!-- Bootstrap 5 JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
