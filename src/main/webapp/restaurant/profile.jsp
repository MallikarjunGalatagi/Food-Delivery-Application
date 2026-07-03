<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="pageTitle" value="Store Profile Settings | Foodify" scope="request" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<div class="container main-content">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="fw-bold mb-1">Store Profile Details</h3>
            <p class="text-muted mb-0">Update your restaurant descriptions, branding assets, average times, and operational statuses.</p>
        </div>
        <a href="${pageContext.request.contextPath}/restaurant/dashboard" class="btn btn-outline-secondary btn-sm py-1.5 px-3">
            <i class="fa-solid fa-arrow-left me-1"></i> Dashboard
        </a>
    </div>

    <!-- Alert feeds -->
    <c:if test="${not empty param.successMsg}">
        <div class="alert alert-success alert-dismissible fade show mb-4" role="alert">
            <i class="fa-solid fa-circle-check me-2"></i> ${param.successMsg}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>
    <c:if test="${not empty param.errorMsg}">
        <div class="alert alert-danger alert-dismissible fade show mb-4" role="alert">
            <i class="fa-solid fa-triangle-exclamation me-2"></i> ${param.errorMsg}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <div class="row">
        <!-- Profile Form Card -->
        <div class="col-lg-8 mb-4">
            <div class="card border-0 shadow-sm p-4" style="border-radius: var(--border-radius); background: white;">
                <form action="${pageContext.request.contextPath}/restaurant/profile" method="post">
                    <div class="mb-3">
                        <label for="restaurantName" class="form-label font-weight-500">Restaurant Name</label>
                        <input type="text" class="form-control form-control-custom" id="restaurantName" name="restaurantName" value="${restaurant.restaurantName}" required>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="cuisineType" class="form-label font-weight-500">Cuisines (comma separated)</label>
                            <input type="text" class="form-control form-control-custom" id="cuisineType" name="cuisineType" value="${restaurant.cuisineType}" required placeholder="Italian, Pizza">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="deliveryTime" class="form-label font-weight-500">Avg. Preparation Time (mins)</label>
                            <input type="number" class="form-control form-control-custom" id="deliveryTime" name="deliveryTime" value="${restaurant.estimatedDeliveryTime}" required>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="logoPath" class="form-label font-weight-500">Logo Image Path/URL</label>
                            <input type="text" class="form-control form-control-custom" id="logoPath" name="logoPath" value="${restaurant.logoPath}">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="bannerPath" class="form-label font-weight-500">Banner Background Path/URL</label>
                            <input type="text" class="form-control form-control-custom" id="bannerPath" name="bannerPath" value="${restaurant.bannerPath}">
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="isActive" class="form-label font-weight-500">Operational Status</label>
                        <select name="isActive" id="isActive" class="form-select form-control-custom">
                            <option value="true" ${restaurant.isActive() ? 'selected' : ''}>Active (Open for Orders)</option>
                            <option value="false" ${!restaurant.isActive() ? 'selected' : ''}>Closed (Temporarily Offline)</option>
                        </select>
                    </div>

                    <div class="mb-4">
                        <label for="address" class="form-label font-weight-500">Store Physical Address</label>
                        <textarea class="form-control form-control-custom" id="address" name="address" rows="3" required>${restaurant.address}</textarea>
                    </div>

                    <button type="submit" class="btn btn-primary-custom px-4 py-2.5">Save Changes</button>
                </form>
            </div>
        </div>

        <!-- Branding Assets Preview Card -->
        <div class="col-lg-4">
            <div class="card border-0 shadow-sm p-4 text-center mb-4" style="border-radius: var(--border-radius); background: white;">
                <h6 class="fw-bold mb-3">Store Branding Assets Preview</h6>
                <div class="mb-3">
                    <span class="text-muted d-block small mb-2">Logo Preview</span>
                    <img src="${not empty restaurant.logoPath ? restaurant.logoPath : 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?auto=format&fit=crop&q=80&w=150'}" class="rounded-circle border" alt="Store Logo" style="width: 100px; height: 100px; object-fit: cover;">
                </div>
                <div>
                    <span class="text-muted d-block small mb-2">Banner Preview</span>
                    <img src="${not empty restaurant.bannerPath ? restaurant.bannerPath : 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?auto=format&fit=crop&q=80&w=300'}" class="rounded img-fluid border" alt="Store Banner" style="max-height: 120px; object-fit: cover; width: 100%;">
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />
