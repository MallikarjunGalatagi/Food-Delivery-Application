<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<c:set var="pageTitle" value="Login | Foodify" scope="request" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<div class="container main-content d-flex align-items-center justify-content-center">
    <div class="auth-card w-100">
        <h3 class="text-center mb-2">Welcome Back</h3>
        <p class="text-muted text-center mb-4">Log in to your Foodify account</p>
        
        <!-- Display alert messages -->
        <c:set var="dispError" value="${not empty param.errorMsg ? param.errorMsg : errorMsg}" />
        <c:set var="dispSuccess" value="${not empty param.successMsg ? param.successMsg : successMsg}" />
        
        <c:if test="${not empty dispError}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fa-solid fa-triangle-exclamation me-2"></i> ${dispError}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <c:remove var="errorMsg" scope="session" />
        </c:if>
        <c:if test="${not empty dispSuccess}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fa-solid fa-circle-check me-2"></i> ${dispSuccess}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <c:remove var="successMsg" scope="session" />
        </c:if>

        <form action="${pageContext.request.contextPath}/auth/login" method="post">
            <div class="mb-3">
                <label for="email" class="form-label font-weight-500">Email Address</label>
                <input type="email" class="form-control form-control-custom" id="email" name="email" required placeholder="name@example.com">
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
