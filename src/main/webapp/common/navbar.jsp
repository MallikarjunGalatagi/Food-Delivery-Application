<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<nav class="navbar navbar-expand-lg navbar-custom sticky-top">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/index.jsp">
            <i class="fa-solid fa-utensils me-2"></i>Food<span>ify</span>
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarContent" aria-controls="navbarContent" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        
        <div class="collapse navbar-collapse" id="navbarContent">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item">
                    <a class="nav-link ${pageContext.request.requestURI.endsWith('index.jsp') ? 'active' : ''}" href="${pageContext.request.contextPath}/index.jsp">Home</a>
                </li>
                
                <!-- Customer navigation links -->
                <c:if test="${empty sessionScope.user || sessionScope.user.role == 'CUSTOMER'}">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/restaurant?action=list">Restaurants</a>
                    </li>
                </c:if>
                
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/common/about.jsp">About Us</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/common/contact.jsp">Contact Us</a>
                </li>
            </ul>
            
            <div class="d-flex align-items-center gap-3">
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <!-- Logged-in Menu based on Role -->
                        <c:choose>
                            <c:when test="${sessionScope.user.role == 'CUSTOMER'}">
                                <!-- Cart Icon for Customers -->
                                <a href="${pageContext.request.contextPath}/customer/cart" class="position-relative me-3 text-dark text-decoration-none">
                                    <i class="fa-solid fa-cart-shopping fs-5 text-primary-custom"></i>
                                    <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger" id="cartBadge">
                                        ${sessionScope.cartSize != null ? sessionScope.cartSize : '0'}
                                    </span>
                                </a>
                                
                                <div class="dropdown">
                                    <a class="btn btn-outline-primary-custom dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                        <i class="fa-regular fa-user me-2"></i>Hi, ${sessionScope.user.firstName}
                                    </a>
                                    <ul class="dropdown-menu dropdown-menu-end border-0 shadow-sm mt-2">
                                        <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/customer/dashboard"><i class="fa-solid fa-house-user me-2 text-muted"></i>Dashboard</a></li>
                                        <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/customer/orders"><i class="fa-solid fa-history me-2 text-muted"></i>My Orders</a></li>
                                        <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/customer/profile"><i class="fa-solid fa-user-gear me-2 text-muted"></i>Manage Profile</a></li>
                                        <li><hr class="dropdown-divider"></li>
                                        <li><a class="dropdown-item py-2 text-danger" href="${pageContext.request.contextPath}/auth/logout"><i class="fa-solid fa-right-from-bracket me-2"></i>Logout</a></li>
                                    </ul>
                                </div>
                            </c:when>
                            
                            <c:when test="${sessionScope.user.role == 'RESTAURANT_OWNER'}">
                                <div class="dropdown">
                                    <a class="btn btn-primary-custom dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                        <i class="fa-solid fa-store me-2"></i>Owner: ${sessionScope.user.firstName}
                                    </a>
                                    <ul class="dropdown-menu dropdown-menu-end border-0 shadow-sm mt-2">
                                        <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/restaurant/dashboard"><i class="fa-solid fa-chart-line me-2 text-muted"></i>Dashboard</a></li>
                                        <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/restaurant/menu"><i class="fa-solid fa-bowl-food me-2 text-muted"></i>Manage Menu</a></li>
                                        <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/restaurant/orders"><i class="fa-solid fa-clipboard-list me-2 text-muted"></i>Orders</a></li>
                                        <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/restaurant/profile"><i class="fa-solid fa-store-gear me-2 text-muted"></i>Store Details</a></li>
                                        <li><hr class="dropdown-divider"></li>
                                        <li><a class="dropdown-item py-2 text-danger" href="${pageContext.request.contextPath}/auth/logout"><i class="fa-solid fa-right-from-bracket me-2"></i>Logout</a></li>
                                    </ul>
                                </div>
                            </c:when>
                            
                            <c:when test="${sessionScope.user.role == 'DELIVERY_PARTNER'}">
                                <div class="dropdown">
                                    <a class="btn btn-success dropdown-toggle text-white" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                        <i class="fa-solid fa-motorcycle me-2"></i>Rider: ${sessionScope.user.firstName}
                                    </a>
                                    <ul class="dropdown-menu dropdown-menu-end border-0 shadow-sm mt-2">
                                        <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/delivery/dashboard"><i class="fa-solid fa-motorcycle me-2 text-muted"></i>Deliveries</a></li>
                                        <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/delivery/profile"><i class="fa-solid fa-user-circle me-2 text-muted"></i>Profile</a></li>
                                        <li><hr class="dropdown-divider"></li>
                                        <li><a class="dropdown-item py-2 text-danger" href="${pageContext.request.contextPath}/auth/logout"><i class="fa-solid fa-right-from-bracket me-2"></i>Logout</a></li>
                                    </ul>
                                </div>
                            </c:when>
                            
                            <c:when test="${sessionScope.user.role == 'ADMIN'}">
                                <div class="dropdown">
                                    <a class="btn btn-dark dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                        <i class="fa-solid fa-user-shield me-2"></i>Admin Console
                                    </a>
                                    <ul class="dropdown-menu dropdown-menu-end border-0 shadow-sm mt-2">
                                        <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/admin/dashboard"><i class="fa-solid fa-dashboard me-2 text-muted"></i>Dashboard</a></li>
                                        <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/admin/restaurants"><i class="fa-solid fa-check-double me-2 text-muted"></i>Approve Partners</a></li>
                                        <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/admin/users"><i class="fa-solid fa-users me-2 text-muted"></i>Manage Accounts</a></li>
                                        <li><hr class="dropdown-divider"></li>
                                        <li><a class="dropdown-item py-2 text-danger" href="${pageContext.request.contextPath}/auth/logout"><i class="fa-solid fa-right-from-bracket me-2"></i>Logout</a></li>
                                    </ul>
                                </div>
                            </c:when>
                        </c:choose>
                    </c:when>
                    <c:otherwise>
                        <!-- Visitor Menu -->
                        <a href="${pageContext.request.contextPath}/auth/login.jsp" class="btn btn-outline-primary-custom">Login</a>
                        <div class="dropdown">
                            <button class="btn btn-primary-custom dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                                Register
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end border-0 shadow-sm mt-2">
                                <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/auth/register.jsp?role=CUSTOMER"><i class="fa-solid fa-user me-2 text-muted"></i>Customer Account</a></li>
                                <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/auth/register.jsp?role=RESTAURANT_OWNER"><i class="fa-solid fa-shop me-2 text-muted"></i>Restaurant Owner</a></li>
                                <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/auth/register.jsp?role=DELIVERY_PARTNER"><i class="fa-solid fa-motorcycle me-2 text-muted"></i>Delivery Rider</a></li>
                            </ul>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</nav>
