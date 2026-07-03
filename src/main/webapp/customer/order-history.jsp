<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="pageTitle" value="Order History | Foodify" scope="request" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<div class="container main-content">
    <h3 class="fw-bold mb-4"><i class="fa-solid fa-clock-rotate-left text-primary-custom me-2"></i>My Orders</h3>

    <!-- Breadcrumbs -->
    <nav aria-label="breadcrumb" class="mb-4">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/index.jsp" class="text-decoration-none text-muted">Home</a></li>
            <li class="breadcrumb-item active" aria-current="page">Order History</li>
        </ol>
    </nav>

    <c:choose>
        <c:when test="${not empty orders}">
            <div class="card border-0 shadow-sm p-4" style="border-radius: var(--border-radius); background: white;">
                <div class="table-responsive">
                    <table class="table align-middle">
                        <thead>
                            <tr class="text-muted small uppercase">
                                <th scope="col" style="width: 100px;">Order ID</th>
                                <th scope="col">Date</th>
                                <th scope="col">Restaurant</th>
                                <th scope="col" class="text-end">Amount</th>
                                <th scope="col" class="text-center">Payment</th>
                                <th scope="col" class="text-center">Status</th>
                                <th scope="col" class="text-center" style="width: 200px;">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="o" items="${orders}">
                                <tr>
                                    <td class="fw-bold">#${o.id}</td>
                                    <td class="small text-muted">${o.createdAt}</td>
                                    <td class="fw-bold text-dark">${o.restaurantName}</td>
                                    <td class="text-end fw-bold text-dark">&#8377;${o.grandTotal}</td>
                                    <td class="text-center small">
                                        <span class="badge bg-light text-dark border">${o.paymentMethod}</span>
                                    </td>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${o.isDelivered()}">
                                                <span class="badge bg-success-subtle text-success py-1.5 px-3">Delivered</span>
                                            </c:when>
                                            <c:when test="${o.isCancelled()}">
                                                <span class="badge bg-danger-subtle text-danger py-1.5 px-3">Cancelled</span>
                                            </c:when>
                                            <c:when test="${o.isReady()}">
                                                <span class="badge bg-warning-subtle text-warning-emphasis py-1.5 px-3">Ready for Pickup</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-primary-subtle text-primary-custom py-1.5 px-3">${o.status}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-center">
                                        <div class="d-flex justify-content-center gap-2">
                                            <a href="${pageContext.request.contextPath}/customer/orders?action=track&id=${o.id}" class="btn btn-outline-primary-custom btn-sm py-1 px-2.5">
                                                <i class="fa-solid fa-map-location-dot me-1"></i> Track
                                            </a>
                                            <a href="${pageContext.request.contextPath}/customer/orders?action=invoice&id=${o.id}" class="btn btn-light btn-sm text-dark border py-1 px-2.5" title="Download PDF Invoice">
                                                <i class="fa-regular fa-file-pdf fs-6 text-danger me-1"></i> PDF
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <!-- No Orders State -->
            <div class="text-center py-5">
                <div class="mb-4 text-muted"><i class="fa-solid fa-clock display-1 text-light"></i></div>
                <h4 class="fw-bold">No Orders Yet</h4>
                <p class="text-muted">You haven't placed any orders yet. When you do, they will show up here.</p>
                <a href="${pageContext.request.contextPath}/restaurant?action=list" class="btn btn-primary-custom px-4 py-2.5 mt-3">
                    Order Delicious Food
                </a>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<jsp:include page="../common/footer.jsp" />
