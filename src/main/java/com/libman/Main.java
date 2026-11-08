package com.libman;

import com.libman.dao.*;
import com.libman.db.Database7;
import com.libman.db.SeedData7;
import com.libman.model.ImportDocument7;
import com.libman.model.Librarian7;
import com.libman.module.importdocument.ImportDocumentModule7;
import com.libman.module.search.SearchDocumentModule7;
import java.math.BigDecimal;
import java.util.List;

public class Main {
    public static void main(String[] args) throws Exception {
        Database7.initialize();
        SeedData7.seed();

        var documentDAO = new DocumentDAO7();
        var supplierDAO = new SupplierDAO7();
        var searchModule = new SearchDocumentModule7(documentDAO, supplierDAO);
        var results = searchModule.searchDocument("Doremon");
        System.out.println("Search Document 7 - kết quả: " + results.size());
        if (!results.isEmpty()) {
            System.out.println("Chi tiết: " + searchModule.getDocumentDetail(results.get(0).documentCode()));
            System.out.println("Nhà cung cấp: " + searchModule.getSuppliers(results.get(0)).stream()
                    .map(com.libman.model.Supplier7::name).toList());
        }

        var importModule = new ImportDocumentModule7(supplierDAO, documentDAO,
                new DocumentCopyDAO7(), new ImportInvoiceDAO7());
        var supplier = importModule.searchSupplier("BK1").get(0);
        var scanned = importModule.scanDocument("DR1");
        var invoice = importModule.createInvoice(supplier,
                new Librarian7("LIB1", "LIBRARIAN", "librarian7", "librarian7",
                        "Librarian7", "0900000001", "Địa chỉ thủ thư", "Nhân viên thư viện"),
                List.of(new ImportDocument7(scanned, 2, BigDecimal.valueOf(10000))));
        System.out.println("Import Document 7 - hóa đơn: " + invoice.id() + ", tổng tiền: " + invoice.total());
    }
}
