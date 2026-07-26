package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import database.DBConnection;
import model.Category;

/**
 * Data Access Object for Category operations.
 */
public class CategoryDAO {

    /**
     * Creates a new category.
     * @param category Category to create
     * @return true if creation is successful, false otherwise
     */ 
    public boolean create(Category category) {
        String sql = "INSERT INTO categories (categoryName) VALUES (?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            
            ps.setString(1, category.getCategoryName());
            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        category.setCategoryId(rs.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            System.err.println("Error creating category: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Retrieves all categories.
     * @return list of categories
     */
    public ArrayList<Category> getAll() {
        ArrayList<Category> list = new ArrayList<>();
        String sql = "SELECT categoryId, categoryName FROM categories ORDER BY categoryName ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Category c = new Category(
                    rs.getInt("categoryId"),
                    rs.getString("categoryName")
                );
                list.add(c);
            }
        } catch (SQLException e) {
            System.err.println("Error retrieving categories: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Retrieves a single category by ID.
     * @param categoryId the category ID
     * @return Category object or null if not found
     */
    public Category getById(int categoryId) {
        String sql = "SELECT categoryId, categoryName FROM categories WHERE categoryId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, categoryId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Category(
                        rs.getInt("categoryId"),
                        rs.getString("categoryName")
                    );
                }
            }
        } catch (SQLException e) {
            System.err.println("Error retrieving category by ID: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Updates an existing category.
     * @param category Category with updated details
     * @return true if update is successful, false otherwise
     */
    public boolean update(Category category) {
        String sql = "UPDATE categories SET categoryName = ? WHERE categoryId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, category.getCategoryName());
            ps.setInt(2, category.getCategoryId());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error updating category: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Deletes a category.
     * @param categoryId ID of the category to delete
     * @return true if deletion is successful, false otherwise
     */
    public boolean delete(int categoryId) {
        String sql = "DELETE FROM categories WHERE categoryId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, categoryId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error deleting category: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
}
