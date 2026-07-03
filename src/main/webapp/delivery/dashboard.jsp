<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="pageTitle" value="Rider Dashboard | Foodify" scope="request" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<div class="container main-content">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="fw-bold mb-1">Rider Console</h3>
            <p class="text-muted mb-0">Accept delivery jobs, update transport status, and track your active earnings.</p>
        </div>
        <div class="d-flex gap-2">
            <span class="badge bg-success-subtle text-success py-2.5 px-3 border fs-6 rounded-3">
                <i class="fa-solid fa-motorcycle me-1"></i> License: ${sessionScope.deliveryPartner.licenseNumber}
            </span>
        </div>
    </div>

    <!-- Alert feeds -->
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

    <!-- Stats row -->
    <div class="row g-4 mb-4 text-center">
        <div class="col-md-6">
            <div class="card border-0 shadow-sm p-4 h-100" style="border-radius: var(--border-radius); background: white;">
                <span class="text-muted d-block small mb-1">DELIVERIES COMPLETED</span>
                <h2 class="fw-bold text-dark mb-0">${deliveriesCount}</h2>
            </div>
        </div>
        <div class="col-md-6">
            <div class="card border-0 shadow-sm p-4 h-100" style="border-radius: var(--border-radius); background: white;">
                <span class="text-muted d-block small mb-1">TOTAL EARNINGS</span>
                <h2 class="fw-bold text-success mb-0">&#8377;${sessionScope.deliveryPartner.earnings}</h2>
            </div>
        </div>
    </div>

    <div class="row g-4">
        <!-- Active Delivery Column -->
        <div class="col-lg-5 mb-4">
            <div class="card border-0 shadow-sm p-4 h-100" style="border-radius: var(--border-radius); background: white;">
                <h5 class="fw-bold mb-4 text-dark"><i class="fa-solid fa-route text-success me-2"></i>Active Job</h5>
                
                <c:choose>
                    <c:when test="${not empty activeDelivery}">
                        <div class="border rounded-3 p-4 bg-light">
                            <div class="d-flex justify-content-between align-items-center mb-3 border-bottom pb-2">
                                <span class="fw-bold text-dark">Order #${activeDelivery.id}</span>
                                <span class="badge bg-warning text-dark">${activeDelivery.status}</span>
                            </div>

                            <!-- Pickup Info -->
                            <div class="mb-3">
                                <span class="text-muted d-block small uppercase font-weight-600"><i class="fa-solid fa-store me-1"></i> Pickup From</span>
                                <span class="fw-bold text-dark d-block">${activeDelivery.restaurantName}</span>
                            </div>

                            <!-- Dropoff Info -->
                            <div class="mb-3">
                                <span class="text-muted d-block small uppercase font-weight-600"><i class="fa-solid fa-location-dot me-1"></i> Deliver To</span>
                                <span class="fw-semibold text-dark d-block mb-1">${activeDelivery.customerName}</span>
                                <span class="text-muted small">${activeDelivery.address.getFormattedAddress()}</span>
                            </div>

                            <!-- Payment Details -->
                            <div class="mb-4">
                                <span class="text-muted d-block small uppercase font-weight-600"><i class="fa-solid fa-wallet me-1"></i> Cash to Collect</span>
                                <span class="fw-bold text-primary-custom fs-5">
                                    &#8377;${activeDelivery.grandTotal}
                                    <span class="text-muted small fs-xs font-weight-normal">(${activeDelivery.paymentMethod})</span>
                                </span>
                            </div>

                            <!-- Progress Buttons -->
                            <c:choose>
                                <c:when test="${activeDelivery.status == 'PICKED_UP'}">
                                    <a href="${pageContext.request.contextPath}/delivery/orders?action=status&id=${activeDelivery.id}&status=OUT_FOR_DELIVERY" class="btn btn-primary-custom w-100 py-2.5">
                                        Mark Out For Delivery
                                    </a>
                                </c:when>
                                <c:when test="${activeDelivery.status == 'OUT_FOR_DELIVERY'}">
                                    <a href="${pageContext.request.contextPath}/delivery/orders?action=status&id=${activeDelivery.id}&status=DELIVERED" class="btn btn-success text-white w-100 py-2.5" onclick="return confirm('Confirm cash collection and delivery completion?')">
                                        Mark as Delivered
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <a href="${pageContext.request.contextPath}/delivery/orders?action=status&id=${activeDelivery.id}&status=PICKED_UP" class="btn btn-warning text-dark fw-semibold w-100 py-2.5">
                                        Confirm Food Pickup
                                    </a>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-5 bg-light rounded-3">
                            <div class="text-muted mb-3"><i class="fa-solid fa-check-circle display-4 text-light"></i></div>
                            <h6 class="fw-bold">No Active Jobs</h6>
                            <p class="text-muted small mb-0">Select an available delivery assignment below to start earning.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Available Jobs Column -->
        <div class="col-lg-7">
            <div class="card border-0 shadow-sm p-4 h-100" style="border-radius: var(--border-radius); background: white;">
                <h5 class="fw-bold mb-4"><i class="fa-solid fa-clipboard-list text-primary-custom me-2"></i>Available Delivery Jobs</h5>
                
                <c:choose>
                    <c:when test="${not empty availableOrders}">
                        <div class="table-responsive">
                            <table class="table align-middle">
                                <thead>
                                    <tr class="text-muted small uppercase">
                                        <th scope="col" style="width: 80px;">Order</th>
                                        <th scope="col">Store Details</th>
                                        <th scope="col">Destination</th>
                                        <th scope="col" class="text-end" style="width: 90px;">COD Cash</th>
                                        <th scope="col" class="text-center" style="width: 100px;">Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="job" items="${availableOrders}">
                                        <tr>
                                            <td class="fw-bold">#${job.id}</td>
                                            <td>
                                                <div class="fw-bold text-dark small">${job.restaurantName}</div>
                                            </td>
                                            <td>
                                                <span class="text-muted small text-truncate d-block" style="max-width: 180px;">${job.address.city}, ${job.address.state}</span>
                                            </td>
                                            <td class="text-end fw-semibold small text-dark">&#8377;${job.grandTotal}</td>
                                            <td class="text-center">
                                                <a href="${pageContext.request.contextPath}/delivery/orders?action=accept&id=${job.id}" class="btn btn-outline-primary-custom btn-sm py-1 px-2.5 font-weight-600" ${not empty activeDelivery ? 'disabled' : ''}>
                                                    Accept
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <p class="text-muted py-4 mb-0 text-center small">No open delivery jobs available right now. Check back shortly!</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />
