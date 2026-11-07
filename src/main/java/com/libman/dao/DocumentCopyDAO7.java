package com.libman.dao;

import com.libman.model.DocumentCopy7;
import java.sql.SQLException;

public class DocumentCopyDAO7 extends DAO7 {
    public void saveDocumentCoppy7(DocumentCopy7 copy) throws SQLException {
        try (var connection = getConnection7();
             var statement = connection.prepareStatement(
                     "INSERT INTO DocumentCopy7(id,qr_code,document_code,status) VALUES(?,?,?,?)")) {
            statement.setString(1, copy.id());
            statement.setString(2, copy.qrCode());
            statement.setString(3, copy.documentCode());
            statement.setString(4, copy.status());
            statement.executeUpdate();
        }
    }
}
