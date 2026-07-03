package controller.admin;

import dao.UserDAO;
import dao.UserDAOImpl;
import model.Restaurant;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "RestaurantApprovalServlet", urlPatterns = {"/admin/restaurants"})
public class RestaurantApprovalServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "approve":
                approveRestaurant(request, response);
                break;
            case "reject":
                rejectRestaurant(request, response);
                break;
            case "list":
            default:
                listRestaurants(request, response);
                break;
        }
    }

    private void listRestaurants(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Restaurant> pending = userDAO.getPendingRestaurants();
        List<Restaurant> all = userDAO.getAllRestaurants();

        request.setAttribute("pendingRestaurants", pending);
        request.setAttribute("allRestaurants", all);
        request.getRequestDispatcher("/admin/manage-restaurants.jsp").forward(request, response);
    }

    private void approveRestaurant(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        boolean success = userDAO.updateRestaurantStatus(id, "ACTIVE");
        if (success) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard?successMsg=Restaurant approved successfully.");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard?errorMsg=Failed to approve restaurant.");
        }
    }

    private void rejectRestaurant(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        boolean success = userDAO.updateRestaurantStatus(id, "REJECTED");
        if (success) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard?successMsg=Restaurant registration rejected.");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard?errorMsg=Failed to reject restaurant.");
        }
    }
}
