package controller.auth;

import dao.UserDAO;
import dao.UserDAOImpl;
import model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/auth/register"})
public class RegisterServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/auth/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String roleStr = request.getParameter("role");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");

        // Validate Email Uniqueness
        if (userDAO.getUserByEmail(email) != null) {
            request.setAttribute("errorMsg", "Email address is already in use. Please choose another.");
            request.getRequestDispatcher("/auth/register.jsp").forward(request, response);
            return;
        }

        UserRole role = UserRole.valueOf(roleStr);
        UserStatus status = (role == UserRole.RESTAURANT_OWNER) ? UserStatus.PENDING_APPROVAL : UserStatus.ACTIVE;

        User user = new User();
        user.setEmail(email);
        user.setPassword(password);
        user.setFirstName(firstName);
        user.setLastName(lastName);
        user.setPhone(phone);
        user.setRole(role);
        user.setStatus(status);

        boolean success = false;

        if (role == UserRole.CUSTOMER) {
            Customer customer = new Customer();
            customer.setUser(user);
            customer.setLoyaltyPoints(0);
            success = userDAO.registerCustomer(customer);
        } else if (role == UserRole.RESTAURANT_OWNER) {
            String restaurantName = request.getParameter("restaurantName");
            String cuisineType = request.getParameter("cuisineType");
            int deliveryTime = Integer.parseInt(request.getParameter("deliveryTime"));
            String address = request.getParameter("restaurantAddress");

            Restaurant restaurant = new Restaurant();
            restaurant.setUser(user);
            restaurant.setRestaurantName(restaurantName);
            restaurant.setCuisineType(cuisineType);
            restaurant.setEstimatedDeliveryTime(deliveryTime);
            restaurant.setAddress(address);
            restaurant.setActive(true);

            success = userDAO.registerRestaurant(restaurant);
        } else if (role == UserRole.DELIVERY_PARTNER) {
            String vehicleNumber = request.getParameter("vehicleNumber");
            String licenseNumber = request.getParameter("licenseNumber");

            DeliveryPartner partner = new DeliveryPartner();
            partner.setUser(user);
            partner.setVehicleNumber(vehicleNumber);
            partner.setLicenseNumber(licenseNumber);
            partner.setAvailable(true);

            success = userDAO.registerDeliveryPartner(partner);
        }

        if (success) {
            String msg = (role == UserRole.RESTAURANT_OWNER) 
                ? "Registration successful! Your store is pending administrator approval before you can log in."
                : "Registration successful! You can now log in.";
            request.setAttribute("successMsg", msg);
            request.getRequestDispatcher("/auth/login.jsp").forward(request, response);
        } else {
            request.setAttribute("errorMsg", "An error occurred during registration. Please try again.");
            request.getRequestDispatcher("/auth/register.jsp").forward(request, response);
        }
    }
}
