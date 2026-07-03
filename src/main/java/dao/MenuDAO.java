package dao;

import model.Category;
import model.FoodItem;
import java.util.List;

public interface MenuDAO {
    // Categories CRUD
    List<Category> getCategoriesByRestaurantId(int restaurantId);
    Category getCategoryById(int id);
    boolean addCategory(Category category);
    boolean updateCategory(Category category);
    boolean deleteCategory(int id);

    // Food Items CRUD
    List<FoodItem> getFoodItemsByRestaurantId(int restaurantId);
    List<FoodItem> getFoodItemsByCategoryId(int categoryId);
    FoodItem getFoodItemById(int id);
    boolean addFoodItem(FoodItem item);
    boolean updateFoodItem(FoodItem item);
    boolean deleteFoodItem(int id);
    boolean updateFoodAvailability(int foodItemId, boolean isAvailable);
    List<FoodItem> searchFoodItems(String query);
}
