<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="dao.UserDAO" %>
<%@ page import="model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Directory - Smart Task Manager</title>
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
                    <h2>Registered User Accounts</h2>
                    <p>Directory of all registered profiles in the Smart Task Manager system.</p>
                </div>
            </div>

            <!-- Users List Table -->
            <div class="content-card">
                <div class="table-responsive">
                    <table class="table table-custom table-hover align-middle mb-0">
                        <thead>
                            <tr>
                                <th style="width: 15%;">User ID</th>
                                <th>Name</th>
                                <th>Email Address</th>
                                <th style="text-align: right; width: 20%;">Access Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                UserDAO uDAO = new UserDAO();
                                ArrayList<User> userList = uDAO.getAllUsers();
                                
                                if (userList != null && !userList.isEmpty()) {
                                    for (User u : userList) {
                                        boolean isCurrentUser = u.getUserId() == sessionUser.getUserId();
                            %>
                                        <tr>
                                            <td class="text-secondary">#<%= u.getUserId() %></td>
                                            <td class="font-weight-600 text-white">
                                                <%= u.getName() %>
                                                <% if (isCurrentUser) { %>
                                                    <span class="badge bg-primary ms-2 small" style="font-size: 0.65rem;">You</span>
                                                <% } %>
                                            </td>
                                            <td class="text-secondary"><%= u.getEmail() %></td>
                                            <td style="text-align: right;">
                                                <span class="badge-custom badge-low">
                                                    <i class="fa-solid fa-circle-check me-1" style="font-size: 0.75rem;"></i> Active
                                                </span>
                                            </td>
                                        </tr>
                            <%
                                    }
                                } else {
                            %>
                                <tr>
                                    <td colspan="4" class="text-center py-5 text-secondary">
                                        <i class="fa-regular fa-user d-block mb-3" style="font-size: 2.5rem;"></i>
                                        No users registered.
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

    <!-- Bootstrap 5 JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
