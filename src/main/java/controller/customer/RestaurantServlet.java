package controller.customer;

import dao.*;
import model.Category;
import model.FoodItem;
import model.Restaurant;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "RestaurantServlet", urlPatterns = {"/restaurant"})
public class RestaurantServlet extends HttpServlet {
    private final RestaurantDAO restaurantDAO = new RestaurantDAOImpl();
    private final MenuDAO menuDAO = new MenuDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "details":
                showRestaurantDetails(request, response);
                break;
            case "list":
            default:
                listRestaurants(request, response);
                break;
        }
    }

    private void listRestaurants(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String search = request.getParameter("search");
        String cuisine = request.getParameter("cuisine");
        String sortBy = request.getParameter("sortBy");

        List<Restaurant> restaurants = restaurantDAO.getActiveRestaurants(search, cuisine, sortBy);
        List<String> cuisines = restaurantDAO.getAllCuisines();
        List<FoodItem> matchingFoodItems = null;

        if (search != null && !search.trim().isEmpty()) {
            matchingFoodItems = menuDAO.searchFoodItems(search);
        }

        request.setAttribute("restaurants", restaurants);
        request.setAttribute("cuisines", cuisines);
        request.setAttribute("matchingFoodItems", matchingFoodItems);
        request.setAttribute("searchParam", search);
        request.setAttribute("cuisineParam", cuisine);
        request.setAttribute("sortByParam", sortBy);

        request.getRequestDispatcher("/customer/restaurants.jsp").forward(request, response);
    }

    private void showRestaurantDetails(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null) {
            response.sendRedirect(request.getContextPath() + "/restaurant?action=list");
            return;
        }

        int id = Integer.parseInt(idStr);
        Restaurant restaurant = restaurantDAO.getRestaurantById(id);
        
        if (restaurant == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Restaurant not found");
            return;
        }

        List<Category> categories = menuDAO.getCategoriesByRestaurantId(id);
        List<FoodItem> foodItems = menuDAO.getFoodItemsByRestaurantId(id);

        request.setAttribute("restaurant", restaurant);
        request.setAttribute("categories", categories);
        request.setAttribute("foodItems", foodItems);

        request.getRequestDispatcher("/customer/restaurant-details.jsp").forward(request, response);
    }
}
