<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="pageTitle" value="Foodify | Premium Online Food Delivery" scope="request" />
<jsp:include page="common/header.jsp" />
<jsp:include page="common/navbar.jsp" />

<!-- Hero Section -->
<section class="hero-section text-center text-md-start">
    <div class="container">
        <div class="row align-items-center">
            <div class="col-md-6 mb-5 mb-md-0">
                <span class="badge bg-warning-subtle text-warning-emphasis px-3 py-2 rounded-pill font-weight-600 mb-3 fs-6">
                    <i class="fa-solid fa-fire me-1"></i> Hungry? We've got you covered!
                </span>
                <h1 class="display-4 fw-bold mb-3" style="line-height: 1.2;">
                    Delicious Meals Delivered <br><span class="text-primary-custom">Right To Your Door</span>
                </h1>
                <p class="lead text-muted mb-4 fs-5">
                    Order from the best local restaurants in your city. Fresh ingredients, professional chefs, and lightning-fast delivery.
                </p>
                
                <!-- Main Search Bar -->
                <form action="${pageContext.request.contextPath}/restaurant" method="get" class="d-flex flex-column flex-sm-row gap-2 max-width-500 search-container">
                    <input type="hidden" name="action" value="list">
                    <div class="search-bar-wrapper flex-grow-1 d-flex align-items-center">
                        <i class="fa-solid fa-magnifying-glass text-muted ms-3"></i>
                        <input type="text" name="search" class="search-input py-3 ps-2 pe-3" placeholder="Search cuisines, restaurants, or food items..." aria-label="Search">
                    </div>
                    <button class="btn btn-primary-custom px-4 py-3 rounded-pill hover-lift" type="submit">Find Food</button>
                </form>
            </div>
            
            <div class="col-md-6 text-center">
                <!-- Hero Image Illustration -->
                <div class="position-relative d-inline-block">
                    <img src="https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&q=80&w=600" class="img-fluid rounded-4 shadow-lg" alt="Delicious Food Spread" style="max-height: 400px; object-fit: cover; width: 100%;">
                    <div class="position-absolute bottom-0 start-0 bg-white p-3 rounded-3 shadow-md m-3 d-flex align-items-center gap-3">
                        <div class="bg-success-subtle p-2.5 rounded-circle text-success fs-4 d-flex align-items-center justify-content-center" style="width: 48px; height: 48px;">
                            <i class="fa-solid fa-clock-rotate-left"></i>
                        </div>
                        <div class="text-start">
                            <h6 class="mb-0 fw-bold">Super Fast Delivery</h6>
                            <span class="text-muted small">Under 30 Minutes</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Features Highlights -->
<section class="py-5 bg-white">
    <div class="container">
        <div class="text-center mb-5">
            <h2 class="fw-bold">Why Order from Foodify?</h2>
            <p class="text-muted">The best food delivery experience in town</p>
        </div>
        
        <div class="row g-4">
            <div class="col-md-4">
                <div class="card card-custom h-100 p-4 text-center">
                    <div class="d-inline-flex align-items-center justify-content-center bg-primary-subtle text-primary-custom rounded-circle mb-4" style="width: 64px; height: 64px;">
                        <i class="fa-solid fa-utensils fs-3"></i>
                    </div>
                    <h5 class="fw-bold">Wide Variety</h5>
                    <p class="text-muted mb-0">Choose from hundreds of local cuisines, from wood-fired pizzas to fresh Japanese sushi rolls.</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card card-custom h-100 p-4 text-center">
                    <div class="d-inline-flex align-items-center justify-content-center bg-warning-subtle text-warning-emphasis rounded-circle mb-4" style="width: 64px; height: 64px;">
                        <i class="fa-solid fa-bicycle fs-3"></i>
                    </div>
                    <h5 class="fw-bold">Live Order Tracking</h5>
                    <p class="text-muted mb-0">Follow your order status in real time, from the kitchen prep until it arrives at your doorstep.</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card card-custom h-100 p-4 text-center">
                    <div class="d-inline-flex align-items-center justify-content-center bg-success-subtle text-success rounded-circle mb-4" style="width: 64px; height: 64px;">
                        <i class="fa-solid fa-wallet fs-3"></i>
                    </div>
                    <h5 class="fw-bold">Easy Checkout & COD</h5>
                    <p class="text-muted mb-0">Pay with Cash on Delivery or use our online demo checkout. Secure, fast, and convenient.</p>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Join Our Network Banners -->
<section class="py-5" style="background-color: #F1F5F9;">
    <div class="container">
        <div class="row g-4">
            <!-- Restaurant Banner -->
            <div class="col-md-6">
                <div class="card border-0 rounded-4 overflow-hidden shadow-sm" style="background: linear-gradient(135deg, #1e293b, #0f172a); color: white;">
                    <div class="card-body p-5">
                        <h3 class="fw-bold text-white mb-3">Partner with Foodify</h3>
                        <p class="text-slate-300 mb-4" style="opacity: 0.8;">Grow your business, reach new customers, and boost your sales by listing your menu on our food delivery network.</p>
                        <a href="${pageContext.request.contextPath}/auth/register.jsp?role=RESTAURANT_OWNER" class="btn btn-primary-custom px-4 py-2.5">Join as Store Owner</a>
                    </div>
                </div>
            </div>
            <!-- Rider Banner -->
            <div class="col-md-6">
                <div class="card border-0 rounded-4 overflow-hidden shadow-sm" style="background: linear-gradient(135deg, #FF6B35, #e55a2b); color: white;">
                    <div class="card-body p-5">
                        <h3 class="fw-bold text-white mb-3">Ride with Foodify</h3>
                        <p class="text-white mb-4" style="opacity: 0.9;">Work on your own terms. Earn competitive money per delivery, choose your hours, and explore the city as a rider.</p>
                        <a href="${pageContext.request.contextPath}/auth/register.jsp?role=DELIVERY_PARTNER" class="btn btn-light text-primary-custom fw-bold px-4 py-2.5 border-0 hover-lift" style="border-radius: var(--border-radius);">Join as Delivery Rider</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<jsp:include page="common/footer.jsp" />
