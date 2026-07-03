<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="pageTitle" value="Contact Us | Foodify" scope="request" />
<jsp:include page="header.jsp" />
<jsp:include page="navbar.jsp" />

<div class="container main-content">
    <div class="text-center mb-5">
        <span class="badge bg-warning-subtle text-warning-emphasis px-3 py-2 rounded-pill font-weight-600 mb-3 fs-6">Contact Us</span>
        <h2 class="fw-bold text-dark">Get in Touch</h2>
        <p class="text-muted max-width-600 mx-auto">Have questions about listings, riding, or order support? Fill out the form below or contact our hotline directly.</p>
    </div>

    <!-- Feedback messages -->
    <c:if test="${not empty param.successMsg}">
        <div class="alert alert-success alert-dismissible fade show mb-4" role="alert">
            <i class="fa-solid fa-circle-check me-2"></i> ${param.successMsg}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <div class="row g-5">
        <!-- Contact details -->
        <div class="col-md-5">
            <div class="card border-0 shadow-sm p-4 h-100" style="border-radius: var(--border-radius); background: white;">
                <h5 class="fw-bold mb-4">Support Channels</h5>
                <div class="d-flex align-items-start gap-3 mb-4">
                    <div class="bg-primary-subtle text-primary-custom rounded-circle p-2.5 d-flex align-items-center justify-content-center" style="width: 44px; height: 44px;">
                        <i class="fa-solid fa-phone fs-5"></i>
                    </div>
                    <div>
                        <h6 class="fw-bold mb-1">Customer Support Hotline</h6>
                        <span class="text-muted small d-block">+1 (555) 123-4567</span>
                        <span class="text-muted small">Toll-Free, 24/7 Available</span>
                    </div>
                </div>

                <div class="d-flex align-items-start gap-3 mb-4">
                    <div class="bg-primary-subtle text-primary-custom rounded-circle p-2.5 d-flex align-items-center justify-content-center" style="width: 44px; height: 44px;">
                        <i class="fa-solid fa-envelope fs-5"></i>
                    </div>
                    <div>
                        <h6 class="fw-bold mb-1">Email Support Desk</h6>
                        <span class="text-muted small">support@foodify.com</span>
                    </div>
                </div>

                <div class="d-flex align-items-start gap-3">
                    <div class="bg-primary-subtle text-primary-custom rounded-circle p-2.5 d-flex align-items-center justify-content-center" style="width: 44px; height: 44px;">
                        <i class="fa-solid fa-map-location fs-5"></i>
                    </div>
                    <div>
                        <h6 class="fw-bold mb-1">HQ Corporate Office</h6>
                        <span class="text-muted small">100 Tech Tower, Suite 400, Mumbai, IN 400001</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Contact Form -->
        <div class="col-md-7">
            <div class="card border-0 shadow-sm p-4" style="border-radius: var(--border-radius); background: white;">
                <h5 class="fw-bold mb-4">Send a Message</h5>
                <form action="${pageContext.request.contextPath}/common/contact.jsp" method="get">
                    <input type="hidden" name="successMsg" value="Your message has been sent successfully. We will get back to you within 24 hours.">
                    
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="name" class="form-label small">Your Name</label>
                            <input type="text" class="form-control form-control-custom form-control-sm" id="name" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="email" class="form-label small">Email Address</label>
                            <input type="email" class="form-control form-control-custom form-control-sm" id="email" required placeholder="name@example.com">
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="subject" class="form-label small">Subject Topic</label>
                        <input type="text" class="form-control form-control-custom form-control-sm" id="subject" required>
                    </div>
                    <div class="mb-4">
                        <label for="message" class="form-label small">Detailed Message</label>
                        <textarea class="form-control form-control-custom form-control-sm" id="message" rows="4" required></textarea>
                    </div>
                    <button type="submit" class="btn btn-primary-custom px-4 py-2">Submit inquiry</button>
                </form>
            </div>
        </div>
    </div>
</div>

<jsp:include page="footer.jsp" />
