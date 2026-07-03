package controller.customer;

import dao.AddressDAO;
import dao.AddressDAOImpl;
import dao.UserDAO;
import dao.UserDAOImpl;
import model.Address;
import model.User;
import org.mindrot.jbcrypt.BCrypt;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "CustomerProfileServlet", urlPatterns = {"/customer/profile"})
public class CustomerProfileServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAOImpl();
    private final AddressDAO addressDAO = new AddressDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }

        // Fetch fresh copy from database
        User freshUser = userDAO.getUserById(user.getId());
        session.setAttribute("user", freshUser);

        // Fetch user addresses
        List<Address> addresses = addressDAO.getAddressesByCustomerId(user.getId());
        request.setAttribute("addresses", addresses);

        // Forward to the JSP page
        request.getRequestDispatcher("/customer/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if ("updateProfile".equals(action)) {
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String phone = request.getParameter("phone");

            user.setFirstName(firstName);
            user.setLastName(lastName);
            user.setPhone(phone);

            boolean success = userDAO.updateProfile(user);
            if (success) {
                session.setAttribute("user", user);
                response.sendRedirect(request.getContextPath() + "/customer/profile?successMsg=Profile details updated successfully.");
            } else {
                response.sendRedirect(request.getContextPath() + "/customer/profile?errorMsg=Failed to update profile details.");
            }
        } else if ("changePassword".equals(action)) {
            String currentPassword = request.getParameter("currentPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");

            // Fetch user from DB to verify old password
            User dbUser = userDAO.getUserById(user.getId());

            if (!BCrypt.checkpw(currentPassword, dbUser.getPassword())) {
                response.sendRedirect(request.getContextPath() + "/customer/profile?errorMsg=Current password does not match.");
                return;
            }

            if (!newPassword.equals(confirmPassword)) {
                response.sendRedirect(request.getContextPath() + "/customer/profile?errorMsg=New password and confirmation do not match.");
                return;
            }

            boolean success = userDAO.updatePassword(user.getId(), newPassword);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/customer/profile?successMsg=Password changed successfully.");
            } else {
                response.sendRedirect(request.getContextPath() + "/customer/profile?errorMsg=Failed to update password.");
            }
        } else if ("addAddress".equals(action)) {
            String addressLine1 = request.getParameter("addressLine1");
            String addressLine2 = request.getParameter("addressLine2");
            String city = request.getParameter("city");
            String state = request.getParameter("state");
            String postalCode = request.getParameter("postalCode");
            boolean isDefault = "true".equals(request.getParameter("isDefault")) || "on".equals(request.getParameter("isDefault"));

            Address address = new Address();
            address.setCustomerId(user.getId());
            address.setAddressLine1(addressLine1);
            address.setAddressLine2(addressLine2);
            address.setCity(city);
            address.setState(state);
            address.setPostalCode(postalCode);
            address.setDefault(isDefault);

            boolean success = addressDAO.addAddress(address);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/customer/profile?successMsg=Address added successfully.");
            } else {
                response.sendRedirect(request.getContextPath() + "/customer/profile?errorMsg=Failed to add address.");
            }
        } else if ("deleteAddress".equals(action)) {
            int addressId = Integer.parseInt(request.getParameter("addressId"));
            boolean success = addressDAO.deleteAddress(addressId);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/customer/profile?successMsg=Address deleted successfully.");
            } else {
                response.sendRedirect(request.getContextPath() + "/customer/profile?errorMsg=Failed to delete address.");
            }
        } else if ("setDefaultAddress".equals(action)) {
            int addressId = Integer.parseInt(request.getParameter("addressId"));
            boolean success = addressDAO.setDefaultAddress(user.getId(), addressId);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/customer/profile?successMsg=Default address updated.");
            } else {
                response.sendRedirect(request.getContextPath() + "/customer/profile?errorMsg=Failed to update default address.");
            }
        }
    }
}
