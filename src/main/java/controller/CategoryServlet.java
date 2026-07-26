package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import dao.CategoryDAO;
import model.Category;

/**
 * Servlet controller for Category Management.
 */
@WebServlet("/category")
public class CategoryServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CategoryDAO categoryDAO;

    public void init() {
        categoryDAO = new CategoryDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "delete":
                handleDelete(request, response);
                break;
            case "list":
            default:
                listCategories(request, response);
                break;
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }

        switch (action) {
            case "add":
                handleAdd(request, response);
                break;
            case "update":
                handleUpdate(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/category?action=list");
                break;
        }
    }

    private void listCategories(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ArrayList<Category> list = categoryDAO.getAll();
        request.setAttribute("categoriesList", list);
        request.getRequestDispatcher("/jsp/categories.jsp").forward(request, response);
    }

    private void handleAdd(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String categoryName = request.getParameter("categoryName");
        if (categoryName != null && !categoryName.trim().isEmpty()) {
            Category category = new Category();
            category.setCategoryName(categoryName.trim());
            categoryDAO.create(category);
        }
        response.sendRedirect(request.getContextPath() + "/category?action=list");
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idStr = request.getParameter("categoryId");
        String categoryName = request.getParameter("categoryName");

        if (idStr != null && categoryName != null && !categoryName.trim().isEmpty()) {
            try {
                int id = Integer.parseInt(idStr);
                Category category = new Category(id, categoryName.trim());
                categoryDAO.update(category);
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
        response.sendRedirect(request.getContextPath() + "/category?action=list");
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idStr = request.getParameter("categoryId");
        if (idStr != null) {
            try {
                int id = Integer.parseInt(idStr);
                categoryDAO.delete(id);
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
        response.sendRedirect(request.getContextPath() + "/category?action=list");
    }
}
