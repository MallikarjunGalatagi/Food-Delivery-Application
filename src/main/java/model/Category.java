package model;

public class Category {
    private int id;
    private int restaurantId;
    private String name;
    private String description;

    public Category() {}

    public Category(int id, int restaurantId, String name, String description) {
        this.id = id;
        this.restaurantId = restaurantId;
        this.name = name;
        this.description = description;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getRestaurantId() { return restaurantId; }
    public void setRestaurantId(int restaurantId) { this.restaurantId = restaurantId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
}
