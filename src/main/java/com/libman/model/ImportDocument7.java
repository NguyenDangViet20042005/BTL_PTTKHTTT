package com.libman.model;

import java.math.BigDecimal;

public record ImportDocument7(Document7 document, int quantity, BigDecimal unitPrice) {
    public ImportDocument7 {
        if (quantity <= 0) {
            throw new IllegalArgumentException("Số lượng nhập phải lớn hơn 0");
        }
        if (unitPrice == null || unitPrice.signum() < 0) {
            throw new IllegalArgumentException("Đơn giá không hợp lệ");
        }
    }

    public BigDecimal amount() {
        return unitPrice.multiply(BigDecimal.valueOf(quantity));
    }
}
