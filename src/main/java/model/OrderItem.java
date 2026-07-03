package model;

public class OrderItem {
    private int id;
    private int orderId;
    private int foodItemId;
    private int quantity;
    private double price; // The price at which it was purchased
    
    // Joint details
    private String foodName;
    private boolean isVeg;

    public OrderItem() {}

    public OrderItem(int id, int orderId, int foodItemId, int quantity, double price) {
        this.id = id;
        this.orderId = orderId;
        this.foodItemId = foodItemId;
        this.quantity = quantity;
        this.price = price;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }

    public int getFoodItemId() { return foodItemId; }
    public void setFoodItemId(int foodItemId) { this.foodItemId = foodItemId; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public String getFoodName() { return foodName; }
    public void setFoodName(String foodName) { this.foodName = foodName; }

    public boolean isVeg() { return isVeg; }
    public void setVeg(boolean veg) { isVeg = veg; }

    public double getSubtotal() {
        return price * quantity;
    }
}
