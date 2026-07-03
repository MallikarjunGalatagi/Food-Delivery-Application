package dao;

import model.Review;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReviewDAOImpl implements ReviewDAO {

    @Override
    public List<Review> getReviewsByRestaurantId(int restaurantId) {
        List<Review> list = new ArrayList<>();
        String sql = "SELECT r.*, u.first_name, u.last_name FROM reviews r JOIN users u ON r.customer_id = u.id WHERE r.restaurant_id = ? ORDER BY r.id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, restaurantId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Review rev = new Review(
                        rs.getInt("id"),
                        rs.getInt("order_id"),
                        rs.getInt("customer_id"),
                        rs.getInt("restaurant_id"),
                        rs.getInt("rating"),
                        rs.getString("review_text"),
                        rs.getTimestamp("created_at")
                    );
                    rev.setCustomerName(rs.getString("first_name") + " " + rs.getString("last_name"));
                    list.add(rev);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public boolean addReview(Review review) {
        Connection conn = null;
        String insertSql = "INSERT INTO reviews (order_id, customer_id, restaurant_id, rating, review_text) VALUES (?, ?, ?, ?, ?)";
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
                ps.setInt(1, review.getOrderId());
                ps.setInt(2, review.getCustomerId());
                ps.setInt(3, review.getRestaurantId());
                ps.setInt(4, review.getRating());
                ps.setString(5, review.getReviewText());
                ps.executeUpdate();
            }

            // Recalculate average rating and update restaurant rating
            double avgRating = calculateAverage(conn, review.getRestaurantId());
            updateRestaurantRating(conn, review.getRestaurantId(), avgRating);

            conn.commit();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
        } finally {
            if (conn != null) {
                try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }
        return false;
    }

    @Override
    public double getAverageRatingForRestaurant(int restaurantId) {
        try (Connection conn = DBConnection.getConnection()) {
            return calculateAverage(conn, restaurantId);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    private double calculateAverage(Connection conn, int restaurantId) throws SQLException {
        String sql = "SELECT AVG(rating) FROM reviews WHERE restaurant_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, restaurantId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble(1);
                }
            }
        }
        return 0.0;
    }

    private void updateRestaurantRating(Connection conn, int restaurantId, double rating) throws SQLException {
        String sql = "UPDATE restaurants SET rating = ? WHERE user_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDouble(1, rating);
            ps.setInt(2, restaurantId);
            ps.executeUpdate();
        }
    }
}
