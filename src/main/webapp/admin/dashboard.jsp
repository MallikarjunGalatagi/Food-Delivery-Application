<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="pageTitle" value="Admin Console | Foodify" scope="request" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<div class="container main-content">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="fw-bold mb-1">Administrator Dashboard</h3>
            <p class="text-muted mb-0">Monitor platform-wide activities, approve restaurant registrations, and inspect sales logs.</p>
        </div>
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

    <!-- Platform KPI stats row -->
    <div class="row g-4 mb-4 text-center">
        <div class="col-md-4 col-lg-2">
            <div class="card border-0 shadow-sm p-3 h-100" style="border-radius: var(--border-radius); background: white;">
                <span class="text-muted d-block small mb-1">TOTAL REVENUE</span>
                <h4 class="fw-bold text-success mb-0">&#8377;${totalRevenue}</h4>
            </div>
        </div>
        <div class="col-md-4 col-lg-2">
            <div class="card border-0 shadow-sm p-3 h-100" style="border-radius: var(--border-radius); background: white;">
                <span class="text-muted d-block small mb-1">TOTAL ORDERS</span>
                <h4 class="fw-bold text-dark mb-0">${totalOrdersCount}</h4>
            </div>
        </div>
        <div class="col-md-4 col-lg-2">
            <div class="card border-0 shadow-sm p-3 h-100" style="border-radius: var(--border-radius); background: white;">
                <span class="text-muted d-block small mb-1">CUSTOMERS</span>
                <h4 class="fw-bold text-dark mb-0">${customersCount}</h4>
            </div>
        </div>
        <div class="col-md-4 col-lg-2">
            <div class="card border-0 shadow-sm p-3 h-100" style="border-radius: var(--border-radius); background: white;">
                <span class="text-muted d-block small mb-1">RESTAURANTS</span>
                <h4 class="fw-bold text-dark mb-0">${activeRestaurants}</h4>
            </div>
        </div>
        <div class="col-md-4 col-lg-2">
            <div class="card border-0 shadow-sm p-3 h-100" style="border-radius: var(--border-radius); background: #FFF7ED; border: 1px solid #FFEDD5;">
                <span class="text-orange-500 text-muted d-block small mb-1">PENDING APP.</span>
                <h4 class="fw-bold text-orange-600 mb-0" style="color: #EA580C;">${pendingRestaurants}</h4>
            </div>
        </div>
        <div class="col-md-4 col-lg-2">
            <div class="card border-0 shadow-sm p-3 h-100" style="border-radius: var(--border-radius); background: white;">
                <span class="text-muted d-block small mb-1">RIDERS</span>
                <h4 class="fw-bold text-dark mb-0">${ridersCount}</h4>
            </div>
        </div>
    </div>

    <div class="row g-4">
        <!-- 1. Pending Approvals Panel -->
        <div class="col-lg-5 mb-4">
            <div class="card border-0 shadow-sm p-4 h-100" style="border-radius: var(--border-radius); background: white;">
                <h5 class="fw-bold mb-4">Pending Registrations</h5>
                
                <c:choose>
                    <c:when test="${not empty pendingList}">
                        <div class="d-flex flex-column gap-3">
                            <c:forEach var="r" items="${pendingList}">
                                <div class="p-3 border rounded-3">
                                    <div class="d-flex justify-content-between align-items-start mb-2">
                                        <div>
                                            <h6 class="fw-bold mb-0 text-dark">${r.restaurantName}</h6>
                                            <span class="text-muted small">${r.cuisineType}</span>
                                        </div>
                                        <div class="d-flex gap-2">
                                            <a href="${pageContext.request.contextPath}/admin/restaurants?action=approve&id=${r.userId}" class="btn btn-success btn-xs py-1 px-2 text-white">Approve</a>
                                            <a href="${pageContext.request.contextPath}/admin/restaurants?action=reject&id=${r.userId}" class="btn btn-outline-danger btn-xs py-1 px-2" onclick="return confirm('Reject this restaurant registration?')">Reject</a>
                                        </div>
                                    </div>
                                    <p class="mb-0 text-muted small"><i class="fa-solid fa-location-dot me-1"></i>${r.address}</p>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-5 bg-light rounded-3">
                            <p class="text-muted small mb-0">No restaurants pending approval. All clean!</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- 2. Recent Orders Log -->
        <div class="col-lg-7">
            <div class="card border-0 shadow-sm p-4 h-100" style="border-radius: var(--border-radius); background: white;">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h5 class="fw-bold mb-0">Recent Orders</h5>
                    <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-outline-primary-custom btn-sm">Manage Users</a>
                </div>

                <c:choose>
                    <c:when test="${not empty recentOrders}">
                        <div class="table-responsive">
                            <table class="table align-middle">
                                <thead>
                                    <tr class="text-muted small uppercase">
                                        <th scope="col" style="width: 80px;">Order ID</th>
                                        <th scope="col">Store</th>
                                        <th scope="col">Customer</th>
                                        <th scope="col" class="text-end">Amount</th>
                                        <th scope="col" class="text-center">Status</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="o" items="${recentOrders}">
                                        <tr>
                                            <td class="fw-bold">#${o.id}</td>
                                            <td>
                                                <span class="fw-semibold text-dark small">${o.restaurantName}</span>
                                            </td>
                                            <td>
                                                <span class="text-muted small">${o.customerName}</span>
                                            </td>
                                            <td class="text-end fw-semibold text-dark small">&#8377;${o.grandTotal}</td>
                                            <td class="text-center">
                                                <span class="badge ${o.isDelivered() ? 'bg-success-subtle text-success' : 'bg-light text-dark border'} small">${o.status}</span>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <p class="text-muted small py-4 mb-0 text-center">No orders logs available.</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />
