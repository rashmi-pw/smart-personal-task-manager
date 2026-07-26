package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import dao.NotificationDAO;
import dao.TaskDAO;
import model.Notification;
import model.Task;
import model.User;
import util.DateConverter;

/**
 * Servlet controller for Notification/Reminder Management.
 */
@WebServlet("/notification")
public class NotificationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private NotificationDAO notificationDAO;
    private TaskDAO taskDAO;

    public void init() {
        notificationDAO = new NotificationDAO();
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
            case "trigger":
                handleTrigger(request, response);
                break;
            case "list":
            default:
                listNotifications(request, response);
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
                response.sendRedirect(request.getContextPath() + "/notification?action=list");
                break;
        }
    }

    private void listNotifications(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        int userId = user.getUserId();

        ArrayList<Notification> notifications = notificationDAO.getNotificationsByUserId(userId);
        ArrayList<Task> tasks = taskDAO.getTasksByUserId(userId);

        request.setAttribute("notificationsList", notifications);
        request.setAttribute("tasksList", tasks);
        request.getRequestDispatcher("/jsp/notifications.jsp").forward(request, response);
    }

    private void handleAdd(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String message = request.getParameter("message");
        String reminderTimeStr = request.getParameter("reminderTime");
        String taskIdStr = request.getParameter("taskId");

        if (message != null && reminderTimeStr != null && taskIdStr != null) {
            try {
                LocalDateTime reminderTime = DateConverter.parseDateTime(reminderTimeStr);
                int taskId = Integer.parseInt(taskIdStr);

                Notification notification = new Notification();
                notification.setMessage(message);
                notification.setReminderTime(reminderTime);
                notification.setTaskId(taskId);

                notificationDAO.create(notification);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        response.sendRedirect(request.getContextPath() + "/notification?action=list");
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idStr = request.getParameter("notificationId");
        String message = request.getParameter("message");
        String reminderTimeStr = request.getParameter("reminderTime");
        String taskIdStr = request.getParameter("taskId");

        if (idStr != null && message != null && reminderTimeStr != null && taskIdStr != null) {
            try {
                int id = Integer.parseInt(idStr);
                LocalDateTime reminderTime = DateConverter.parseDateTime(reminderTimeStr);
                int taskId = Integer.parseInt(taskIdStr);

                Notification notification = new Notification(id, message, reminderTime);
                notification.setTaskId(taskId);

                notificationDAO.update(notification);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        response.sendRedirect(request.getContextPath() + "/notification?action=list");
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idStr = request.getParameter("notificationId");
        if (idStr != null) {
            try {
                int id = Integer.parseInt(idStr);
                notificationDAO.delete(id);
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
        response.sendRedirect(request.getContextPath() + "/notification?action=list");
    }

    private void handleTrigger(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idStr = request.getParameter("notificationId");
        if (idStr != null) {
            try {
                int id = Integer.parseInt(idStr);
                Notification notification = notificationDAO.getById(id);
                if (notification != null) {
                    // Polymorphic method execution via interface
                    notification.sendReminder();
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
        response.sendRedirect(request.getContextPath() + "/notification?action=list");
    }
}
