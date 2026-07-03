<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<c:set var="pageTitle" value="Register | Foodify" scope="request" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<div class="container main-content d-flex align-items-center justify-content-center">
    <div class="auth-card w-100" style="max-width: 600px;">
        <h3 class="text-center mb-2">Create an Account</h3>
        <p class="text-muted text-center mb-4">Join Foodify today and enjoy great benefits</p>
        
        <!-- Display alert messages -->
        <c:if test="${not empty errorMsg}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fa-solid fa-triangle-exclamation me-2"></i> ${errorMsg}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/auth/register" method="post" id="registerForm">
            <!-- Role Selection -->
            <div class="mb-4">
                <label for="role" class="form-label font-weight-500">I want to register as a:</label>
                <select class="form-select form-control-custom" id="role" name="role" onchange="toggleRoleFields(this.value)">
                    <option value="CUSTOMER" ${param.role == 'CUSTOMER' || empty param.role ? 'selected' : ''}>Customer</option>
                    <option value="RESTAURANT_OWNER" ${param.role == 'RESTAURANT_OWNER' ? 'selected' : ''}>Restaurant Owner (Partner)</option>
                    <option value="DELIVERY_PARTNER" ${param.role == 'DELIVERY_PARTNER' ? 'selected' : ''}>Delivery Rider (Partner)</option>
                </select>
            </div>

            <!-- Common Fields -->
            <div class="row">
                <div class="col-md-6 mb-3">
                    <label for="firstName" class="form-label">First Name</label>
                    <input type="text" class="form-control form-control-custom" id="firstName" name="firstName" required>
                </div>
                <div class="col-md-6 mb-3">
                    <label for="lastName" class="form-label">Last Name</label>
                    <input type="text" class="form-control form-control-custom" id="lastName" name="lastName" required>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6 mb-3">
                    <label for="email" class="form-label">Email Address</label>
                    <input type="email" class="form-control form-control-custom" id="email" name="email" required placeholder="name@example.com">
                </div>
                <div class="col-md-6 mb-3">
                    <label for="phone" class="form-label">Phone Number</label>
                    <input type="tel" class="form-control form-control-custom" id="phone" name="phone" required placeholder="9876543210">
                </div>
            </div>

            <div class="mb-3">
                <label for="password" class="form-label">Password</label>
                <input type="password" class="form-control form-control-custom" id="password" name="password" required placeholder="Min 6 characters">
            </div>

            <!-- Restaurant Owner Specific Fields -->
            <div id="restaurantFields" class="border-top pt-3 mt-3 d-none">
                <h5 class="mb-3 text-primary-custom"><i class="fa-solid fa-store me-2"></i>Restaurant Information</h5>
                <div class="mb-3">
                    <label for="restaurantName" class="form-label">Restaurant Name</label>
                    <input type="text" class="form-control form-control-custom" id="restaurantName" name="restaurantName">
                </div>
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="cuisineType" class="form-label">Cuisines (comma separated)</label>
                        <input type="text" class="form-control form-control-custom" id="cuisineType" name="cuisineType" placeholder="Italian, Fast Food">
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="deliveryTime" class="form-label">Avg. Preparation Time (mins)</label>
                        <input type="number" class="form-control form-control-custom" id="deliveryTime" name="deliveryTime" value="30">
                    </div>
                </div>
                <div class="mb-3">
                    <label for="restaurantAddress" class="form-label">Complete Address</label>
                    <textarea class="form-control form-control-custom" id="restaurantAddress" name="restaurantAddress" rows="2"></textarea>
                </div>
            </div>

            <!-- Delivery Partner Specific Fields -->
            <div id="deliveryFields" class="border-top pt-3 mt-3 d-none">
                <h5 class="mb-3 text-success"><i class="fa-solid fa-motorcycle me-2"></i>Rider & Vehicle Information</h5>
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="vehicleNumber" class="form-label">Vehicle Registration Number</label>
                        <input type="text" class="form-control form-control-custom" id="vehicleNumber" name="vehicleNumber" placeholder="MH-01-AB-1234">
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="licenseNumber" class="form-label">Driving License Number</label>
                        <input type="text" class="form-control form-control-custom" id="licenseNumber" name="licenseNumber" placeholder="DL-1234567890">
                    </div>
                </div>
            </div>

            <button type="submit" class="btn btn-primary-custom w-100 py-2.5 mt-3">Register Now</button>
        </form>
        
        <p class="text-center text-muted mt-4 mb-0">
            Already have an account? 
            <a href="${pageContext.request.contextPath}/auth/login.jsp" class="text-primary-custom text-decoration-none font-weight-500">Log In</a>
        </p>
    </div>
</div>

<script>
function toggleRoleFields(role) {
    const restaurantFields = document.getElementById('restaurantFields');
    const deliveryFields = document.getElementById('deliveryFields');
    
    // Clear required attributes to avoid submittal blocking on hidden fields
    const restInputs = restaurantFields.querySelectorAll('input, textarea');
    const delInputs = deliveryFields.querySelectorAll('input');
    
    restInputs.forEach(i => i.removeAttribute('required'));
    delInputs.forEach(i => i.removeAttribute('required'));

    restaurantFields.classList.add('d-none');
    deliveryFields.classList.add('d-none');

    if (role === 'RESTAURANT_OWNER') {
        restaurantFields.classList.remove('d-none');
        restInputs.forEach(i => {
            if (i.id !== 'logoPath' && i.id !== 'bannerPath') {
                i.setAttribute('required', 'true');
            }
        });
    } else if (role === 'DELIVERY_PARTNER') {
        deliveryFields.classList.remove('d-none');
        delInputs.forEach(i => i.setAttribute('required', 'true'));
    }
}

// Initial toggle trigger on page load
document.addEventListener('DOMContentLoaded', function() {
    toggleRoleFields(document.getElementById('role').value);
});
</script>

<jsp:include page="../common/footer.jsp" />
