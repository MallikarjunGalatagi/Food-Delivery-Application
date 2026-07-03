package controller.admin;

import dao.UserDAO;
import dao.UserDAOImpl;
import model.Customer;
import model.DeliveryPartner;
import model.Restaurant;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminUserManagementServlet", urlPatterns = {"/admin/users"})
public class AdminUserManagementServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Customer> customers = userDAO.getAllCustomers();
        List<Restaurant> restaurants = userDAO.getAllRestaurants();
        List<DeliveryPartner> partners = userDAO.getAllDeliveryPartners();

        request.setAttribute("customersList", customers);
        request.setAttribute("restaurantsList", restaurants);
        request.setAttribute("partnersList", partners);

        request.getRequestDispatcher("/admin/manage-users.jsp").forward(request, response);
    }
}
