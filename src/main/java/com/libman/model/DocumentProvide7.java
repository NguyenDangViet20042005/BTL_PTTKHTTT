package com.libman.model;

import java.math.BigDecimal;

public record DocumentProvide7(
        String id,
        String documentCode,
        String supplierId,
        BigDecimal supplyPrice) {
}
