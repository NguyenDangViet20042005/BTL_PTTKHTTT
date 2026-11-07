package com.libman.model;

import java.math.BigDecimal;
import java.util.List;

public record Document7(
        String id,
        String generalQr,
        String documentCode,
        String name,
        int quantity,
        String type,
        String author,
        int publicationYear,
        BigDecimal unitPrice,
        List<Supplier7> suppliers,
        List<DocumentCopy7> documentCopies) {

    public Document7 {
        suppliers = suppliers == null ? List.of() : List.copyOf(suppliers);
        documentCopies = documentCopies == null ? List.of() : List.copyOf(documentCopies);
    }

    public Document7 withQuantity(int newQuantity) {
        return new Document7(id, generalQr, documentCode, name, newQuantity, type, author,
                publicationYear, unitPrice, suppliers, documentCopies);
    }
}
