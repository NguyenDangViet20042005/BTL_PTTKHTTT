package com.libman.dao;

import com.libman.model.ImportInvoice7;
import java.sql.SQLException;

public class ImportInvoiceDAO7 extends DAO7 {
    public void saveDocument7(ImportInvoice7 invoice) throws SQLException {
        try (var connection = getConnection7()) {
            connection.setAutoCommit(false);
            try (var header = connection.prepareStatement(
                    "INSERT INTO ImportInvoice7(id,supplier_id,librarian_name,created_at,total) VALUES(?,?,?,?,?)");
                 var line = connection.prepareStatement(
                         "INSERT INTO ImportDocument7(invoice_id,document_code,quantity,unit_price) VALUES(?,?,?,?)")) {
                header.setString(1, invoice.id());
                header.setString(2, invoice.supplier().id());
                header.setString(3, invoice.librarianName());
                header.setString(4, invoice.createdAt().toString());
                header.setBigDecimal(5, invoice.total());
                header.executeUpdate();
                for (var item : invoice.items()) {
                    line.setString(1, invoice.id());
                    line.setString(2, item.document().documentCode());
                    line.setInt(3, item.quantity());
                    line.setBigDecimal(4, item.unitPrice());
                    line.executeUpdate();
                }
                connection.commit();
            } catch (SQLException exception) {
                connection.rollback();
                throw exception;
            }
        }
    }
}
