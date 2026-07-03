<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<c:set var="pageTitle" value="Reset Password | Foodify" scope="request" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<div class="container main-content d-flex align-items-center justify-content-center">
    <div class="auth-card w-100">
        <h3 class="text-center mb-2">Reset Password</h3>
        <p class="text-muted text-center mb-4">Verify your credentials to set a new password</p>
        
        <!-- Display alert messages -->
        <c:if test="${not empty errorMsg}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fa-solid fa-triangle-exclamation me-2"></i> ${errorMsg}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/auth/forgot-password" method="post" onsubmit="return validatePasswords()">
            <div class="mb-3">
                <label for="email" class="form-label">Registered Email</label>
                <input type="email" class="form-control form-control-custom" id="email" name="email" required placeholder="name@example.com">
            </div>
            
            <div class="mb-3">
                <label for="phone" class="form-label">Registered Phone Number</label>
                <input type="tel" class="form-control form-control-custom" id="phone" name="phone" required placeholder="9876543210">
            </div>

            <div class="mb-3">
                <label for="newPassword" class="form-label">New Password</label>
                <input type="password" class="form-control form-control-custom" id="newPassword" name="newPassword" required placeholder="Min 6 characters">
            </div>

            <div class="mb-3">
                <label for="confirmPassword" class="form-label">Confirm New Password</label>
                <input type="password" class="form-control form-control-custom" id="confirmPassword" name="confirmPassword" required placeholder="Re-enter password">
            </div>

            <div id="passwordError" class="text-danger small mb-3 d-none">
                <i class="fa-solid fa-circle-exclamation me-1"></i> Passwords do not match.
            </div>

            <button type="submit" class="btn btn-primary-custom w-100 py-2.5 mt-3">Reset Password</button>
        </form>
        
        <p class="text-center text-muted mt-4 mb-0">
            Back to <a href="${pageContext.request.contextPath}/auth/login.jsp" class="text-primary-custom text-decoration-none font-weight-500">Log In</a>
        </p>
    </div>
</div>

<script>
function validatePasswords() {
    const pw = document.getElementById('newPassword').value;
    const cpw = document.getElementById('confirmPassword').value;
    const err = document.getElementById('passwordError');
    
    if (pw !== cpw) {
        err.classList.remove('d-none');
        return false;
    }
    err.classList.add('d-none');
    return true;
}
</script>

<jsp:include page="../common/footer.jsp" />
