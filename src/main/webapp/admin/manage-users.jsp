<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="pageTitle" value="Manage Users | Foodify Admin" scope="request" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<div class="container main-content">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="fw-bold mb-1">User Account Management</h3>
            <p class="text-muted mb-0">List of all system accounts (customers and delivery riders) registered on the network.</p>
        </div>
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-outline-secondary btn-sm py-1.5 px-3">
            <i class="fa-solid fa-arrow-left me-1"></i> Dashboard
        </a>
    </div>

    <!-- Tab Selection -->
    <ul class="nav nav-pills mb-4 d-flex gap-2" id="userTabs" role="tablist">
        <li class="nav-item" role="presentation">
            <button class="nav-link active btn-sm" id="customers-tab" data-bs-toggle="pill" data-bs-target="#customers" type="button" role="tab" aria-controls="customers" aria-selected="true">
                <i class="fa-solid fa-user me-2"></i> Customers (${customersList.size()})
            </button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link btn-sm" id="riders-tab" data-bs-toggle="pill" data-bs-target="#riders" type="button" role="tab" aria-controls="riders" aria-selected="false">
                <i class="fa-solid fa-motorcycle me-2"></i> Delivery Partners (${partnersList.size()})
            </button>
        </li>
    </ul>

    <div class="tab-content" id="userTabsContent">
        <!-- 1. Customers Tab Panel -->
        <div class="tab-pane fade show active" id="customers" role="tabpanel" aria-labelledby="customers-tab">
            <div class="card border-0 shadow-sm p-4" style="border-radius: var(--border-radius); background: white;">
                <c:choose>
                    <c:when test="${not empty customersList}">
                        <div class="table-responsive">
                            <table class="table align-middle">
                                <thead>
                                    <tr class="text-muted small uppercase">
                                        <th scope="col" style="width: 80px;">User ID</th>
                                        <th scope="col">Full Name</th>
                                        <th scope="col">Email Address</th>
                                        <th scope="col">Phone Number</th>
                                        <th scope="col" class="text-center" style="width: 130px;">Loyalty Points</th>
                                        <th scope="col" class="text-center">Joined Date</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="c" items="${customersList}">
                                        <tr>
                                            <td class="fw-bold">#${c.userId}</td>
                                            <td class="fw-bold text-dark">${c.user.getFullName()}</td>
                                            <td class="text-dark">${c.user.email}</td>
                                            <td class="text-muted small">${c.user.phone}</td>
                                            <td class="text-center fw-semibold text-primary-custom">${c.loyaltyPoints} pts</td>
                                            <td class="text-center small text-muted">${c.user.createdAt}</td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <p class="text-muted py-4 mb-0 text-center small">No customer accounts registered on the system.</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- 2. Riders Tab Panel -->
        <div class="tab-pane fade" id="riders" role="tabpanel" aria-labelledby="riders-tab">
            <div class="card border-0 shadow-sm p-4" style="border-radius: var(--border-radius); background: white;">
                <c:choose>
                    <c:when test="${not empty partnersList}">
                        <div class="table-responsive">
                            <table class="table align-middle">
                                <thead>
                                    <tr class="text-muted small uppercase">
                                        <th scope="col" style="width: 80px;">Rider ID</th>
                                        <th scope="col">Full Name</th>
                                        <th scope="col">Email Address</th>
                                        <th scope="col">Vehicle Details</th>
                                        <th scope="col">License ID</th>
                                        <th scope="col" class="text-center" style="width: 80px;">Rating</th>
                                        <th scope="col" class="text-end" style="width: 100px;">Earnings</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="dp" items="${partnersList}">
                                        <tr>
                                            <td class="fw-bold">#${dp.userId}</td>
                                            <td class="fw-bold text-dark">${dp.user.getFullName()}</td>
                                            <td class="text-dark">${dp.user.email}</td>
                                            <td>
                                                <span class="badge bg-light text-dark border small">${dp.vehicleNumber}</span>
                                            </td>
                                            <td class="text-muted small">${dp.licenseNumber}</td>
                                            <td class="text-center">
                                                <span class="badge bg-warning text-dark"><i class="fa-solid fa-star me-1"></i>${dp.rating}</span>
                                            </td>
                                            <td class="text-end fw-bold text-success">&#8377;${dp.earnings}</td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <p class="text-muted py-4 mb-0 text-center small">No delivery riders registered on the system.</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />
