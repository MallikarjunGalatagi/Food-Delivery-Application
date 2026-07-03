package controller.delivery;

import dao.*;
import model.DeliveryPartner;
import model.Order;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet(name = "DeliveryDashboardServlet", urlPatterns = {"/delivery/dashboard"})
public class DeliveryDashboardServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAOImpl();
    private final OrderDAO orderDAO = new OrderDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        DeliveryPartner partner = (DeliveryPartner) session.getAttribute("deliveryPartner");
        if (partner == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }

        // Fetch fresh rider status (earnings, availability)
        partner = userDAO.getDeliveryPartnerByUserId(partner.getUserId());
        session.setAttribute("deliveryPartner", partner);

        // Fetch available orders for delivery (marked READY_FOR_PICKUP and unassigned)
        List<Order> availableOrders = orderDAO.getAvailableOrdersForDelivery();

        // Fetch assigned orders
        List<Order> assignedOrders = orderDAO.getAssignedOrdersByRiderId(partner.getUserId());
        
        // Filter active vs completed
        Order activeDelivery = assignedOrders.stream()
            .filter(o -> !o.isDelivered() && !o.isCancelled())
            .findFirst()
            .orElse(null);
            
        List<Order> completedDeliveries = assignedOrders.stream()
            .filter(o -> o.isDelivered())
            .collect(Collectors.toList());

        request.setAttribute("availableOrders", availableOrders);
        request.setAttribute("activeDelivery", activeDelivery);
        request.setAttribute("completedDeliveries", completedDeliveries);
        request.setAttribute("deliveriesCount", completedDeliveries.size());

        request.getRequestDispatcher("/delivery/dashboard.jsp").forward(request, response);
    }
}
