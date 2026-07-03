<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<c:set var="pageTitle" value="Login | Foodify" scope="request" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<div class="container main-content d-flex align-items-center justify-content-center">
    <div class="auth-card w-100">
        <h3 class="text-center mb-2">Welcome Back</h3>
        <p class="text-muted text-center mb-4">Log in to your Foodify account</p>
        
        <!-- Display alert messages -->
        <c:if test="${not empty errorMsg || not empty param.errorMsg}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fa-solid fa-triangle-exclamation me-2"></i> ${not empty param.errorMsg ? param.errorMsg : errorMsg}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <c:remove var="errorMsg" scope="session" />
        </c:if>
        <c:if test="${not empty successMsg || not empty param.successMsg}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fa-solid fa-circle-check me-2"></i> ${not empty param.successMsg ? param.successMsg : successMsg}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <c:remove var="successMsg" scope="session" />
        </c:if>

        <form action="${pageContext.request.contextPath}/auth/login" method="post">
            <div class="mb-3">
                <label for="email" class="form-label font-weight-500">Username / Email</label>
                <input type="text" class="form-control form-control-custom" id="email" name="email" required placeholder="Enter username or email">
            </div>
            
            <div class="mb-3">
                <div class="d-flex justify-content-between">
                    <label for="password" class="form-label font-weight-500">Password</label>
                    <a href="${pageContext.request.contextPath}/auth/forgot-password.jsp" class="text-primary-custom text-decoration-none small">Forgot Password?</a>
                </div>
                <input type="password" class="form-control form-control-custom" id="password" name="password" required placeholder="Enter password">
            </div>

            <button type="submit" class="btn btn-primary-custom w-100 py-2.5 mt-3">Log In</button>
        </form>
        
        <p class="text-center text-muted mt-4 mb-0">
            Don't have an account? 
            <a href="${pageContext.request.contextPath}/auth/register.jsp" class="text-primary-custom text-decoration-none font-weight-500">Register</a>
        </p>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />
