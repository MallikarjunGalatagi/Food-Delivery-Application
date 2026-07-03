<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="pageTitle" value="Manage Profile | Foodify" scope="request" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<div class="container main-content">
    <!-- Breadcrumbs -->
    <nav aria-label="breadcrumb" class="mb-4">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/index.jsp" class="text-decoration-none text-muted">Home</a></li>
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/customer/dashboard" class="text-decoration-none text-muted">Dashboard</a></li>
            <li class="breadcrumb-item active" aria-current="page">Manage Profile</li>
        </ol>
    </nav>

    <!-- Feedback messages -->
    <c:if test="${not empty param.successMsg}">
        <div class="alert alert-success alert-dismissible fade show border-0 shadow-sm" role="alert">
            <i class="fa-solid fa-circle-check me-2"></i> ${param.successMsg}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>
    <c:if test="${not empty param.errorMsg}">
        <div class="alert alert-danger alert-dismissible fade show border-0 shadow-sm" role="alert">
            <i class="fa-solid fa-circle-exclamation me-2"></i> ${param.errorMsg}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <div class="row">
        <!-- Sidebar Navigation Tabs -->
        <div class="col-lg-3 mb-4">
            <div class="card border-0 shadow-sm p-4 sticky-top" style="top: 95px; border-radius: var(--border-radius); background: white; z-index: 10;">
                <h5 class="fw-bold mb-4"><i class="fa-solid fa-user-gear text-primary-custom me-2"></i>Settings</h5>
                <div class="nav flex-column nav-pills" id="v-pills-tab" role="tablist" aria-orientation="vertical">
                    <button class="nav-link active text-start py-2.5 px-3 mb-2 font-weight-500" id="v-pills-profile-tab" data-bs-toggle="pill" data-bs-target="#v-pills-profile" type="button" role="tab" aria-controls="v-pills-profile" aria-selected="true">
                        <i class="fa-regular fa-id-card me-2"></i>Personal Info
                    </button>
                    <button class="nav-link text-start py-2.5 px-3 mb-2 font-weight-500" id="v-pills-addresses-tab" data-bs-toggle="pill" data-bs-target="#v-pills-addresses" type="button" role="tab" aria-controls="v-pills-addresses" aria-selected="false">
                        <i class="fa-solid fa-map-location-dot me-2"></i>Manage Addresses
                    </button>
                    <button class="nav-link text-start py-2.5 px-3 mb-2 font-weight-500" id="v-pills-security-tab" data-bs-toggle="pill" data-bs-target="#v-pills-security" type="button" role="tab" aria-controls="v-pills-security" aria-selected="false">
                        <i class="fa-solid fa-shield-halved me-2"></i>Security Settings
                    </button>
                </div>
            </div>
        </div>

        <!-- Tab Content Areas -->
        <div class="col-lg-9">
            <div class="tab-content" id="v-pills-tabContent">
                <!-- Personal Info Panel -->
                <div class="tab-pane fade show active" id="v-pills-profile" role="tabpanel" aria-labelledby="v-pills-profile-tab">
                    <div class="card border-0 shadow-sm p-4" style="border-radius: var(--border-radius); background: white;">
                        <h4 class="fw-bold text-dark mb-4 pb-2 border-bottom">Personal Information</h4>
                        
                        <form action="${pageContext.request.contextPath}/customer/profile" method="post">
                            <input type="hidden" name="action" value="updateProfile">
                            
                            <div class="row g-3 mb-4">
                                <div class="col-md-6">
                                    <label for="firstName" class="form-label small fw-semibold text-muted">First Name</label>
                                    <input type="text" name="firstName" id="firstName" class="form-control form-control-custom" value="${sessionScope.user.firstName}" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="lastName" class="form-label small fw-semibold text-muted">Last Name</label>
                                    <input type="text" name="lastName" id="lastName" class="form-control form-control-custom" value="${sessionScope.user.lastName}" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="email" class="form-label small fw-semibold text-muted">Email Address (Cannot Change)</label>
                                    <input type="email" id="email" class="form-control form-control-custom bg-light" value="${sessionScope.user.email}" readonly>
                                </div>
                                <div class="col-md-6">
                                    <label for="phone" class="form-label small fw-semibold text-muted">Phone Number</label>
                                    <input type="tel" name="phone" id="phone" class="form-control form-control-custom" value="${sessionScope.user.phone}" required>
                                </div>
                            </div>
                            
                            <button type="submit" class="btn btn-primary-custom px-4 py-2">Save Profile Details</button>
                        </form>
                    </div>
                </div>

                <!-- Addresses Panel -->
                <div class="tab-pane fade" id="v-pills-addresses" role="tabpanel" aria-labelledby="v-pills-addresses-tab">
                    <div class="card border-0 shadow-sm p-4" style="border-radius: var(--border-radius); background: white;">
                        <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom">
                            <h4 class="fw-bold text-dark mb-0">Delivery Addresses</h4>
                            <button type="button" class="btn btn-primary-custom btn-sm px-3 py-2" data-bs-toggle="modal" data-bs-target="#addAddressModal">
                                <i class="fa-solid fa-plus me-1"></i> Add New Address
                            </button>
                        </div>

                        <c:choose>
                            <c:when test="${not empty addresses}">
                                <div class="row g-3">
                                    <c:forEach var="addr" items="${addresses}">
                                        <div class="col-md-6">
                                            <div class="card border p-3 position-relative ${addr.isDefault() ? 'border-primary' : ''}" style="border-radius: var(--border-radius);">
                                                <c:if test="${addr.isDefault()}">
                                                    <span class="position-absolute top-0 end-0 badge bg-primary m-3 small">Default</span>
                                                </c:if>
                                                <h6 class="fw-bold mb-2">Delivery Destination</h6>
                                                <p class="text-muted small mb-3">
                                                    ${addr.addressLine1}<br>
                                                    <c:if test="${not empty addr.addressLine2}">${addr.addressLine2}<br></c:if>
                                                    ${addr.city}, ${addr.state} - ${addr.postalCode}
                                                </p>
                                                
                                                <div class="d-flex gap-2 mt-auto">
                                                    <c:if test="${not addr.isDefault()}">
                                                        <form action="${pageContext.request.contextPath}/customer/profile" method="post">
                                                            <input type="hidden" name="action" value="setDefaultAddress">
                                                            <input type="hidden" name="addressId" value="${addr.id}">
                                                            <button type="submit" class="btn btn-link btn-sm text-decoration-none p-0 text-primary-custom small">Set Default</button>
                                                        </form>
                                                        <span class="text-muted small">|</span>
                                                    </c:if>
                                                    <form action="${pageContext.request.contextPath}/customer/profile" method="post" onsubmit="return confirm('Are you sure you want to delete this address?');">
                                                        <input type="hidden" name="action" value="deleteAddress">
                                                        <input type="hidden" name="addressId" value="${addr.id}">
                                                        <button type="submit" class="btn btn-link btn-sm text-decoration-none p-0 text-danger small">Delete</button>
                                                    </form>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-5">
                                    <div class="mb-3 text-muted"><i class="fa-solid fa-map-pin fs-2"></i></div>
                                    <h5 class="fw-bold">No Saved Addresses</h5>
                                    <p class="text-muted small">Please add a delivery destination address to place orders.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Security Panel -->
                <div class="tab-pane fade" id="v-pills-security" role="tabpanel" aria-labelledby="v-pills-security-tab">
                    <div class="card border-0 shadow-sm p-4" style="border-radius: var(--border-radius); background: white;">
                        <h4 class="fw-bold text-dark mb-4 pb-2 border-bottom">Security Settings</h4>
                        
                        <form action="${pageContext.request.contextPath}/customer/profile" method="post">
                            <input type="hidden" name="action" value="changePassword">
                            
                            <div class="mb-3 max-width-500">
                                <label for="currentPassword" class="form-label small fw-semibold text-muted">Current Password</label>
                                <input type="password" name="currentPassword" id="currentPassword" class="form-control form-control-custom" required>
                            </div>
                            
                            <div class="mb-3 max-width-500">
                                <label for="newPassword" class="form-label small fw-semibold text-muted">New Password</label>
                                <input type="password" name="newPassword" id="newPassword" class="form-control form-control-custom" required>
                            </div>
                            
                            <div class="mb-4 max-width-500">
                                <label for="confirmPassword" class="form-label small fw-semibold text-muted">Confirm New Password</label>
                                <input type="password" name="confirmPassword" id="confirmPassword" class="form-control form-control-custom" required>
                            </div>
                            
                            <button type="submit" class="btn btn-primary-custom px-4 py-2">Update Password</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Add Address Modal -->
