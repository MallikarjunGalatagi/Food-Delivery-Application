package dao;

import model.User;
import model.UserRole;
import model.UserStatus;
import model.Customer;
import model.Restaurant;
import model.DeliveryPartner;
import util.DBConnection;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAOImpl implements UserDAO {

    @Override
    public User getUserByEmail(String email) {
        String sql = "SELECT * FROM users WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapUser(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public User getUserById(int id) {
        String sql = "SELECT * FROM users WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapUser(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public Customer getCustomerByUserId(int userId) {
        String sql = "SELECT u.*, c.loyalty_points FROM users u JOIN customers c ON u.id = c.user_id WHERE u.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User u = mapUser(rs);
                    return new Customer(userId, u, rs.getInt("loyalty_points"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public Restaurant getRestaurantByUserId(int userId) {
        String sql = "SELECT u.*, r.restaurant_name, r.logo_path, r.banner_path, r.cuisine_type, r.estimated_delivery_time, r.address, r.rating, r.is_active " +
                     "FROM users u JOIN restaurants r ON u.id = r.user_id WHERE u.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User u = mapUser(rs);
                    return new Restaurant(
                        userId, u,
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
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public DeliveryPartner getDeliveryPartnerByUserId(int userId) {
        String sql = "SELECT u.*, dp.vehicle_number, dp.license_number, dp.is_available, dp.rating, dp.earnings " +
                     "FROM users u JOIN delivery_partners dp ON u.id = dp.user_id WHERE u.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User u = mapUser(rs);
                    return new DeliveryPartner(
                        userId, u,
                        rs.getString("vehicle_number"),
                        rs.getString("license_number"),
                        rs.getBoolean("is_available"),
                        rs.getDouble("rating"),
                        rs.getDouble("earnings")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public boolean registerCustomer(Customer customer) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // 1. Insert into users
            int userId = insertUser(conn, customer.getUser());
            if (userId == -1) {
                conn.rollback();
                return false;
            }
            customer.getUser().setId(userId);
            customer.setUserId(userId);

            // 2. Insert into customers
            String sqlCust = "INSERT INTO customers (user_id, loyalty_points) VALUES (?, ?)";
            try (PreparedStatement psCust = conn.prepareStatement(sqlCust)) {
                psCust.setInt(1, userId);
                psCust.setInt(2, customer.getLoyaltyPoints());
                psCust.executeUpdate();
            }

            // 3. Initialize customer Cart
            String sqlCart = "INSERT INTO carts (customer_id) VALUES (?)";
            try (PreparedStatement psCart = conn.prepareStatement(sqlCart)) {
                psCart.setInt(1, userId);
                psCart.executeUpdate();
            }

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
    public boolean registerRestaurant(Restaurant restaurant) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // 1. Insert into users
            int userId = insertUser(conn, restaurant.getUser());
            if (userId == -1) {
                conn.rollback();
                return false;
            }
            restaurant.getUser().setId(userId);
            restaurant.setUserId(userId);

            // 2. Insert into restaurants
            String sqlRest = "INSERT INTO restaurants (user_id, restaurant_name, logo_path, banner_path, cuisine_type, estimated_delivery_time, address) " +
                             "VALUES (?, ?, ?, ?, ?, ?, ?)";
            try (PreparedStatement psRest = conn.prepareStatement(sqlRest)) {
                psRest.setInt(1, userId);
                psRest.setString(2, restaurant.getRestaurantName());
                psRest.setString(3, restaurant.getLogoPath());
                psRest.setString(4, restaurant.getBannerPath());
                psRest.setString(5, restaurant.getCuisineType());
                psRest.setInt(6, restaurant.getEstimatedDeliveryTime());
                psRest.setString(7, restaurant.getAddress());
                psRest.executeUpdate();
            }

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
    public boolean registerDeliveryPartner(DeliveryPartner partner) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // 1. Insert into users
            int userId = insertUser(conn, partner.getUser());
            if (userId == -1) {
                conn.rollback();
                return false;
            }
            partner.getUser().setId(userId);
            partner.setUserId(userId);

            // 2. Insert into delivery_partners
            String sqlDp = "INSERT INTO delivery_partners (user_id, vehicle_number, license_number, is_available) VALUES (?, ?, ?, ?)";
            try (PreparedStatement psDp = conn.prepareStatement(sqlDp)) {
                psDp.setInt(1, userId);
                psDp.setString(2, partner.getVehicleNumber());
                psDp.setString(3, partner.getLicenseNumber());
                psDp.setBoolean(4, partner.isAvailable());
                psDp.executeUpdate();
            }

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
    public boolean updateProfile(User user) {
        String sql = "UPDATE users SET first_name = ?, last_name = ?, phone = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getFirstName());
            ps.setString(2, user.getLastName());
            ps.setString(3, user.getPhone());
            ps.setInt(4, user.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean updatePassword(int userId, String newPassword) {
        String sql = "UPDATE users SET password = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());
            ps.setString(1, hashedPassword);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public List<User> getAllUsers() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM users ORDER BY id DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                list.add(mapUser(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<Restaurant> getPendingRestaurants() {
        List<Restaurant> list = new ArrayList<>();
        String sql = "SELECT u.*, r.restaurant_name, r.logo_path, r.banner_path, r.cuisine_type, r.estimated_delivery_time, r.address, r.rating, r.is_active " +
                     "FROM users u JOIN restaurants r ON u.id = r.user_id WHERE u.status = 'PENDING_APPROVAL' ORDER BY u.id DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                User u = mapUser(rs);
                list.add(new Restaurant(
                    rs.getInt("id"), u,
                    rs.getString("restaurant_name"),
                    rs.getString("logo_path"),
                    rs.getString("banner_path"),
                    rs.getString("cuisine_type"),
                    rs.getInt("estimated_delivery_time"),
                    rs.getString("address"),
                    rs.getDouble("rating"),
                    rs.getBoolean("is_active")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public boolean updateRestaurantStatus(int restaurantId, String status) {
        String sql = "UPDATE users SET status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, restaurantId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public List<Customer> getAllCustomers() {
        List<Customer> list = new ArrayList<>();
        String sql = "SELECT u.*, c.loyalty_points FROM users u JOIN customers c ON u.id = c.user_id ORDER BY u.id DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                User u = mapUser(rs);
                list.add(new Customer(rs.getInt("id"), u, rs.getInt("loyalty_points")));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<Restaurant> getAllRestaurants() {
        List<Restaurant> list = new ArrayList<>();
        String sql = "SELECT u.*, r.restaurant_name, r.logo_path, r.banner_path, r.cuisine_type, r.estimated_delivery_time, r.address, r.rating, r.is_active " +
                     "FROM users u JOIN restaurants r ON u.id = r.user_id ORDER BY u.id DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                User u = mapUser(rs);
                list.add(new Restaurant(
                    rs.getInt("id"), u,
                    rs.getString("restaurant_name"),
                    rs.getString("logo_path"),
                    rs.getString("banner_path"),
                    rs.getString("cuisine_type"),
                    rs.getInt("estimated_delivery_time"),
                    rs.getString("address"),
                    rs.getDouble("rating"),
                    rs.getBoolean("is_active")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<DeliveryPartner> getAllDeliveryPartners() {
        List<DeliveryPartner> list = new ArrayList<>();
        String sql = "SELECT u.*, dp.vehicle_number, dp.license_number, dp.is_available, dp.rating, dp.earnings " +
                     "FROM users u JOIN delivery_partners dp ON u.id = dp.user_id ORDER BY u.id DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                User u = mapUser(rs);
                list.add(new DeliveryPartner(
                    rs.getInt("id"), u,
                    rs.getString("vehicle_number"),
                    rs.getString("license_number"),
                    rs.getBoolean("is_available"),
                    rs.getDouble("rating"),
                    rs.getDouble("earnings")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // --- Helper Methods ---
    private int insertUser(Connection conn, User user) throws SQLException {
        String sql = "INSERT INTO users (email, password, first_name, last_name, phone, role, status) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            String hashedPassword = BCrypt.hashpw(user.getPassword(), BCrypt.gensalt());
            ps.setString(1, user.getEmail());
            ps.setString(2, hashedPassword);
            ps.setString(3, user.getFirstName());
            ps.setString(4, user.getLastName());
            ps.setString(5, user.getPhone());
            ps.setString(6, user.getRole().name());
            ps.setString(7, user.getStatus().name());
            
            int affected = ps.executeUpdate();
            if (affected == 0) return -1;
            
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return -1;
    }

    private User mapUser(ResultSet rs) throws SQLException {
        User u = new User();
        u.setId(rs.getInt("id"));
        u.setEmail(rs.getString("email"));
        u.setPassword(rs.getString("password"));
        u.setFirstName(rs.getString("first_name"));
        u.setLastName(rs.getString("last_name"));
        u.setPhone(rs.getString("phone"));
        u.setRole(UserRole.valueOf(rs.getString("role")));
        u.setStatus(UserStatus.valueOf(rs.getString("status")));
        u.setCreatedAt(rs.getTimestamp("created_at"));
        return u;
    }

    @Override
    public int getCustomersCount() {
        String sql = "SELECT COUNT(*) FROM users WHERE role = 'CUSTOMER'";
        return queryForInt(sql);
    }

    @Override
    public int getActiveRestaurantsCount() {
        String sql = "SELECT COUNT(*) FROM users WHERE role = 'RESTAURANT_OWNER' AND status = 'ACTIVE'";
        return queryForInt(sql);
    }

    @Override
    public int getPendingRestaurantsCount() {
        String sql = "SELECT COUNT(*) FROM users WHERE role = 'RESTAURANT_OWNER' AND status = 'PENDING_APPROVAL'";
        return queryForInt(sql);
    }

    @Override
    public int getRidersCount() {
        String sql = "SELECT COUNT(*) FROM users WHERE role = 'DELIVERY_PARTNER'";
        return queryForInt(sql);
    }

    private int queryForInt(String sql) {
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}
