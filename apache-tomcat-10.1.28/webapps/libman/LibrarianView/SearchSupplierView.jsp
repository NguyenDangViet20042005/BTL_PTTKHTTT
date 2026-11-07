<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="com.libman.dao.SupplierDAO7" %>
<%@ page import="com.libman.model.Supplier7" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.util.List" %>
<%
request.setCharacterEncoding("UTF-8");
String keyword = request.getParameter("keyword");
List<Supplier7> suppliers = List.of();
String supplierError = null;
try {
    suppliers = new SupplierDAO7().getSupplier7(keyword);
} catch (SQLException exception) {
    supplierError = exception.getMessage();
}
%>
<!doctype html>
<html lang="vi">
<head><meta charset="UTF-8"><title>SearchSupplierView.jsp7</title><link rel="stylesheet" href="../style.css"></head>
<body><main class="page-shell">
<h1 class="screen-title">Tìm kiếm nhà cung cấp</h1>
<nav><a href="LibrarianView.jsp">Quay lại trang thủ thư</a></nav>
<form method="get"><input name="keyword" placeholder="Tên nhà cung cấp" value="<%= keyword == null ? "" : keyword %>"><button type="submit">Tìm kiếm</button></form>
<p>DAO tương ứng: <strong>SupplierDAO7.getSupplier7()</strong>.</p>
<table><thead><tr><th>Mã</th><th>Tên</th><th>Địa chỉ</th><th>Chọn</th></tr></thead>
<tbody>
<% if (supplierError != null) { %>
<tr><td colspan="4">Không thể đọc cơ sở dữ liệu: <%= supplierError %></td></tr>
<% } else if (suppliers.isEmpty()) { %>
<tr><td colspan="4">Không tìm thấy nhà cung cấp phù hợp.</td></tr>
<% } else { for (Supplier7 supplier : suppliers) { %>
<tr><td><%= supplier.id() %></td><td><%= supplier.name() %></td><td><%= supplier.address() %></td>
<td><a href="ImportDocumentView.jsp?supplierId=<%= supplier.id() %>">Chọn</a></td></tr>
<% } } %>
</tbody></table>
</main>
</body></html>
