<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile Settings - Smart Task Manager</title>
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
                    <h2>User Profile Settings</h2>
                    <p>Manage your account credentials and personal preferences.</p>
                </div>
            </div>

            <%
                String errorMessage = (String) request.getAttribute("errorMessage");
                String successMessage = (String) request.getAttribute("successMessage");
                if (errorMessage != null) {
            %>
                <div class="alert alert-danger border-0 text-white bg-danger bg-opacity-75 mb-4" role="alert">
                    <i class="fa-solid fa-triangle-exclamation me-2"></i> <%= errorMessage %>
                </div>
            <%
                }
                if (successMessage != null) {
            %>
                <div class="alert alert-success border-0 text-white bg-success bg-opacity-75 mb-4" role="alert">
                    <i class="fa-solid fa-circle-check me-2"></i> <%= successMessage %>
                </div>
            <%
                }
            %>

            <div class="row g-4">
                <!-- Update profile form -->
                <div class="col-lg-8">
                    <div class="content-card">
                        <h4 class="mb-4 font-weight-700" style="font-size: 1.15rem;"><i class="fa-solid fa-user-pen text-primary me-2"></i>Account Information</h4>
                        
                        <form action="${pageContext.request.contextPath}/user" method="POST">
                            <input type="hidden" name="action" value="updateProfile">
                            
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label for="profName" class="form-label text-secondary">Full Name</label>
                                    <input type="text" class="form-control form-control-custom" id="profName" name="name" value="<%= sessionUser.getName() %>" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="profEmail" class="form-label text-secondary">Email Address</label>
                                    <input type="email" class="form-control form-control-custom" id="profEmail" name="email" value="<%= sessionUser.getEmail() %>" required>
                                </div>
                                <div class="col-12">
                                    <label for="profPassword" class="form-label text-secondary">New Password (leave empty to keep current)</label>
                                    <input type="password" class="form-control form-control-custom" id="profPassword" name="password" placeholder="••••••••">
                                </div>
                                <div class="col-12 mt-4">
                                    <button type="submit" class="btn btn-primary-custom" style="width: auto; padding: 0.6rem 2rem;">Save Profile Settings</button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Danger Zone (Delete Account) -->
                <div class="col-lg-4">
                    <div class="content-card border border-danger border-opacity-35" style="background-color: rgba(239, 68, 68, 0.02);">
                        <h4 class="text-danger mb-3 font-weight-700" style="font-size: 1.15rem;"><i class="fa-solid fa-triangle-exclamation me-2"></i>Danger Zone</h4>
                        <p class="text-secondary small mb-4">Deleting your account will permanently erase all your tasks, categories, and reminders. This action is irreversible.</p>
                        
                        <button type="button" class="btn btn-outline-danger w-100 py-2 font-weight-600" data-bs-toggle="modal" data-bs-target="#deleteAccountModal">
                            <i class="fa-regular fa-trash-can me-1"></i> Delete My Account
                        </button>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <!-- DELETE ACCOUNT CONFIRMATION MODAL -->
    <div class="modal fade" id="deleteAccountModal" tabindex="-1" aria-labelledby="deleteAccountModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content modal-content-custom border border-danger border-opacity-50">
                <div class="modal-header modal-header-custom border-bottom border-danger border-opacity-20">
                    <h5 class="modal-title font-weight-700 text-danger" id="deleteAccountModalLabel"><i class="fa-solid fa-circle-exclamation me-2"></i>Confirm Account Deletion</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="${pageContext.request.contextPath}/user" method="POST">
                    <input type="hidden" name="action" value="deleteAccount">
                    <div class="modal-body p-4">
                        <p class="text-white font-weight-600 mb-2">Are you absolutely sure you want to delete your account?</p>
                        <p class="text-secondary small mb-0">By clicking "Delete Account", all your personal details, categories, configurations, and tasks will be deleted forever.</p>
                    </div>
                    <div class="modal-footer modal-footer-custom border-top border-danger border-opacity-20">
                        <button type="button" class="btn btn-outline-secondary px-4" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-danger px-4">Delete Account</button>
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
