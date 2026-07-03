package controller.customer;

import dao.OrderDAO;
import dao.OrderDAOImpl;
import model.Customer;
import model.Order;
import model.OrderItem;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.lowagie.text.*;
import com.lowagie.text.pdf.*;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "OrderHistoryServlet", urlPatterns = {"/customer/orders"})
public class OrderHistoryServlet extends HttpServlet {
    private final OrderDAO orderDAO = new OrderDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Customer customer = (Customer) session.getAttribute("customer");
        if (customer == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "track":
                trackOrder(request, response, customer);
                break;
            case "cancel":
                cancelOrder(request, response, customer);
                break;
            case "invoice":
                generateInvoice(request, response, customer);
                break;
            case "list":
            default:
                listOrders(request, response, customer);
                break;
        }
    }

    private void listOrders(HttpServletRequest request, HttpServletResponse response, Customer customer) 
            throws ServletException, IOException {
        List<Order> orders = orderDAO.getOrdersByCustomerId(customer.getUserId());
        request.setAttribute("orders", orders);
        request.getRequestDispatcher("/customer/order-history.jsp").forward(request, response);
    }

    private void trackOrder(HttpServletRequest request, HttpServletResponse response, Customer customer) 
            throws ServletException, IOException {
        int orderId = Integer.parseInt(request.getParameter("id"));
        Order order = orderDAO.getOrderById(orderId);
        
        if (order == null || order.getCustomerId() != customer.getUserId()) {
            response.sendRedirect(request.getContextPath() + "/customer/orders");
            return;
        }

        request.setAttribute("order", order);
        request.getRequestDispatcher("/customer/track-order.jsp").forward(request, response);
    }

    private void cancelOrder(HttpServletRequest request, HttpServletResponse response, Customer customer) 
            throws IOException {
        int orderId = Integer.parseInt(request.getParameter("id"));
        Order order = orderDAO.getOrderById(orderId);

        if (order != null && order.getCustomerId() == customer.getUserId()) {
            if (order.isPendingAcceptance()) {
                boolean success = orderDAO.updateOrderStatus(orderId, "CANCELLED");
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/customer/orders?action=track&id=" + orderId + 
                        "&successMsg=Order cancelled successfully.");
                    return;
                }
            }
        }
        response.sendRedirect(request.getContextPath() + "/customer/orders?action=track&id=" + orderId + 
            "&errorMsg=Cannot cancel order. The kitchen has already started preparing your food.");
    }

    private void generateInvoice(HttpServletRequest request, HttpServletResponse response, Customer customer) 
            throws IOException {
        int orderId = Integer.parseInt(request.getParameter("id"));
        Order order = orderDAO.getOrderById(orderId);

        if (order == null || order.getCustomerId() != customer.getUserId()) {
            response.sendRedirect(request.getContextPath() + "/customer/orders");
            return;
        }

        // Set response parameters
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=Foodify_Invoice_#" + order.getId() + ".pdf");

        Document document = new Document(PageSize.A4, 36, 36, 36, 36);
        try {
            PdfWriter.getInstance(document, response.getOutputStream());
            document.open();

            // Fonts
            Font titleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 22, Font.BOLD, java.awt.Color.decode("#FF6B35"));
            Font headingFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 12, Font.BOLD, java.awt.Color.DARK_GRAY);
            Font bodyFont = FontFactory.getFont(FontFactory.HELVETICA, 10, Font.NORMAL, java.awt.Color.BLACK);
            Font headerTableFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10, Font.BOLD, java.awt.Color.WHITE);

            // Title Header
            Paragraph logo = new Paragraph("FOODIFY INVOICE", titleFont);
            logo.setAlignment(Element.ALIGN_CENTER);
            logo.setSpacingAfter(20);
            document.add(logo);

            // Metadata block (2 columns)
            PdfPTable metaTable = new PdfPTable(2);
            metaTable.setWidthPercentage(100);
            metaTable.setSpacingAfter(20);

            // Column 1: Order Details
            PdfPCell cell1 = new PdfPCell();
            cell1.setBorder(Rectangle.NO_BORDER);
            cell1.addElement(new Paragraph("Order ID: #" + order.getId(), bodyFont));
            cell1.addElement(new Paragraph("Date: " + order.getCreatedAt().toString(), bodyFont));
            cell1.addElement(new Paragraph("Payment Method: " + order.getPaymentMethod(), bodyFont));
            cell1.addElement(new Paragraph("Payment Status: " + order.getPaymentStatus(), bodyFont));
            metaTable.addCell(cell1);

            // Column 2: Restaurant & Customer info
            PdfPCell cell2 = new PdfPCell();
            cell2.setBorder(Rectangle.NO_BORDER);
            cell2.addElement(new Paragraph("Restaurant: " + order.getRestaurantName(), bodyFont));
            cell2.addElement(new Paragraph("Customer: " + order.getCustomerName(), bodyFont));
            if (order.getAddress() != null) {
                cell2.addElement(new Paragraph("Delivery Address:\n" + order.getAddress().getFormattedAddress(), bodyFont));
            }
            metaTable.addCell(cell2);
            
            document.add(metaTable);

            // Line separation
            Paragraph sep = new Paragraph("----------------------------------------------------------------------------------------------------------------------------------");
            sep.setSpacingAfter(10);
            document.add(sep);

            // Items Table
            PdfPTable table = new PdfPTable(4);
            table.setWidthPercentage(100);
            table.setSpacingBefore(10);
            table.setSpacingAfter(20);
            table.setWidths(new float[]{4f, 2f, 2f, 2f});

            // Table Headers
            String[] headers = {"Item Name", "Price (INR)", "Quantity", "Total (INR)"};
            for (String header : headers) {
                PdfPCell hCell = new PdfPCell(new Phrase(header, headerTableFont));
                hCell.setBackgroundColor(java.awt.Color.decode("#FF6B35"));
                hCell.setPadding(8);
                hCell.setHorizontalAlignment(Element.ALIGN_CENTER);
                table.addCell(hCell);
            }

            // Populate table rows
            for (OrderItem item : order.getItems()) {
                PdfPCell nameCell = new PdfPCell(new Phrase(item.getFoodName(), bodyFont));
                nameCell.setPadding(6);
                table.addCell(nameCell);

                PdfPCell priceCell = new PdfPCell(new Phrase(String.valueOf(item.getPrice()), bodyFont));
                priceCell.setHorizontalAlignment(Element.ALIGN_CENTER);
                priceCell.setPadding(6);
                table.addCell(priceCell);

                PdfPCell qtyCell = new PdfPCell(new Phrase(String.valueOf(item.getQuantity()), bodyFont));
                qtyCell.setHorizontalAlignment(Element.ALIGN_CENTER);
                qtyCell.setPadding(6);
                table.addCell(qtyCell);

                PdfPCell totalCell = new PdfPCell(new Phrase(String.valueOf(item.getSubtotal()), bodyFont));
                totalCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
                totalCell.setPadding(6);
                table.addCell(totalCell);
            }

            document.add(table);

            // Financial Summary Block
            PdfPTable financeTable = new PdfPTable(2);
            financeTable.setWidthPercentage(40);
            financeTable.setHorizontalAlignment(Element.ALIGN_RIGHT);
            financeTable.setSpacingAfter(30);

            financeTable.addCell(new PdfPCell(new Phrase("Subtotal:", bodyFont)));
            PdfPCell subCell = new PdfPCell(new Phrase(String.valueOf(order.getSubtotal()), bodyFont));
            subCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
            financeTable.addCell(subCell);

            financeTable.addCell(new PdfPCell(new Phrase("Delivery Charge:", bodyFont)));
            PdfPCell delCell = new PdfPCell(new Phrase(String.valueOf(order.getDeliveryCharge()), bodyFont));
            delCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
            financeTable.addCell(delCell);

            financeTable.addCell(new PdfPCell(new Phrase("Tax (GST 5%):", bodyFont)));
            PdfPCell taxCell = new PdfPCell(new Phrase(String.valueOf(order.getTax()), bodyFont));
            taxCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
            financeTable.addCell(taxCell);

            PdfPCell grandLblCell = new PdfPCell(new Phrase("Grand Total:", headingFont));
            grandLblCell.setBackgroundColor(java.awt.Color.LIGHT_GRAY);
            financeTable.addCell(grandLblCell);
            
            PdfPCell grandValCell = new PdfPCell(new Phrase(String.valueOf(order.getGrandTotal()), headingFont));
            grandValCell.setBackgroundColor(java.awt.Color.LIGHT_GRAY);
            grandValCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
            financeTable.addCell(grandValCell);

            document.add(financeTable);

            // Footer note
            Paragraph footer = new Paragraph("Thank you for ordering with Foodify!\nIf you have any questions about this invoice, contact support@foodify.com", bodyFont);
            footer.setAlignment(Element.ALIGN_CENTER);
            document.add(footer);

        } catch (DocumentException e) {
            e.printStackTrace();
        } finally {
            document.close();
        }
    }
}
