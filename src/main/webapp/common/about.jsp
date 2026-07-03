<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="pageTitle" value="About Us | Foodify" scope="request" />
<jsp:include page="header.jsp" />
<jsp:include page="navbar.jsp" />

<div class="container main-content">
    <!-- About Section -->
    <div class="text-center mb-5">
        <span class="badge bg-warning-subtle text-warning-emphasis px-3 py-2 rounded-pill font-weight-600 mb-3 fs-6">About Foodify</span>
        <h2 class="fw-bold text-dark">Our Story & Mission</h2>
        <p class="text-muted max-width-600 mx-auto">Founded in 2026, Foodify is a premium online food ordering platform linking local dining hubs to customer doorsteps with high-speed logistics and zero hassle.</p>
    </div>

    <div class="row align-items-center g-5 mb-5">
        <div class="col-md-6">
            <img src="https://images.unsplash.com/photo-1552566626-52f8b828add9?auto=format&fit=crop&q=80&w=600" class="img-fluid rounded-4 shadow-md" alt="Restaurant Chefs Cooking" style="max-height: 350px; width: 100%; object-fit: cover;">
        </div>
        <div class="col-md-6">
            <h4 class="fw-bold mb-3">Fresh Cooking, Fast Transit</h4>
            <p class="text-muted mb-3">We believe that great food should never be delayed by distance. By partnering with leading local kitchens, wood-fired pizzerias, gourmet bakeries, and sushi bars, we bring authentic dining experiences straight to your home.</p>
            <p class="text-muted">Our custom dispatch algorithm automatically matches orders to the nearest available delivery rider as soon as the kitchen packages the meal, keeping heat, texture, and taste perfectly preserved.</p>
        </div>
    </div>
</div>

<jsp:include page="footer.jsp" />
