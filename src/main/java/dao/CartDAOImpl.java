package dao;

import model.Cart;
import model.CartItem;
import model.FoodItem;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CartDAOImpl implements CartDAO {

    @Override
    public Cart getCartByCustomerId(int customerId) {
        int cartId = getOrCreateCartId(customerId);
        if (cartId == -1) return null;

        Cart cart = new Cart();
        cart.setId(cartId);
        cart.setCustomerId(customerId);
        
        List<CartItem> items = new ArrayList<>();
        String sql = "SELECT ci.id as cart_item_id, ci.quantity, f.* " +
                     "FROM cart_items ci " +
                     "JOIN food_items f ON ci.food_item_id = f.id " +
                     "WHERE ci.cart_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, cartId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    FoodItem f = new FoodItem(
                        rs.getInt("id"),
                        rs.getInt("restaurant_id"),
                        rs.getInt("category_id"),
                        rs.getString("name"),
                        rs.getString("description"),
                        rs.getDouble("price"),
                        rs.getBoolean("is_veg"),
                        rs.getBoolean("is_available"),
                        rs.getString("image_path")
                    );
                    
                    CartItem ci = new CartItem(
                        rs.getInt("cart_item_id"),
                        cartId,
                        f,
                        rs.getInt("quantity")
                    );
                    items.add(ci);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        cart.setItems(items);
        return cart;
    }

    @Override
    public boolean addItemToCart(int customerId, int foodItemId, int quantity) {
        int cartId = getOrCreateCartId(customerId);
        if (cartId == -1) return false;

        // Check if item already exists in cart
        String checkSql = "SELECT id, quantity FROM cart_items WHERE cart_id = ? AND food_item_id = ?";
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            
            int existingId = -1;
            int existingQty = 0;
            
            try (PreparedStatement psCheck = conn.prepareStatement(checkSql)) {
                psCheck.setInt(1, cartId);
                psCheck.setInt(2, foodItemId);
                try (ResultSet rs = psCheck.executeQuery()) {
                    if (rs.next()) {
                        existingId = rs.getInt("id");
                        existingQty = rs.getInt("quantity");
                    }
                }
            }

            boolean success;
            if (existingId != -1) {
                // Update quantity
                String updateSql = "UPDATE cart_items SET quantity = ? WHERE id = ?";
                try (PreparedStatement psUpdate = conn.prepareStatement(updateSql)) {
                    psUpdate.setInt(1, existingQty + quantity);
                    psUpdate.setInt(2, existingId);
                    success = psUpdate.executeUpdate() > 0;
                }
            } else {
                // Insert new item
                String insertSql = "INSERT INTO cart_items (cart_id, food_item_id, quantity) VALUES (?, ?, ?)";
                try (PreparedStatement psInsert = conn.prepareStatement(insertSql)) {
                    psInsert.setInt(1, cartId);
                    psInsert.setInt(2, foodItemId);
                    psInsert.setInt(3, quantity);
                    success = psInsert.executeUpdate() > 0;
                }
            }

            if (success) {
                conn.commit();
                return true;
            } else {
                conn.rollback();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean updateItemQuantity(int customerId, int foodItemId, int quantity) {
        int cartId = getOrCreateCartId(customerId);
        if (cartId == -1) return false;

        if (quantity <= 0) {
            return removeItemFromCart(customerId, foodItemId);
        }

        String sql = "UPDATE cart_items SET quantity = ? WHERE cart_id = ? AND food_item_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quantity);
            ps.setInt(2, cartId);
            ps.setInt(3, foodItemId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean removeItemFromCart(int customerId, int foodItemId) {
        int cartId = getOrCreateCartId(customerId);
        if (cartId == -1) return false;

        String sql = "DELETE FROM cart_items WHERE cart_id = ? AND food_item_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, cartId);
            ps.setInt(2, foodItemId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean clearCart(int customerId) {
        int cartId = getOrCreateCartId(customerId);
        if (cartId == -1) return false;

        String sql = "DELETE FROM cart_items WHERE cart_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, cartId);
            return ps.executeUpdate() >= 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // --- Helper to fetch or create a cart for the customer ---
    private int getOrCreateCartId(int customerId) {
        String sqlSelect = "SELECT id FROM carts WHERE customer_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement psSelect = conn.prepareStatement(sqlSelect)) {
            psSelect.setInt(1, customerId);
            try (ResultSet rs = psSelect.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("id");
                }
            }
            
            // If doesn't exist, create it (safety fallback)
            String sqlInsert = "INSERT INTO carts (customer_id) VALUES (?)";
            try (PreparedStatement psInsert = conn.prepareStatement(sqlInsert, Statement.RETURN_GENERATED_KEYS)) {
                psInsert.setInt(1, customerId);
                psInsert.executeUpdate();
                try (ResultSet rsGen = psInsert.getGeneratedKeys()) {
                    if (rsGen.next()) {
                        return rsGen.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }
}
