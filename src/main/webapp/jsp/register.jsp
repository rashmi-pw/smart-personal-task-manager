<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Smart Task Manager</title>
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
                <i class="fa-solid fa-user-plus text-primary" style="font-size: 2.5rem;"></i>
            </div>
            <h1>Create Account</h1>
            <p>Get started with your smart personal task manager</p>
        </div>

        <div id="regError" class="alert alert-danger border-0 text-white bg-danger bg-opacity-75 d-none mb-3" role="alert">
            <i class="fa-solid fa-triangle-exclamation me-2"></i>
        </div>

        <%
            String errorMessage = (String) request.getAttribute("errorMessage");
            String successMessage = (String) request.getAttribute("successMessage");
            if (errorMessage != null) {
        %>
            <div class="alert alert-danger border-0 text-white bg-danger bg-opacity-75 mb-3" role="alert">
                <i class="fa-solid fa-triangle-exclamation me-2"></i> <%= errorMessage %>
            </div>
        <%
            }
            if (successMessage != null) {
        %>
            <div class="alert alert-success border-0 text-white bg-success bg-opacity-75 mb-3" role="alert">
                <i class="fa-solid fa-circle-check me-2"></i> <%= successMessage %>
            </div>
        <%
            }
        %>

        <form action="${pageContext.request.contextPath}/user" method="POST" onsubmit="return validateRegistration();">
            <input type="hidden" name="action" value="register">
            
            <div class="mb-3">
                <label for="regName" class="form-label text-secondary">Full Name</label>
                <div class="input-group">
                    <span class="input-group-text bg-dark border-secondary text-secondary"><i class="fa-regular fa-user"></i></span>
                    <input type="text" class="form-control form-control-custom" id="regName" name="name" required placeholder="John Doe">
                </div>
            </div>

            <div class="mb-3">
                <label for="regEmail" class="form-label text-secondary">Email address</label>
                <div class="input-group">
                    <span class="input-group-text bg-dark border-secondary text-secondary"><i class="fa-regular fa-envelope"></i></span>
                    <input type="email" class="form-control form-control-custom" id="regEmail" name="email" required placeholder="name@example.com">
                </div>
            </div>

            <div class="mb-3">
                <label for="regPassword" class="form-label text-secondary">Password</label>
                <div class="input-group">
                    <span class="input-group-text bg-dark border-secondary text-secondary"><i class="fa-solid fa-lock"></i></span>
                    <input type="password" class="form-control form-control-custom" id="regPassword" name="password" required placeholder="••••••••">
                </div>
            </div>

            <div class="mb-4">
                <label for="regConfirmPassword" class="form-label text-secondary">Confirm Password</label>
                <div class="input-group">
                    <span class="input-group-text bg-dark border-secondary text-secondary"><i class="fa-solid fa-shield-halved"></i></span>
                    <input type="password" class="form-control form-control-custom" id="regConfirmPassword" required placeholder="••••••••">
                </div>
            </div>

            <button type="submit" class="btn btn-primary-custom mb-3">Sign Up</button>

            <div class="text-center">
                <p class="text-secondary small mb-0">Already have an account? <a href="${pageContext.request.contextPath}/jsp/login.jsp" class="text-primary text-decoration-none">Sign In here</a></p>
            </div>
        </form>
    </div>

    <!-- Script and Bootstrap 5 JS -->
    <script src="${pageContext.request.contextPath}/js/main.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
