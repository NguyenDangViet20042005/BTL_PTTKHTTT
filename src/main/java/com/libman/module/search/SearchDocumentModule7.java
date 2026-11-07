package com.libman.module.search;

import com.libman.dao.DocumentDAO7;
import com.libman.dao.SupplierDAO7;
import com.libman.model.Document7;
import com.libman.model.Supplier7;
import java.sql.SQLException;
import java.util.List;

public class SearchDocumentModule7 {
    private final DocumentDAO7 documentDAO;
    private final SupplierDAO7 supplierDAO;

    public SearchDocumentModule7(DocumentDAO7 documentDAO, SupplierDAO7 supplierDAO) {
        this.documentDAO = documentDAO;
        this.supplierDAO = supplierDAO;
    }

    public List<Document7> searchDocument(String keyword) throws SQLException {
        return documentDAO.getDocument7(keyword, true);
    }

    public Document7 getDocumentDetail(String code) throws SQLException {
        return documentDAO.getDocument7(code);
    }

    public List<Supplier7> getSuppliers(Document7 document) {
        try {
            return supplierDAO.getSupplier7(document);
        } catch (SQLException exception) {
            throw new IllegalStateException("Không thể lấy nhà cung cấp của tài liệu", exception);
        }
    }
}
