<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
    <!-- Footer Section -->
    <footer class="footer-custom">
        <div class="container">
            <div class="row">
                <div class="col-md-4 mb-4">
                    <h5 class="text-white"><i class="fa-solid fa-utensils text-primary-custom me-2"></i>Foodify</h5>
                    <p>Bringing delicious meals from your favorite local restaurants straight to your doorstep. Fast, fresh, and hassle-free.</p>
                </div>
                <div class="col-md-2 mb-4">
                    <h5>Quick Links</h5>
                    <ul class="list-unstyled">
                        <li><a href="${pageContext.request.contextPath}/index.jsp">Home</a></li>
                        <li><a href="${pageContext.request.contextPath}/common/about.jsp">About Us</a></li>
                        <li><a href="${pageContext.request.contextPath}/restaurant?action=list">Restaurants</a></li>
                        <li><a href="${pageContext.request.contextPath}/common/contact.jsp">Contact</a></li>
                    </ul>
                </div>
                <div class="col-md-3 mb-4">
                    <h5>For Partners</h5>
                    <ul class="list-unstyled">
                        <li><a href="${pageContext.request.contextPath}/auth/register.jsp?role=RESTAURANT_OWNER">Partner With Us</a></li>
                        <li><a href="${pageContext.request.contextPath}/auth/register.jsp?role=DELIVERY_PARTNER">Ride with Us</a></li>
                    </ul>
                </div>
                <div class="col-md-3 mb-4">
                    <h5>Contact Us</h5>
                    <p><i class="fa-solid fa-envelope me-2 text-primary-custom"></i> support@foodify.com</p>
                    <p><i class="fa-solid fa-phone me-2 text-primary-custom"></i> +1 (555) 123-4567</p>
                    <div class="d-flex gap-3 mt-3">
                        <a href="#" class="fs-5"><i class="fa-brands fa-facebook"></i></a>
                        <a href="#" class="fs-5"><i class="fa-brands fa-twitter"></i></a>
                        <a href="#" class="fs-5"><i class="fa-brands fa-instagram"></i></a>
                    </div>
                </div>
            </div>
            <div class="footer-bottom text-center">
                <p class="mb-0">&copy; 2026 Foodify Online Food Delivery System. Built with Java, Servlets, and JSP.</p>
            </div>
        </div>
    </footer>

    <!-- Bootstrap 5 JS Bundle (Includes Popper) -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
