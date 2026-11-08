IF DB_ID(N'LibMan') IS NULL
    CREATE DATABASE LibMan;
GO

USE LibMan;
GO

IF OBJECT_ID(N'dbo.Librarian7', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Librarian7 (
        id NVARCHAR(20) NOT NULL PRIMARY KEY,
        role NVARCHAR(50) NOT NULL,
        username NVARCHAR(100) NOT NULL UNIQUE,
        password NVARCHAR(255) NOT NULL,
        name NVARCHAR(150) NOT NULL,
        phone NVARCHAR(30) NOT NULL,
        address NVARCHAR(300) NOT NULL,
        position NVARCHAR(100) NOT NULL
    );
END;
GO

IF OBJECT_ID(N'dbo.ImportDocument7', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Supplier7 (
        id NVARCHAR(20) NOT NULL PRIMARY KEY,
        name NVARCHAR(200) NOT NULL,
        address NVARCHAR(300) NOT NULL,
        phone NVARCHAR(30) NOT NULL
    );

    CREATE TABLE dbo.Document7 (
        id NVARCHAR(30) NOT NULL PRIMARY KEY,
        general_qr NVARCHAR(100) NOT NULL UNIQUE,
        document_code NVARCHAR(30) NOT NULL UNIQUE,
        name NVARCHAR(200) NOT NULL,
        quantity INT NOT NULL DEFAULT 0,
        type NVARCHAR(100) NOT NULL,
        author NVARCHAR(200) NOT NULL,
        publication_year INT NOT NULL,
        unit_price DECIMAL(18, 2) NOT NULL,
        supplier_id NVARCHAR(20) NOT NULL
            CONSTRAINT FK_Document7_Supplier7 REFERENCES dbo.Supplier7(id)
    );

    CREATE TABLE dbo.DocumentCopy7 (
        id NVARCHAR(50) NOT NULL PRIMARY KEY,
        qr_code NVARCHAR(100) NOT NULL UNIQUE,
        document_code NVARCHAR(30) NOT NULL
            CONSTRAINT FK_DocumentCopy7_Document7 REFERENCES dbo.Document7(document_code),
        status NVARCHAR(30) NOT NULL
    );

    CREATE TABLE dbo.ImportInvoice7 (
        id NVARCHAR(50) NOT NULL PRIMARY KEY,
        supplier_id NVARCHAR(20) NOT NULL
            CONSTRAINT FK_ImportInvoice7_Supplier7 REFERENCES dbo.Supplier7(id),
        librarian_id NVARCHAR(20) NOT NULL
            CONSTRAINT FK_ImportInvoice7_Librarian7 REFERENCES dbo.Librarian7(id),
        created_at DATETIME2 NOT NULL,
        total DECIMAL(18, 2) NOT NULL
    );

    CREATE TABLE dbo.ImportDocument7 (
        id NVARCHAR(50) NOT NULL UNIQUE,
        invoice_id NVARCHAR(50) NOT NULL
            CONSTRAINT FK_ImportDocument7_Invoice REFERENCES dbo.ImportInvoice7(id),
        document_code NVARCHAR(30) NOT NULL
            CONSTRAINT FK_ImportDocument7_Document REFERENCES dbo.Document7(document_code),
        quantity INT NOT NULL,
        unit_price DECIMAL(18, 2) NOT NULL,
        CONSTRAINT PK_ImportDocument7 PRIMARY KEY (invoice_id, document_code)
    );
END;
GO

IF OBJECT_ID(N'dbo.Librarian7', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Librarian7 (
        id NVARCHAR(20) NOT NULL PRIMARY KEY,
        role NVARCHAR(50) NOT NULL,
        username NVARCHAR(100) NOT NULL UNIQUE,
        password NVARCHAR(255) NOT NULL,
        name NVARCHAR(150) NOT NULL,
        phone NVARCHAR(30) NOT NULL,
        address NVARCHAR(300) NOT NULL,
        position NVARCHAR(100) NOT NULL
    );
END;
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Librarian7 WHERE id = N'LIB1')
BEGIN
    INSERT INTO dbo.Librarian7(id, role, username, password, name, phone, address, position)
    VALUES (N'LIB1', N'LIBRARIAN', N'librarian7', N'librarian7', N'Librarian7',
            N'0900000001', N'Địa chỉ thủ thư', N'Nhân viên thư viện');
END;
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Supplier7)
BEGIN
    INSERT INTO dbo.Supplier7(id, name, address, phone) VALUES
    (N'BK1', N'Bách Khoa Manga', N'8D Hà Đông, Hà Nội', N'0123456789'),
    (N'NXB1', N'Nhà xuất bản Kim Đồng', N'55 Quang Trung, Hà Nội', N'0987654321');
END;
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Document7)
BEGIN
    INSERT INTO dbo.Document7
        (id, general_qr, document_code, name, quantity, type, author, publication_year, unit_price, supplier_id)
    VALUES
    (N'DOC-DR1',N'QR-DR1',N'DR1',N'Doremon tập 1',6,N'Sách truyện',N'Fujiko F. Fujio',2000,10500,N'BK1'),
    (N'DOC-DR2',N'QR-DR2',N'DR2',N'Doremon tập 2',7,N'Sách truyện',N'Fujiko F. Fujio',2000,11000,N'BK1'),
    (N'DOC-DR3',N'QR-DR3',N'DR3',N'Doremon tập 3',8,N'Sách truyện',N'Fujiko F. Fujio',2000,11500,N'BK1'),
    (N'DOC-DB1',N'QR-DB1',N'DB1',N'DragonBall tập 1',6,N'Sách truyện',N'Akira Toriyama',1984,12000,N'NXB1'),
    (N'DOC-DB2',N'QR-DB2',N'DB2',N'DragonBall tập 2',7,N'Sách truyện',N'Akira Toriyama',1984,12500,N'NXB1'),
    (N'DOC-DB3',N'QR-DB3',N'DB3',N'DragonBall tập 3',8,N'Sách truyện',N'Akira Toriyama',1984,13000,N'NXB1'),
    (N'DOC-NR1',N'QR-NR1',N'NR1',N'Naruto tập 1',6,N'Sách truyện',N'Masashi Kishimoto',1999,13500,N'NXB1'),
    (N'DOC-NR2',N'QR-NR2',N'NR2',N'Naruto tập 2',7,N'Sách truyện',N'Masashi Kishimoto',1999,14000,N'NXB1'),
    (N'DOC-NR3',N'QR-NR3',N'NR3',N'Naruto tập 3',8,N'Sách truyện',N'Masashi Kishimoto',1999,14500,N'NXB1'),
    (N'DOC-OP1',N'QR-OP1',N'OP1',N'OnePiece tập 1',6,N'Sách truyện',N'Eiichiro Oda',1997,15000,N'BK1'),
    (N'DOC-OP2',N'QR-OP2',N'OP2',N'OnePiece tập 2',7,N'Sách truyện',N'Eiichiro Oda',1997,15500,N'BK1'),
    (N'DOC-OP3',N'QR-OP3',N'OP3',N'OnePiece tập 3',8,N'Sách truyện',N'Eiichiro Oda',1997,16000,N'BK1'),
    (N'DOC-DC1',N'QR-DC1',N'DC1',N'Detective Conan tập 1',6,N'Sách truyện',N'Gosho Aoyama',1994,16500,N'NXB1'),
    (N'DOC-DC2',N'QR-DC2',N'DC2',N'Detective Conan tập 2',7,N'Sách truyện',N'Gosho Aoyama',1994,17000,N'NXB1'),
    (N'DOC-DC3',N'QR-DC3',N'DC3',N'Detective Conan tập 3',8,N'Sách truyện',N'Gosho Aoyama',1994,17500,N'NXB1'),
    (N'DOC-SL1',N'QR-SL1',N'SL1',N'Slam Dunk tập 1',6,N'Sách truyện',N'Takehiko Inoue',1990,18000,N'BK1'),
    (N'DOC-SL2',N'QR-SL2',N'SL2',N'Slam Dunk tập 2',7,N'Sách truyện',N'Takehiko Inoue',1990,18500,N'BK1'),
    (N'DOC-SL3',N'QR-SL3',N'SL3',N'Slam Dunk tập 3',8,N'Sách truyện',N'Takehiko Inoue',1990,19000,N'BK1'),
    (N'DOC-KN1',N'QR-KN1',N'KN1',N'Kimetsu no Yaiba tập 1',6,N'Sách truyện',N'Koyoharu Gotouge',2016,19500,N'NXB1'),
    (N'DOC-KN2',N'QR-KN2',N'KN2',N'Kimetsu no Yaiba tập 2',7,N'Sách truyện',N'Koyoharu Gotouge',2016,20000,N'NXB1'),
    (N'DOC-KN3',N'QR-KN3',N'KN3',N'Kimetsu no Yaiba tập 3',8,N'Sách truyện',N'Koyoharu Gotouge',2016,20500,N'NXB1'),
    (N'DOC-MHA1',N'QR-MHA1',N'MHA1',N'My Hero Academia tập 1',6,N'Sách truyện',N'Kohei Horikoshi',2014,21000,N'BK1'),
    (N'DOC-MHA2',N'QR-MHA2',N'MHA2',N'My Hero Academia tập 2',7,N'Sách truyện',N'Kohei Horikoshi',2014,21500,N'BK1'),
    (N'DOC-MHA3',N'QR-MHA3',N'MHA3',N'My Hero Academia tập 3',8,N'Sách truyện',N'Kohei Horikoshi',2014,22000,N'BK1'),
    (N'DOC-OPM1',N'QR-OPM1',N'OPM1',N'One Punch Man tập 1',6,N'Sách truyện',N'ONE',2009,22500,N'NXB1'),
    (N'DOC-OPM2',N'QR-OPM2',N'OPM2',N'One Punch Man tập 2',7,N'Sách truyện',N'ONE',2009,23000,N'NXB1'),
    (N'DOC-OPM3',N'QR-OPM3',N'OPM3',N'One Punch Man tập 3',8,N'Sách truyện',N'ONE',2009,23500,N'NXB1'),
    (N'DOC-SAO1',N'QR-SAO1',N'SAO1',N'Sword Art Online tập 1',6,N'Sách truyện',N'Reki Kawahara',2009,24000,N'BK1'),
    (N'DOC-SAO2',N'QR-SAO2',N'SAO2',N'Sword Art Online tập 2',7,N'Sách truyện',N'Reki Kawahara',2009,24500,N'BK1'),
    (N'DOC-SAO3',N'QR-SAO3',N'SAO3',N'Sword Art Online tập 3',8,N'Sách truyện',N'Reki Kawahara',2009,25000,N'BK1');
END;
GO

SELECT DB_NAME() AS DatabaseName,
       (SELECT COUNT(*) FROM dbo.Supplier7) AS SupplierCount,
       (SELECT COUNT(*) FROM dbo.Document7) AS DocumentCount;
GO

IF OBJECT_ID(N'dbo.DocumentProvide7', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.DocumentProvide7 (
        id NVARCHAR(50) NOT NULL UNIQUE,
        document_code NVARCHAR(30) NOT NULL
            CONSTRAINT FK_DocumentProvide7_Document REFERENCES dbo.Document7(document_code),
        supplier_id NVARCHAR(20) NOT NULL
            CONSTRAINT FK_DocumentProvide7_Supplier REFERENCES dbo.Supplier7(id),
        supply_price DECIMAL(18,2) NOT NULL,
        CONSTRAINT PK_DocumentProvide7 PRIMARY KEY (document_code, supplier_id)
    );
END;
GO

IF COL_LENGTH(N'dbo.DocumentProvide7', N'id') IS NULL
    ALTER TABLE dbo.DocumentProvide7 ADD id NVARCHAR(50) NULL;
GO

IF COL_LENGTH(N'dbo.DocumentProvide7', N'id') IS NOT NULL
BEGIN
    UPDATE dbo.DocumentProvide7
    SET id = N'PROV-' + document_code + N'-' + supplier_id
    WHERE id IS NULL;
END;
GO

IF COL_LENGTH(N'dbo.ImportDocument7', N'id') IS NULL
    ALTER TABLE dbo.ImportDocument7 ADD id NVARCHAR(50) NULL;
GO

IF COL_LENGTH(N'dbo.ImportDocument7', N'id') IS NOT NULL
BEGIN
    UPDATE dbo.ImportDocument7
    SET id = N'IMP-' + invoice_id + N'-' + document_code
    WHERE id IS NULL;
END;
GO

ALTER TABLE dbo.DocumentProvide7 ALTER COLUMN id NVARCHAR(50) NOT NULL;
ALTER TABLE dbo.ImportDocument7 ALTER COLUMN id NVARCHAR(50) NOT NULL;
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'UQ_DocumentProvide7_Id'
               AND object_id = OBJECT_ID(N'dbo.DocumentProvide7'))
    ALTER TABLE dbo.DocumentProvide7 ADD CONSTRAINT UQ_DocumentProvide7_Id UNIQUE (id);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'UQ_ImportDocument7_Id'
               AND object_id = OBJECT_ID(N'dbo.ImportDocument7'))
    ALTER TABLE dbo.ImportDocument7 ADD CONSTRAINT UQ_ImportDocument7_Id UNIQUE (id);
GO

INSERT INTO dbo.DocumentProvide7(id, document_code, supplier_id, supply_price)
SELECT N'PROV-' + d.document_code + N'-' + d.supplier_id, d.document_code, d.supplier_id, d.unit_price
FROM dbo.Document7 d
WHERE NOT EXISTS (
    SELECT 1 FROM dbo.DocumentProvide7 p
    WHERE p.document_code = d.document_code AND p.supplier_id = d.supplier_id
);
GO

INSERT INTO dbo.DocumentProvide7(id, document_code, supplier_id, supply_price)
SELECT N'PROV-' + d.document_code + N'-' + CASE WHEN d.supplier_id = N'BK1' THEN N'NXB1' ELSE N'BK1' END,
       d.document_code, CASE WHEN d.supplier_id = N'BK1' THEN N'NXB1' ELSE N'BK1' END, d.unit_price
FROM dbo.Document7 d
WHERE NOT EXISTS (
    SELECT 1 FROM dbo.DocumentProvide7 p
    WHERE p.document_code = d.document_code
      AND p.supplier_id = CASE WHEN d.supplier_id = N'BK1' THEN N'NXB1' ELSE N'BK1' END
);
GO

INSERT INTO dbo.Supplier7(id, name, address, phone)
SELECT v.id, v.name, v.address, v.phone
FROM (VALUES
    (N'NXB2', N'Nhà xuất bản Trẻ', N'161B Lý Chính Thắng, Thành phố Hồ Chí Minh', N'0901000002'),
    (N'NXB3', N'Nhà xuất bản Phụ Nữ', N'39 Hàng Chuối, Hà Nội', N'0901000003'),
    (N'NXB4', N'Nhà xuất bản Lao Động', N'175 Giảng Võ, Hà Nội', N'0901000004'),
    (N'NXB5', N'Nhà xuất bản Văn Học', N'18 Nguyễn Trường Tộ, Hà Nội', N'0901000005'),
    (N'NXB6', N'Nhà xuất bản Giáo Dục', N'81 Trần Hưng Đạo, Hà Nội', N'0901000006'),
    (N'NXB7', N'Nhà xuất bản Thống Kê', N'86 Nguyễn Thái Học, Hà Nội', N'0901000007'),
    (N'NXB8', N'Nhà xuất bản Tổng Hợp', N'62 Nguyễn Thị Minh Khai, Thành phố Hồ Chí Minh', N'0901000008'),
    (N'NXB9', N'Nhà xuất bản Khoa Học', N'18 Hoàng Quốc Việt, Hà Nội', N'0901000009'),
    (N'NXB10', N'Nhà xuất bản Á Châu', N'25 Lê Đại Hành, Hà Nội', N'0901000010')
) v(id, name, address, phone)
WHERE NOT EXISTS (SELECT 1 FROM dbo.Supplier7 s WHERE s.id = v.id);
GO

;WITH Series(prefix, title, author, publication_year, supplier_id, base_price) AS (
    SELECT * FROM (VALUES
        (N'HP', N'Harry Potter', N'J. K. Rowling', 1997, N'NXB2', 28000),
        (N'LOTR', N'Chúa tể những chiếc nhẫn', N'J. R. R. Tolkien', 1954, N'NXB3', 32000),
        (N'GK', N'Kẻ trộm sách', N'Markus Zusak', 2005, N'NXB4', 36000),
        (N'NT', N'Nhà giả kim', N'Paulo Coelho', 1988, N'NXB5', 45000),
        (N'DT', N'Đắc nhân tâm', N'Dale Carnegie', 1936, N'NXB6', 50000),
        (N'VN', N'Truyện Việt Nam chọn lọc', N'Nhiều tác giả', 2020, N'NXB7', 38000),
        (N'KH', N'Khám phá khoa học', N'Bill Bryson', 2018, N'NXB8', 62000),
        (N'LT', N'Lập trình Java căn bản', N'Nguyễn Văn A', 2023, N'NXB9', 85000),
        (N'CS', N'Cấu trúc dữ liệu và giải thuật', N'Nguyễn Văn B', 2022, N'NXB9', 92000),
        (N'KT', N'Kinh tế học nhập môn', N'Gregory Mankiw', 2021, N'NXB10', 105000)
    ) s(prefix, title, author, publication_year, supplier_id, base_price)
), Volumes(volume) AS (
    SELECT volume FROM (VALUES (1), (2), (3), (4), (5)) v(volume)
)
INSERT INTO dbo.Document7
    (id, general_qr, document_code, name, quantity, type, author, publication_year, unit_price, supplier_id)
SELECT N'DOC-' + s.prefix + CONVERT(NVARCHAR(2), v.volume),
       N'QR-' + s.prefix + CONVERT(NVARCHAR(2), v.volume),
       s.prefix + CONVERT(NVARCHAR(2), v.volume),
       s.title + N' tập ' + CONVERT(NVARCHAR(2), v.volume),
       8 + v.volume, CASE WHEN s.prefix IN (N'LT', N'CS', N'KT') THEN N'Sách giáo trình' ELSE N'Sách tham khảo' END,
       s.author, s.publication_year, s.base_price + (v.volume - 1) * 2500, s.supplier_id
FROM Series s CROSS JOIN Volumes v
WHERE NOT EXISTS (
    SELECT 1 FROM dbo.Document7 d
    WHERE d.document_code = s.prefix + CONVERT(NVARCHAR(2), v.volume)
);
GO

INSERT INTO dbo.DocumentProvide7(id, document_code, supplier_id, supply_price)
SELECT N'PROV-' + d.document_code + N'-' + d.supplier_id, d.document_code, d.supplier_id, d.unit_price
FROM dbo.Document7 d
WHERE NOT EXISTS (
    SELECT 1 FROM dbo.DocumentProvide7 p
    WHERE p.document_code = d.document_code AND p.supplier_id = d.supplier_id
);
GO

;WITH Numbers(number) AS (
    SELECT TOP (20) ROW_NUMBER() OVER (ORDER BY (SELECT NULL))
    FROM sys.all_objects
)
INSERT INTO dbo.DocumentCopy7(id, qr_code, document_code, status)
SELECT N'COPY-' + d.document_code + N'-' + RIGHT(N'00' + CONVERT(NVARCHAR(2), n.number), 2),
       N'COPYQR-' + d.document_code + N'-' + RIGHT(N'00' + CONVERT(NVARCHAR(2), n.number), 2),
       d.document_code, CASE WHEN n.number % 7 = 0 THEN N'BORROWED' ELSE N'AVAILABLE' END
FROM dbo.Document7 d
JOIN Numbers n ON n.number <= d.quantity
WHERE NOT EXISTS (
    SELECT 1 FROM dbo.DocumentCopy7 c
    WHERE c.document_code = d.document_code AND c.qr_code =
        N'COPYQR-' + d.document_code + N'-' + RIGHT(N'00' + CONVERT(NVARCHAR(2), n.number), 2)
);
GO

INSERT INTO dbo.ImportInvoice7(id, supplier_id, librarian_id, created_at, total)
SELECT v.id, v.supplier_id, N'LIB1', v.created_at, d.unit_price * v.quantity
FROM (VALUES
    (N'INV-SEED-01', N'NXB2', N'Nguyễn An', CONVERT(DATETIME2, '2026-01-05T09:00:00'), N'HP1', 3),
    (N'INV-SEED-02', N'NXB3', N'Trần Bình', CONVERT(DATETIME2, '2026-01-12T10:30:00'), N'LOTR2', 4),
    (N'INV-SEED-03', N'NXB4', N'Lê Chi', CONVERT(DATETIME2, '2026-02-02T14:00:00'), N'GK3', 2),
    (N'INV-SEED-04', N'NXB5', N'Phạm Dũng', CONVERT(DATETIME2, '2026-02-18T08:45:00'), N'NT4', 5),
    (N'INV-SEED-05', N'NXB6', N'Hoàng Em', CONVERT(DATETIME2, '2026-03-03T11:15:00'), N'DT5', 3),
    (N'INV-SEED-06', N'NXB9', N'Vũ Giang', CONVERT(DATETIME2, '2026-03-20T15:20:00'), N'LT2', 6)
) v(id, supplier_id, librarian_name, created_at, document_code, quantity)
JOIN dbo.Document7 d ON d.document_code = v.document_code
WHERE NOT EXISTS (SELECT 1 FROM dbo.ImportInvoice7 i WHERE i.id = v.id);
GO

INSERT INTO dbo.ImportDocument7(id, invoice_id, document_code, quantity, unit_price)
SELECT N'IMP-' + v.invoice_id + N'-' + v.document_code, v.invoice_id, v.document_code, v.quantity, d.unit_price
FROM (VALUES
    (N'INV-SEED-01', N'HP1', 3), (N'INV-SEED-02', N'LOTR2', 4),
    (N'INV-SEED-03', N'GK3', 2), (N'INV-SEED-04', N'NT4', 5),
    (N'INV-SEED-05', N'DT5', 3), (N'INV-SEED-06', N'LT2', 6)
) v(invoice_id, document_code, quantity)
JOIN dbo.Document7 d ON d.document_code = v.document_code
WHERE NOT EXISTS (
    SELECT 1 FROM dbo.ImportDocument7 i
    WHERE i.invoice_id = v.invoice_id AND i.document_code = v.document_code
);
GO

UPDATE dbo.Supplier7 SET name = N'Bách Khoa Manga', address = N'8D Hà Đông, Hà Nội', phone = N'0123456789'
WHERE id = N'BK1';
UPDATE dbo.Supplier7 SET name = N'Nhà xuất bản Kim Đồng', address = N'55 Quang Trung, Hà Nội', phone = N'0987654321'
WHERE id = N'NXB1';
UPDATE dbo.Supplier7 SET name = N'Nhà xuất bản Trẻ', address = N'161B Lý Chính Thắng, Thành phố Hồ Chí Minh'
WHERE id = N'NXB2';
UPDATE dbo.Supplier7 SET name = N'Nhà xuất bản Phụ Nữ', address = N'39 Hàng Chuối, Hà Nội'
WHERE id = N'NXB3';
UPDATE dbo.Supplier7 SET name = N'Nhà xuất bản Lao Động', address = N'175 Giảng Võ, Hà Nội'
WHERE id = N'NXB4';
UPDATE dbo.Supplier7 SET name = N'Nhà xuất bản Văn Học', address = N'18 Nguyễn Trường Tộ, Hà Nội'
WHERE id = N'NXB5';
UPDATE dbo.Supplier7 SET name = N'Nhà xuất bản Giáo Dục', address = N'81 Trần Hưng Đạo, Hà Nội'
WHERE id = N'NXB6';
UPDATE dbo.Supplier7 SET name = N'Nhà xuất bản Thống Kê', address = N'86 Nguyễn Thái Học, Hà Nội'
WHERE id = N'NXB7';
UPDATE dbo.Supplier7 SET name = N'Nhà xuất bản Tổng Hợp', address = N'62 Nguyễn Thị Minh Khai, Thành phố Hồ Chí Minh'
WHERE id = N'NXB8';
UPDATE dbo.Supplier7 SET name = N'Nhà xuất bản Khoa Học', address = N'18 Hoàng Quốc Việt, Hà Nội'
WHERE id = N'NXB9';
UPDATE dbo.Supplier7 SET name = N'Nhà xuất bản Á Châu', address = N'25 Lê Đại Hành, Hà Nội'
WHERE id = N'NXB10';
GO

UPDATE dbo.Document7 SET name = CASE
    WHEN document_code LIKE N'CS%' THEN N'Cấu trúc dữ liệu và giải thuật tập ' + SUBSTRING(document_code, 3, 2)
    WHEN document_code LIKE N'DT%' THEN N'Đắc nhân tâm tập ' + SUBSTRING(document_code, 3, 2)
    WHEN document_code LIKE N'GK%' THEN N'Kẻ trộm sách tập ' + SUBSTRING(document_code, 3, 2)
    WHEN document_code LIKE N'KH%' THEN N'Khám phá khoa học tập ' + SUBSTRING(document_code, 3, 2)
    WHEN document_code LIKE N'KT%' THEN N'Kinh tế học nhập môn tập ' + SUBSTRING(document_code, 3, 2)
    WHEN document_code LIKE N'LT%' THEN N'Lập trình Java căn bản tập ' + SUBSTRING(document_code, 3, 2)
    WHEN document_code LIKE N'NT%' THEN N'Nhà giả kim tập ' + SUBSTRING(document_code, 3, 2)
    WHEN document_code LIKE N'VN%' THEN N'Truyện Việt Nam chọn lọc tập ' + SUBSTRING(document_code, 3, 2)
    ELSE name
END
WHERE document_code LIKE N'CS%' OR document_code LIKE N'DT%' OR document_code LIKE N'GK%'
   OR document_code LIKE N'KH%' OR document_code LIKE N'KT%' OR document_code LIKE N'LT%'
   OR document_code LIKE N'NT%' OR document_code LIKE N'VN%';
GO

UPDATE d SET
    name = CASE
        WHEN document_code LIKE N'DR%' THEN N'Doremon tập ' + SUBSTRING(document_code, 3, 10)
        WHEN document_code LIKE N'DB%' THEN N'DragonBall tập ' + SUBSTRING(document_code, 3, 10)
        WHEN document_code LIKE N'NR%' THEN N'Naruto tập ' + SUBSTRING(document_code, 3, 10)
        WHEN document_code LIKE N'OP%' AND document_code NOT LIKE N'OPM%' THEN N'OnePiece tập ' + SUBSTRING(document_code, 3, 10)
        WHEN document_code LIKE N'DC%' THEN N'Detective Conan tập ' + SUBSTRING(document_code, 3, 10)
        WHEN document_code LIKE N'SL%' THEN N'Slam Dunk tập ' + SUBSTRING(document_code, 3, 10)
        WHEN document_code LIKE N'KN%' THEN N'Kimetsu no Yaiba tập ' + SUBSTRING(document_code, 3, 10)
        WHEN document_code LIKE N'MHA%' THEN N'My Hero Academia tập ' + SUBSTRING(document_code, 4, 10)
        WHEN document_code LIKE N'OPM%' THEN N'One Punch Man tập ' + SUBSTRING(document_code, 4, 10)
        WHEN document_code LIKE N'SAO%' THEN N'Sword Art Online tập ' + SUBSTRING(document_code, 4, 10)
        WHEN document_code LIKE N'HP%' THEN N'Harry Potter tập ' + SUBSTRING(document_code, 3, 10)
        WHEN document_code LIKE N'LOTR%' THEN N'Chúa tể những chiếc nhẫn tập ' + SUBSTRING(document_code, 5, 10)
        WHEN document_code LIKE N'GK%' THEN N'Kẻ trộm sách tập ' + SUBSTRING(document_code, 3, 10)
        WHEN document_code LIKE N'NT%' THEN N'Nhà giả kim tập ' + SUBSTRING(document_code, 3, 10)
        WHEN document_code LIKE N'DT%' THEN N'Đắc nhân tâm tập ' + SUBSTRING(document_code, 3, 10)
        WHEN document_code LIKE N'VN%' THEN N'Truyện Việt Nam chọn lọc tập ' + SUBSTRING(document_code, 3, 10)
        WHEN document_code LIKE N'KH%' THEN N'Khám phá khoa học tập ' + SUBSTRING(document_code, 3, 10)
        WHEN document_code LIKE N'LT%' THEN N'Lập trình Java căn bản tập ' + SUBSTRING(document_code, 3, 10)
        WHEN document_code LIKE N'CS%' THEN N'Cấu trúc dữ liệu và giải thuật tập ' + SUBSTRING(document_code, 3, 10)
        WHEN document_code LIKE N'KT%' THEN N'Kinh tế học nhập môn tập ' + SUBSTRING(document_code, 3, 10)
        ELSE name
    END,
    type = CASE
        WHEN document_code LIKE N'LT%' OR document_code LIKE N'CS%' OR document_code LIKE N'KT%'
            THEN N'Sách giáo trình'
        WHEN document_code LIKE N'HP%' OR document_code LIKE N'LOTR%' OR document_code LIKE N'GK%'
          OR document_code LIKE N'NT%' OR document_code LIKE N'DT%' OR document_code LIKE N'VN%'
          OR document_code LIKE N'KH%' THEN N'Sách tham khảo'
        ELSE N'Sách truyện'
    END
FROM dbo.Document7 d;
GO

UPDATE dbo.Document7
SET author = CASE
    WHEN document_code LIKE N'LT%' THEN N'Nguyễn Văn A'
    WHEN document_code LIKE N'CS%' THEN N'Nguyễn Văn B'
    WHEN document_code LIKE N'VN%' THEN N'Nhiều tác giả'
    ELSE author
END
WHERE document_code LIKE N'LT%'
   OR document_code LIKE N'CS%'
   OR document_code LIKE N'VN%';
GO
