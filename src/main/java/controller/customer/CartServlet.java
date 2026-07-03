package controller.customer;

import dao.CartDAO;
import dao.CartDAOImpl;
import dao.MenuDAO;
import dao.MenuDAOImpl;
import model.Cart;
import model.CartItem;
import model.Customer;
import model.FoodItem;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "CartServlet", urlPatterns = {"/customer/cart"})
public class CartServlet extends HttpServlet {
    private final CartDAO cartDAO = new CartDAOImpl();
    private final MenuDAO menuDAO = new MenuDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Customer customer = (Customer) session.getAttribute("customer");
        
        if (customer == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if ("clearAndAdd".equals(action)) {
            clearAndAdd(request, response, customer);
            return;
        }
        if ("clear".equals(action)) {
            cartDAO.clearCart(customer.getUserId());
            session.setAttribute("cartSize", 0);
            response.sendRedirect(request.getContextPath() + "/customer/cart");
            return;
        }

        Cart cart = cartDAO.getCartByCustomerId(customer.getUserId());
        session.setAttribute("cartSize", cart.getItems().size());
        request.setAttribute("cart", cart);

        request.getRequestDispatcher("/customer/cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Customer customer = (Customer) session.getAttribute("customer");

        if (customer == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/customer/cart");
            return;
        }

        switch (action) {
            case "add":
                addItem(request, response, customer);
                break;
            case "update":
                updateItem(request, response, customer);
                break;
            case "remove":
                removeItem(request, response, customer);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/customer/cart");
                break;
        }
    }

    private void addItem(HttpServletRequest request, HttpServletResponse response, Customer customer) 
            throws IOException {
        int foodItemId = Integer.parseInt(request.getParameter("foodItemId"));
        int restaurantId = Integer.parseInt(request.getParameter("restaurantId"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));

        // Load existing cart to enforce single-restaurant rule
        Cart cart = cartDAO.getCartByCustomerId(customer.getUserId());
        if (cart != null && !cart.getItems().isEmpty()) {
            CartItem firstItem = cart.getItems().get(0);
            int existingRestaurantId = firstItem.getFoodItem().getRestaurantId();
            
            if (existingRestaurantId != restaurantId) {
                // Mismatch restaurant! Send error query param
                response.sendRedirect(request.getContextPath() + "/restaurant?action=details&id=" + restaurantId + 
                    "&errorMsg=mismatch&mismatchFoodItemId=" + foodItemId + "&mismatchRestaurantId=" + restaurantId);
                return;
            }
        }

        boolean success = cartDAO.addItemToCart(customer.getUserId(), foodItemId, quantity);
        if (success) {
            // Update cart count
            Cart updatedCart = cartDAO.getCartByCustomerId(customer.getUserId());
            request.getSession().setAttribute("cartSize", updatedCart.getItems().size());
            
            response.sendRedirect(request.getContextPath() + "/restaurant?action=details&id=" + restaurantId + 
                "&successMsg=Item added to cart!");
        } else {
            response.sendRedirect(request.getContextPath() + "/restaurant?action=details&id=" + restaurantId + 
                "&errorMsg=Failed to add item. Please try again.");
        }
    }

    private void clearAndAdd(HttpServletRequest request, HttpServletResponse response, Customer customer) 
            throws IOException {
        int foodItemId = Integer.parseInt(request.getParameter("foodItemId"));
        int restaurantId = Integer.parseInt(request.getParameter("restaurantId"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));

        // Clear existing cart items
        cartDAO.clearCart(customer.getUserId());
        
        // Add the new item
        boolean success = cartDAO.addItemToCart(customer.getUserId(), foodItemId, quantity);
        if (success) {
            Cart updatedCart = cartDAO.getCartByCustomerId(customer.getUserId());
            request.getSession().setAttribute("cartSize", updatedCart.getItems().size());
            response.sendRedirect(request.getContextPath() + "/restaurant?action=details&id=" + restaurantId + 
                "&successMsg=Cart cleared and new item added!");
        } else {
            response.sendRedirect(request.getContextPath() + "/restaurant?action=details&id=" + restaurantId + 
                "&errorMsg=Failed to add item. Please try again.");
        }
    }

    private void updateItem(HttpServletRequest request, HttpServletResponse response, Customer customer) 
            throws IOException {
        int foodItemId = Integer.parseInt(request.getParameter("foodItemId"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));

        cartDAO.updateItemQuantity(customer.getUserId(), foodItemId, quantity);
        
        Cart updatedCart = cartDAO.getCartByCustomerId(customer.getUserId());
        request.getSession().setAttribute("cartSize", updatedCart.getItems().size());

        response.sendRedirect(request.getContextPath() + "/customer/cart");
    }

    private void removeItem(HttpServletRequest request, HttpServletResponse response, Customer customer) 
            throws IOException {
        int foodItemId = Integer.parseInt(request.getParameter("foodItemId"));

        cartDAO.removeItemFromCart(customer.getUserId(), foodItemId);

        Cart updatedCart = cartDAO.getCartByCustomerId(customer.getUserId());
        request.getSession().setAttribute("cartSize", updatedCart.getItems().size());

        response.sendRedirect(request.getContextPath() + "/customer/cart");
    }
}
