package com.libman.dao;

import com.libman.model.ImportInvoice7;
import java.sql.SQLException;

public class ImportInvoiceDAO7 extends DAO7 {
    public void saveDocument7(ImportInvoice7 invoice) throws SQLException {
        try (var connection = getConnection7()) {
            connection.setAutoCommit(false);
            try (var header = connection.prepareStatement(
                    "INSERT INTO ImportInvoice7(id,supplier_id,librarian_id,created_at,total) VALUES(?,?,?,?,?)");
                 var line = connection.prepareStatement(
                         "INSERT INTO ImportDocument7(id,invoice_id,document_code,quantity,unit_price) VALUES(?,?,?,?,?)")) {
                header.setString(1, invoice.id());
                header.setString(2, invoice.supplier().id());
                header.setString(3, invoice.librarian().id());
                header.setString(4, invoice.createdAt().toString());
                header.setBigDecimal(5, invoice.total());
                header.executeUpdate();
                for (var item : invoice.items()) {
                    line.setString(1, item.id());
                    line.setString(2, invoice.id());
                    line.setString(3, item.document().documentCode());
                    line.setInt(4, item.quantity());
                    line.setBigDecimal(5, item.unitPrice());
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
