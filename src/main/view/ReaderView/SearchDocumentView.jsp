<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.libman.db.Database7" %>
<!doctype html>
<html lang="vi">
<head><meta charset="UTF-8"><title>SearchDocumentView.jsp7</title><link rel="stylesheet" href="../style.css"></head>
<body><main class="page-shell">
<h1 class="screen-title">Tìm kiếm tài liệu</h1>
<nav><a href="ReaderView.jsp">ReaderView</a></nav>
<form method="get" action="SearchDocumentView.jsp">
    <input name="keyword" placeholder="Tên hoặc mã tài liệu" value="<%= request.getParameter("keyword") == null ? "" : request.getParameter("keyword") %>">
    <button type="submit">Tìm kiếm</button>
</form>
<p>DAO tương ứng: <strong>DocumentDAO7.getDocument7()</strong>.</p>
<table><thead><tr><th>Mã tài liệu</th><th>Tên tài liệu</th><th>Tác giả</th><th>Chi tiết</th></tr></thead><tbody>
<%
String keyword = request.getParameter("keyword");
String search = keyword == null ? "" : keyword.trim();
String sql = "SELECT document_code, name, author FROM document7 " +
        "WHERE name LIKE ? OR document_code LIKE ? ORDER BY name";
Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
try (Connection connection = Database7.open();
     PreparedStatement statement = connection.prepareStatement(sql)) {
    String pattern = "%" + search + "%";
    statement.setString(1, pattern);
    statement.setString(2, pattern);
    try (ResultSet result = statement.executeQuery()) {
        boolean found = false;
        while (result.next()) {
            found = true;
%>
<tr><td><%= result.getString("document_code") %></td>
<td><%= result.getString("name") %></td>
<td><%= result.getString("author") %></td>
<td><a href="DetailDocumentView.jsp?code=<%= result.getString("document_code") %>">Xem</a></td></tr>
<%
        }
        if (!found) {
%>
<tr><td colspan="4">Không tìm thấy tài liệu phù hợp.</td></tr>
<%
        }
    }
} catch (SQLException exception) {
%>
<tr><td colspan="4">Không thể đọc cơ sở dữ liệu: <%= exception.getMessage() %></td></tr>
<%
}
%>
</tbody></table>
</main>
</body>
</html>
