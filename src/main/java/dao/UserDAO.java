package dao;

import model.User;
import model.Customer;
import model.Restaurant;
import model.DeliveryPartner;
import java.util.List;

public interface UserDAO {
    // Basic Authentication & Retrieve
    User getUserByEmail(String email);
    User getUserById(int id);
    
    // Role-specific retrieval
    Customer getCustomerByUserId(int userId);
    Restaurant getRestaurantByUserId(int userId);
    DeliveryPartner getDeliveryPartnerByUserId(int userId);
    
    // Registrations (Transactional)
    boolean registerCustomer(Customer customer);
    boolean registerRestaurant(Restaurant restaurant);
    boolean registerDeliveryPartner(DeliveryPartner partner);
    
    // Updates
    boolean updateProfile(User user);
    boolean updatePassword(int userId, String newPassword);
    
    // Admin management operations
    List<User> getAllUsers();
    List<Restaurant> getPendingRestaurants();
    boolean updateRestaurantStatus(int restaurantId, String status);
    List<Customer> getAllCustomers();
    List<Restaurant> getAllRestaurants();
    List<DeliveryPartner> getAllDeliveryPartners();
    
    // Admin Counts
    int getCustomersCount();
    int getActiveRestaurantsCount();
    int getPendingRestaurantsCount();
    int getRidersCount();
}
