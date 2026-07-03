<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="pageTitle" value="My Cart | Foodify" scope="request" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<div class="container main-content">
    <h3 class="fw-bold mb-4"><i class="fa-solid fa-cart-shopping text-primary-custom me-2"></i>Your Shopping Cart</h3>

    <!-- Breadcrumbs -->
    <nav aria-label="breadcrumb" class="mb-4">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/index.jsp" class="text-decoration-none text-muted">Home</a></li>
            <li class="breadcrumb-item active" aria-current="page">Shopping Cart</li>
        </ol>
    </nav>

    <c:choose>
        <c:when test="${not empty cart.items}">
            <div class="row">
                <!-- Cart Items List -->
                <div class="col-lg-8 mb-4">
                    <div class="card border-0 shadow-sm p-4" style="border-radius: var(--border-radius); background: white;">
                        <div class="table-responsive">
                            <table class="table align-middle">
                                <thead>
                                    <tr class="text-muted small uppercase">
                                        <th scope="col" style="width: 100px;">Item</th>
                                        <th scope="col">Name</th>
                                        <th scope="col" class="text-center" style="width: 130px;">Quantity</th>
                                        <th scope="col" class="text-end">Price</th>
                                        <th scope="col" class="text-end">Subtotal</th>
                                        <th scope="col" class="text-center" style="width: 60px;"></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="item" items="${cart.items}">
                                        <tr>
                                            <td>
                                                <img src="${not empty item.foodItem.imagePath ? item.foodItem.imagePath : 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&q=80&w=100'}" alt="${item.foodItem.name}" class="img-fluid rounded-3" style="width: 70px; height: 70px; object-fit: cover;">
                                            </td>
                                            <td>
                                                <div class="d-flex align-items-center gap-2 mb-1">
                                                    <c:choose>
                                                        <c:when test="${item.foodItem.isVeg()}">
                                                            <span class="badge-veg" style="font-size: 0.65rem; padding: 2px 4px;"><i class="fa-solid fa-circle text-white me-1 fs-xxs"></i>Veg</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge-nonveg" style="font-size: 0.65rem; padding: 2px 4px;"><i class="fa-solid fa-triangle me-1 fs-xxs"></i>Non-Veg</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                                <h6 class="fw-bold mb-0 text-truncate" style="max-width: 250px;">${item.foodItem.name}</h6>
                                            </td>
                                            <td class="text-center">
                                                <div class="d-flex align-items-center justify-content-center gap-2">
                                                    <!-- Decrement form -->
                                                    <form action="${pageContext.request.contextPath}/customer/cart" method="post" class="m-0">
                                                        <input type="hidden" name="action" value="update">
                                                        <input type="hidden" name="foodItemId" value="${item.foodItem.id}">
                                                        <input type="hidden" name="quantity" value="${item.quantity - 1}">
                                                        <button type="submit" class="btn btn-outline-secondary btn-sm rounded-circle d-flex align-items-center justify-content-center" style="width: 28px; height: 28px; padding: 0;" ${item.quantity <= 1 ? 'disabled' : ''}>
                                                            <i class="fa-solid fa-minus fs-xs"></i>
                                                        </button>
                                                    </form>
                                                    
                                                    <span class="fw-bold px-2">${item.quantity}</span>
                                                    
                                                    <!-- Increment form -->
                                                    <form action="${pageContext.request.contextPath}/customer/cart" method="post" class="m-0">
                                                        <input type="hidden" name="action" value="update">
                                                        <input type="hidden" name="foodItemId" value="${item.foodItem.id}">
                                                        <input type="hidden" name="quantity" value="${item.quantity + 1}">
                                                        <button type="submit" class="btn btn-outline-secondary btn-sm rounded-circle d-flex align-items-center justify-content-center" style="width: 28px; height: 28px; padding: 0;">
                                                            <i class="fa-solid fa-plus fs-xs"></i>
                                                        </button>
                                                    </form>
                                                </div>
                                            </td>
                                            <td class="text-end fw-semibold text-muted">&#8377;${item.foodItem.price}</td>
                                            <td class="text-end fw-bold text-dark">&#8377;${item.getSubtotal()}</td>
                                            <td class="text-center">
                                                <form action="${pageContext.request.contextPath}/customer/cart" method="post" class="m-0">
                                                    <input type="hidden" name="action" value="remove">
                                                    <input type="hidden" name="foodItemId" value="${item.foodItem.id}">
                                                    <button type="submit" class="btn text-danger btn-sm" title="Remove item">
                                                        <i class="fa-regular fa-trash-can fs-5"></i>
                                                    </button>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Order Pricing Summary -->
                <div class="col-lg-4">
                    <div class="card border-0 shadow-sm p-4" style="border-radius: var(--border-radius); background: white;">
                        <h5 class="fw-bold mb-4">Summary</h5>
                        
                        <div class="d-flex justify-content-between mb-2">
                            <span class="text-muted">Subtotal</span>
                            <span class="fw-bold text-dark">&#8377;${cart.getSubtotal()}</span>
                        </div>
                        <div class="d-flex justify-content-between mb-2">
                            <span class="text-muted">Delivery Fee</span>
                            <span class="fw-bold text-success">&#8377;${cart.getDeliveryCharge()}</span>
                        </div>
                        <div class="d-flex justify-content-between mb-3">
                            <span class="text-muted">GST (5%)</span>
                            <span class="fw-bold text-dark">&#8377;${cart.getTax()}</span>
                        </div>
                        <hr>
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <span class="fw-bold fs-5 text-dark">Grand Total</span>
                            <span class="fw-bold fs-4 text-primary-custom">&#8377;${cart.getGrandTotal()}</span>
                        </div>
                        
                        <a href="${pageContext.request.contextPath}/customer/checkout" class="btn btn-primary-custom w-100 py-2.5">
                            Proceed to Checkout <i class="fa-solid fa-arrow-right ms-2"></i>
                        </a>
                        <a href="${pageContext.request.contextPath}/restaurant?action=list" class="btn btn-link w-100 mt-2 text-decoration-none text-muted small py-1">
                            <i class="fa-solid fa-circle-arrow-left me-2"></i>Add More Items
                        </a>
                    </div>
                </div>
            </div>
        </c:when>
        
        <c:otherwise>
            <!-- Empty Cart State -->
            <div class="text-center py-5">
                <div class="mb-4 text-muted"><i class="fa-solid fa-basket-shopping display-1 text-light"></i></div>
                <h4 class="fw-bold">Your Cart is Empty</h4>
                <p class="text-muted">Add some delicious items from nearby restaurants to start an order.</p>
                <a href="${pageContext.request.contextPath}/restaurant?action=list" class="btn btn-primary-custom px-4 py-2.5 mt-3">
                    Browse Restaurants
                </a>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<jsp:include page="../common/footer.jsp" />
