package controller.restaurant;

import dao.ReviewDAO;
import dao.ReviewDAOImpl;
import model.Restaurant;
import model.Review;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "RestaurantReviewsServlet", urlPatterns = {"/restaurant/reviews"})
public class RestaurantReviewsServlet extends HttpServlet {
    private final ReviewDAO reviewDAO = new ReviewDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Restaurant restaurant = (Restaurant) session.getAttribute("restaurant");
        if (restaurant == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }

        List<Review> reviews = reviewDAO.getReviewsByRestaurantId(restaurant.getUserId());
        request.setAttribute("reviews", reviews);

        request.getRequestDispatcher("/restaurant/reviews.jsp").forward(request, response);
    }
}
