package model;

public class DeliveryPartner {
    private int userId;
    private User user;
    private String vehicleNumber;
    private String licenseNumber;
    private boolean isAvailable;
    private double rating;
    private double earnings;

    public DeliveryPartner() {}

    public DeliveryPartner(int userId, User user, String vehicleNumber, String licenseNumber, boolean isAvailable, double rating, double earnings) {
        this.userId = userId;
        this.user = user;
        this.vehicleNumber = vehicleNumber;
        this.licenseNumber = licenseNumber;
        this.isAvailable = isAvailable;
        this.rating = rating;
        this.earnings = earnings;
    }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }

    public String getVehicleNumber() { return vehicleNumber; }
    public void setVehicleNumber(String vehicleNumber) { this.vehicleNumber = vehicleNumber; }

    public String getLicenseNumber() { return licenseNumber; }
    public void setLicenseNumber(String licenseNumber) { this.licenseNumber = licenseNumber; }

    public boolean isAvailable() { return isAvailable; }
    public void setAvailable(boolean available) { isAvailable = available; }

    public double getRating() { return rating; }
    public void setRating(double rating) { this.rating = rating; }

    public double getEarnings() { return earnings; }
    public void setEarnings(double earnings) { this.earnings = earnings; }
}
