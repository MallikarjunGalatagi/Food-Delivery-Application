package model;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class Order {
    private int id;
    private int customerId;
    private int restaurantId;
    private Integer deliveryPartnerId; // Nullable
    private String status; // PLACED, ACCEPTED, PREPARING, READY_FOR_PICKUP, PICKED_UP, OUT_FOR_DELIVERY, DELIVERED, CANCELLED
    private double subtotal;
    private double deliveryCharge;
    private double tax;
    private double grandTotal;
    private int addressId;
    private Address address;
    private String paymentMethod; // COD, ONLINE
    private String paymentStatus; // PENDING, COMPLETED, FAILED
    private Timestamp createdAt;
    
    // Joint details
    private List<OrderItem> items = new ArrayList<>();
    private String restaurantName;
    private String customerName;
    private String customerPhone;
    private String riderName;
    private String riderPhone;

    public Order() {}

    public Order(int id, int customerId, int restaurantId, Integer deliveryPartnerId, String status, double subtotal, double deliveryCharge, double tax, double grandTotal, int addressId, Address address, String paymentMethod, String paymentStatus, Timestamp createdAt) {
        this.id = id;
        this.customerId = customerId;
        this.restaurantId = restaurantId;
        this.deliveryPartnerId = deliveryPartnerId;
        this.status = status;
        this.subtotal = subtotal;
        this.deliveryCharge = deliveryCharge;
        this.tax = tax;
        this.grandTotal = grandTotal;
        this.addressId = addressId;
        this.address = address;
        this.paymentMethod = paymentMethod;
        this.paymentStatus = paymentStatus;
        this.createdAt = createdAt;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getCustomerId() { return customerId; }
    public void setCustomerId(int customerId) { this.customerId = customerId; }

    public int getRestaurantId() { return restaurantId; }
    public void setRestaurantId(int restaurantId) { this.restaurantId = restaurantId; }

    public Integer getDeliveryPartnerId() { return deliveryPartnerId; }
    public void setDeliveryPartnerId(Integer deliveryPartnerId) { this.deliveryPartnerId = deliveryPartnerId; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public double getSubtotal() { return subtotal; }
    public void setSubtotal(double subtotal) { this.subtotal = subtotal; }

    public double getDeliveryCharge() { return deliveryCharge; }
    public void setDeliveryCharge(double deliveryCharge) { this.deliveryCharge = deliveryCharge; }

    public double getTax() { return tax; }
    public void setTax(double tax) { this.tax = tax; }

    public double getGrandTotal() { return grandTotal; }
    public void setGrandTotal(double grandTotal) { this.grandTotal = grandTotal; }

    public int getAddressId() { return addressId; }
    public void setAddressId(int addressId) { this.addressId = addressId; }

    public Address getAddress() { return address; }
    public void setAddress(Address address) { this.address = address; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public String getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public List<OrderItem> getItems() { return items; }
    public void setItems(List<OrderItem> items) { this.items = items; }

    public String getRestaurantName() { return restaurantName; }
    public void setRestaurantName(String restaurantName) { this.restaurantName = restaurantName; }

    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }

    public String getCustomerPhone() { return customerPhone; }
    public void setCustomerPhone(String customerPhone) { this.customerPhone = customerPhone; }

    public String getRiderName() { return riderName; }
    public void setRiderName(String riderName) { this.riderName = riderName; }

    public String getRiderPhone() { return riderPhone; }
    public void setRiderPhone(String riderPhone) { this.riderPhone = riderPhone; }

    // Helper status checking methods
    public boolean isPendingAcceptance() { return "PLACED".equalsIgnoreCase(status); }
    public boolean isPreparing() { return "ACCEPTED".equalsIgnoreCase(status) || "PREPARING".equalsIgnoreCase(status); }
    public boolean isReady() { return "READY_FOR_PICKUP".equalsIgnoreCase(status); }
    public boolean isPickedUp() { return "PICKED_UP".equalsIgnoreCase(status); }
    public boolean isOutForDelivery() { return "OUT_FOR_DELIVERY".equalsIgnoreCase(status); }
    public boolean isDelivered() { return "DELIVERED".equalsIgnoreCase(status); }
    public boolean isCancelled() { return "CANCELLED".equalsIgnoreCase(status); }
    
    public int getStatusStep() {
        if ("PLACED".equalsIgnoreCase(status)) return 1;
        if ("ACCEPTED".equalsIgnoreCase(status)) return 2;
        if ("PREPARING".equalsIgnoreCase(status)) return 3;
        if ("READY_FOR_PICKUP".equalsIgnoreCase(status)) return 4;
        if ("PICKED_UP".equalsIgnoreCase(status)) return 5;
        if ("OUT_FOR_DELIVERY".equalsIgnoreCase(status)) return 6;
        if ("DELIVERED".equalsIgnoreCase(status)) return 7;
        return 0; // Cancelled or default
    }
}
