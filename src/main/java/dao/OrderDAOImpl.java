package dao;

import model.*;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAOImpl implements OrderDAO {

    @Override
    public int placeOrder(Order order) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // 1. Insert into orders
            String sqlOrder = "INSERT INTO orders (customer_id, restaurant_id, status, subtotal, delivery_charge, tax, grand_total, address_id, payment_method, payment_status) " +
                              "VALUES (?, ?, 'PLACED', ?, ?, ?, ?, ?, ?, ?)";
            int orderId = -1;
            try (PreparedStatement psOrder = conn.prepareStatement(sqlOrder, Statement.RETURN_GENERATED_KEYS)) {
                psOrder.setInt(1, order.getCustomerId());
                psOrder.setInt(2, order.getRestaurantId());
                psOrder.setDouble(3, order.getSubtotal());
                psOrder.setDouble(4, order.getDeliveryCharge());
                psOrder.setDouble(5, order.getTax());
                psOrder.setDouble(6, order.getGrandTotal());
                psOrder.setInt(7, order.getAddressId());
                psOrder.setString(8, order.getPaymentMethod());
                psOrder.setString(9, order.getPaymentStatus());
                
                psOrder.executeUpdate();
                try (ResultSet rs = psOrder.getGeneratedKeys()) {
                    if (rs.next()) {
                        orderId = rs.getInt(1);
                    }
                }
            }

            if (orderId == -1) {
                conn.rollback();
                return -1;
            }

            // 2. Insert order items
            String sqlItem = "INSERT INTO order_items (order_id, food_item_id, quantity, price) VALUES (?, ?, ?, ?)";
            try (PreparedStatement psItem = conn.prepareStatement(sqlItem)) {
                for (OrderItem item : order.getItems()) {
                    psItem.setInt(1, orderId);
                    psItem.setInt(2, item.getFoodItemId());
                    psItem.setInt(3, item.getQuantity());
                    psItem.setDouble(4, item.getPrice());
                    psItem.addBatch();
                }
                psItem.executeBatch();
            }

            // 3. Insert payment details if ONLINE or COD
            String sqlPay = "INSERT INTO payments (order_id, transaction_id, payment_method, amount, status) VALUES (?, ?, ?, ?, ?)";
            try (PreparedStatement psPay = conn.prepareStatement(sqlPay)) {
                psPay.setInt(1, orderId);
                psPay.setString(2, "TXN-" + System.currentTimeMillis());
                psPay.setString(3, order.getPaymentMethod());
                psPay.setDouble(4, order.getGrandTotal());
                psPay.setString(5, order.getPaymentStatus());
                psPay.executeUpdate();
            }

            // 4. Clear Customer Cart
            String sqlClear = "DELETE ci FROM cart_items ci JOIN carts c ON ci.cart_id = c.id WHERE c.customer_id = ?";
            try (PreparedStatement psClear = conn.prepareStatement(sqlClear)) {
                psClear.setInt(1, order.getCustomerId());
                psClear.executeUpdate();
            }

            conn.commit();
            return orderId;
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
        return -1;
    }

    @Override
    public Order getOrderById(int orderId) {
        String sql = "SELECT o.*, r.restaurant_name, " +
                     "u_cust.first_name as cust_fname, u_cust.last_name as cust_lname, u_cust.phone as cust_phone, " +
                     "u_rider.first_name as rider_fname, u_rider.last_name as rider_lname, u_rider.phone as rider_phone " +
                     "FROM orders o " +
                     "JOIN restaurants r ON o.restaurant_id = r.user_id " +
                     "JOIN users u_cust ON o.customer_id = u_cust.id " +
                     "LEFT JOIN users u_rider ON o.delivery_partner_id = u_rider.id " +
                     "WHERE o.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Order order = mapOrder(rs);
                    
                    // Fetch items
                    order.setItems(getOrderItems(conn, orderId));
                    
                    // Fetch address
                    order.setAddress(getOrderAddress(conn, order.getAddressId()));
                    
                    return order;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public List<Order> getOrdersByCustomerId(int customerId) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT o.*, r.restaurant_name, " +
                     "u_cust.first_name as cust_fname, u_cust.last_name as cust_lname, u_cust.phone as cust_phone, " +
                     "u_rider.first_name as rider_fname, u_rider.last_name as rider_lname, u_rider.phone as rider_phone " +
                     "FROM orders o " +
                     "JOIN restaurants r ON o.restaurant_id = r.user_id " +
                     "JOIN users u_cust ON o.customer_id = u_cust.id " +
                     "LEFT JOIN users u_rider ON o.delivery_partner_id = u_rider.id " +
                     "WHERE o.customer_id = ? ORDER BY o.id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order order = mapOrder(rs);
                    order.setItems(getOrderItems(conn, order.getId()));
                    list.add(order);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<Order> getOrdersByRestaurantId(int restaurantId) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT o.*, r.restaurant_name, " +
                     "u_cust.first_name as cust_fname, u_cust.last_name as cust_lname, u_cust.phone as cust_phone, " +
                     "u_rider.first_name as rider_fname, u_rider.last_name as rider_lname, u_rider.phone as rider_phone " +
                     "FROM orders o " +
                     "JOIN restaurants r ON o.restaurant_id = r.user_id " +
                     "JOIN users u_cust ON o.customer_id = u_cust.id " +
                     "LEFT JOIN users u_rider ON o.delivery_partner_id = u_rider.id " +
                     "WHERE o.restaurant_id = ? ORDER BY o.id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, restaurantId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order order = mapOrder(rs);
                    order.setItems(getOrderItems(conn, order.getId()));
                    list.add(order);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<Order> getAssignedOrdersByRiderId(int riderId) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT o.*, r.restaurant_name, " +
                     "u_cust.first_name as cust_fname, u_cust.last_name as cust_lname, u_cust.phone as cust_phone, " +
                     "u_rider.first_name as rider_fname, u_rider.last_name as rider_lname, u_rider.phone as rider_phone " +
                     "FROM orders o " +
                     "JOIN restaurants r ON o.restaurant_id = r.user_id " +
                     "JOIN users u_cust ON o.customer_id = u_cust.id " +
                     "LEFT JOIN users u_rider ON o.delivery_partner_id = u_rider.id " +
                     "WHERE o.delivery_partner_id = ? ORDER BY o.id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, riderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order order = mapOrder(rs);
                    order.setItems(getOrderItems(conn, order.getId()));
                    order.setAddress(getOrderAddress(conn, order.getAddressId()));
                    list.add(order);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<Order> getAvailableOrdersForDelivery() {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT o.*, r.restaurant_name, " +
                     "u_cust.first_name as cust_fname, u_cust.last_name as cust_lname, u_cust.phone as cust_phone, " +
                     "u_rider.first_name as rider_fname, u_rider.last_name as rider_lname, u_rider.phone as rider_phone " +
                     "FROM orders o " +
                     "JOIN restaurants r ON o.restaurant_id = r.user_id " +
                     "JOIN users u_cust ON o.customer_id = u_cust.id " +
                     "LEFT JOIN users u_rider ON o.delivery_partner_id = u_rider.id " +
                     "WHERE o.status = 'READY_FOR_PICKUP' AND o.delivery_partner_id IS NULL ORDER BY o.id ASC";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Order order = mapOrder(rs);
                order.setItems(getOrderItems(conn, order.getId()));
                order.setAddress(getOrderAddress(conn, order.getAddressId()));
                list.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<Order> getAllOrders() {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT o.*, r.restaurant_name, " +
                     "u_cust.first_name as cust_fname, u_cust.last_name as cust_lname, u_cust.phone as cust_phone, " +
                     "u_rider.first_name as rider_fname, u_rider.last_name as rider_lname, u_rider.phone as rider_phone " +
                     "FROM orders o " +
                     "JOIN restaurants r ON o.restaurant_id = r.user_id " +
                     "JOIN users u_cust ON o.customer_id = u_cust.id " +
                     "LEFT JOIN users u_rider ON o.delivery_partner_id = u_rider.id " +
                     "ORDER BY o.id DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Order order = mapOrder(rs);
                list.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public boolean updateOrderStatus(int orderId, String status) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // Update order status, and if DELIVERED, set payment_status to COMPLETED
            String updateOrderSql = "DELIVERED".equals(status)
                ? "UPDATE orders SET status = ?, payment_status = 'COMPLETED' WHERE id = ?"
                : "UPDATE orders SET status = ? WHERE id = ?";
            
            try (PreparedStatement ps = conn.prepareStatement(updateOrderSql)) {
                ps.setString(1, status);
                ps.setInt(2, orderId);
                ps.executeUpdate();
            }

            // If DELIVERED, credit delivery partner earnings
            if ("DELIVERED".equalsIgnoreCase(status)) {
                String selectRiderSql = "SELECT delivery_partner_id, delivery_charge FROM orders WHERE id = ?";
                Integer riderId = null;
                double deliveryCharge = 0.0;
                
                try (PreparedStatement psSel = conn.prepareStatement(selectRiderSql)) {
                    psSel.setInt(1, orderId);
                    try (ResultSet rs = psSel.executeQuery()) {
                        if (rs.next()) {
                            int rId = rs.getInt("delivery_partner_id");
                            if (!rs.wasNull()) {
                                riderId = rId;
                            }
                            deliveryCharge = rs.getDouble("delivery_charge");
                        }
                    }
                }

                if (riderId != null && deliveryCharge > 0) {
                    String updateEarningsSql = "UPDATE delivery_partners SET earnings = earnings + ? WHERE user_id = ?";
                    try (PreparedStatement psEarn = conn.prepareStatement(updateEarningsSql)) {
                        psEarn.setDouble(1, deliveryCharge);
                        psEarn.setInt(2, riderId);
                        psEarn.executeUpdate();
                    }
                }
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
    public boolean assignRiderToOrder(int orderId, int riderId) {
        String sql = "UPDATE orders SET delivery_partner_id = ?, status = 'PICKED_UP' WHERE id = ? AND delivery_partner_id IS NULL";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, riderId);
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean updatePaymentStatus(int orderId, String paymentStatus) {
        String sql = "UPDATE orders SET payment_status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, paymentStatus);
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // --- Helper Methods ---
    private List<OrderItem> getOrderItems(Connection conn, int orderId) throws SQLException {
        List<OrderItem> list = new ArrayList<>();
        String sql = "SELECT oi.*, f.name as food_name, f.is_veg FROM order_items oi JOIN food_items f ON oi.food_item_id = f.id WHERE oi.order_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderItem item = new OrderItem(
                        rs.getInt("id"),
                        rs.getInt("order_id"),
                        rs.getInt("food_item_id"),
                        rs.getInt("quantity"),
                        rs.getDouble("price")
                    );
                    item.setFoodName(rs.getString("food_name"));
                    item.setVeg(rs.getBoolean("is_veg"));
                    list.add(item);
                }
            }
        }
        return list;
    }

    private Address getOrderAddress(Connection conn, int addressId) throws SQLException {
        String sql = "SELECT * FROM addresses WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, addressId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Address(
                        rs.getInt("id"),
                        rs.getInt("customer_id"),
                        rs.getString("address_line1"),
                        rs.getString("address_line2"),
                        rs.getString("city"),
                        rs.getString("state"),
                        rs.getString("postal_code"),
                        rs.getBoolean("is_default")
                    );
                }
            }
        }
        return null;
    }

    private Order mapOrder(ResultSet rs) throws SQLException {
        Order o = new Order();
        o.setId(rs.getInt("id"));
        o.setCustomerId(rs.getInt("customer_id"));
        o.setRestaurantId(rs.getInt("restaurant_id"));
        
        int rId = rs.getInt("delivery_partner_id");
        o.setDeliveryPartnerId(rs.wasNull() ? null : rId);
        
        o.setStatus(rs.getString("status"));
        o.setSubtotal(rs.getDouble("subtotal"));
        o.setDeliveryCharge(rs.getDouble("delivery_charge"));
        o.setTax(rs.getDouble("tax"));
        o.setGrandTotal(rs.getDouble("grand_total"));
        o.setAddressId(rs.getInt("address_id"));
        o.setPaymentMethod(rs.getString("payment_method"));
        o.setPaymentStatus(rs.getString("payment_status"));
        o.setCreatedAt(rs.getTimestamp("created_at"));
        
        o.setRestaurantName(rs.getString("restaurant_name"));
        o.setCustomerName(rs.getString("cust_fname") + " " + rs.getString("cust_lname"));
        o.setCustomerPhone(rs.getString("cust_phone"));
        
        String riderFname = rs.getString("rider_fname");
        if (riderFname != null) {
            o.setRiderName(riderFname + " " + rs.getString("rider_lname"));
            o.setRiderPhone(rs.getString("rider_phone"));
        }
        return o;
    }

    @Override
    public int getTodayOrdersCount(int restaurantId) {
        String sql = "SELECT COUNT(*) FROM orders WHERE restaurant_id = ? AND DATE(created_at) = CURDATE()";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, restaurantId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public double getTodayRevenue(int restaurantId) {
        String sql = "SELECT SUM(grand_total) FROM orders WHERE restaurant_id = ? AND status = 'DELIVERED' AND DATE(created_at) = CURDATE()";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, restaurantId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getDouble(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    @Override
    public double getMonthlyRevenue(int restaurantId) {
        String sql = "SELECT SUM(grand_total) FROM orders WHERE restaurant_id = ? AND status = 'DELIVERED' AND MONTH(created_at) = MONTH(CURDATE()) AND YEAR(created_at) = YEAR(CURDATE())";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, restaurantId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getDouble(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    @Override
    public double getPlatformTotalRevenue() {
        String sql = "SELECT SUM(grand_total) FROM orders WHERE status = 'DELIVERED'";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) return rs.getDouble(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    @Override
    public int getPlatformTotalOrdersCount() {
        String sql = "SELECT COUNT(*) FROM orders";
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
