package controller.admin;

import dao.*;
import model.Order;
import model.Restaurant;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/admin/dashboard"})
public class AdminDashboardServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAOImpl();
    private final OrderDAO orderDAO = new OrderDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // System metrics
        double totalRevenue = orderDAO.getPlatformTotalRevenue();
        int totalOrdersCount = orderDAO.getPlatformTotalOrdersCount();
        int customersCount = userDAO.getCustomersCount();
        int activeRestaurants = userDAO.getActiveRestaurantsCount();
        int pendingRestaurants = userDAO.getPendingRestaurantsCount();
        int ridersCount = userDAO.getRidersCount();

        // Lists for preview panels
        List<Order> recentOrders = orderDAO.getAllOrders();
        List<Order> topRecent = recentOrders.subList(0, Math.min(recentOrders.size(), 5));
        
        List<Restaurant> pendingList = userDAO.getPendingRestaurants();

        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("totalOrdersCount", totalOrdersCount);
        request.setAttribute("customersCount", customersCount);
        request.setAttribute("activeRestaurants", activeRestaurants);
        request.setAttribute("pendingRestaurants", pendingRestaurants);
        request.setAttribute("ridersCount", ridersCount);
        
        request.setAttribute("recentOrders", topRecent);
        request.setAttribute("pendingList", pendingList);

        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }
}
