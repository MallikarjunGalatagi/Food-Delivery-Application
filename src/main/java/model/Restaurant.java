package model;

public class Restaurant {
    private int userId; // The owner's user ID
    private User user;  // The owner user details
    private String restaurantName;
    private String logoPath;
    private String bannerPath;
    private String cuisineType;
    private int estimatedDeliveryTime;
    private String address;
    private double rating;
    private boolean isActive;

    public Restaurant() {}

    public Restaurant(int userId, User user, String restaurantName, String logoPath, String bannerPath, String cuisineType, int estimatedDeliveryTime, String address, double rating, boolean isActive) {
        this.userId = userId;
        this.user = user;
        this.restaurantName = restaurantName;
        this.logoPath = logoPath;
        this.bannerPath = bannerPath;
        this.cuisineType = cuisineType;
        this.estimatedDeliveryTime = estimatedDeliveryTime;
        this.address = address;
        this.rating = rating;
        this.isActive = isActive;
    }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }

    public String getRestaurantName() { return restaurantName; }
    public void setRestaurantName(String restaurantName) { this.restaurantName = restaurantName; }

    public String getLogoPath() { return logoPath; }
    public void setLogoPath(String logoPath) { this.logoPath = logoPath; }

    public String getBannerPath() { return bannerPath; }
    public void setBannerPath(String bannerPath) { this.bannerPath = bannerPath; }

    public String getCuisineType() { return cuisineType; }
    public void setCuisineType(String cuisineType) { this.cuisineType = cuisineType; }

    public int getEstimatedDeliveryTime() { return estimatedDeliveryTime; }
    public void setEstimatedDeliveryTime(int estimatedDeliveryTime) { this.estimatedDeliveryTime = estimatedDeliveryTime; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public double getRating() { return rating; }
    public void setRating(double rating) { this.rating = rating; }

    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }
}
