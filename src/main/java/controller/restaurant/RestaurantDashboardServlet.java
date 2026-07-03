package controller.restaurant;

import dao.*;
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
import java.util.stream.Collectors;

@WebServlet(name = "RestaurantDashboardServlet", urlPatterns = {"/restaurant/dashboard"})
public class RestaurantDashboardServlet extends HttpServlet {
    private final OrderDAO orderDAO = new OrderDAOImpl();
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

        // Stats
        int todayOrders = orderDAO.getTodayOrdersCount(restaurant.getUserId());
        double todayRevenue = orderDAO.getTodayRevenue(restaurant.getUserId());
        double monthlyRevenue = orderDAO.getMonthlyRevenue(restaurant.getUserId());
        int menuItemsCount = menuDAO.getFoodItemsByRestaurantId(restaurant.getUserId()).size();

        // Load active orders (filter out delivered and cancelled for the immediate action panel)
        List<Order> allOrders = orderDAO.getOrdersByRestaurantId(restaurant.getUserId());
        List<Order> activeOrders = allOrders.stream()
            .filter(o -> !o.isDelivered() && !o.isCancelled())
            .collect(Collectors.toList());

        request.setAttribute("todayOrders", todayOrders);
        request.setAttribute("todayRevenue", todayRevenue);
        request.setAttribute("monthlyRevenue", monthlyRevenue);
        request.setAttribute("menuItemsCount", menuItemsCount);
        request.setAttribute("activeOrders", activeOrders);

        request.getRequestDispatcher("/restaurant/dashboard.jsp").forward(request, response);
    }
}
