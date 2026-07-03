package dao;

import model.Restaurant;
import model.User;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class RestaurantDAOImpl implements RestaurantDAO {

    @Override
    public List<Restaurant> getActiveRestaurants(String search, String cuisine, String sortBy) {
        List<Restaurant> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT r.*, u.first_name, u.last_name, u.email, u.phone, u.role, u.status, u.created_at " +
            "FROM restaurants r " +
            "JOIN users u ON r.user_id = u.id " +
            "WHERE r.is_active = 1 AND u.status = 'ACTIVE' "
        );

        List<Object> params = new ArrayList<>();

        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (r.restaurant_name LIKE ? OR r.cuisine_type LIKE ? OR EXISTS (SELECT 1 FROM food_items f WHERE f.restaurant_id = r.user_id AND f.name LIKE ?)) ");
            String term = "%" + search.trim() + "%";
            params.add(term);
            params.add(term);
            params.add(term);
        }

        if (cuisine != null && !cuisine.trim().isEmpty()) {
            sql.append("AND r.cuisine_type LIKE ? ");
            params.add("%" + cuisine.trim() + "%");
        }

        if (sortBy != null) {
            switch (sortBy) {
                case "rating":
                    sql.append("ORDER BY r.rating DESC ");
                    break;
                case "delivery_time":
                    sql.append("ORDER BY r.estimated_delivery_time ASC ");
                    break;
                default:
                    sql.append("ORDER BY r.restaurant_name ASC ");
                    break;
            }
        } else {
            sql.append("ORDER BY r.restaurant_name ASC ");
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRestaurant(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public Restaurant getRestaurantById(int id) {
        String sql = "SELECT r.*, u.first_name, u.last_name, u.email, u.phone, u.role, u.status, u.created_at " +
                     "FROM restaurants r JOIN users u ON r.user_id = u.id WHERE r.user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRestaurant(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public List<String> getAllCuisines() {
        Set<String> uniqueCuisines = new HashSet<>();
        String sql = "SELECT cuisine_type FROM restaurants r JOIN users u ON r.user_id = u.id WHERE r.is_active = 1 AND u.status = 'ACTIVE'";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                String val = rs.getString("cuisine_type");
                if (val != null) {
                    String[] parts = val.split(",");
                    for (String part : parts) {
                        uniqueCuisines.add(part.trim());
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return new ArrayList<>(uniqueCuisines);
    }

    @Override
    public boolean updateRestaurantDetails(Restaurant restaurant) {
        String sql = "UPDATE restaurants SET restaurant_name = ?, cuisine_type = ?, estimated_delivery_time = ?, address = ?, logo_path = ?, banner_path = ?, is_active = ? WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, restaurant.getRestaurantName());
            ps.setString(2, restaurant.getCuisineType());
            ps.setInt(3, restaurant.getEstimatedDeliveryTime());
            ps.setString(4, restaurant.getAddress());
            ps.setString(5, restaurant.getLogoPath());
            ps.setString(6, restaurant.getBannerPath());
            ps.setBoolean(7, restaurant.isActive());
            ps.setInt(8, restaurant.getUserId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Restaurant mapRestaurant(ResultSet rs) throws SQLException {
        User u = new User();
        u.setId(rs.getInt("user_id"));
        u.setEmail(rs.getString("email"));
        u.setFirstName(rs.getString("first_name"));
        u.setLastName(rs.getString("last_name"));
        u.setPhone(rs.getString("phone"));
        
        return new Restaurant(
            rs.getInt("user_id"), u,
            rs.getString("restaurant_name"),
            rs.getString("logo_path"),
            rs.getString("banner_path"),
            rs.getString("cuisine_type"),
            rs.getInt("estimated_delivery_time"),
            rs.getString("address"),
            rs.getDouble("rating"),
            rs.getBoolean("is_active")
        );
    }
}
