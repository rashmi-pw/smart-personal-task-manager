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
import dao.NotificationDAO;
import model.Category;
import model.Task;
import model.RecurringTask;
import model.Notification;
import model.TaskManager;
import model.User;

/**
 * Servlet controller for preparing and rendering the dashboard.
 */
@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        int userId = user.getUserId();

        // Load tasks using TaskManager
        TaskManager taskManager = new TaskManager(userId);
        ArrayList<Task> tasks = taskManager.viewAllTasks();

        // Calculate statistics
        int totalTasks = tasks.size();
        int pendingTasks = 0;
        int completedTasks = 0;
        int recurringCount = 0;

        for (Task t : tasks) {
            if ("completed".equalsIgnoreCase(t.getStatus())) {
                completedTasks++;
            } else {
                pendingTasks++;
            }
            if (t instanceof RecurringTask) {
                recurringCount++;
            }
        }

        // Fetch categories and notifications
        CategoryDAO categoryDAO = new CategoryDAO();
        ArrayList<Category> categories = categoryDAO.getAll();

        NotificationDAO notificationDAO = new NotificationDAO();
        ArrayList<Notification> notifications = notificationDAO.getNotificationsByUserId(userId);

        // Set request attributes
        request.setAttribute("tasks", tasks);
        request.setAttribute("totalTasks", totalTasks);
        request.setAttribute("pendingTasks", pendingTasks);
        request.setAttribute("completedTasks", completedTasks);
        request.setAttribute("recurringCount", recurringCount);
        request.setAttribute("categories", categories);
        request.setAttribute("notifications", notifications);

        // Forward to dashboard.jsp
        request.getRequestDispatcher("/jsp/dashboard.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
