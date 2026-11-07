package com.libman.module.importdocument;

import com.libman.dao.DocumentCopyDAO7;
import com.libman.dao.DocumentDAO7;
import com.libman.dao.DocumentProvideDAO7;
import com.libman.dao.ImportInvoiceDAO7;
import com.libman.dao.SupplierDAO7;
import com.libman.model.Document7;
import com.libman.model.ImportDocument7;
import com.libman.model.ImportInvoice7;
import com.libman.model.DocumentProvide7;
import com.libman.model.Supplier7;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

public class ImportDocumentModule7 {
    private final SupplierDAO7 supplierDAO;
    private final DocumentDAO7 documentDAO;
    private final DocumentCopyDAO7 documentCopyDAO;
    private final ImportInvoiceDAO7 invoiceDAO;
    private final DocumentProvideDAO7 documentProvideDAO;

    public ImportDocumentModule7(SupplierDAO7 supplierDAO, DocumentDAO7 documentDAO,
                                 DocumentCopyDAO7 documentCopyDAO, ImportInvoiceDAO7 invoiceDAO) {
        this.supplierDAO = supplierDAO;
        this.documentDAO = documentDAO;
        this.documentCopyDAO = documentCopyDAO;
        this.invoiceDAO = invoiceDAO;
        this.documentProvideDAO = new DocumentProvideDAO7();
    }

    public List<Supplier7> searchSupplier(String keyword) throws SQLException {
        return supplierDAO.getSupplier7(keyword);
    }

    public Document7 scanDocument(String codeOrQr) throws SQLException {
        return documentDAO.getDocument7(codeOrQr);
    }

    public void addNewDocument(Document7 document) throws SQLException {
        documentDAO.saveDocument7(document);
    }

    public ImportInvoice7 createInvoice(Supplier7 supplier, String librarianName,
                                        List<ImportDocument7> items) throws SQLException {
        ImportInvoice7 invoice = new ImportInvoice7("INV-" + UUID.randomUUID(), supplier,
                librarianName, LocalDateTime.now(), items);
        for (ImportDocument7 item : items) {
            Document7 document = item.document();
            documentProvideDAO.saveDocument7(
                    new DocumentProvide7(document.documentCode(), supplier.id(), item.unitPrice()));
            documentDAO.saveDocument7(document.documentCode(), item.quantity());
            for (int copy = 1; copy <= item.quantity(); copy++) {
                documentCopyDAO.saveDocumentCoppy7(new com.libman.model.DocumentCopy7(
                        UUID.randomUUID().toString(), document.documentCode() + "-" + UUID.randomUUID(),
                        document.documentCode(), "AVAILABLE"));
            }
        }
        invoiceDAO.saveDocument7(invoice);
        return invoice;
    }
}
