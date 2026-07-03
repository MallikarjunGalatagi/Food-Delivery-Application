<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="pageTitle" value="Track Order #${order.id} | Foodify" scope="request" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<div class="container main-content">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="fw-bold mb-0">Track Order #${order.id}</h3>
        <a href="${pageContext.request.contextPath}/customer/orders" class="btn btn-outline-secondary btn-sm py-1.5 px-3">
            <i class="fa-solid fa-arrow-left me-1"></i> Back to History
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
        <!-- Timeline Progress Column -->
        <div class="col-lg-8 mb-4">
            <div class="card border-0 shadow-sm p-4 mb-4" style="border-radius: var(--border-radius); background: white;">
                <c:choose>
                    <c:when test="${order.isCancelled()}">
                        <!-- Cancelled Banner -->
                        <div class="text-center py-5">
                            <div class="text-danger mb-3"><i class="fa-solid fa-circle-xmark display-3"></i></div>
                            <h4 class="fw-bold text-danger">This Order Was Cancelled</h4>
                            <p class="text-muted">Refunds for online payments will be processed within 3-5 business days.</p>
                        </div>
                    </c:when>
                    
                    <c:otherwise>
                        <!-- Timeline UI -->
                        <ul class="timeline">
                            <!-- Step 1: Placed -->
                            <li class="timeline-item completed">
                                <div class="timeline-marker"><i class="fa-solid fa-check"></i></div>
                                <div class="timeline-content">
                                    <h6 class="fw-bold mb-1">Order Placed</h6>
                                    <p class="text-muted small mb-0">We have received your order request from <strong>${order.restaurantName}</strong>.</p>
                                </div>
                            </li>

                            <!-- Step 2: Preparing -->
                            <c:set var="isPrep" value="${order.statusStep >= 2}" />
                            <li class="timeline-item ${isPrep ? 'completed' : (order.statusStep == 1 ? 'active' : '')}">
                                <div class="timeline-marker">
                                    <c:choose>
                                        <c:when test="${isPrep}"><i class="fa-solid fa-check"></i></c:when>
                                        <c:otherwise><i class="fa-solid fa-kitchen-set"></i></c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="timeline-content">
                                    <h6 class="fw-bold mb-1">Confirmed & Preparing</h6>
                                    <p class="text-muted small mb-0">The restaurant has accepted and is preparing your freshly cooked meal.</p>
                                </div>
                            </li>

                            <!-- Step 3: Ready for Pickup -->
                            <c:set var="isReady" value="${order.statusStep >= 4}" />
                            <li class="timeline-item ${isReady ? 'completed' : (order.statusStep == 2 || order.statusStep == 3 ? 'active' : '')}">
                                <div class="timeline-marker">
                                    <c:choose>
                                        <c:when test="${isReady}"><i class="fa-solid fa-check"></i></c:when>
                                        <c:otherwise><i class="fa-solid fa-box-archive"></i></c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="timeline-content">
                                    <h6 class="fw-bold mb-1">Ready for Pickup</h6>
                                    <p class="text-muted small mb-0">Your order is packaged and waiting for the delivery rider at the counter.</p>
                                </div>
                            </li>

                            <!-- Step 4: Out for Delivery -->
                            <c:set var="isOut" value="${order.statusStep >= 5}" />
                            <li class="timeline-item ${isOut ? 'completed' : (order.statusStep == 4 ? 'active' : '')}">
                                <div class="timeline-marker">
                                    <c:choose>
                                        <c:when test="${isOut}"><i class="fa-solid fa-check"></i></c:when>
                                        <c:otherwise><i class="fa-solid fa-motorcycle"></i></c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="timeline-content">
                                    <h6 class="fw-bold mb-1">Out for Delivery</h6>
                                    <p class="text-muted small mb-0">Our delivery rider is carrying your warm meal straight to your destination.</p>
                                </div>
                            </li>

                            <!-- Step 5: Delivered -->
                            <c:set var="isDelivered" value="${order.statusStep == 7}" />
                            <li class="timeline-item ${isDelivered ? 'completed' : (order.statusStep == 5 || order.statusStep == 6 ? 'active' : '')}">
                                <div class="timeline-marker">
                                    <c:choose>
                                        <c:when test="${isDelivered}"><i class="fa-solid fa-check"></i></c:when>
                                        <c:otherwise><i class="fa-solid fa-house-circle-check"></i></c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="timeline-content">
                                    <h6 class="fw-bold mb-1">Delivered</h6>
                                    <p class="text-muted small mb-0">Order successfully completed. Enjoy your delicious food!</p>
                                </div>
                            </li>
                        </ul>
                    </c:otherwise>
                </c:choose>
            </div>
            
            <!-- Cancel Button Area (Only visible before prep - status PLACED) -->
            <c:if test="${order.isPendingAcceptance()}">
                <div class="card border-0 shadow-sm p-4 bg-danger-subtle text-danger" style="border-radius: var(--border-radius);">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="fw-bold mb-1">Change of mind?</h6>
                            <p class="mb-0 small opacity-75">You can cancel this order before the restaurant accepts and starts cooking.</p>
                        </div>
                        <a href="${pageContext.request.contextPath}/customer/orders?action=cancel&id=${order.id}" class="btn btn-danger py-2 px-4 fw-semibold border-0" onclick="return confirm('Are you sure you want to cancel this order?')" style="border-radius: var(--border-radius);">
                            Cancel Order
                        </a>
                    </div>
                </div>
            </c:if>
        </div>

        <!-- Order Summary & Rider Details -->
        <div class="col-lg-4">
            <!-- Rider Details Card -->
            <c:if test="${not empty order.deliveryPartnerId && not order.isCancelled()}">
                <div class="card border-0 shadow-sm p-4 mb-4" style="border-radius: var(--border-radius); background: white;">
                    <h5 class="fw-bold mb-3"><i class="fa-solid fa-motorcycle text-success me-2"></i>Delivery Rider</h5>
                    <div class="d-flex align-items-center gap-3">
                        <div class="bg-light rounded-circle d-flex align-items-center justify-content-center text-success fs-3" style="width: 56px; height: 56px;">
                            <i class="fa-solid fa-user-ninja"></i>
                        </div>
                        <div>
                            <h6 class="fw-bold mb-0">${order.riderName}</h6>
                            <span class="text-muted small">Phone: ${order.riderPhone}</span>
                        </div>
                    </div>
                </div>
            </c:if>

            <!-- Order Review Details -->
            <div class="card border-0 shadow-sm p-4" style="border-radius: var(--border-radius); background: white;">
                <h5 class="fw-bold mb-3">Order Details</h5>
                
                <div class="mb-3 small">
                    <span class="text-muted">Status:</span>
                    <span class="fw-bold text-primary-custom ms-1">${order.status}</span>
                </div>
                
                <div class="mb-3 small">
                    <span class="text-muted">Payment:</span>
                    <span class="fw-bold text-dark ms-1">${order.paymentMethod} (${order.paymentStatus})</span>
                </div>

                <div class="border-top pt-3 mb-3">
                    <h6 class="fw-bold text-muted small uppercase mb-3">Items Summary</h6>
                    <div class="d-flex flex-column gap-2">
                        <c:forEach var="item" items="${order.items}">
                            <div class="d-flex justify-content-between text-muted small">
                                <span>${item.foodName} x ${item.quantity}</span>
                                <span>&#8377;${item.getSubtotal()}</span>
                            </div>
                        </c:forEach>
                    </div>
                </div>

                <div class="border-top pt-3">
                    <div class="d-flex justify-content-between mb-1 small text-muted">
                        <span>Subtotal</span>
                        <span>&#8377;${order.subtotal}</span>
                    </div>
                    <div class="d-flex justify-content-between mb-1 small text-muted">
                        <span>Delivery Fee</span>
                        <span>&#8377;${order.deliveryCharge}</span>
                    </div>
                    <div class="d-flex justify-content-between mb-2 small text-muted">
                        <span>GST</span>
                        <span>&#8377;${order.tax}</span>
                    </div>
                    <div class="d-flex justify-content-between fw-bold text-dark">
                        <span>Grand Total</span>
                        <span class="text-primary-custom">&#8377;${order.grandTotal}</span>
                    </div>
                </div>
                
                <a href="${pageContext.request.contextPath}/customer/orders?action=invoice&id=${order.id}" class="btn btn-outline-primary-custom w-100 py-2 btn-sm mt-4">
                    <i class="fa-regular fa-file-pdf me-2"></i>Download PDF Invoice
                </a>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />
