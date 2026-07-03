package model;

public class CartItem {
    private int id;
    private int cartId;
    private FoodItem foodItem;
    private int quantity;

    public CartItem() {}

    public CartItem(int id, int cartId, FoodItem foodItem, int quantity) {
        this.id = id;
        this.cartId = cartId;
        this.foodItem = foodItem;
        this.quantity = quantity;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getCartId() { return cartId; }
    public void setCartId(int cartId) { this.cartId = cartId; }

    public FoodItem getFoodItem() { return foodItem; }
    public void setFoodItem(FoodItem foodItem) { this.foodItem = foodItem; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public double getSubtotal() {
        return foodItem != null ? foodItem.getPrice() * quantity : 0.0;
    }
}
