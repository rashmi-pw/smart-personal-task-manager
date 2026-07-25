<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Smart Task Manager</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- FontAwesome Icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <!-- Custom Style -->
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
</head>
<body class="auth-wrapper">

    <div class="auth-card">
        <div class="auth-header">
            <div class="mb-3">
                <i class="fa-solid fa-circle-check text-primary" style="font-size: 2.5rem;"></i>
            </div>
            <h1>Smart Task Manager</h1>
            <p>Welcome back! Please login to your account</p>
        </div>

        <%
            String errorMessage = (String) request.getAttribute("errorMessage");
            String successMessage = (String) request.getAttribute("successMessage");
            if (errorMessage != null) {
        %>
            <div class="alert alert-danger border-0 text-white bg-danger bg-opacity-75" role="alert">
                <i class="fa-solid fa-triangle-exclamation me-2"></i> <%= errorMessage %>
            </div>
        <%
            }
            if (successMessage != null) {
        %>
            <div class="alert alert-success border-0 text-white bg-success bg-opacity-75" role="alert">
                <i class="fa-solid fa-circle-check me-2"></i> <%= successMessage %>
            </div>
        <%
            }
        %>

        <form action="${pageContext.request.contextPath}/user" method="POST">
            <input type="hidden" name="action" value="login">
            
            <div class="mb-3">
                <label for="loginEmail" class="form-label text-secondary">Email address</label>
                <div class="input-group">
                    <span class="input-group-text bg-dark border-secondary text-secondary"><i class="fa-regular fa-envelope"></i></span>
                    <input type="email" class="form-control form-control-custom" id="loginEmail" name="email" required placeholder="name@example.com">
                </div>
            </div>

            <div class="mb-4">
                <label for="loginPassword" class="form-label text-secondary">Password</label>
                <div class="input-group">
                    <span class="input-group-text bg-dark border-secondary text-secondary"><i class="fa-solid fa-lock"></i></span>
                    <input type="password" class="form-control form-control-custom" id="loginPassword" name="password" required placeholder="••••••••">
                </div>
            </div>

            <button type="submit" class="btn btn-primary-custom mb-3">Sign In</button>

            <div class="text-center">
                <p class="text-secondary small mb-0">Don't have an account? <a href="${pageContext.request.contextPath}/jsp/register.jsp" class="text-primary text-decoration-none">Register here</a></p>
            </div>
        </form>
    </div>

    <!-- Bootstrap 5 JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
