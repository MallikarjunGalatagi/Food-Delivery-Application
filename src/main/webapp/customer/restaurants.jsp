<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="pageTitle" value="Browse Restaurants | Foodify" scope="request" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<div class="container main-content">
    <!-- Breadcrumbs -->
    <nav aria-label="breadcrumb" class="mb-4">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/index.jsp" class="text-decoration-none text-muted">Home</a></li>
            <li class="breadcrumb-item active" aria-current="page">Restaurants</li>
        </ol>
    </nav>

    <!-- Display system feedbacks -->
    <c:if test="${not empty param.successMsg || not empty successMsg}">
        <div class="alert alert-success alert-dismissible fade show shadow-sm mb-4" role="alert">
            <i class="fa-solid fa-circle-check me-2"></i> ${not empty param.successMsg ? param.successMsg : successMsg}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <c:remove var="successMsg" scope="session" />
    </c:if>
    <c:if test="${not empty param.errorMsg || not empty errorMsg}">
        <c:choose>
            <c:when test="${param.errorMsg == 'mismatch' || errorMsg == 'mismatch'}">
                <div class="alert alert-warning alert-dismissible fade show shadow-sm p-4 rounded-3 border-start border-4 border-warning mb-4" role="alert">
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
                <div class="alert alert-warning alert-dismissible fade show shadow-sm mb-4" role="alert">
                    <i class="fa-solid fa-circle-exclamation me-2"></i> ${not empty param.errorMsg ? param.errorMsg : errorMsg}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:otherwise>
        </c:choose>
        <c:remove var="errorMsg" scope="session" />
    </c:if>

    <div class="row">
        <!-- Sidebar Filters Column -->
        <div class="col-lg-3 mb-4">
            <div class="card border-0 shadow-sm p-4" style="border-radius: var(--border-radius); background: white;">
                <h5 class="fw-bold mb-4"><i class="fa-solid fa-sliders text-primary-custom me-2"></i>Filters</h5>
                
                <form action="${pageContext.request.contextPath}/restaurant" method="get">
                    <input type="hidden" name="action" value="list">
                    
                    <!-- Search inside filters -->
                    <div class="mb-4">
                        <label for="search" class="form-label small fw-semibold text-muted">Search</label>
                        <input type="text" name="search" id="search" class="form-control form-control-custom form-control-sm" placeholder="e.g. Pizza, Burger, Tacos" value="${searchParam}">
                    </div>

                    <!-- Sort Filter -->
                    <div class="mb-4">
                        <label for="sortBy" class="form-label small fw-semibold text-muted">Sort By</label>
                        <select name="sortBy" id="sortBy" class="form-select form-control-custom form-control-sm">
                            <option value="name" ${sortByParam == 'name' ? 'selected' : ''}>Name (A - Z)</option>
                            <option value="rating" ${sortByParam == 'rating' ? 'selected' : ''}>Highest Rating</option>
                            <option value="delivery_time" ${sortByParam == 'delivery_time' ? 'selected' : ''}>Fastest Delivery</option>
                        </select>
                    </div>

                    <!-- Cuisine Filter -->
                    <div class="mb-4">
                        <label class="form-label small fw-semibold text-muted">Cuisine</label>
                        <div class="d-flex flex-column gap-2" style="max-height: 200px; overflow-y: auto;">
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="cuisine" id="allCuisines" value="" ${empty cuisineParam ? 'checked' : ''}>
                                <label class="form-check-label small" for="allCuisines">All Cuisines</label>
                            </div>
                            <c:forEach var="c" items="${cuisines}">
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="cuisine" id="c_${c}" value="${c}" ${cuisineParam == c ? 'checked' : ''}>
                                    <label class="form-check-label small" for="c_${c}">${c}</label>
                                </div>
                            </c:forEach>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-primary-custom w-100 py-2 btn-sm">Apply Filters</button>
                    <a href="${pageContext.request.contextPath}/restaurant?action=list" class="btn btn-link w-100 mt-2 text-decoration-none text-muted small py-1">Clear All</a>
                </form>
            </div>
        </div>

        <!-- Restaurants Listing Column -->
        <div class="col-lg-9">
            <!-- Direct Food Items Results -->
            <c:if test="${not empty searchParam}">
                <div class="mb-5">
                    <h4 class="fw-bold mb-4 text-dark">
                        <i class="fa-solid fa-burger text-primary-custom me-2"></i>Food Items Matching "${searchParam}"
                        <span class="text-muted fs-6 font-weight-normal">(${not empty matchingFoodItems ? matchingFoodItems.size() : 0} found)</span>
                    </h4>
                    
                    <c:choose>
                        <c:when test="${not empty matchingFoodItems}">
                            <div class="row g-4">
                                <c:forEach var="food" items="${matchingFoodItems}">
                                    <div class="col-md-6 col-xl-4">
                                        <div class="card card-custom h-100 d-flex flex-column">
                                            <div class="card-img-container" style="height: 180px; padding-bottom: 0;">
                                                <img src="${not empty food.imagePath ? food.imagePath : 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&q=80&w=400'}" alt="${food.name}" style="position: absolute; width: 100%; height: 100%; object-fit: cover;">
                                            </div>
                                            <div class="card-body p-4 d-flex flex-column">
                                                <div class="d-flex align-items-center gap-2 mb-2">
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
                                                <h5 class="fw-bold mb-1 card-title text-truncate" style="max-width: 90%;">${food.name}</h5>
                                                <span class="text-primary-custom small fw-semibold mb-2">by ${food.restaurantName}</span>
                                                <p class="text-muted small mb-3" style="display:-webkit-box; -webkit-line-clamp:2; -webkit-box-orient:vertical; overflow:hidden; font-size:0.8rem; height: 2.4rem;">${food.description}</p>
                                                
                                                <div class="mt-auto pt-3 border-top d-flex justify-content-between align-items-center">
                                                    <span class="fw-bold text-dark fs-5">&#8377;${food.price}</span>
                                                    
                                                    <c:choose>
                                                        <c:when test="${food.isAvailable()}">
                                                            <form action="${pageContext.request.contextPath}/customer/cart" method="post" class="m-0">
                                                                <input type="hidden" name="action" value="add">
                                                                <input type="hidden" name="foodItemId" value="${food.id}">
                                                                <input type="hidden" name="restaurantId" value="${food.restaurantId}">
                                                                <input type="hidden" name="quantity" value="1">
                                                                <button type="submit" class="btn btn-outline-primary-custom btn-sm px-3 py-1.5 font-weight-600 hover-lift">
                                                                    Add to Cart +
                                                                </button>
                                                            </form>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <button class="btn btn-secondary btn-sm px-3 py-1.5 font-weight-600 disabled" disabled>
                                                                Sold Out
                                                            </button>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-4 bg-white rounded-3 shadow-sm border border-light">
                                <p class="text-muted mb-0">No matching food items found.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:if>

            <!-- Restaurants Results -->
            <div>
                <h4 class="fw-bold mb-4 text-dark">
                    <i class="fa-solid fa-store text-primary-custom me-2"></i>
                    <c:choose>
                        <c:when test="${not empty searchParam}">Matching Restaurants</c:when>
                        <c:when test="${not empty cuisineParam}">${cuisineParam} Restaurants</c:when>
                        <c:otherwise>All Restaurants</c:otherwise>
                    </c:choose>
                    <span class="text-muted fs-6 font-weight-normal">(${restaurants.size()} found)</span>
                </h4>

                <c:choose>
                    <c:when test="${not empty restaurants}">
                        <div class="row g-4">
                            <c:forEach var="r" items="${restaurants}">
                                <div class="col-md-6 col-xl-4">
                                    <div class="card card-custom h-100">
                                        <div class="card-img-container">
                                            <!-- Fallback banner image if banner_path is null -->
                                            <img src="${not empty r.bannerPath ? r.bannerPath : 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?auto=format&fit=crop&q=80&w=400'}" alt="${r.restaurantName}">
                                        </div>
                                        <div class="card-body p-4 d-flex flex-column">
                                            <div class="d-flex justify-content-between align-items-start mb-2">
                                                <h5 class="fw-bold card-title mb-0 text-truncate" style="max-width: 80%;">${r.restaurantName}</h5>
                                                <div class="rating-badge flex-shrink-0">
                                                    <i class="fa-solid fa-star me-1 text-warning"></i>
                                                    <c:choose>
                                                        <c:when test="${r.rating > 0}">${r.rating}</c:when>
                                                        <c:otherwise>New</c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                            
                                            <p class="text-muted small text-truncate mb-3">${r.cuisineType}</p>
                                            
                                            <div class="mt-auto pt-3 border-top d-flex justify-content-between align-items-center">
                                                <div class="small text-muted">
                                                    <i class="fa-regular fa-clock me-1"></i> ${r.estimatedDeliveryTime} mins
                                                </div>
                                                <a href="${pageContext.request.contextPath}/restaurant?action=details&id=${r.userId}" class="btn btn-primary-custom btn-sm py-1.5 px-3 hover-lift">
                                                    View Menu
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:if test="${empty matchingFoodItems}">
                            <!-- No Results State -->
                            <div class="text-center py-5 mt-4">
                                <div class="mb-4 text-muted"><i class="fa-solid fa-utensils fs-1"></i></div>
                                <h4 class="fw-bold">No Results Found</h4>
                                <p class="text-muted">We couldn't find any food items or restaurants matching your search selection.</p>
                                <a href="${pageContext.request.contextPath}/restaurant?action=list" class="btn btn-primary-custom px-4 py-2 mt-3 hover-lift">Reset Search</a>
                            </div>
                        </c:if>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />
