<%@ page contentType="text/plain; charset=UTF-8" %>
<%@ page import="com.libman.dao.DocumentDAO7" %>
<%@ page import="com.libman.model.Document7" %>
<%@ page import="java.sql.SQLException" %>
<%
request.setCharacterEncoding("UTF-8");
String qr = request.getParameter("qr");
if (qr == null || qr.isBlank()) {
    response.setStatus(400);
    out.print("General QR không được để trống");
} else {
    try {
        Document7 document = new DocumentDAO7().getDocument7(qr.trim());
        out.print(document.name());
    } catch (IllegalArgumentException exception) {
        response.setStatus(404);
        out.print("Không tìm thấy tài liệu");
    } catch (SQLException exception) {
        response.setStatus(500);
        out.print("Không thể tra cứu tài liệu");
    }
}
%>
