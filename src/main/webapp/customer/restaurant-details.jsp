<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="pageTitle" value="${restaurant.restaurantName} Menu | Foodify" scope="request" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<!-- Restaurant Banner block -->
<div class="bg-dark text-white py-5" style="background: linear-gradient(rgba(0, 0, 0, 0.6), rgba(0, 0, 0, 0.85)), url('${not empty restaurant.bannerPath ? restaurant.bannerPath : 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?auto=format&fit=crop&q=80&w=1200'}') no-repeat center center / cover;">
    <div class="container">
        <div class="row align-items-center">
            <div class="col-md-8">
                <span class="badge bg-warning text-dark mb-2 fw-semibold">${restaurant.cuisineType}</span>
                <h1 class="display-5 fw-bold text-white mb-2">${restaurant.restaurantName}</h1>
                <p class="mb-3 text-white-50"><i class="fa-solid fa-location-dot me-2"></i>${restaurant.address}</p>
                
                <div class="d-flex flex-wrap gap-4 text-white-50 small">
                    <div>
                        <span class="rating-badge text-dark me-2">
                            <i class="fa-solid fa-star text-warning"></i> 
                            <c:choose>
                                <c:when test="${restaurant.rating > 0}">${restaurant.rating}</c:when>
                                <c:otherwise>New</c:otherwise>
                            </c:choose>
                        </span>
                        <span>Ratings</span>
                    </div>
                    <div class="vr bg-secondary"></div>
                    <div>
                        <i class="fa-regular fa-clock me-1 text-primary-custom"></i> ${restaurant.estimatedDeliveryTime} Mins preparation time
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="container main-content mt-4">
    <!-- Breadcrumbs -->
    <nav aria-label="breadcrumb" class="mb-4">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/index.jsp" class="text-decoration-none text-muted">Home</a></li>
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/restaurant?action=list" class="text-decoration-none text-muted">Restaurants</a></li>
            <li class="breadcrumb-item active" aria-current="page">${restaurant.restaurantName}</li>
        </ol>
    </nav>

    <!-- Display system feedbacks -->
    <c:if test="${not empty param.successMsg || not empty successMsg}">
        <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
            <i class="fa-solid fa-circle-check me-2"></i> ${not empty param.successMsg ? param.successMsg : successMsg}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <c:remove var="successMsg" scope="session" />
    </c:if>
    <c:if test="${not empty param.errorMsg || not empty errorMsg}">
        <c:choose>
            <c:when test="${param.errorMsg == 'mismatch' || errorMsg == 'mismatch'}">
                <div class="alert alert-warning alert-dismissible fade show shadow-sm p-4 rounded-3 border-start border-4 border-warning" role="alert">
                    <div class="d-flex align-items-start gap-3">
                        <div class="fs-4 text-warning">
                            <i class="fa-solid fa-triangle-exclamation"></i>
                        </div>
                        <div>
                            <h6 class="fw-bold mb-1 text-dark">Items from another restaurant in cart</h6>
                            <p class="mb-2 small text-muted">Your cart contains items from a different restaurant. Would you like to clear them and start a new order with this item?</p>
                            <div>
                                <a href="${pageContext.request.contextPath}/customer/cart?action=clearAndAdd&foodItemId=${param.mismatchFoodItemId}&restaurantId=${param.mismatchRestaurantId}&quantity=1" class="btn btn-warning btn-sm fw-bold me-2 px-3 py-1 text-dark hover-lift">
                                    <i class="fa-solid fa-trash-can me-1"></i> Clear Cart & Add Item
                                </a>
                                <a href="${pageContext.request.contextPath}/customer/cart" class="btn btn-outline-secondary btn-sm px-3 py-1">
                                    View Cart
                                </a>
                            </div>
                        </div>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:when>
            <c:otherwise>
                <div class="alert alert-warning alert-dismissible fade show shadow-sm" role="alert">
                    <i class="fa-solid fa-circle-exclamation me-2"></i> ${not empty param.errorMsg ? param.errorMsg : errorMsg}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:otherwise>
        </c:choose>
        <c:remove var="errorMsg" scope="session" />
    </c:if>

    <div class="row">
        <!-- Categories Navigation List -->
        <div class="col-lg-3 mb-4">
            <div class="list-group sticky-top shadow-sm border-0 rounded-3" style="top: 95px; z-index: 10;">
                <div class="list-group-item bg-light border-0 fw-bold text-muted small uppercase">Menu Categories</div>
                <c:forEach var="cat" items="${categories}">
                    <a href="#cat_${cat.id}" class="list-group-item list-group-item-action border-0 py-2.5 font-weight-500">${cat.name}</a>
                </c:forEach>
            </div>
        </div>

        <!-- Menu items rendering -->
        <div class="col-lg-9">
            <c:choose>
                <c:when test="${not empty categories}">
                    <c:forEach var="cat" items="${categories}">
                        <div id="cat_${cat.id}" class="mb-5">
                            <h4 class="fw-bold border-bottom pb-2 text-dark mb-4">${cat.name}</h4>
                            
                            <div class="row g-4">
                                <c:forEach var="food" items="${foodItems}">
                                    <c:if test="${food.categoryId == cat.id}">
                                        <div class="col-md-6">
                                            <div class="card card-custom h-100 flex-row">
                                                <div class="col-4 p-0 card-img-container position-relative" style="height: auto; min-height: 120px;">
                                                    <img src="${not empty food.imagePath ? food.imagePath : 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&q=80&w=200'}" alt="${food.name}" style="position: absolute; width: 100%; height: 100%; object-fit: cover;">
                                                </div>
                                                <div class="col-8 p-3 d-flex flex-column">
                                                    <div class="d-flex align-items-center gap-2 mb-1">
                                                        <c:choose>
                                                            <c:when test="${food.isVeg()}">
                                                                <span class="badge-veg small"><i class="fa-solid fa-circle text-white me-1 fs-xs"></i>Veg</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge-nonveg small"><i class="fa-solid fa-triangle me-1 fs-xs"></i>Non-Veg</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                        <c:if test="${not food.isAvailable()}">
                                                            <span class="badge bg-secondary text-white small">Sold Out</span>
                                                        </c:if>
                                                    </div>
                                                    <h5 class="fw-bold mb-1 fs-6">${food.name}</h5>
                                                    <p class="text-muted small text-truncate-2 mb-2" style="display:-webkit-box; -webkit-line-clamp:2; -webkit-box-orient:vertical; overflow:hidden; font-size:0.8rem;">${food.description}</p>
                                                    
                                                    <div class="mt-auto d-flex justify-content-between align-items-center">
                                                        <span class="fw-bold text-dark">&#8377;${food.price}</span>
                                                        
                                                        <c:if test="${food.isAvailable()}">
                                                            <form action="${pageContext.request.contextPath}/customer/cart" method="post" class="m-0">
                                                                <input type="hidden" name="action" value="add">
                                                                <input type="hidden" name="foodItemId" value="${food.id}">
                                                                <input type="hidden" name="restaurantId" value="${restaurant.userId}">
                                                                <input type="hidden" name="quantity" value="1">
                                                                <button type="submit" class="btn btn-outline-primary-custom btn-sm px-3 py-1 font-weight-600">
                                                                    Add +
                                                                </button>
                                                            </form>
                                                        </c:if>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:if>
                                </c:forEach>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="text-center py-5">
                        <p class="text-muted">No items available on the menu right now.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />
