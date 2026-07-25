package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.stream.Collectors;
import dao.CategoryDAO;
import dao.TaskDAO;
import model.Category;
import model.Task;
import model.RecurringTask;
import model.TaskManager;
import model.User;
import util.DateConverter;

/**
 * Servlet controller for Task and Recurring Task Management.
 */
@WebServlet("/task")
public class TaskServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CategoryDAO categoryDAO;
    private TaskDAO taskDAO;

    public void init() {
        categoryDAO = new CategoryDAO();
        taskDAO = new TaskDAO();
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
            case "complete":
                handleComplete(request, response);
                break;
            case "list":
            default:
                listTasks(request, response);
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
            case "updateStatus":
                handleUpdateStatus(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/task?action=list");
                break;
        }
    }

    private void listTasks(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        int userId = user.getUserId();

        TaskManager taskManager = new TaskManager(userId);
        ArrayList<Task> tasks = taskManager.viewAllTasks();

        // Retrieve filtering/search parameters
        String catIdParam = request.getParameter("filterCategory");
        String priorityParam = request.getParameter("filterPriority");
        String statusParam = request.getParameter("filterStatus");
        String searchParam = request.getParameter("searchQuery");

        // Filter by Category
        if (catIdParam != null && !catIdParam.trim().isEmpty()) {
            try {
                int catId = Integer.parseInt(catIdParam);
                tasks = tasks.stream()
                        .filter(t -> t.getCategory() != null && t.getCategory().getCategoryId() == catId)
                        .collect(Collectors.toCollection(ArrayList::new));
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        // Filter by Priority
        if (priorityParam != null && !priorityParam.trim().isEmpty()) {
            tasks = tasks.stream()
                    .filter(t -> priorityParam.equalsIgnoreCase(t.getPriority()))
                    .collect(Collectors.toCollection(ArrayList::new));
        }

        // Filter by Status
        if (statusParam != null && !statusParam.trim().isEmpty()) {
            tasks = tasks.stream()
                    .filter(t -> statusParam.equalsIgnoreCase(t.getStatus()))
                    .collect(Collectors.toCollection(ArrayList::new));
        }

        // Search by Keyword (polymorphic list search)
        if (searchParam != null && !searchParam.trim().isEmpty()) {
            // TaskManager has a searchTask method which returns first match.
            // Let's implement list-wide matching for list rendering.
            String query = searchParam.toLowerCase();
            tasks = tasks.stream()
                    .filter(t -> t.getTitle().toLowerCase().contains(query) || 
                                (t.getDescription() != null && t.getDescription().toLowerCase().contains(query)))
                    .collect(Collectors.toCollection(ArrayList::new));
        }

        // Load all categories for select options in the view
        ArrayList<Category> categories = categoryDAO.getAll();

        request.setAttribute("tasksList", tasks);
        request.setAttribute("categoriesList", categories);
        request.getRequestDispatcher("/jsp/tasks.jsp").forward(request, response);
    }

    private void handleAdd(HttpServletRequest request, HttpServletResponse response) throws IOException {
        User user = (User) request.getSession().getAttribute("user");
        int userId = user.getUserId();

        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String dueDateStr = request.getParameter("dueDate");
        String priority = request.getParameter("priority");
        String status = request.getParameter("status");
        String categoryIdStr = request.getParameter("categoryId");
        String recurrenceType = request.getParameter("recurrenceType");

        LocalDate dueDate = DateConverter.parseDate(dueDateStr);
        int categoryId = Integer.parseInt(categoryIdStr);
        Category category = categoryDAO.getById(categoryId);

        Task task;
        if (recurrenceType != null && !recurrenceType.trim().isEmpty() && !"none".equalsIgnoreCase(recurrenceType)) {
            task = new RecurringTask(0, title, description, dueDate, priority, status, recurrenceType);
        } else {
            task = new Task(0, title, description, dueDate, priority, status, category);
        }

        task.setCategory(category);
        task.setUserId(userId);

        TaskManager taskManager = new TaskManager();
        taskManager.addTask(task);

        response.sendRedirect(request.getContextPath() + "/task?action=list");
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String taskIdStr = request.getParameter("taskId");
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String dueDateStr = request.getParameter("dueDate");
        String priority = request.getParameter("priority");
        String status = request.getParameter("status");
        String categoryIdStr = request.getParameter("categoryId");
        String recurrenceType = request.getParameter("recurrenceType");

        if (taskIdStr != null) {
            int taskId = Integer.parseInt(taskIdStr);
            LocalDate dueDate = DateConverter.parseDate(dueDateStr);
            int categoryId = Integer.parseInt(categoryIdStr);
            Category category = categoryDAO.getById(categoryId);

            Task task;
            if (recurrenceType != null && !recurrenceType.trim().isEmpty() && !"none".equalsIgnoreCase(recurrenceType)) {
                task = new RecurringTask(taskId, title, description, dueDate, priority, status, recurrenceType);
            } else {
                task = new Task(taskId, title, description, dueDate, priority, status, category);
            }

            task.setCategory(category);
            User user = (User) request.getSession().getAttribute("user");
            task.setUserId(user.getUserId());

            TaskManager taskManager = new TaskManager();
            taskManager.updateTask(task);
        }

        response.sendRedirect(request.getContextPath() + "/task?action=list");
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String taskIdStr = request.getParameter("taskId");
        if (taskIdStr != null) {
            int taskId = Integer.parseInt(taskIdStr);
            TaskManager taskManager = new TaskManager();
            taskManager.removeTask(taskId);
        }
        response.sendRedirect(request.getContextPath() + "/task?action=list");
    }

    private void handleComplete(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String taskIdStr = request.getParameter("taskId");
        if (taskIdStr != null) {
            int taskId = Integer.parseInt(taskIdStr);
            Task task = taskDAO.getById(taskId);
            if (task != null) {
                task.markCompleted();
            }
        }
        response.sendRedirect(request.getContextPath() + "/task?action=list");
    }

    private void handleUpdateStatus(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String taskIdStr = request.getParameter("taskId");
        String status = request.getParameter("status");
        if (taskIdStr != null && status != null) {
            int taskId = Integer.parseInt(taskIdStr);
            taskDAO.updateStatus(taskId, status);
        }
        response.sendRedirect(request.getContextPath() + "/task?action=list");
    }
}
