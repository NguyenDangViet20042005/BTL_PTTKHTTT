package com.libman.dao;

import com.libman.model.DocumentProvide7;
import java.sql.SQLException;

public class DocumentProvideDAO7 extends DAO7 {
    public void saveDocument7(DocumentProvide7 relation) throws SQLException {
        try (var connection = getConnection7();
             var statement = connection.prepareStatement("""
                     MERGE dbo.DocumentProvide7 AS target
                     USING (SELECT ? AS id, ? AS document_code, ? AS supplier_id, ? AS supply_price) AS source
                     ON target.document_code = source.document_code AND target.supplier_id = source.supplier_id
                     WHEN MATCHED THEN UPDATE SET supply_price = source.supply_price
                     WHEN NOT MATCHED THEN INSERT (id, document_code, supplier_id, supply_price)
                     VALUES (source.id, source.document_code, source.supplier_id, source.supply_price);
                     """)) {
            statement.setString(1, relation.id());
            statement.setString(2, relation.documentCode());
            statement.setString(3, relation.supplierId());
            statement.setBigDecimal(4, relation.supplyPrice());
            statement.executeUpdate();
        }
    }
}
