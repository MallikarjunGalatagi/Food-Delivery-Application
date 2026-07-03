<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="pageTitle" value="My Dashboard | Foodify" scope="request" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<div class="container main-content">
    <!-- Welcome Header -->
    <div class="row align-items-center mb-4 g-3">
        <div class="col-md-8">
            <h3 class="fw-bold mb-1">Welcome back, ${sessionScope.user.firstName}!</h3>
            <p class="text-muted mb-0">Manage your orders, profile details, and delivery addresses from here.</p>
        </div>
        <div class="col-md-4 text-md-end">
            <!-- Loyalty Points Card -->
            <div class="d-inline-block bg-warning-subtle text-warning-emphasis py-2 px-4 rounded-3 border border-warning-subtle">
                <i class="fa-solid fa-gift me-2 fs-5"></i>
                <span class="small fw-semibold">Loyalty Points:</span>
                <span class="fw-bold fs-5 ms-1">${customer.loyaltyPoints}</span>
            </div>
        </div>
    </div>

    <!-- Info Cards row -->
    <div class="row g-4 mb-4">
        <!-- Profile Card -->
        <div class="col-md-4">
            <div class="card border-0 shadow-sm p-4 h-100" style="border-radius: var(--border-radius); background: white;">
                <h5 class="fw-bold mb-4 text-dark"><i class="fa-regular fa-user-circle text-primary-custom me-2"></i>My Profile</h5>
                <div class="mb-3">
                    <span class="text-muted d-block small">Email Address</span>
                    <span class="fw-bold text-dark">${sessionScope.user.email}</span>
                </div>
                <div class="mb-3">
                    <span class="text-muted d-block small">Phone Number</span>
                    <span class="fw-bold text-dark">${sessionScope.user.phone}</span>
                </div>
                <div class="mb-3">
                    <span class="text-muted d-block small">Member Since</span>
                    <span class="fw-bold text-dark">${sessionScope.user.createdAt}</span>
                </div>
            </div>
        </div>

        <!-- Order Summary Card -->
        <div class="col-md-4">
            <div class="card border-0 shadow-sm p-4 h-100" style="border-radius: var(--border-radius); background: white;">
                <h5 class="fw-bold mb-4 text-dark"><i class="fa-solid fa-receipt text-primary-custom me-2"></i>Orders Summary</h5>
                <div class="text-center py-3">
                    <div class="display-3 fw-bold text-primary-custom mb-1">${totalOrdersCount}</div>
                    <span class="text-muted small fw-semibold uppercase">Total Orders Placed</span>
                </div>
            </div>
        </div>
        
        <!-- Cart Preview Card -->
        <div class="col-md-4">
            <div class="card border-0 shadow-sm p-4 h-100" style="border-radius: var(--border-radius); background: white;">
                <h5 class="fw-bold mb-4 text-dark"><i class="fa-solid fa-basket-shopping text-primary-custom me-2"></i>Active Cart</h5>
                <div class="text-center py-3">
                    <div class="display-3 fw-bold text-dark mb-1">${sessionScope.cartSize != null ? sessionScope.cartSize : '0'}</div>
                    <span class="text-muted small fw-semibold uppercase">Items in Cart</span>
                    <div class="mt-3">
                        <a href="${pageContext.request.contextPath}/customer/cart" class="btn btn-outline-primary-custom btn-sm">View Cart</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="row g-4">
        <!-- Recent Orders Column -->
        <div class="col-lg-7">
            <div class="card border-0 shadow-sm p-4 mb-4" style="border-radius: var(--border-radius); background: white;">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h5 class="fw-bold mb-0">Recent Orders</h5>
                    <a href="${pageContext.request.contextPath}/customer/orders" class="text-primary-custom text-decoration-none small font-weight-500">View All</a>
                </div>

                <c:choose>
                    <c:when test="${not empty recentOrders}">
                        <div class="d-flex flex-column gap-3">
                            <c:forEach var="o" items="${recentOrders}">
                                <div class="p-3 border rounded-3 d-flex justify-content-between align-items-center">
                                    <div>
                                        <div class="d-flex align-items-center gap-2 mb-1">
                                            <span class="fw-bold small text-dark">#${o.id}</span>
                                            <span class="text-muted small">| ${o.restaurantName}</span>
                                        </div>
                                        <span class="text-muted small">${o.createdAt}</span>
                                    </div>
                                    <div class="text-end">
                                        <span class="fw-bold text-dark d-block mb-1">&#8377;${o.grandTotal}</span>
                                        <a href="${pageContext.request.contextPath}/customer/orders?action=track&id=${o.id}" class="btn btn-light btn-sm border py-0.5 px-2.5 small">Track</a>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <p class="text-muted py-3 mb-0 small text-center">No orders placed recently.</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Address Management Column -->
        <div class="col-lg-5">
            <div class="card border-0 shadow-sm p-4" style="border-radius: var(--border-radius); background: white;">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h5 class="fw-bold mb-0">My Addresses</h5>
                    <a href="${pageContext.request.contextPath}/customer/checkout" class="btn btn-outline-primary-custom btn-sm">Add / Edit</a>
                </div>
                
                <c:choose>
                    <c:when test="${not empty addresses}">
                        <div class="d-flex flex-column gap-3">
                            <c:forEach var="addr" items="${addresses}">
                                <div class="p-3 border rounded-3">
                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                        <span class="fw-bold text-dark small">Delivery Point</span>
                                        <c:if test="${addr.isDefault()}">
                                            <span class="badge bg-success-subtle text-success" style="font-size: 0.65rem;">Default</span>
                                        </c:if>
                                    </div>
                                    <p class="mb-0 text-muted small">${addr.getFormattedAddress()}</p>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <p class="text-muted py-3 mb-0 small text-center">No saved delivery addresses.</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />
