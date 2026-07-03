package model;

import java.util.ArrayList;
import java.util.List;

public class Cart {
    private int id;
    private int customerId;
    private List<CartItem> items = new ArrayList<>();

    public Cart() {}

    public Cart(int id, int customerId, List<CartItem> items) {
        this.id = id;
        this.customerId = customerId;
        this.items = items;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getCustomerId() { return customerId; }
    public void setCustomerId(int customerId) { this.customerId = customerId; }

    public List<CartItem> getItems() { return items; }
    public void setItems(List<CartItem> items) { this.items = items; }

    public double getSubtotal() {
        double subtotal = 0.0;
        for (CartItem item : items) {
            subtotal += item.getSubtotal();
        }
        return subtotal;
    }

    public double getDeliveryCharge() {
        // Flat rate of 40.00 if cart has items, else 0.00
        return getSubtotal() > 0 ? 40.00 : 0.00;
    }

    public double getTax() {
        // 5% GST
        return getSubtotal() * 0.05;
    }

    public double getGrandTotal() {
        return getSubtotal() + getDeliveryCharge() + getTax();
    }
}
