package dao;

import model.Cart;

public interface CartDAO {
    Cart getCartByCustomerId(int customerId);
    boolean addItemToCart(int customerId, int foodItemId, int quantity);
    boolean updateItemQuantity(int customerId, int foodItemId, int quantity);
    boolean removeItemFromCart(int customerId, int foodItemId);
    boolean clearCart(int customerId);
}
