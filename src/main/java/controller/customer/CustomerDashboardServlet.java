package controller.customer;

import dao.*;
import model.Address;
import model.Customer;
import model.Order;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "CustomerDashboardServlet", urlPatterns = {"/customer/dashboard"})
public class CustomerDashboardServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAOImpl();
    private final AddressDAO addressDAO = new AddressDAOImpl();
    private final OrderDAO orderDAO = new OrderDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Customer sessionCustomer = (Customer) session.getAttribute("customer");
        if (sessionCustomer == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }

        // Fetch fresh copy of customer detail
        Customer customer = userDAO.getCustomerByUserId(sessionCustomer.getUserId());
        session.setAttribute("customer", customer);

        List<Address> addresses = addressDAO.getAddressesByCustomerId(customer.getUserId());
        List<Order> orders = orderDAO.getOrdersByCustomerId(customer.getUserId());
        
        // Take top 3 recent orders for preview
        List<Order> recentOrders = orders.subList(0, Math.min(orders.size(), 3));

        request.setAttribute("addresses", addresses);
        request.setAttribute("recentOrders", recentOrders);
        request.setAttribute("totalOrdersCount", orders.size());

        request.getRequestDispatcher("/customer/dashboard.jsp").forward(request, response);
    }
}
