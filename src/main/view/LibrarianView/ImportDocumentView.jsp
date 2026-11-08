<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="com.libman.dao.SupplierDAO7" %>
<%@ page import="com.libman.model.Supplier7" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.util.List" %>
<%@ page import="com.libman.dao.DocumentDAO7" %>
<%@ page import="com.libman.model.Document7" %>
<%
request.setCharacterEncoding("UTF-8");
String lookupQr = request.getParameter("qr");
if (lookupQr != null) {
    response.setContentType("application/json; charset=UTF-8");
    if (lookupQr.isBlank()) {
        response.setStatus(400);
        out.print("{\"error\":\"General QR không được để trống\"}");
    } else {
        try {
            Document7 document = new DocumentDAO7().getDocument7(lookupQr.trim());
            String documentCode = document.documentCode().replace("\\", "\\\\").replace("\"", "\\\"");
            String documentName = document.name().replace("\\", "\\\\").replace("\"", "\\\"");
            out.print("{\"documentCode\":\"" + documentCode + "\",\"name\":\"" + documentName + "\"}");
        } catch (IllegalArgumentException exception) {
            response.setStatus(404);
            out.print("{\"error\":\"Không tìm thấy tài liệu\"}");
        } catch (SQLException exception) {
            response.setStatus(500);
            out.print("{\"error\":\"Không thể tra cứu tài liệu\"}");
        }
    }
    return;
}
String supplierId = request.getParameter("supplierId");
if (supplierId == null || supplierId.isBlank()) {
    supplierId = "BK1";
}
String selectedSupplierId = supplierId;
Supplier7 supplier = null;
String supplierError = null;
try {
    supplier = new SupplierDAO7().getSupplier7(selectedSupplierId).stream()
            .filter(value -> value.id().equals(selectedSupplierId))
            .findFirst().orElse(null);
} catch (SQLException exception) {
    supplierError = exception.getMessage();
}
%>
<!doctype html>
<html lang="vi">
<head><meta charset="UTF-8"><title>Nhập tài liệu</title><link rel="stylesheet" href="../style.css"></head>
<body>
<main class="page-shell">
    <h1 class="screen-title">Quét mã và điền đơn nhập:</h1>
    <p class="status-line">Trạng thái quét mã:
        <span id="scan-status" class="status-success">Chưa quét mã</span>
    </p>
    <p class="status-line">Không tìm thấy tài liệu:
        <a href="ImportDocumentView.jsp?supplierId=<%= supplierId %>">Thêm mới tài liệu</a>
    </p>
    <% if (supplierError != null) { %>
        <p class="error">Không thể đọc nhà cung cấp: <%= supplierError %></p>
    <% } else { %>
        <p class="supplier-heading">Nhà cung cấp:
            <strong><%= supplier == null ? supplierId : supplier.name() %></strong>
        </p>
        <form method="post" action="InvoiceView.jsp" id="import-form">
            <input type="hidden" name="supplierId" value="<%= supplierId %>">
            <div class="qr-entry">
                <label for="general-qr">General QR</label>
                <input id="general-qr" type="text" autocomplete="off" placeholder="Nhập General QR, ví dụ QR-DR1">
                <button type="button" id="add-document">Nhập mã</button>
            </div>
            <table>
                <thead>
                <tr><th>TT</th><th>Mã tài liệu</th><th>Tên tài liệu</th><th>Số lượng</th><th>Đơn giá</th></tr>
                </thead>
                <tbody id="document-rows"></tbody>
            </table>
            <div class="action-row">
                <button type="reset">Làm lại</button>
                <a href="SearchSupplierView.jsp">Quay lại</a>
                <button type="submit">Tạo hóa đơn</button>
            </div>
        </form>
    <% } %>
</main>
<script>
const qrInput = document.getElementById('general-qr');
const rows = document.getElementById('document-rows');
const importForm = document.getElementById('import-form');
const scanStatus = document.getElementById('scan-status');
const addButton = document.getElementById('add-document');
let rowNumber = 0;

async function addDocumentRow() {
    const qr = qrInput.value.trim();
    if (!qr) {
        qrInput.focus();
        return;
    }
    addButton.disabled = true;
    try {
        const response = await fetch('ImportDocumentView.jsp?qr=' + encodeURIComponent(qr));
        const document = await response.json();
        if (!response.ok) {
            scanStatus.textContent = 'Thất bại';
            scanStatus.className = 'status-failure';
            return;
        }
        scanStatus.textContent = 'Thành công!';
        scanStatus.className = 'status-success';
        appendDocumentRow(document.documentCode, document.name);
    } catch (error) {
        scanStatus.textContent = 'Thất bại';
        scanStatus.className = 'status-failure';
    } finally {
        addButton.disabled = false;
        qrInput.focus();
    }
}

function appendDocumentRow(documentCode, name) {
    rowNumber += 1;
    const row = document.createElement('tr');
    row.innerHTML =
        '<td>' + rowNumber + '</td>' +
        '<td><input type="hidden" name="qr" value="' + escapeHtml(documentCode) + '">' + escapeHtml(documentCode) + '</td>' +
        '<td>' + escapeHtml(name) + '</td>' +
        '<td><input type="number" name="quantity" min="1" value="1" required></td>' +
        '<td><input type="number" name="unitPrice" min="0" value="10000" required></td>';
    rows.appendChild(row);
    qrInput.value = '';
}

function escapeHtml(value) {
    return value.replace(/[&<>"']/g, character => ({
        '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#039;'
    }[character]));
}

importForm.addEventListener('reset', () => {
    rows.replaceChildren();
    rowNumber = 0;
    scanStatus.textContent = 'Chưa quét mã';
    scanStatus.className = 'status-success';
});

addButton.addEventListener('click', addDocumentRow);
qrInput.addEventListener('keydown', event => {
    if (event.key === 'Enter') {
        event.preventDefault();
        addDocumentRow();
    }
});
</script>
</body>
</html>
