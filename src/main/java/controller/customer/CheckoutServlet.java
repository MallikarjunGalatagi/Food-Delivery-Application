package controller.customer;

import dao.*;
import model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "CheckoutServlet", urlPatterns = {"/customer/checkout"})
public class CheckoutServlet extends HttpServlet {
    private final CartDAO cartDAO = new CartDAOImpl();
    private final AddressDAO addressDAO = new AddressDAOImpl();
    private final OrderDAO orderDAO = new OrderDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Customer customer = (Customer) session.getAttribute("customer");
        if (customer == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }

        Cart cart = cartDAO.getCartByCustomerId(customer.getUserId());
        if (cart == null || cart.getItems().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/customer/cart");
            return;
        }

        List<Address> addresses = addressDAO.getAddressesByCustomerId(customer.getUserId());
        request.setAttribute("cart", cart);
        request.setAttribute("addresses", addresses);
        request.getRequestDispatcher("/customer/checkout.jsp").forward(request, response);
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

        // Handle inline address insertion
        String addressAction = request.getParameter("addressAction");
        if ("addAddress".equals(addressAction)) {
            addNewAddress(request, response, customer.getUserId());
            return;
        }

        String addressIdStr = request.getParameter("addressId");
        String paymentMethod = request.getParameter("paymentMethod");

        if (addressIdStr == null || addressIdStr.trim().isEmpty()) {
            request.setAttribute("errorMsg", "Please select a delivery address.");
            doGet(request, response);
            return;
        }

        Cart cart = cartDAO.getCartByCustomerId(customer.getUserId());
        if (cart == null || cart.getItems().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/customer/cart");
            return;
        }

        int addressId = Integer.parseInt(addressIdStr);

        Order order = new Order();
        order.setCustomerId(customer.getUserId());
        order.setRestaurantId(cart.getItems().get(0).getFoodItem().getRestaurantId());
        order.setSubtotal(cart.getSubtotal());
        order.setDeliveryCharge(cart.getDeliveryCharge());
        order.setTax(cart.getTax());
        order.setGrandTotal(cart.getGrandTotal());
        order.setAddressId(addressId);
        order.setPaymentMethod(paymentMethod);
        
        // Demo payment handling
        if ("ONLINE".equalsIgnoreCase(paymentMethod)) {
            order.setPaymentStatus("COMPLETED");
        } else {
            order.setPaymentStatus("PENDING");
        }

        List<OrderItem> orderItems = new ArrayList<>();
        for (CartItem ci : cart.getItems()) {
            OrderItem oi = new OrderItem();
            oi.setFoodItemId(ci.getFoodItem().getId());
            oi.setQuantity(ci.getQuantity());
            oi.setPrice(ci.getFoodItem().getPrice());
            orderItems.add(oi);
        }
        order.setItems(orderItems);

        int orderId = orderDAO.placeOrder(order);
        
        if (orderId != -1) {
            // Update session cart size
            session.setAttribute("cartSize", 0);
            
            // Redirect to tracking page
            response.sendRedirect(request.getContextPath() + "/customer/orders?action=track&id=" + orderId);
        } else {
            request.setAttribute("errorMsg", "Failed to place your order. Please try again.");
            doGet(request, response);
        }
    }

    private void addNewAddress(HttpServletRequest request, HttpServletResponse response, int customerId) 
            throws IOException {
        String line1 = request.getParameter("addressLine1");
        String line2 = request.getParameter("addressLine2");
        String city = request.getParameter("city");
        String state = request.getParameter("state");
        String zip = request.getParameter("postalCode");
        boolean isDefault = "on".equals(request.getParameter("isDefault"));

        Address address = new Address();
        address.setCustomerId(customerId);
        address.setAddressLine1(line1);
        address.setAddressLine2(line2);
        address.setCity(city);
        address.setState(state);
        address.setPostalCode(zip);
        address.setDefault(isDefault);

        addressDAO.addAddress(address);
        response.sendRedirect(request.getContextPath() + "/customer/checkout");
    }
}
