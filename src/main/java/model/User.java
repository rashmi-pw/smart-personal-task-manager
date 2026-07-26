package model;

import dao.UserDAO;

/**
 * User model class representing users in the system.
 */
public class User {
    private int userId;
    private String name;
    private String email;
    private String password;

    public User() {
    }

    public User(int userId, String name, String email, String password) {
        this.userId = userId;
        this.name = name;
        this.email = email;
        this.password = password;
    }

    // Getters and Setters
    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    // Business Methods matching UML Diagram
    public boolean register() {
        UserDAO userDAO = new UserDAO();
        return userDAO.register(this);
    }

    public boolean login() {
        UserDAO userDAO = new UserDAO();
        User loggedInUser = userDAO.login(this.email, this.password);
        if (loggedInUser != null) {
            this.userId = loggedInUser.getUserId();
            this.name = loggedInUser.getName();
            return true;
        }
        return false;
    }

    public void logout() {
        // Clear properties or log the action
        this.userId = 0;
        this.name = null;
        this.email = null;
        this.password = null;
    }

    public void updateProfile() {
        UserDAO userDAO = new UserDAO();
        userDAO.updateProfile(this);
    }

    @Override
    public String toString() {
        return "User{" +
                "userId=" + userId +
                ", name='" + name + '\'' +
                ", email='" + email + '\'' +
                '}';
    }
}
