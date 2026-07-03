<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="pageTitle" value="Store Dashboard | Foodify" scope="request" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<div class="container main-content">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="fw-bold mb-1">Kitchen Dashboard</h3>
            <p class="text-muted mb-0">Manage incoming orders and monitor cooking progress for <strong>${sessionScope.restaurant.restaurantName}</strong>.</p>
        </div>
        <div class="rating-badge py-2 px-3 flex-shrink-0 border bg-warning-subtle text-warning-emphasis">
            <i class="fa-solid fa-star me-1 text-warning"></i>
            <strong>Store Rating: ${sessionScope.restaurant.rating}</strong>
        </div>
    </div>

    <!-- Alert notifications -->
    <c:if test="${not empty param.successMsg}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="fa-solid fa-circle-check me-2"></i> ${param.successMsg}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>
    <c:if test="${not empty param.errorMsg}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="fa-solid fa-triangle-exclamation me-2"></i> ${param.errorMsg}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <!-- Analytics Dashboard row -->
    <div class="row g-4 mb-4 text-center">
        <div class="col-md-3">
            <div class="card border-0 shadow-sm p-3 h-100" style="border-radius: var(--border-radius); background: white;">
                <span class="text-muted d-block small mb-1">TODAY'S ORDERS</span>
                <h3 class="fw-bold text-dark mb-0">${todayOrders}</h3>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card border-0 shadow-sm p-3 h-100" style="border-radius: var(--border-radius); background: white;">
                <span class="text-muted d-block small mb-1">TODAY'S SALES</span>
                <h3 class="fw-bold text-success mb-0">&#8377;${todayRevenue}</h3>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card border-0 shadow-sm p-3 h-100" style="border-radius: var(--border-radius); background: white;">
                <span class="text-muted d-block small mb-1">MONTHLY SALES</span>
                <h3 class="fw-bold text-primary-custom mb-0">&#8377;${monthlyRevenue}</h3>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card border-0 shadow-sm p-3 h-100" style="border-radius: var(--border-radius); background: white;">
                <span class="text-muted d-block small mb-1">ACTIVE DISHES</span>
                <h3 class="fw-bold text-dark mb-0">${menuItemsCount}</h3>
            </div>
        </div>
    </div>

    <!-- Active Orders Management -->
    <div class="card border-0 shadow-sm p-4" style="border-radius: var(--border-radius); background: white;">
        <h5 class="fw-bold mb-4">Active Orders</h5>
        
        <c:choose>
            <c:when test="${not empty activeOrders}">
                <div class="table-responsive">
                    <table class="table align-middle">
                        <thead>
                            <tr class="text-muted small uppercase">
                                <th scope="col" style="width: 90px;">Order ID</th>
                                <th scope="col" style="width: 150px;">Customer</th>
                                <th scope="col">Items Ordered</th>
                                <th scope="col" class="text-end" style="width: 100px;">Total</th>
                                <th scope="col" class="text-center" style="width: 120px;">Current Status</th>
                                <th scope="col" class="text-center" style="width: 180px;">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="o" items="${activeOrders}">
                                <tr>
                                    <td class="fw-bold">#${o.id}</td>
                                    <td>
                                        <div class="fw-semibold text-dark">${o.customerName}</div>
                                        <span class="text-muted small">${o.customerPhone}</span>
                                    </td>
                                    <td>
                                        <ul class="list-unstyled mb-0 small">
                                            <c:forEach var="item" items="${o.items}">
                                                <li>
                                                    <c:choose>
                                                        <c:when test="${item.isVeg()}"><span class="text-success">&#9679;</span></c:when>
                                                        <c:otherwise><span class="text-danger">&#9650;</span></c:otherwise>
                                                    </c:choose>
                                                    ${item.foodName} <strong>x${item.quantity}</strong>
                                                </li>
                                            </c:forEach>
                                        </ul>
                                    </td>
                                    <td class="text-end fw-bold text-dark">&#8377;${o.grandTotal}</td>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${o.isPendingAcceptance()}">
                                                <span class="badge bg-warning-subtle text-warning-emphasis">New Order</span>
                                            </c:when>
                                            <c:when test="${o.isPreparing()}">
                                                <span class="badge bg-primary-subtle text-primary-custom">In Preparation</span>
                                            </c:when>
                                            <c:when test="${o.isReady()}">
                                                <span class="badge bg-info-subtle text-info-emphasis">Ready for Rider</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-light text-dark">${o.status}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${o.isPendingAcceptance()}">
                                                <div class="d-flex gap-2 justify-content-center">
                                                    <a href="${pageContext.request.contextPath}/restaurant/orders?action=accept&id=${o.id}" class="btn btn-success btn-sm py-1 px-2.5 text-white">Accept</a>
                                                    <a href="${pageContext.request.contextPath}/restaurant/orders?action=reject&id=${o.id}" class="btn btn-outline-danger btn-sm py-1 px-2.5" onclick="return confirm('Are you sure you want to reject this order?')">Reject</a>
                                                </div>
                                            </c:when>
                                            <c:when test="${o.status == 'ACCEPTED'}">
                                                <a href="${pageContext.request.contextPath}/restaurant/orders?action=status&id=${o.id}&status=PREPARING" class="btn btn-primary-custom btn-sm w-100 py-1.5">Start Preparing</a>
                                            </c:when>
                                            <c:when test="${o.status == 'PREPARING'}">
                                                <a href="${pageContext.request.contextPath}/restaurant/orders?action=status&id=${o.id}&status=READY_FOR_PICKUP" class="btn btn-warning btn-sm w-100 py-1.5 text-dark fw-semibold">Ready for Pickup</a>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted small">Rider dispatched</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:when>
            <c:otherwise>
                <p class="text-muted py-4 mb-0 text-center small">No active orders in the kitchen. All clean!</p>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />
