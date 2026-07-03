package dao;

import model.Order;
import java.util.List;

public interface OrderDAO {
    // Core Transactions
    int placeOrder(Order order);
    Order getOrderById(int orderId);
    
    // List Retrieves
    List<Order> getOrdersByCustomerId(int customerId);
    List<Order> getOrdersByRestaurantId(int restaurantId);
    List<Order> getAssignedOrdersByRiderId(int riderId);
    List<Order> getAvailableOrdersForDelivery();
    List<Order> getAllOrders();
    
    // Updates
    boolean updateOrderStatus(int orderId, String status);
    boolean assignRiderToOrder(int orderId, int riderId);
    boolean updatePaymentStatus(int orderId, String paymentStatus);
    
    // Analytics
    int getTodayOrdersCount(int restaurantId);
    double getTodayRevenue(int restaurantId);
    double getMonthlyRevenue(int restaurantId);
    
    // Platform-wide admin analytics
    double getPlatformTotalRevenue();
    int getPlatformTotalOrdersCount();
}
