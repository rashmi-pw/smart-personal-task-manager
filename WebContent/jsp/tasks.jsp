<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="model.Task" %>
<%@ page import="model.RecurringTask" %>
<%@ page import="model.Category" %>
<%@ page import="util.DateConverter" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tasks - Smart Task Manager</title>
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
                    <h2>Task Management</h2>
                    <p>Add, update, search, filter, and track all your tasks.</p>
                </div>
                <div>
                    <button class="btn btn-primary-custom px-4 py-2" data-bs-toggle="modal" data-bs-target="#addTaskModal">
                        <i class="fa-solid fa-plus me-1"></i> Add Task
                    </button>
                </div>
            </div>

            <!-- Filters Bar -->
            <div class="content-card mb-4">
                <form action="${pageContext.request.contextPath}/task" method="GET">
                    <input type="hidden" name="action" value="list">
                    <div class="row g-3 align-items-end">
                        <div class="col-md-3">
                            <label class="form-label text-secondary small">Filter by Category</label>
                            <select class="form-select form-control-custom" name="filterCategory">
                                <option value="">All Categories</option>
                                <%
                                    ArrayList<Category> categoriesList = (ArrayList<Category>) request.getAttribute("categoriesList");
                                    String currentCat = request.getParameter("filterCategory");
                                    if (categoriesList != null) {
                                        for (Category c : categoriesList) {
                                            boolean selected = currentCat != null && currentCat.equals(String.valueOf(c.getCategoryId()));
                                %>
                                            <option value="<%= c.getCategoryId() %>" <%= selected ? "selected" : "" %>><%= c.getCategoryName() %></option>
                                <%
                                        }
                                    }
                                %>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <label class="form-label text-secondary small">Priority</label>
                            <select class="form-select form-control-custom" name="filterPriority">
                                <option value="">All</option>
                                <%
                                    String currentPriority = request.getParameter("filterPriority");
                                    String[] priorities = {"Low", "Medium", "High"};
                                    for (String p : priorities) {
                                        boolean selected = currentPriority != null && currentPriority.equalsIgnoreCase(p);
                                %>
                                        <option value="<%= p %>" <%= selected ? "selected" : "" %>><%= p %></option>
                                <%
                                    }
                                %>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <label class="form-label text-secondary small">Status</label>
                            <select class="form-select form-control-custom" name="filterStatus">
                                <option value="">All</option>
                                <%
                                    String currentStatus = request.getParameter("filterStatus");
                                    String[] statuses = {"Pending", "Completed"};
                                    for (String s : statuses) {
                                        boolean selected = currentStatus != null && currentStatus.equalsIgnoreCase(s);
                                %>
                                        <option value="<%= s %>" <%= selected ? "selected" : "" %>><%= s %></option>
                                <%
                                    }
                                %>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label text-secondary small">Search Title/Desc</label>
                            <input type="text" class="form-control form-control-custom" name="searchQuery" value="<%= request.getParameter("searchQuery") != null ? request.getParameter("searchQuery") : "" %>" placeholder="Type keyword...">
                        </div>
                        <div class="col-md-2 d-flex">
                            <button type="submit" class="btn btn-primary w-100 me-2"><i class="fa-solid fa-filter me-1"></i> Filter</button>
                            <a href="${pageContext.request.contextPath}/task?action=list" class="btn btn-outline-secondary"><i class="fa-solid fa-rotate-left"></i></a>
                        </div>
                    </div>
                </form>
            </div>

            <!-- Tasks Table -->
            <div class="content-card">
                <div class="table-responsive">
                    <table class="table table-custom table-hover align-middle mb-0">
                        <thead>
                            <tr>
                                <th>Title</th>
                                <th>Category</th>
                                <th>Due Date</th>
                                <th>Priority</th>
                                <th>Recurrence</th>
                                <th>Status</th>
                                <th style="text-align: right;">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                ArrayList<Task> tasksList = (ArrayList<Task>) request.getAttribute("tasksList");
                                if (tasksList != null && !tasksList.isEmpty()) {
                                    for (Task t : tasksList) {
                                        String priorityClass = "badge-low";
                                        if ("high".equalsIgnoreCase(t.getPriority())) priorityClass = "badge-high";
                                        else if ("medium".equalsIgnoreCase(t.getPriority())) priorityClass = "badge-medium";

                                        String statusClass = "status-pending";
                                        if ("completed".equalsIgnoreCase(t.getStatus())) statusClass = "status-completed";

                                        String recurrenceText = "None";
                                        String recurrenceVal = "";
                                        if (t instanceof RecurringTask) {
                                            recurrenceText = ((RecurringTask) t).getRecurrenceType();
                                            recurrenceVal = recurrenceText;
                                        }
                            %>
                                        <tr>
                                            <td>
                                                <div class="font-weight-600 text-white"><%= t.getTitle() %></div>
                                                <div class="text-secondary small text-truncate" style="max-width: 250px;" title="<%= t.getDescription() != null ? t.getDescription() : "" %>">
                                                    <%= t.getDescription() != null ? t.getDescription() : "" %>
                                                </div>
                                            </td>
                                            <td><span class="badge bg-secondary bg-opacity-25 text-white py-1 px-2 border border-secondary border-opacity-50"><%= t.getCategory().getCategoryName() %></span></td>
                                            <td class="text-secondary"><%= DateConverter.formatDate(t.getDueDate()) %></td>
                                            <td><span class="badge-custom <%= priorityClass %>"><%= t.getPriority() %></span></td>
                                            <td>
                                                <span class="text-secondary small">
                                                    <% if (!"None".equals(recurrenceText)) { %>
                                                        <i class="fa-solid fa-rotate text-info me-1"></i> <%= recurrenceText %>
                                                    <% } else { %>
                                                        <i class="fa-solid fa-minus text-muted me-1"></i> None
                                                    <% } %>
                                                </span>
                                            </td>
                                            <td><span class="status-badge <%= statusClass %>"><%= t.getStatus() %></span></td>
                                            <td style="text-align: right;">
                                                <% if (!"completed".equalsIgnoreCase(t.getStatus())) { %>
                                                    <a href="${pageContext.request.contextPath}/task?action=complete&taskId=<%= t.getTaskId() %>" 
                                                       class="btn btn-sm btn-outline-success me-1" title="Mark Completed">
                                                        <i class="fa-solid fa-check"></i> Done
                                                    </a>
                                                <% } %>
                                                
                                                <button class="btn btn-sm btn-outline-light me-1" 
                                                        data-bs-toggle="modal" 
                                                        data-bs-target="#editTaskModal"
                                                        onclick="editTask(
                                                            <%= t.getTaskId() %>, 
                                                            '<%= t.getTitle().replace("'", "\\'") %>', 
                                                            '<%= (t.getDescription() != null ? t.getDescription().replace("'", "\\'").replace("\n", " ").replace("\r", " ") : "") %>', 
                                                            '<%= DateConverter.formatDate(t.getDueDate()) %>', 
                                                            '<%= t.getPriority() %>', 
                                                            '<%= t.getStatus() %>', 
                                                            <%= t.getCategory().getCategoryId() %>, 
                                                            '<%= recurrenceVal %>'
                                                        )">
                                                    <i class="fa-regular fa-pen-to-square"></i> Edit
                                                </button>
                                                
                                                <a href="${pageContext.request.contextPath}/task?action=delete&taskId=<%= t.getTaskId() %>" 
                                                   class="btn btn-sm btn-outline-danger" 
                                                   onclick="return confirm('Are you sure you want to delete this task?');">
                                                    <i class="fa-regular fa-trash-can"></i>
                                                </a>
                                            </td>
                                        </tr>
                            <%
                                    }
                                } else {
                            %>
                                <tr>
                                    <td colspan="7" class="text-center py-5 text-secondary">
                                        <i class="fa-solid fa-check-double d-block mb-3" style="font-size: 2.5rem;"></i>
                                        No tasks found matching your filters.
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

    <!-- ADD TASK MODAL -->
    <div class="modal fade" id="addTaskModal" tabindex="-1" aria-labelledby="addTaskModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content modal-content-custom">
                <div class="modal-header modal-header-custom">
                    <h5 class="modal-title font-weight-700" id="addTaskModalLabel"><i class="fa-solid fa-circle-plus text-primary me-2"></i>Add New Task</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="${pageContext.request.contextPath}/task" method="POST">
                    <input type="hidden" name="action" value="add">
                    <div class="modal-body p-4 row g-3">
                        <div class="col-md-8">
                            <label for="addTitle" class="form-label text-secondary">Task Title</label>
                            <input type="text" class="form-control form-control-custom" id="addTitle" name="title" required placeholder="e.g. Prepare OOP project report">
                        </div>
                        <div class="col-md-4">
                            <label for="addCategoryId" class="form-label text-secondary">Category</label>
                            <select class="form-select form-control-custom" id="addCategoryId" name="categoryId" required>
                                <%
                                    if (categoriesList != null) {
                                        for (Category c : categoriesList) {
                                %>
                                            <option value="<%= c.getCategoryId() %>"><%= c.getCategoryName() %></option>
                                <%
                                        }
                                    }
                                %>
                            </select>
                        </div>
                        <div class="col-12">
                            <label for="addDescription" class="form-label text-secondary">Description</label>
                            <textarea class="form-control form-control-custom" id="addDescription" name="description" rows="3" placeholder="Provide task requirements..."></textarea>
                        </div>
                        <div class="col-md-4">
                            <label for="addDueDate" class="form-label text-secondary">Due Date</label>
                            <input type="date" class="form-control form-control-custom" id="addDueDate" name="dueDate" required>
                        </div>
                        <div class="col-md-4">
                            <label for="addPriority" class="form-label text-secondary">Priority</label>
                            <select class="form-select form-control-custom" id="addPriority" name="priority" required>
                                <option value="Low">Low</option>
                                <option value="Medium" selected>Medium</option>
                                <option value="High">High</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label for="addStatus" class="form-label text-secondary">Status</label>
                            <select class="form-select form-control-custom" id="addStatus" name="status" required>
                                <option value="Pending" selected>Pending</option>
                                <option value="Completed">Completed</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label for="addRecurrenceType" class="form-label text-secondary">Recurrence Pattern</label>
                            <select class="form-select form-control-custom" id="addRecurrenceType" name="recurrenceType">
                                <option value="none" selected>Standard (None)</option>
                                <option value="daily">Daily Recurrence</option>
                                <option value="weekly">Weekly Recurrence</option>
                                <option value="monthly">Monthly Recurrence</option>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer modal-footer-custom">
                        <button type="button" class="btn btn-outline-secondary px-4" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary px-4">Create Task</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- EDIT TASK MODAL -->
    <div class="modal fade" id="editTaskModal" tabindex="-1" aria-labelledby="editTaskModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content modal-content-custom">
                <div class="modal-header modal-header-custom">
                    <h5 class="modal-title font-weight-700" id="editTaskModalLabel"><i class="fa-regular fa-pen-to-square text-primary me-2"></i>Edit Task</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="${pageContext.request.contextPath}/task" method="POST">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" id="editTaskId" name="taskId">
                    <div class="modal-body p-4 row g-3">
                        <div class="col-md-8">
                            <label for="editTitle" class="form-label text-secondary">Task Title</label>
                            <input type="text" class="form-control form-control-custom" id="editTitle" name="title" required>
                        </div>
                        <div class="col-md-4">
                            <label for="editCategoryId" class="form-label text-secondary">Category</label>
                            <select class="form-select form-control-custom" id="editCategoryId" name="categoryId" required>
                                <%
                                    if (categoriesList != null) {
                                        for (Category c : categoriesList) {
                                %>
                                            <option value="<%= c.getCategoryId() %>"><%= c.getCategoryName() %></option>
                                <%
                                        }
                                    }
                                %>
                            </select>
                        </div>
                        <div class="col-12">
                            <label for="editDescription" class="form-label text-secondary">Description</label>
                            <textarea class="form-control form-control-custom" id="editDescription" name="description" rows="3"></textarea>
                        </div>
                        <div class="col-md-4">
                            <label for="editDueDate" class="form-label text-secondary">Due Date</label>
                            <input type="date" class="form-control form-control-custom" id="editDueDate" name="dueDate" required>
                        </div>
                        <div class="col-md-4">
                            <label for="editPriority" class="form-label text-secondary">Priority</label>
                            <select class="form-select form-control-custom" id="editPriority" name="priority" required>
                                <option value="Low">Low</option>
                                <option value="Medium">Medium</option>
                                <option value="High">High</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label for="editStatus" class="form-label text-secondary">Status</label>
                            <select class="form-select form-control-custom" id="editStatus" name="status" required>
                                <option value="Pending">Pending</option>
                                <option value="Completed">Completed</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label for="editRecurrenceType" class="form-label text-secondary">Recurrence Pattern</label>
                            <select class="form-select form-control-custom" id="editRecurrenceType" name="recurrenceType">
                                <option value="none">Standard (None)</option>
                                <option value="daily">Daily Recurrence</option>
                                <option value="weekly">Weekly Recurrence</option>
                                <option value="monthly">Monthly Recurrence</option>
                            </select>
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
