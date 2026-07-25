<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="model.Category" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Categories - Smart Task Manager</title>
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
                    <h2>Category Management</h2>
                    <p>Organize your tasks by creating and managing categories.</p>
                </div>
                <div>
                    <button class="btn btn-primary-custom px-4 py-2" data-bs-toggle="modal" data-bs-target="#addCategoryModal">
                        <i class="fa-solid fa-plus me-1"></i> Add Category
                    </button>
                </div>
            </div>

            <!-- Categories Card -->
            <div class="content-card">
                <div class="table-responsive">
                    <table class="table table-custom table-hover align-middle mb-0">
                        <thead>
                            <tr>
                                <th style="width: 15%;">ID</th>
                                <th>Category Name</th>
                                <th style="width: 25%; text-align: right;">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                ArrayList<Category> list = (ArrayList<Category>) request.getAttribute("categoriesList");
                                if (list != null && !list.isEmpty()) {
                                    for (Category c : list) {
                            %>
                                        <tr>
                                            <td class="text-secondary">#<%= c.getCategoryId() %></td>
                                            <td class="font-weight-600 text-white"><%= c.getCategoryName() %></td>
                                            <td style="text-align: right;">
                                                <button class="btn btn-sm btn-outline-light me-2" 
                                                        data-bs-toggle="modal" 
                                                        data-bs-target="#editCategoryModal"
                                                        onclick="editCategory(<%= c.getCategoryId() %>, '<%= c.getCategoryName().replace("'", "\\'") %>')">
                                                    <i class="fa-regular fa-pen-to-square me-1"></i> Edit
                                                </button>
                                                <a href="${pageContext.request.contextPath}/category?action=delete&categoryId=<%= c.getCategoryId() %>" 
                                                   class="btn btn-sm btn-outline-danger" 
                                                   onclick="return confirm('Are you sure you want to delete this category? All associated tasks will be permanently removed!');">
                                                    <i class="fa-regular fa-trash-can me-1"></i> Delete
                                                </a>
                                            </td>
                                        </tr>
                            <%
                                    }
                                } else {
                            %>
                                <tr>
                                    <td colspan="3" class="text-center py-5 text-secondary">
                                        <i class="fa-regular fa-folder-open d-block mb-3" style="font-size: 2.5rem;"></i>
                                        No categories found. Click "Add Category" to create one!
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

    <!-- ADD CATEGORY MODAL -->
    <div class="modal fade" id="addCategoryModal" tabindex="-1" aria-labelledby="addCategoryModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content modal-content-custom">
                <div class="modal-header modal-header-custom">
                    <h5 class="modal-title font-weight-700" id="addCategoryModalLabel"><i class="fa-solid fa-folder-plus text-primary me-2"></i>Add New Category</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="${pageContext.request.contextPath}/category" method="POST">
                    <input type="hidden" name="action" value="add">
                    <div class="modal-body p-4">
                        <div class="mb-3">
                            <label for="addCategoryName" class="form-label text-secondary">Category Name</label>
                            <input type="text" class="form-control form-control-custom" id="addCategoryName" name="categoryName" required placeholder="e.g. Work, Personal, Studies">
                        </div>
                    </div>
                    <div class="modal-footer modal-footer-custom">
                        <button type="button" class="btn btn-outline-secondary px-4" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary px-4">Create Category</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- EDIT CATEGORY MODAL -->
    <div class="modal fade" id="editCategoryModal" tabindex="-1" aria-labelledby="editCategoryModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content modal-content-custom">
                <div class="modal-header modal-header-custom">
                    <h5 class="modal-title font-weight-700" id="editCategoryModalLabel"><i class="fa-regular fa-pen-to-square text-primary me-2"></i>Edit Category</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="${pageContext.request.contextPath}/category" method="POST">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" id="editCategoryId" name="categoryId">
                    <div class="modal-body p-4">
                        <div class="mb-3">
                            <label for="editCategoryName" class="form-label text-secondary">Category Name</label>
                            <input type="text" class="form-control form-control-custom" id="editCategoryName" name="categoryName" required>
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
