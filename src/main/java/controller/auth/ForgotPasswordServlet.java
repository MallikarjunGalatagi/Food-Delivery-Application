package controller.auth;

import dao.UserDAO;
import dao.UserDAOImpl;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "ForgotPasswordServlet", urlPatterns = {"/auth/forgot-password"})
public class ForgotPasswordServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/auth/forgot-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String newPassword = request.getParameter("newPassword");

        User user = userDAO.getUserByEmail(email);

        if (user != null && user.getPhone().equals(phone)) {
            boolean success = userDAO.updatePassword(user.getId(), newPassword);
            if (success) {
                request.setAttribute("successMsg", "Password reset successfully! Log in with your new password.");
                request.getRequestDispatcher("/auth/login.jsp").forward(request, response);
            } else {
                request.setAttribute("errorMsg", "An error occurred while updating the password. Try again.");
                request.getRequestDispatcher("/auth/forgot-password.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("errorMsg", "Verification failed. Email and phone number do not match.");
            request.getRequestDispatcher("/auth/forgot-password.jsp").forward(request, response);
        }
    }
}
