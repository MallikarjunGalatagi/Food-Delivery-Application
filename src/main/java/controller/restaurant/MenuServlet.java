package controller.restaurant;

import dao.MenuDAO;
import dao.MenuDAOImpl;
import model.Category;
import model.FoodItem;
import model.Restaurant;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "MenuServlet", urlPatterns = {"/restaurant/menu"})
public class MenuServlet extends HttpServlet {
    private final MenuDAO menuDAO = new MenuDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Restaurant restaurant = (Restaurant) session.getAttribute("restaurant");
        if (restaurant == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "deleteCategory":
                deleteCategory(request, response, restaurant.getUserId());
                break;
            case "deleteFood":
                deleteFoodItem(request, response, restaurant.getUserId());
                break;
            case "toggleAvailability":
                toggleAvailability(request, response);
                break;
            case "list":
            default:
                listMenu(request, response, restaurant.getUserId());
                break;
        }
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

        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/restaurant/menu");
            return;
        }

        switch (action) {
            case "addCategory":
                addCategory(request, response, restaurant.getUserId());
                break;
            case "addFood":
                addFoodItem(request, response, restaurant.getUserId());
                break;
            case "editFood":
                editFoodItem(request, response, restaurant.getUserId());
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/restaurant/menu");
                break;
        }
    }

    private void listMenu(HttpServletRequest request, HttpServletResponse response, int restaurantId) 
            throws ServletException, IOException {
        List<Category> categories = menuDAO.getCategoriesByRestaurantId(restaurantId);
        List<FoodItem> foodItems = menuDAO.getFoodItemsByRestaurantId(restaurantId);

        request.setAttribute("categories", categories);
        request.setAttribute("foodItems", foodItems);

        request.getRequestDispatcher("/restaurant/menu-management.jsp").forward(request, response);
    }

    private void addCategory(HttpServletRequest request, HttpServletResponse response, int restaurantId) 
            throws IOException {
        String name = request.getParameter("categoryName");
        String desc = request.getParameter("categoryDescription");

        Category category = new Category();
        category.setRestaurantId(restaurantId);
        category.setName(name);
        category.setDescription(desc);

        boolean success = menuDAO.addCategory(category);
        if (success) {
            response.sendRedirect(request.getContextPath() + "/restaurant/menu?successMsg=Category added successfully.");
        } else {
            response.sendRedirect(request.getContextPath() + "/restaurant/menu?errorMsg=Failed to add category.");
        }
    }

    private void deleteCategory(HttpServletRequest request, HttpServletResponse response, int restaurantId) 
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Category category = menuDAO.getCategoryById(id);

        if (category != null && category.getRestaurantId() == restaurantId) {
            menuDAO.deleteCategory(id);
            response.sendRedirect(request.getContextPath() + "/restaurant/menu?successMsg=Category deleted successfully.");
        } else {
            response.sendRedirect(request.getContextPath() + "/restaurant/menu?errorMsg=Failed to delete category.");
        }
    }

    private void addFoodItem(HttpServletRequest request, HttpServletResponse response, int restaurantId) 
            throws IOException {
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));
        String name = request.getParameter("foodName");
        String desc = request.getParameter("foodDescription");
        double price = Double.parseDouble(request.getParameter("foodPrice"));
        boolean isVeg = "true".equals(request.getParameter("isVeg"));
        String imagePath = request.getParameter("imagePath");

        FoodItem item = new FoodItem();
        item.setRestaurantId(restaurantId);
        item.setCategoryId(categoryId);
        item.setName(name);
        item.setDescription(desc);
        item.setPrice(price);
        item.setVeg(isVeg);
        item.setAvailable(true);
        item.setImagePath(imagePath);

        boolean success = menuDAO.addFoodItem(item);
        if (success) {
            response.sendRedirect(request.getContextPath() + "/restaurant/menu?successMsg=Food item added.");
        } else {
            response.sendRedirect(request.getContextPath() + "/restaurant/menu?errorMsg=Failed to add food item.");
        }
    }

    private void editFoodItem(HttpServletRequest request, HttpServletResponse response, int restaurantId) 
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));
        String name = request.getParameter("foodName");
        String desc = request.getParameter("foodDescription");
        double price = Double.parseDouble(request.getParameter("foodPrice"));
        boolean isVeg = "true".equals(request.getParameter("isVeg"));
        boolean isAvailable = "true".equals(request.getParameter("isAvailable"));
        String imagePath = request.getParameter("imagePath");

        FoodItem item = menuDAO.getFoodItemById(id);
        if (item != null && item.getRestaurantId() == restaurantId) {
            item.setCategoryId(categoryId);
            item.setName(name);
            item.setDescription(desc);
            item.setPrice(price);
            item.setVeg(isVeg);
            item.setAvailable(isAvailable);
            item.setImagePath(imagePath);

            menuDAO.updateFoodItem(item);
            response.sendRedirect(request.getContextPath() + "/restaurant/menu?successMsg=Food item updated.");
        } else {
            response.sendRedirect(request.getContextPath() + "/restaurant/menu?errorMsg=Failed to update food item.");
        }
    }

    private void deleteFoodItem(HttpServletRequest request, HttpServletResponse response, int restaurantId) 
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        FoodItem item = menuDAO.getFoodItemById(id);

        if (item != null && item.getRestaurantId() == restaurantId) {
            menuDAO.deleteFoodItem(id);
            response.sendRedirect(request.getContextPath() + "/restaurant/menu?successMsg=Food item deleted.");
        } else {
            response.sendRedirect(request.getContextPath() + "/restaurant/menu?errorMsg=Failed to delete food item.");
        }
    }

    private void toggleAvailability(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        boolean available = Boolean.parseBoolean(request.getParameter("available"));
        
        menuDAO.updateFoodAvailability(id, available);
        response.sendRedirect(request.getContextPath() + "/restaurant/menu?successMsg=Availability status toggled.");
    }
}
