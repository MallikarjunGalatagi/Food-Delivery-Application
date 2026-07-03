<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="pageTitle" value="Checkout | Foodify" scope="request" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<div class="container main-content">
    <h3 class="fw-bold mb-4">Secure Checkout</h3>
    
    <!-- Breadcrumbs -->
    <nav aria-label="breadcrumb" class="mb-4">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/index.jsp" class="text-decoration-none text-muted">Home</a></li>
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/customer/cart" class="text-decoration-none text-muted">Cart</a></li>
            <li class="breadcrumb-item active" aria-current="page">Checkout</li>
        </ol>
    </nav>

    <!-- Error Alert -->
    <c:if test="${not empty errorMsg}">
        <div class="alert alert-danger alert-dismissible fade show mb-4" role="alert">
            <i class="fa-solid fa-triangle-exclamation me-2"></i> ${errorMsg}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <div class="row">
        <!-- Delivery Address & Payment Method -->
        <div class="col-lg-7 mb-4">
            <!-- 1. Delivery Address Card -->
            <div class="card border-0 shadow-sm p-4 mb-4" style="border-radius: var(--border-radius); background: white;">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h5 class="fw-bold mb-0"><i class="fa-solid fa-location-dot text-primary-custom me-2"></i>1. Delivery Address</h5>
                    <button class="btn btn-outline-primary-custom btn-sm" type="button" data-bs-toggle="collapse" data-bs-target="#newAddressForm" aria-expanded="false" aria-controls="newAddressForm">
                        + Add New
                    </button>
                </div>

                <!-- Add New Address Collapsible Form -->
                <div class="collapse mb-4" id="newAddressForm">
                    <div class="card card-body bg-light border-0 p-4 rounded-3">
                        <h6 class="fw-bold mb-3">Add New Address</h6>
                        <form action="${pageContext.request.contextPath}/customer/checkout" method="post">
                            <input type="hidden" name="addressAction" value="addAddress">
                            
                            <div class="mb-3">
                                <label for="addressLine1" class="form-label small">Address Line 1</label>
                                <input type="text" class="form-control form-control-custom form-control-sm" id="addressLine1" name="addressLine1" required placeholder="House/Flat No., Building Name">
                            </div>
                            <div class="mb-3">
                                <label for="addressLine2" class="form-label small">Address Line 2 (Optional)</label>
                                <input type="text" class="form-control form-control-custom form-control-sm" id="addressLine2" name="addressLine2" placeholder="Street, Area">
                            </div>
                            <div class="row">
                                <div class="col-md-4 mb-3">
                                    <label for="city" class="form-label small">City</label>
                                    <input type="text" class="form-control form-control-custom form-control-sm" id="city" name="city" required>
                                </div>
                                <div class="col-md-4 mb-3">
                                    <label for="state" class="form-label small">State</label>
                                    <input type="text" class="form-control form-control-custom form-control-sm" id="state" name="state" required>
                                </div>
                                <div class="col-md-4 mb-3">
                                    <label for="postalCode" class="form-label small">Postal Code</label>
                                    <input type="text" class="form-control form-control-custom form-control-sm" id="postalCode" name="postalCode" required>
                                </div>
                            </div>
                            <div class="mb-3 form-check">
                                <input type="checkbox" class="form-check-input" id="isDefault" name="isDefault">
                                <label class="form-check-label small" for="isDefault">Set as default address</label>
                            </div>
                            <button type="submit" class="btn btn-primary-custom btn-sm px-4">Save Address</button>
                        </form>
                    </div>
                </div>

                <!-- Select Address List -->
                <form id="checkoutForm" action="${pageContext.request.contextPath}/customer/checkout" method="post">
                    <c:choose>
                        <c:when test="${not empty addresses}">
                            <div class="d-flex flex-column gap-3">
                                <c:forEach var="addr" items="${addresses}">
                                    <label class="d-flex align-items-start gap-3 p-3 border rounded-3 cursor-pointer" style="cursor: pointer;">
                                        <input type="radio" name="addressId" value="${addr.id}" class="form-check-input mt-1 flex-shrink-0" ${addr.isDefault() ? 'checked' : ''}>
                                        <div>
                                            <div class="d-flex align-items-center gap-2 mb-1">
                                                <span class="fw-bold small text-dark">Address Details</span>
                                                <c:if test="${addr.isDefault()}">
                                                    <span class="badge bg-success-subtle text-success py-1 px-2" style="font-size: 0.65rem;">Default</span>
                                                </c:if>
                                            </div>
                                            <p class="mb-0 text-muted small">${addr.getFormattedAddress()}</p>
                                        </div>
                                    </label>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-4 bg-light rounded-3">
                                <p class="text-muted mb-0 small">No addresses saved. Please add a delivery address above.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
            </div>

            <!-- 2. Payment Method Card -->
            <div class="card border-0 shadow-sm p-4" style="border-radius: var(--border-radius); background: white;">
                <h5 class="fw-bold mb-4"><i class="fa-solid fa-credit-card text-primary-custom me-2"></i>2. Payment Method</h5>
                
                <div class="d-flex flex-column gap-3">
                    <label class="d-flex align-items-center gap-3 p-3 border rounded-3 cursor-pointer" style="cursor: pointer;">
                        <input type="radio" name="paymentMethod" value="COD" checked class="form-check-input flex-shrink-0">
                        <div>
                            <span class="fw-bold text-dark d-block">Cash on Delivery (COD)</span>
                            <span class="text-muted small">Pay in cash when your meal is delivered.</span>
                        </div>
                    </label>
                    
                    <label class="d-flex align-items-center gap-3 p-3 border rounded-3 cursor-pointer" style="cursor: pointer;">
                        <input type="radio" name="paymentMethod" value="ONLINE" class="form-check-input flex-shrink-0">
                        <div>
                            <span class="fw-bold text-dark d-block">Online Card Payment (Demo)</span>
                            <span class="text-muted small">Simulate an instant credit/debit card authorization.</span>
                        </div>
                    </label>
                </div>
            </div>
        </div>

        <!-- Order Review Panel -->
        <div class="col-lg-5">
            <div class="card border-0 shadow-sm p-4 sticky-top" style="top: 95px; border-radius: var(--border-radius); background: white; z-index: 10;">
                <h5 class="fw-bold mb-4">Order Review</h5>
                
                <!-- Short items list -->
                <div class="d-flex flex-column gap-3 mb-4" style="max-height: 250px; overflow-y: auto;">
                    <c:forEach var="item" items="${cart.items}">
                        <div class="d-flex justify-content-between align-items-center">
                            <div class="d-flex align-items-center gap-3" style="max-width: 75%;">
                                <img src="${not empty item.foodItem.imagePath ? item.foodItem.imagePath : 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&q=80&w=600'}" alt="${item.foodItem.name}" class="rounded-2" style="width: 48px; height: 48px; object-fit: cover;">
                                <div class="text-truncate">
                                    <span class="fw-bold text-dark d-block text-truncate small">${item.foodItem.name}</span>
                                    <span class="text-muted small">Qty: ${item.quantity}</span>
                                </div>
                            </div>
                            <span class="fw-semibold text-dark small">&#8377;${item.getSubtotal()}</span>
                        </div>
                    </c:forEach>
                </div>
                
                <!-- Financial Calculations -->
                <div class="border-top pt-3">
                    <div class="d-flex justify-content-between mb-2">
                        <span class="text-muted small">Subtotal</span>
                        <span class="fw-semibold text-dark small">&#8377;${cart.getSubtotal()}</span>
                    </div>
                    <div class="d-flex justify-content-between mb-2">
                        <span class="text-muted small">Delivery Fee</span>
                        <span class="fw-semibold text-success small">&#8377;${cart.getDeliveryCharge()}</span>
                    </div>
                    <div class="d-flex justify-content-between mb-3">
                        <span class="text-muted small">GST (5%)</span>
                        <span class="fw-semibold text-dark small">&#8377;${cart.getTax()}</span>
                    </div>
                    <hr>
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <span class="fw-bold text-dark">Grand Total</span>
                        <span class="fw-bold fs-5 text-primary-custom">&#8377;${cart.getGrandTotal()}</span>
                    </div>
                </div>
                
                <button type="submit" class="btn btn-primary-custom w-100 py-2.5">
                    Place Order (&#8377;${cart.getGrandTotal()})
                </button>
                </form>
                
                <p class="text-center text-muted small mt-3 mb-0">
                    By placing the order, you agree to our Terms of Service.
                </p>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />
