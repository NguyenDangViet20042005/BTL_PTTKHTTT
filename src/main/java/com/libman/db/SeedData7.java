package com.libman.db;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public final class SeedData7 {
    private SeedData7() {
    }

    public static void seed() throws SQLException {
        try (Connection connection = Database7.open()) {
            boolean hasDocuments;
            try (PreparedStatement count = connection.prepareStatement("SELECT COUNT(*) FROM document7");
                 var result = count.executeQuery()) {
                hasDocuments = result.next() && result.getInt(1) > 0;
            }
            if (!hasDocuments) {
                seedBaseData(connection);
            }
            seedSupportingData(connection);
        }
    }

    private static void seedBaseData(Connection connection) throws SQLException {
        connection.setAutoCommit(false);
        try (PreparedStatement supplier = connection.prepareStatement(
                "INSERT INTO supplier7(id,name,address,phone) VALUES(?,?,?,?)");
             PreparedStatement document = connection.prepareStatement(
                     "INSERT INTO document7(id,general_qr,document_code,name,quantity,type,author,publication_year,unit_price,supplier_id) VALUES(?,?,?,?,?,?,?,?,?,?)")) {
            String[][] suppliers = {
                    {"BK1", "Bách Khoa Manga", "8D Hà Đông, Hà Nội", "0123456789"},
                    {"NXB1", "Nhà xuất bản Kim Đồng", "55 Quang Trung, Hà Nội", "0987654321"},
                    {"NXB2", "Nhà xuất bản Trẻ", "161B Lý Chính Thắng, Thành phố Hồ Chí Minh", "0901000002"},
                    {"NXB3", "Nhà xuất bản Phụ Nữ", "39 Hàng Chuối, Hà Nội", "0901000003"},
                    {"NXB4", "Nhà xuất bản Lao Động", "175 Giảng Võ, Hà Nội", "0901000004"},
                    {"NXB5", "Nhà xuất bản Văn Học", "18 Nguyễn Trường Tộ, Hà Nội", "0901000005"},
                    {"NXB6", "Nhà xuất bản Giáo Dục", "81 Trần Hưng Đạo, Hà Nội", "0901000006"},
                    {"NXB7", "Nhà xuất bản Thống Kê", "86 Nguyễn Thái Học, Hà Nội", "0901000007"},
                    {"NXB8", "Nhà xuất bản Tổng Hợp", "62 Nguyễn Thị Minh Khai, Thành phố Hồ Chí Minh", "0901000008"},
                    {"NXB9", "Nhà xuất bản Khoa Học", "18 Hoàng Quốc Việt, Hà Nội", "0901000009"},
                    {"NXB10", "Nhà xuất bản Á Châu", "25 Lê Đại Hành, Hà Nội", "0901000010"}
            };
            for (String[] value : suppliers) {
                for (int index = 0; index < value.length; index++) {
                    supplier.setString(index + 1, value[index]);
                }
                supplier.executeUpdate();
            }

            String[][] books = {
                    {"DR", "Doremon", "Fujiko F. Fujio", "2000", "BK1"},
                    {"DB", "DragonBall", "Akira Toriyama", "1984", "NXB1"},
                    {"NR", "Naruto", "Masashi Kishimoto", "1999", "NXB1"},
                    {"OP", "OnePiece", "Eiichiro Oda", "1997", "BK1"},
                    {"DC", "Detective Conan", "Gosho Aoyama", "1994", "NXB1"},
                    {"SL", "Slam Dunk", "Takehiko Inoue", "1990", "BK1"},
                    {"KN", "Kimetsu no Yaiba", "Koyoharu Gotouge", "2016", "NXB1"},
                    {"MHA", "My Hero Academia", "Kohei Horikoshi", "2014", "BK1"},
                    {"OPM", "One Punch Man", "ONE", "2009", "NXB1"},
                    {"SAO", "Sword Art Online", "Reki Kawahara", "2009", "BK1"},
                    {"HP", "Harry Potter", "J. K. Rowling", "1997", "NXB2"},
                    {"LOTR", "Chúa tể những chiếc nhẫn", "J. R. R. Tolkien", "1954", "NXB3"},
                    {"GK", "Kẻ trộm sách", "Markus Zusak", "2005", "NXB4"},
                    {"NT", "Nhà giả kim", "Paulo Coelho", "1988", "NXB5"},
                    {"DT", "Đắc nhân tâm", "Dale Carnegie", "1936", "NXB6"},
                    {"VN", "Truyện Việt Nam chọn lọc", "Nhiều tác giả", "2020", "NXB7"},
                    {"KH", "Khám phá khoa học", "Bill Bryson", "2018", "NXB8"},
                    {"LT", "Lập trình Java căn bản", "Nguyễn Văn A", "2023", "NXB9"},
                    {"CS", "Cấu trúc dữ liệu và giải thuật", "Nguyễn Văn B", "2022", "NXB9"},
                    {"KT", "Kinh tế học nhập môn", "Gregory Mankiw", "2021", "NXB10"}
            };
            int number = 1;
            for (String[] book : books) {
                for (int volume = 1; volume <= 3; volume++) {
                    String code = book[0] + volume;
                    document.setString(1, "DOC-" + code);
                    document.setString(2, "QR-" + code);
                    document.setString(3, code);
                    document.setString(4, book[1] + " tập " + volume);
                    document.setInt(5, 5 + volume);
                    document.setString(6, "Sách truyện");
                    document.setString(7, book[2]);
                    document.setInt(8, Integer.parseInt(book[3]));
                    document.setBigDecimal(9, BigDecimal.valueOf(10000L + number * 500L));
                    document.setString(10, book[4]);
                    document.executeUpdate();
                    number++;
                }
            }
            connection.commit();
        } catch (SQLException exception) {
            connection.rollback();
            throw exception;
        } finally {
            connection.setAutoCommit(true);
        }
    }

    private static void seedSupportingData(Connection connection) throws SQLException {
        try (var librarian = connection.prepareStatement("""
                IF NOT EXISTS (SELECT 1 FROM Librarian7 WHERE id = 'LIB1')
                    INSERT INTO Librarian7(id, role, username, password, name, phone, address, position)
                    VALUES ('LIB1', 'LIBRARIAN', 'librarian7', 'librarian7', N'Librarian7',
                            '0900000001', N'Địa chỉ thủ thư', N'Nhân viên thư viện')
                """)) {
            librarian.executeUpdate();
        }
        try (var provide = connection.prepareStatement("""
                INSERT INTO DocumentProvide7(id, document_code, supplier_id, supply_price)
                SELECT 'PROV-' + document_code + '-' + supplier_id, document_code, supplier_id, unit_price FROM Document7 d
                WHERE NOT EXISTS (SELECT 1 FROM DocumentProvide7 p
                                  WHERE p.document_code = d.document_code
                                  AND p.supplier_id = d.supplier_id)
                """)) {
            provide.executeUpdate();
        }
        try (var copies = connection.prepareStatement("""
                INSERT INTO DocumentCopy7(id, qr_code, document_code, status)
                SELECT 'COPY-' + d.document_code + '-' + RIGHT('00' + CAST(n.number AS VARCHAR(2)), 2),
                       'COPYQR-' + d.document_code + '-' + RIGHT('00' + CAST(n.number AS VARCHAR(2)), 2),
                       d.document_code, CASE WHEN n.number % 7 = 0 THEN 'BORROWED' ELSE 'AVAILABLE' END
                FROM Document7 d
                CROSS JOIN (SELECT TOP (20) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS number
                            FROM sys.all_objects) n
                WHERE n.number <= d.quantity
                  AND NOT EXISTS (
                      SELECT 1 FROM DocumentCopy7 c
                      WHERE c.document_code = d.document_code
                        AND c.qr_code = 'COPYQR-' + d.document_code + '-' + RIGHT('00' + CAST(n.number AS VARCHAR(2)), 2))
                """)) {
            copies.executeUpdate();
        }
        try (var invoice = connection.prepareStatement("""
                IF NOT EXISTS (SELECT 1 FROM ImportInvoice7 WHERE id = 'INV-SEED-APP')
                BEGIN
                    INSERT INTO ImportInvoice7(id, supplier_id, librarian_id, created_at, total)
                    SELECT 'INV-SEED-APP', d.supplier_id, 'LIB1', SYSDATETIME(), d.unit_price * 2
                    FROM Document7 d WHERE d.document_code = 'DR1';
                    INSERT INTO ImportDocument7(id, invoice_id, document_code, quantity, unit_price)
                    SELECT 'IMP-INV-SEED-APP-' + document_code, 'INV-SEED-APP', document_code, 2, unit_price
                    FROM Document7 WHERE document_code = 'DR1';
                END
                """)) {
            invoice.executeUpdate();
        }
    }
}
