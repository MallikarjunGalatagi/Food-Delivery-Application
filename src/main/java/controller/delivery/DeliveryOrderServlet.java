package controller.delivery;

import dao.OrderDAO;
import dao.OrderDAOImpl;
import model.DeliveryPartner;
import model.Order;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "DeliveryOrderServlet", urlPatterns = {"/delivery/orders"})
public class DeliveryOrderServlet extends HttpServlet {
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

        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/delivery/dashboard");
            return;
        }

        int orderId = Integer.parseInt(request.getParameter("id"));

        if ("accept".equals(action)) {
            boolean success = orderDAO.assignRiderToOrder(orderId, partner.getUserId());
            if (success) {
                response.sendRedirect(request.getContextPath() + "/delivery/dashboard?successMsg=Delivery assignment accepted! Go pick up the food.");
            } else {
                response.sendRedirect(request.getContextPath() + "/delivery/dashboard?errorMsg=Could not accept assignment. Someone else might have taken it.");
            }
        } else if ("status".equals(action)) {
            String status = request.getParameter("status");
            Order order = orderDAO.getOrderById(orderId);
            
            if (order != null && order.getDeliveryPartnerId() != null && order.getDeliveryPartnerId() == partner.getUserId()) {
                boolean success = orderDAO.updateOrderStatus(orderId, status);
                if (success) {
                    String msg = "DELIVERED".equals(status) 
                        ? "Delivery completed! Cash collected (if COD) and earnings credited." 
                        : "Order status transitioned.";
                    response.sendRedirect(request.getContextPath() + "/delivery/dashboard?successMsg=" + msg);
                } else {
                    response.sendRedirect(request.getContextPath() + "/delivery/dashboard?errorMsg=Failed to update delivery status.");
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/delivery/dashboard?errorMsg=Unauthorized action.");
            }
        }
    }
}
