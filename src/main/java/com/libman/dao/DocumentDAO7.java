package com.libman.dao;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.libman.model.Document7;
import com.libman.model.Supplier7;

public class DocumentDAO7 extends DAO7 {
    public List<Document7> getDocument7() throws SQLException {
        return getDocument7("", true);
    }

    public List<Document7> getDocument7(String keyword, boolean search) throws SQLException {
        String sql = keyword == null || keyword.isBlank()
                ? "SELECT * FROM document7 ORDER BY name"
                : "SELECT d.* FROM Document7 d WHERE d.name LIKE ? OR d.document_code LIKE ? ORDER BY d.name";
        if (keyword == null || keyword.isBlank()) {
            sql = "SELECT d.* FROM Document7 d ORDER BY d.name";
        }
        try (var connection = getConnection7(); var statement = connection.prepareStatement(sql)) {
            if (sql.contains("?")) {
                statement.setString(1, "%" + keyword.trim() + "%");
                statement.setString(2, "%" + keyword.trim() + "%");
            }
            try (var result = statement.executeQuery()) {
                List<Document7> documents = new ArrayList<>();
                while (result.next()) {
                    documents.add(getDocument7(connection, result));
                }
                return documents;
            }
        }
    }

    public Document7 getDocument7(String codeOrQr) throws SQLException {
        try (var connection = getConnection7();
             var statement = connection.prepareStatement(
                     "SELECT * FROM document7 WHERE document_code = ? OR general_qr = ?")) {
            statement.setString(1, codeOrQr);
            statement.setString(2, codeOrQr);
            try (var result = statement.executeQuery()) {
                if (!result.next()) {
                    throw new IllegalArgumentException("Không tìm thấy tài liệu: " + codeOrQr);
                }
                return getDocument7(connection, result);
            }
        }
    }

    public void saveDocument7(Document7 document) throws SQLException {
        try (var connection = getConnection7();
             var statement = connection.prepareStatement(
                     "INSERT INTO document7(id,general_qr,document_code,name,quantity,type,author,publication_year,unit_price,supplier_id) VALUES(?,?,?,?,?,?,?,?,?,?)")) {
            statement.setString(1, document.id());
            statement.setString(2, document.generalQr());
            statement.setString(3, document.documentCode());
            statement.setString(4, document.name());
            statement.setInt(5, document.quantity());
            statement.setString(6, document.type());
            statement.setString(7, document.author());
            statement.setInt(8, document.publicationYear());
            statement.setBigDecimal(9, document.unitPrice());
            statement.setString(10, document.suppliers().stream()
                    .findFirst()
                    .map(Supplier7::id)
                    .orElseThrow(() -> new IllegalArgumentException("Tài liệu phải có nhà cung cấp")));
            statement.executeUpdate();
        }
    }

    public void saveDocument7(String documentCode, int quantity) throws SQLException {
        try (var connection = getConnection7();
             var statement = connection.prepareStatement(
                     "UPDATE document7 SET quantity = quantity + ? WHERE document_code = ?")) {
            statement.setInt(1, quantity);
            statement.setString(2, documentCode);
            if (statement.executeUpdate() != 1) {
                throw new IllegalArgumentException("Không thể cập nhật số lượng tài liệu: " + documentCode);
            }
        }
    }

    private Document7 getDocument7(java.sql.Connection connection, java.sql.ResultSet result)
            throws SQLException {
        var suppliers = new ArrayList<Supplier7>();
        try (var suppliersQuery = connection.prepareStatement("""
                SELECT s.id, s.name, s.address, s.phone
                FROM DocumentProvide7 dp
                JOIN Supplier7 s ON s.id = dp.supplier_id
                WHERE dp.document_code = ? ORDER BY s.name""")) {
            suppliersQuery.setString(1, result.getString("document_code"));
            try (var supplierResult = suppliersQuery.executeQuery()) {
                while (supplierResult.next()) {
                    suppliers.add(new Supplier7(supplierResult.getString("id"), supplierResult.getString("name"),
                            supplierResult.getString("address"), supplierResult.getString("phone")));
                }
            }
        }
        return new Document7(result.getString("id"), result.getString("general_qr"),
                result.getString("document_code"), result.getString("name"), result.getInt("quantity"),
                result.getString("type"), result.getString("author"), result.getInt("publication_year"),
                result.getBigDecimal("unit_price"), suppliers, List.of());
    }
}
