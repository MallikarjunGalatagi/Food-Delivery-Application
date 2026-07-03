<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="pageTitle" value="Manage Restaurants | Foodify Admin" scope="request" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<div class="container main-content">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="fw-bold mb-1">Restaurant Management</h3>
            <p class="text-muted mb-0">List of all food partner outlets in the system with their status details.</p>
        </div>
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-outline-secondary btn-sm py-1.5 px-3">
            <i class="fa-solid fa-arrow-left me-1"></i> Dashboard
        </a>
    </div>

    <!-- Restaurants List Card -->
    <div class="card border-0 shadow-sm p-4" style="border-radius: var(--border-radius); background: white;">
        <c:choose>
            <c:when test="${not empty allRestaurants}">
                <div class="table-responsive">
                    <table class="table align-middle">
                        <thead>
                            <tr class="text-muted small uppercase">
                                <th scope="col" style="width: 80px;">Owner ID</th>
                                <th scope="col">Restaurant Name</th>
                                <th scope="col">Owner Info</th>
                                <th scope="col">Cuisine Type</th>
                                <th scope="col">Address</th>
                                <th scope="col" class="text-center" style="width: 80px;">Rating</th>
                                <th scope="col" class="text-center" style="width: 120px;">Approval Status</th>
                                <th scope="col" class="text-center" style="width: 150px;">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="rest" items="${allRestaurants}">
                                <tr>
                                    <td class="fw-bold">#${rest.userId}</td>
                                    <td class="fw-bold text-dark">${rest.restaurantName}</td>
                                    <td>
                                        <div class="small fw-semibold text-dark">${rest.user.getFullName()}</div>
                                        <span class="text-muted small">${rest.user.email}</span>
                                    </td>
                                    <td class="small text-muted">${rest.cuisineType}</td>
                                    <td class="small text-muted text-truncate" style="max-width: 200px;">${rest.address}</td>
                                    <td class="text-center">
                                        <span class="badge bg-warning text-dark"><i class="fa-solid fa-star me-1 text-warning-emphasis"></i>${rest.rating}</span>
                                    </td>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${rest.user.status == 'ACTIVE'}">
                                                <span class="badge bg-success-subtle text-success py-1.5 px-3">Approved</span>
                                            </c:when>
                                            <c:when test="${rest.user.status == 'PENDING_APPROVAL'}">
                                                <span class="badge bg-warning-subtle text-warning-emphasis py-1.5 px-3">Pending</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-danger-subtle text-danger py-1.5 px-3">${rest.user.status}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-center">
                                        <c:if test="${rest.user.status == 'PENDING_APPROVAL'}">
                                            <div class="d-flex gap-1 justify-content-center">
                                                <a href="${pageContext.request.contextPath}/admin/restaurants?action=approve&id=${rest.userId}" class="btn btn-success text-white btn-xs py-1 px-2">Approve</a>
                                                <a href="${pageContext.request.contextPath}/admin/restaurants?action=reject&id=${rest.userId}" class="btn btn-outline-danger btn-xs py-1 px-2" onclick="return confirm('Reject registration?')">Reject</a>
                                            </div>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:when>
            <c:otherwise>
                <p class="text-muted py-4 mb-0 text-center small">No restaurants registered on the platform yet.</p>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />
