<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="pageTitle" value="Store Customer Reviews | Foodify" scope="request" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<div class="container main-content">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="fw-bold mb-1">Customer Reviews</h3>
            <p class="text-muted mb-0">Read what customers are saying about your food and services.</p>
        </div>
        <a href="${pageContext.request.contextPath}/restaurant/dashboard" class="btn btn-outline-secondary btn-sm py-1.5 px-3">
            <i class="fa-solid fa-arrow-left me-1"></i> Dashboard
        </a>
    </div>

    <!-- Reviews Grid -->
    <div class="row">
        <div class="col-lg-8">
            <c:choose>
                <c:when test="${not empty reviews}">
                    <div class="d-flex flex-column gap-3">
                        <c:forEach var="rev" items="${reviews}">
                            <div class="card border-0 shadow-sm p-4" style="border-radius: var(--border-radius); background: white;">
                                <div class="d-flex justify-content-between align-items-start mb-3">
                                    <div>
                                        <h6 class="fw-bold mb-0 text-dark">${rev.customerName}</h6>
                                        <span class="text-muted small">${rev.createdAt}</span>
                                    </div>
                                    <!-- Render star icons -->
                                    <div class="text-warning">
                                        <c:forEach var="i" begin="1" end="5">
                                            <c:choose>
                                                <c:when test="${i <= rev.rating}">
                                                    <i class="fa-solid fa-star"></i>
                                                </c:when>
                                                <c:otherwise>
                                                    <i class="fa-regular fa-star"></i>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:forEach>
                                    </div>
                                </div>
                                <p class="mb-0 text-muted small">${rev.reviewText}</p>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="card border-0 shadow-sm p-5 text-center" style="border-radius: var(--border-radius); background: white;">
                        <div class="text-muted mb-3"><i class="fa-regular fa-comments display-4 text-light"></i></div>
                        <h5 class="fw-bold">No Reviews Yet</h5>
                        <p class="text-muted mb-0">Your store doesn't have any reviews or ratings from customers yet.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />
