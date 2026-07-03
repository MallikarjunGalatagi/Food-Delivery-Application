package model;

public class Customer {
    private int userId;
    private User user;
    private int loyaltyPoints;

    public Customer() {}

    public Customer(int userId, User user, int loyaltyPoints) {
        this.userId = userId;
        this.user = user;
        this.loyaltyPoints = loyaltyPoints;
    }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }

    public int getLoyaltyPoints() { return loyaltyPoints; }
    public void setLoyaltyPoints(int loyaltyPoints) { this.loyaltyPoints = loyaltyPoints; }
}
