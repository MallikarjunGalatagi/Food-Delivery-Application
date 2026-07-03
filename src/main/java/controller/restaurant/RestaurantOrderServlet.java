package controller.restaurant;

import dao.OrderDAO;
import dao.OrderDAOImpl;
import model.Order;
import model.Restaurant;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "RestaurantOrderServlet", urlPatterns = {"/restaurant/orders"})
public class RestaurantOrderServlet extends HttpServlet {
    private final OrderDAO orderDAO = new OrderDAOImpl();

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
            case "accept":
                updateOrder(request, response, restaurant, "ACCEPTED", "Order accepted.");
                break;
            case "reject":
                updateOrder(request, response, restaurant, "CANCELLED", "Order rejected and cancelled.");
                break;
            case "status":
                String status = request.getParameter("status");
                updateOrder(request, response, restaurant, status, "Status updated to " + status + ".");
                break;
            case "list":
            default:
                listHistoricalOrders(request, response, restaurant);
                break;
        }
    }

    private void updateOrder(HttpServletRequest request, HttpServletResponse response, Restaurant restaurant, String status, String successMsg) 
            throws IOException {
        int orderId = Integer.parseInt(request.getParameter("id"));
        Order order = orderDAO.getOrderById(orderId);

        if (order != null && order.getRestaurantId() == restaurant.getUserId()) {
            boolean success = orderDAO.updateOrderStatus(orderId, status);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/restaurant/dashboard?successMsg=" + successMsg);
                return;
            }
        }
        response.sendRedirect(request.getContextPath() + "/restaurant/dashboard?errorMsg=Failed to update order state.");
    }

    private void listHistoricalOrders(HttpServletRequest request, HttpServletResponse response, Restaurant restaurant) 
            throws ServletException, IOException {
        List<Order> orders = orderDAO.getOrdersByRestaurantId(restaurant.getUserId());
        request.setAttribute("orders", orders);
        request.getRequestDispatcher("/restaurant/order-history.jsp").forward(request, response);
    }
}
