package com.libman.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

public record ImportInvoice7(
        String id,
        Supplier7 supplier,
        String librarianName,
        LocalDateTime createdAt,
        List<ImportDocument7> items) {

    public ImportInvoice7 {
        items = items == null ? List.of() : List.copyOf(items);
        if (items.isEmpty()) {
            throw new IllegalArgumentException("Hóa đơn phải có ít nhất một tài liệu");
        }
    }

    public BigDecimal total() {
        return items.stream().map(ImportDocument7::amount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }
}
