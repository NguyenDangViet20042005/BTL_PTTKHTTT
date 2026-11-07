package com.libman.dao;

import com.libman.model.Supplier7;
import com.libman.model.Document7;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class SupplierDAO7 extends DAO7 {
    public List<Supplier7> getSupplier7() throws SQLException {
        return getSupplier7("");
    }

    public List<Supplier7> getSupplier7(Document7 document) throws SQLException {
        String query = """
                SELECT s.id, s.name, s.address, s.phone
                FROM DocumentProvide7 p
                JOIN Supplier7 s ON s.id = p.supplier_id
                WHERE p.document_code = ?
                ORDER BY s.name
                """;
        try (var connection = getConnection7();
             var statement = connection.prepareStatement(query)) {
            statement.setString(1, document.documentCode());
            try (var result = statement.executeQuery()) {
                List<Supplier7> suppliers = new ArrayList<>();
                while (result.next()) {
                    suppliers.add(new Supplier7(result.getString("id"), result.getString("name"),
                            result.getString("address"), result.getString("phone")));
                }
                return suppliers;
            }
        }
    }

    public List<Supplier7> getSupplier7(String keyword) throws SQLException {
        String query = keyword == null || keyword.isBlank()
                ? "SELECT id,name,address,phone FROM supplier7 ORDER BY name"
                : "SELECT id,name,address,phone FROM supplier7 WHERE name LIKE ? OR id LIKE ? ORDER BY name";
        try (var connection = getConnection7();
             var statement = connection.prepareStatement(query)) {
            if (query.contains("?")) {
                statement.setString(1, "%" + keyword.trim() + "%");
                statement.setString(2, "%" + keyword.trim() + "%");
            }
            try (var result = statement.executeQuery()) {
                List<Supplier7> suppliers = new ArrayList<>();
                while (result.next()) {
                    suppliers.add(new Supplier7(result.getString("id"), result.getString("name"),
                            result.getString("address"), result.getString("phone")));
                }
                return suppliers;
            }
        }
    }

}
