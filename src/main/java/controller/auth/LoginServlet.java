package controller.auth;

import dao.UserDAO;
import dao.UserDAOImpl;
import model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import util.DBConnection;

@WebServlet(name = "LoginServlet", urlPatterns = {"/auth/login"})
public class LoginServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // If already logged in, redirect to index
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }
        request.getRequestDispatcher("/auth/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        User user = userDAO.getUserByEmail(email);

        if (user != null && BCrypt.checkpw(password, user.getPassword())) {
            if (user.getStatus() == UserStatus.PENDING_APPROVAL) {
                request.setAttribute("errorMsg", "Your account is pending administrator approval. Please wait.");
                request.getRequestDispatcher("/auth/login.jsp").forward(request, response);
                return;
            } else if (user.getStatus() == UserStatus.REJECTED || user.getStatus() == UserStatus.INACTIVE) {
                request.setAttribute("errorMsg", "Your account has been deactivated or rejected. Contact support.");
                request.getRequestDispatcher("/auth/login.jsp").forward(request, response);
                return;
            }

            // Create or update session
            HttpSession session = request.getSession(true);
            session.setAttribute("user", user);

            // Fetch and set role-specific profile details in session
            if (user.getRole() == UserRole.CUSTOMER) {
                Customer customer = userDAO.getCustomerByUserId(user.getId());
                session.setAttribute("customer", customer);
                
                // Initialize active cart size from database
                int cartSize = fetchCartSize(customer.getUserId());
                session.setAttribute("cartSize", cartSize);
                
                response.sendRedirect(request.getContextPath() + "/index.jsp");
            } else if (user.getRole() == UserRole.RESTAURANT_OWNER) {
                Restaurant restaurant = userDAO.getRestaurantByUserId(user.getId());
                session.setAttribute("restaurant", restaurant);
                response.sendRedirect(request.getContextPath() + "/restaurant/dashboard");
            } else if (user.getRole() == UserRole.DELIVERY_PARTNER) {
                DeliveryPartner partner = userDAO.getDeliveryPartnerByUserId(user.getId());
                session.setAttribute("deliveryPartner", partner);
                response.sendRedirect(request.getContextPath() + "/delivery/dashboard");
            } else if (user.getRole() == UserRole.ADMIN) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            }
        } else {
            request.setAttribute("errorMsg", "Invalid email or password. Please try again.");
            request.getRequestDispatcher("/auth/login.jsp").forward(request, response);
        }
    }

    private int fetchCartSize(int customerId) {
        String sql = "SELECT COUNT(*) FROM cart_items ci JOIN carts c ON ci.cart_id = c.id WHERE c.customer_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}
