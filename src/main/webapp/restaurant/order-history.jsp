<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="pageTitle" value="Store Order History | Foodify" scope="request" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<div class="container main-content">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="fw-bold mb-1">Order History</h3>
            <p class="text-muted mb-0">Browse through all completed and historical orders for <strong>${sessionScope.restaurant.restaurantName}</strong>.</p>
        </div>
        <a href="${pageContext.request.contextPath}/restaurant/dashboard" class="btn btn-outline-secondary btn-sm py-1.5 px-3">
            <i class="fa-solid fa-arrow-left me-1"></i> Dashboard
        </a>
    </div>

    <!-- Historical Orders Table -->
    <div class="card border-0 shadow-sm p-4" style="border-radius: var(--border-radius); background: white;">
        <c:choose>
            <c:when test="${not empty orders}">
                <div class="table-responsive">
                    <table class="table align-middle">
                        <thead>
                            <tr class="text-muted small uppercase">
                                <th scope="col" style="width: 100px;">Order ID</th>
                                <th scope="col">Date</th>
                                <th scope="col">Customer</th>
                                <th scope="col">Items Ordered</th>
                                <th scope="col" class="text-end" style="width: 110px;">Grand Total</th>
                                <th scope="col" class="text-center" style="width: 120px;">Payment</th>
                                <th scope="col" class="text-center" style="width: 120px;">Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="o" items="${orders}">
                                <tr>
                                    <td class="fw-bold">#${o.id}</td>
                                    <td class="small text-muted">${o.createdAt}</td>
                                    <td>
                                        <div class="fw-semibold text-dark">${o.customerName}</div>
                                        <span class="text-muted small">${o.customerPhone}</span>
                                    </td>
                                    <td>
                                        <ul class="list-unstyled mb-0 small text-muted">
                                            <c:forEach var="item" items="${o.items}">
                                                <li>${item.foodName} x${item.quantity}</li>
                                            </c:forEach>
                                        </ul>
                                    </td>
                                    <td class="text-end fw-bold text-dark">&#8377;${o.grandTotal}</td>
                                    <td class="text-center small">
                                        <span class="badge bg-light text-dark border">${o.paymentMethod} (${o.paymentStatus})</span>
                                    </td>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${o.isDelivered()}">
                                                <span class="badge bg-success-subtle text-success py-1 px-2.5">Delivered</span>
                                            </c:when>
                                            <c:when test="${o.isCancelled()}">
                                                <span class="badge bg-danger-subtle text-danger py-1 px-2.5">Cancelled</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-primary-subtle text-primary-custom py-1 px-2.5">${o.status}</span>
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
                <p class="text-muted py-4 mb-0 text-center small">No order history found for this store.</p>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />
