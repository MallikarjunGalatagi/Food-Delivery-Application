<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="pageTitle" value="Error | Foodify" scope="request" />
<jsp:include page="header.jsp" />
<jsp:include page="navbar.jsp" />

<div class="container main-content text-center py-5">
    <div class="mb-4 text-danger"><i class="fa-solid fa-triangle-exclamation display-1"></i></div>
    <h3 class="fw-bold">Something Went Wrong</h3>
    <p class="text-muted max-width-500 mx-auto mt-2">The page you are looking for might have been moved, deleted, or is temporarily unavailable. If you hit a server issue, please try again.</p>
    <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-primary-custom px-4 py-2.5 mt-3">
        Back to Home
    </a>
</div>

<jsp:include page="footer.jsp" />
