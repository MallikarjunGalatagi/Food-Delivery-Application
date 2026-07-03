package controller.restaurant;

import dao.RestaurantDAO;
import dao.RestaurantDAOImpl;
import model.Restaurant;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "RestaurantProfileServlet", urlPatterns = {"/restaurant/profile"})
public class RestaurantProfileServlet extends HttpServlet {
    private final RestaurantDAO restaurantDAO = new RestaurantDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Restaurant restaurant = (Restaurant) session.getAttribute("restaurant");
        if (restaurant == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }

        // Fetch fresh copy from database
        Restaurant freshRestaurant = restaurantDAO.getRestaurantById(restaurant.getUserId());
        session.setAttribute("restaurant", freshRestaurant);

        request.getRequestDispatcher("/restaurant/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Restaurant restaurant = (Restaurant) session.getAttribute("restaurant");
        if (restaurant == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }

        String name = request.getParameter("restaurantName");
        String cuisine = request.getParameter("cuisineType");
        int deliveryTime = Integer.parseInt(request.getParameter("deliveryTime"));
        String address = request.getParameter("address");
        String logoPath = request.getParameter("logoPath");
        String bannerPath = request.getParameter("bannerPath");
        boolean isActive = "true".equals(request.getParameter("isActive"));

        restaurant.setRestaurantName(name);
        restaurant.setCuisineType(cuisine);
        restaurant.setEstimatedDeliveryTime(deliveryTime);
        restaurant.setAddress(address);
        restaurant.setLogoPath(logoPath);
        restaurant.setBannerPath(bannerPath);
        restaurant.setActive(isActive);

        boolean success = restaurantDAO.updateRestaurantDetails(restaurant);
        if (success) {
            session.setAttribute("restaurant", restaurant);
            response.sendRedirect(request.getContextPath() + "/restaurant/profile?successMsg=Store profile details updated.");
        } else {
            response.sendRedirect(request.getContextPath() + "/restaurant/profile?errorMsg=Failed to update store details.");
        }
    }
}
