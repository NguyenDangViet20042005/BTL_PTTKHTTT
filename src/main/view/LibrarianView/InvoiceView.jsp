<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="com.libman.dao.DocumentCopyDAO7" %>
<%@ page import="com.libman.dao.DocumentDAO7" %>
<%@ page import="com.libman.dao.ImportInvoiceDAO7" %>
<%@ page import="com.libman.dao.SupplierDAO7" %>
<%@ page import="com.libman.model.Document7" %>
<%@ page import="com.libman.model.ImportDocument7" %>
<%@ page import="com.libman.model.ImportInvoice7" %>
<%@ page import="com.libman.model.Supplier7" %>
<%@ page import="com.libman.module.importdocument.ImportDocumentModule7" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.util.List" %>
<%
request.setCharacterEncoding("UTF-8");
ImportInvoice7 invoice = null;
String error = null;
if ("POST".equalsIgnoreCase(request.getMethod())) {
    try {
        String supplierId = request.getParameter("supplierId");
        String[] codesOrQr = request.getParameterValues("qr");
        String[] quantities = request.getParameterValues("quantity");
        String[] unitPrices = request.getParameterValues("unitPrice");
        if (codesOrQr == null || quantities == null || unitPrices == null
                || codesOrQr.length == 0
                || codesOrQr.length != quantities.length
                || codesOrQr.length != unitPrices.length) {
            throw new IllegalArgumentException("Hãy nhập ít nhất một tài liệu.");
        }
        Supplier7 supplier = new SupplierDAO7().getSupplier7(supplierId).stream()
                .filter(value -> value.id().equals(supplierId))
                .findFirst()
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy nhà cung cấp: " + supplierId));
        ImportDocumentModule7 module = new ImportDocumentModule7(
                new SupplierDAO7(), new DocumentDAO7(), new DocumentCopyDAO7(), new ImportInvoiceDAO7());
        List<ImportDocument7> items = new java.util.ArrayList<>();
        for (int index = 0; index < codesOrQr.length; index++) {
            Document7 document = new DocumentDAO7().getDocument7(codesOrQr[index]);
            items.add(new ImportDocument7(document, Integer.parseInt(quantities[index]),
                    new BigDecimal(unitPrices[index])));
        }
        invoice = module.createInvoice(supplier, "Librarian7", items);
    } catch (NumberFormatException exception) {
        error = "Số lượng hoặc đơn giá không hợp lệ.";
    } catch (IllegalArgumentException | SQLException exception) {
        error = exception.getMessage();
    }
}
%>
<!doctype html>
<html lang="vi">
<head><meta charset="UTF-8"><title>InvoiceView.jsp7</title><link rel="stylesheet" href="../style.css"></head>
<body><main class="page-shell">
<h1 class="screen-title">Hóa đơn nhập</h1>
<% if (error != null) { %>
<div class="card"><p>Không thể tạo hóa đơn: <%= error %></p></div>
<% } else if (invoice != null) { %>
<div class="card"><p>Đã lưu hóa đơn: <strong><%= invoice.id() %></strong></p>
<p>Nhà cung cấp: <%= invoice.supplier().name() %></p>
<p>Mã tài liệu: <%= invoice.items().get(0).document().documentCode() %></p>
<p>Số lượng: <%= invoice.items().get(0).quantity() %></p>
<p>Đơn giá: <%= invoice.items().get(0).unitPrice() %> VND</p>
<p>Tổng tiền: <%= invoice.total() %> VND</p>
<button type="button" onclick="window.print()">In hóa đơn</button></div>
<% } else { %>
<div class="card"><p>Chưa có dữ liệu hóa đơn.</p></div>
<% } %>
</main>
</body>
</html>
