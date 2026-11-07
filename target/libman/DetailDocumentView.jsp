<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.libman.db.Database7" %>
<%@ page import="com.libman.dao.DocumentDAO7" %>
<%@ page import="com.libman.dao.SupplierDAO7" %>
<%@ page import="com.libman.model.Document7" %>
<%@ page import="com.libman.model.Supplier7" %>
<%@ page import="java.util.List" %>
<!doctype html>
<html lang="vi">
<head><meta charset="UTF-8"><title>DetailDocumentView.jsp7</title><link rel="stylesheet" href="style.css"></head>
<body><main class="page-shell">
<h1 class="screen-title">Chi tiết tài liệu</h1><nav><a href="SearchDocumentView.jsp">Quay lại tìm kiếm</a></nav>
<%
String code = request.getParameter("code");
if (code == null || code.isBlank()) {
    code = "DR1";
}
Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
try {
   Document7 document = new DocumentDAO7().getDocument7(code);
   List<Supplier7> suppliers = new SupplierDAO7().getSupplier7(document);
%>
<div class="card"><p>Mã tài liệu: <strong><%= document.documentCode() %></strong></p>
<p>Tên tài liệu: <%= document.name() %></p>
<p>Tác giả: <%= document.author() %></p>
<p>Năm xuất bản: <%= document.publicationYear() %></p>
<p>Nhà cung cấp:</p><ul>
<% for (Supplier7 supplier : suppliers) { %>
<li><%= supplier.name() %></li>
<%
}
%>
</ul></div>
<%
} catch (IllegalArgumentException exception) {
%>
<div class="card">Không tìm thấy tài liệu: <%= exception.getMessage() %></div>
<%
} catch (SQLException exception) {
%>
<div class="card">Không thể đọc cơ sở dữ liệu: <%= exception.getMessage() %></div>
<%
}
%>
</main>
</body>
</html>
