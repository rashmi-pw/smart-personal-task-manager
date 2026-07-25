<%@ page import="model.User" %>
<%
    // Security check - ensure user is logged in
    User sessionUser = (User) session.getAttribute("user");
    if (sessionUser == null) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
        return;
    }
    
    String currentURI = request.getRequestURI();
%>
<div class="app-sidebar">
    <div class="sidebar-brand">
        <div class="me-2 text-primary"><i class="fa-solid fa-circle-check fa-lg"></i></div>
        <span class="sidebar-brand-name">Smart Tasks</span>
    </div>
    
    <ul class="sidebar-menu">
        <li class="sidebar-item <%= currentURI.contains("dashboard") ? "active" : "" %>">
            <a href="${pageContext.request.contextPath}/dashboard" class="sidebar-link">
                <i class="fa-solid fa-chart-pie"></i> Dashboard
            </a>
        </li>
        <li class="sidebar-item <%= currentURI.contains("tasks.jsp") || (currentURI.contains("task") && !currentURI.contains("dashboard")) ? "active" : "" %>">
            <a href="${pageContext.request.contextPath}/task?action=list" class="sidebar-link">
                <i class="fa-solid fa-list-check"></i> Tasks
            </a>
        </li>
        <li class="sidebar-item <%= currentURI.contains("categories.jsp") || currentURI.contains("category") ? "active" : "" %>">
            <a href="${pageContext.request.contextPath}/category?action=list" class="sidebar-link">
                <i class="fa-solid fa-tags"></i> Categories
            </a>
        </li>
        <li class="sidebar-item <%= currentURI.contains("notifications.jsp") || currentURI.contains("notification") ? "active" : "" %>">
            <a href="${pageContext.request.contextPath}/notification?action=list" class="sidebar-link">
                <i class="fa-solid fa-bell"></i> Notifications
            </a>
        </li>
        <li class="sidebar-item <%= currentURI.contains("profile.jsp") || (currentURI.contains("user") && request.getParameter("action") != null && request.getParameter("action").equals("profile")) ? "active" : "" %>">
            <a href="${pageContext.request.contextPath}/user?action=profile" class="sidebar-link">
                <i class="fa-solid fa-user-gear"></i> Profile
            </a>
        </li>
        <li class="sidebar-item <%= currentURI.contains("users.jsp") ? "active" : "" %>">
            <a href="${pageContext.request.contextPath}/jsp/users.jsp" class="sidebar-link">
                <i class="fa-solid fa-users"></i> User List
            </a>
        </li>
    </ul>
    
    <div class="sidebar-footer">
        <div class="d-flex align-items-center mb-3">
            <div class="rounded-circle bg-primary d-flex align-items-center justify-content-center text-white" style="width: 36px; height: 36px; font-weight: 600;">
                <%= sessionUser.getName().substring(0, Math.min(sessionUser.getName().length(), 2)).toUpperCase() %>
            </div>
            <div class="ms-2 overflow-hidden">
                <div class="text-white text-truncate font-weight-500" style="font-size: 0.9rem;"><%= sessionUser.getName() %></div>
                <div class="text-secondary text-truncate" style="font-size: 0.75rem;"><%= sessionUser.getEmail() %></div>
            </div>
        </div>
        <a href="${pageContext.request.contextPath}/user?action=logout" class="btn btn-outline-danger btn-sm w-100 py-1" style="font-weight: 500;">
            <i class="fa-solid fa-right-from-bracket me-1"></i> Sign Out
        </a>
    </div>
</div>
