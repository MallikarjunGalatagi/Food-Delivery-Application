package dao;

import model.Restaurant;
import java.util.List;

public interface RestaurantDAO {
    List<Restaurant> getActiveRestaurants(String search, String cuisine, String sortBy);
    Restaurant getRestaurantById(int id);
    List<String> getAllCuisines();
    boolean updateRestaurantDetails(Restaurant restaurant);
}
