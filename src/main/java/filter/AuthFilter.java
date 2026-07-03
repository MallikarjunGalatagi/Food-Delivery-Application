package filter;

import model.User;
import model.UserRole;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter(filterName = "AuthFilter", urlPatterns = {"/admin/*", "/customer/*", "/restaurant/*", "/delivery/*"})
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) 
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        
        String requestURI = httpRequest.getRequestURI();
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        
        if (user == null) {
            // User is not logged in. Redirect to login.
            session = httpRequest.getSession(true);
            session.setAttribute("errorMsg", "Please log in to access this page.");
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/auth/login.jsp");
            return;
        }
        
        UserRole role = user.getRole();
        boolean authorized = false;
        
        if (requestURI.contains("/admin/")) {
            authorized = (role == UserRole.ADMIN);
        } else if (requestURI.contains("/customer/")) {
            authorized = (role == UserRole.CUSTOMER);
        } else if (requestURI.contains("/delivery/")) {
            authorized = (role == UserRole.DELIVERY_PARTNER);
        } else if (requestURI.contains("/restaurant/")) {
            // Restaurant owner dashboard paths (e.g. /restaurant/dashboard, /restaurant/menu)
            authorized = (role == UserRole.RESTAURANT_OWNER);
        } else if (requestURI.endsWith("/restaurant")) {
            // Customer restaurant browsing servlet (/restaurant)
            authorized = (role == UserRole.CUSTOMER || role == UserRole.ADMIN || role == UserRole.RESTAURANT_OWNER);
        }
        
        if (authorized) {
            chain.doFilter(request, response);
        } else {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/index.jsp");
        }
    }

    @Override
    public void destroy() {}
}