<div class="modal fade" id="addAddressModal" tabindex="-1" aria-labelledby="addAddressModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg" style="border-radius: var(--border-radius);">
            <div class="modal-header border-bottom pb-3">
                <h5 class="modal-title fw-bold" id="addAddressModalLabel">Add Delivery Destination</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            
            <form action="${pageContext.request.contextPath}/customer/profile" method="post">
                <input type="hidden" name="action" value="addAddress">
                
                <div class="modal-body py-4">
                    <div class="mb-3">
                        <label for="addressLine1" class="form-label small fw-semibold text-muted">Flat/House Number, Building Name</label>
                        <input type="text" name="addressLine1" id="addressLine1" class="form-control form-control-custom" required>
                    </div>
                    <div class="mb-3">
                        <label for="addressLine2" class="form-label small fw-semibold text-muted">Street Name, Locality (Optional)</label>
                        <input type="text" name="addressLine2" id="addressLine2" class="form-control form-control-custom">
                    </div>
                    <div class="row g-2 mb-3">
                        <div class="col-md-6">
                            <label for="city" class="form-label small fw-semibold text-muted">City</label>
                            <input type="text" name="city" id="city" class="form-control form-control-custom" required>
                        </div>
                        <div class="col-md-6">
                            <label for="state" class="form-label small fw-semibold text-muted">State</label>
                            <input type="text" name="state" id="state" class="form-control form-control-custom" required>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="postalCode" class="form-label small fw-semibold text-muted">PIN/Postal Code</label>
                        <input type="text" name="postalCode" id="postalCode" class="form-control form-control-custom" required>
                    </div>
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" name="isDefault" id="isDefault" value="true">
                        <label class="form-check-label small" for="isDefault">Set as my default delivery address</label>
                    </div>
                </div>
                
                <div class="modal-footer border-top pt-3">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary-custom px-4">Add Address</button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />
