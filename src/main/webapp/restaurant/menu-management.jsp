<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="pageTitle" value="Store Menu Management | Foodify" scope="request" />
<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<div class="container main-content">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="fw-bold mb-1">Menu Management</h3>
            <p class="text-muted mb-0">Control menu categories, edit dishes, adjust pricing, and toggle item availability.</p>
        </div>
        <div class="d-flex gap-2">
            <button class="btn btn-outline-primary-custom btn-sm" data-bs-toggle="modal" data-bs-target="#addCategoryModal">
                <i class="fa-solid fa-folder-plus me-1"></i> Add Category
            </button>
            <button class="btn btn-primary-custom btn-sm" data-bs-toggle="modal" data-bs-target="#addFoodModal" ${empty categories ? 'disabled' : ''}>
                <i class="fa-solid fa-plus me-1"></i> Add Food Item
            </button>
        </div>
    </div>

    <!-- Feedback messages -->
    <c:if test="${not empty param.successMsg}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="fa-solid fa-circle-check me-2"></i> ${param.successMsg}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>
    <c:if test="${not empty param.errorMsg}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="fa-solid fa-triangle-exclamation me-2"></i> ${param.errorMsg}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <div class="row">
        <!-- 1. Categories Sidebar -->
        <div class="col-lg-4 mb-4">
            <div class="card border-0 shadow-sm p-4" style="border-radius: var(--border-radius); background: white;">
                <h5 class="fw-bold mb-3"><i class="fa-regular fa-folder text-primary-custom me-2"></i>Categories</h5>
                
                <c:choose>
                    <c:when test="${not empty categories}">
                        <div class="list-group list-group-flush">
                            <c:forEach var="cat" items="${categories}">
                                <div class="list-group-item d-flex justify-content-between align-items-center px-0 py-3">
                                    <div>
                                        <h6 class="fw-bold mb-1 text-dark">${cat.name}</h6>
                                        <p class="mb-0 text-muted small text-truncate" style="max-width: 200px;">${cat.description}</p>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/restaurant/menu?action=deleteCategory&id=${cat.id}" class="text-danger p-1" onclick="return confirm('Deleting this category will delete all food items linked to it. Continue?')" title="Delete Category">
                                        <i class="fa-regular fa-trash-can fs-6"></i>
                                    </a>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <p class="text-muted small py-3 mb-0 text-center">No categories created yet. Click "Add Category" to start.</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- 2. Food Items List -->
        <div class="col-lg-8">
            <div class="card border-0 shadow-sm p-4" style="border-radius: var(--border-radius); background: white;">
                <h5 class="fw-bold mb-4"><i class="fa-solid fa-utensils text-primary-custom me-2"></i>Dishes & Menu Items</h5>

                <c:choose>
                    <c:when test="${not empty foodItems}">
                        <div class="table-responsive">
                            <table class="table align-middle">
                                <thead>
                                    <tr class="text-muted small uppercase">
                                        <th scope="col" style="width: 70px;">Dish</th>
                                        <th scope="col">Name</th>
                                        <th scope="col" class="text-end">Price</th>
                                        <th scope="col" class="text-center" style="width: 100px;">Type</th>
                                        <th scope="col" class="text-center" style="width: 110px;">Available</th>
                                        <th scope="col" class="text-center" style="width: 100px;">Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="item" items="${foodItems}">
                                        <tr>
                                            <td>
                                                <img src="${not empty item.imagePath ? item.imagePath : 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&q=80&w=100'}" alt="${item.name}" class="rounded-3 img-fluid" style="width: 50px; height: 50px; object-fit: cover;">
                                            </td>
                                            <td>
                                                <h6 class="fw-bold mb-1 text-dark">${item.name}</h6>
                                                <span class="text-muted small">${item.description}</span>
                                            </td>
                                            <td class="text-end fw-bold text-dark">&#8377;${item.price}</td>
                                            <td class="text-center">
                                                <c:choose>
                                                    <c:when test="${item.isVeg()}">
                                                        <span class="badge-veg font-size-xxs">Veg</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge-nonveg font-size-xxs">Non-Veg</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-center">
                                                <a href="${pageContext.request.contextPath}/restaurant/menu?action=toggleAvailability&id=${item.id}&available=${!item.isAvailable()}" class="btn btn-sm ${item.isAvailable() ? 'btn-success' : 'btn-outline-secondary'} py-0.5 px-2 small.5" title="Toggle Availability">
                                                    ${item.isAvailable() ? 'Active' : 'Sold Out'}
                                                </a>
                                            </td>
                                            <td class="text-center">
                                                <div class="d-flex justify-content-center gap-2">
                                                    <!-- Edit modal trigger -->
                                                    <button class="btn btn-light btn-sm text-primary border py-0.5 px-2" data-bs-toggle="modal" data-bs-target="#editModal_${item.id}" title="Edit Item">
                                                        <i class="fa-regular fa-edit"></i>
                                                    </button>
                                                    <a href="${pageContext.request.contextPath}/restaurant/menu?action=deleteFood&id=${item.id}" class="btn btn-light btn-sm text-danger border py-0.5 px-2" onclick="return confirm('Delete this food item?')" title="Delete Item">
                                                        <i class="fa-regular fa-trash-can"></i>
                                                    </a>
                                                </div>
                                            </td>
                                        </tr>

                                        <!-- Edit Food Modal -->
                                        <div class="modal fade" id="editModal_${item.id}" tabindex="-1" aria-hidden="true">
                                            <div class="modal-dialog">
                                                <div class="modal-content">
                                                    <div class="modal-header">
                                                        <h5 class="modal-title fw-bold">Edit Food Item</h5>
                                                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                    </div>
                                                    <form action="${pageContext.request.contextPath}/restaurant/menu" method="post">
                                                        <input type="hidden" name="action" value="editFood">
                                                        <input type="hidden" name="id" value="${item.id}">
                                                        
                                                        <div class="modal-body">
                                                            <div class="mb-3">
                                                                <label class="form-label small">Category</label>
                                                                <select name="categoryId" class="form-select form-control-custom form-control-sm" required>
                                                                    <c:forEach var="c" items="${categories}">
                                                                        <option value="${c.id}" ${c.id == item.categoryId ? 'selected' : ''}>${c.name}</option>
                                                                    </c:forEach>
                                                                </select>
                                                            </div>
                                                            <div class="mb-3">
                                                                <label class="form-label small">Dish Name</label>
                                                                <input type="text" name="foodName" value="${item.name}" class="form-control form-control-custom form-control-sm" required>
                                                            </div>
                                                            <div class="mb-3">
                                                                <label class="form-label small">Description</label>
                                                                <textarea name="foodDescription" class="form-control form-control-custom form-control-sm" rows="2" required>${item.description}</textarea>
                                                            </div>
                                                            <div class="row">
                                                                <div class="col-md-6 mb-3">
                                                                    <label class="form-label small">Price (INR)</label>
                                                                    <input type="number" step="0.01" name="foodPrice" value="${item.price}" class="form-control form-control-custom form-control-sm" required>
                                                                </div>
                                                                <div class="col-md-6 mb-3">
                                                                    <label class="form-label small">Diet Type</label>
                                                                    <select name="isVeg" class="form-select form-control-custom form-control-sm">
                                                                        <option value="true" ${item.isVeg() ? 'selected' : ''}>Vegetarian</option>
                                                                        <option value="false" ${!item.isVeg() ? 'selected' : ''}>Non-Vegetarian</option>
                                                                    </select>
                                                                </div>
                                                            </div>
                                                            <div class="mb-3">
                                                                <label class="form-label small">Availability Status</label>
                                                                <select name="isAvailable" class="form-select form-control-custom form-control-sm">
                                                                    <option value="true" ${item.isAvailable() ? 'selected' : ''}>In Stock</option>
                                                                    <option value="false" ${!item.isAvailable() ? 'selected' : ''}>Out of Stock (Sold Out)</option>
                                                                </select>
                                                            </div>
                                                            <div class="mb-3">
                                                                <label class="form-label small">Image URL / Path</label>
                                                                <input type="text" name="imagePath" value="${item.imagePath}" class="form-control form-control-custom form-control-sm">
                                                            </div>
                                                        </div>
                                                        <div class="modal-footer">
                                                            <button type="button" class="btn btn-outline-secondary btn-sm" data-bs-dismiss="modal">Cancel</button>
                                                            <button type="submit" class="btn btn-primary-custom btn-sm">Save Changes</button>
                                                        </div>
                                                    </form>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <p class="text-muted py-4 mb-0 text-center small">No food items created yet. Click "Add Food Item" to add some dishes.</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<!-- Modal 1: Add Category -->
<div class="modal fade" id="addCategoryModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold">Add Menu Category</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="${pageContext.request.contextPath}/restaurant/menu" method="post">
                <input type="hidden" name="action" value="addCategory">
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="categoryName" class="form-label small">Category Name</label>
                        <input type="text" class="form-control form-control-custom form-control-sm" id="categoryName" name="categoryName" required placeholder="e.g. Desserts, Classic Pizzas">
                    </div>
                    <div class="mb-3">
                        <label for="categoryDescription" class="form-label small">Category Description</label>
                        <textarea class="form-control form-control-custom form-control-sm" id="categoryDescription" name="categoryDescription" rows="2" placeholder="Brief description..."></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary btn-sm" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary-custom btn-sm">Create Category</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modal 2: Add Food Item -->
<div class="modal fade" id="addFoodModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold">Add Menu Dish</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="${pageContext.request.contextPath}/restaurant/menu" method="post">
                <input type="hidden" name="action" value="addFood">
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="categoryId" class="form-label small">Choose Category</label>
                        <select class="form-select form-control-custom form-control-sm" id="categoryId" name="categoryId" required>
                            <c:forEach var="c" items="${categories}">
                                <option value="${c.id}">${c.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="foodName" class="form-label small">Dish Name</label>
                        <input type="text" class="form-control form-control-custom form-control-sm" id="foodName" name="foodName" required placeholder="e.g. Paneer Butter Masala">
                    </div>
                    <div class="mb-3">
                        <label for="foodDescription" class="form-label small">Description</label>
                        <textarea class="form-control form-control-custom form-control-sm" id="foodDescription" name="foodDescription" rows="2" required placeholder="Describe ingredients, portion size..."></textarea>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="foodPrice" class="form-label small">Price (INR)</label>
                            <input type="number" step="0.01" class="form-control form-control-custom form-control-sm" id="foodPrice" name="foodPrice" required placeholder="299.00">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="isVeg" class="form-label small">Diet Type</label>
                            <select class="form-select form-control-custom form-control-sm" id="isVeg" name="isVeg">
                                <option value="true">Vegetarian</option>
                                <option value="false">Non-Vegetarian</option>
                            </select>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="imagePath" class="form-label small">Image URL / Path</label>
                        <input type="text" class="form-control form-control-custom form-control-sm" id="imagePath" name="imagePath" placeholder="e.g. /images/food/dish.jpg">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary btn-sm" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary-custom btn-sm">Add Item</button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />
