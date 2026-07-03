package dao;

import model.Review;
import java.util.List;

public interface ReviewDAO {
    List<Review> getReviewsByRestaurantId(int restaurantId);
    boolean addReview(Review review);
    double getAverageRatingForRestaurant(int restaurantId);
}
