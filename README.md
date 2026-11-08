# LibMan - hai module theo phân tích thiết kế

## Công nghệ

- Java 25 LTS
- Maven
- SQL Server (`localhost:1433`, database `LibMan`, Windows Authentication)

## Hai module

- `SearchDocumentModule7`: tìm tài liệu theo tên/mã, xem chi tiết tài liệu và nhà cung cấp.
- `ImportDocumentModule7`: tìm nhà cung cấp, quét/tìm tài liệu, thêm bản sao và tạo hóa đơn nhập.
- JSP theo đúng thiết kế nằm trong `src/main/view/ReaderView/` và
  `src/main/view/LibrarianView/`: `ReaderView.jsp`, `SearchDocumentView.jsp`,
  `DetailDocumentView.jsp`, `LibrarianView.jsp`, `SearchSupplierView.jsp`,
  `ImportDocumentView.jsp`, `InvoiceView.jsp`.

Tên lớp giữ theo báo cáo: `Document7`, `DocumentCopy7`, `Supplier7`, `Librarian7`,
`DocumentProvide7`, `ImportDocument7`, `ImportInvoice7`, `DocumentDAO7`, `SupplierDAO7`,
`DocumentCopyDAO7`, `ImportInvoiceDAO7`.

Bảng `dbo.Librarian7` lưu `id`, `role`, `username`, `password`, `name`, `phone`,
`address` và `position` của nhân viên thư viện. Các bảng `dbo.DocumentProvide7`
và `dbo.ImportDocument7` đều có thêm mã định danh `id` riêng.

Các DAO cụ thể kế thừa `DAO7`. Lớp cơ sở quản lý thuộc tính kết nối
`Connection` dùng chung và cung cấp `getConnection7()`/`close7()` cho các DAO con.

`DocumentProvide7` là lớp liên kết nhiều-nhiều: một tài liệu có nhiều nhà cung cấp
và một nhà cung cấp có thể cung cấp nhiều tài liệu. Quan hệ này được lưu tại bảng
`dbo.DocumentProvide7`.

## Chạy

Từ thư mục dự án:

```powershell
mvn clean compile exec:java
```

Database `LibMan` gồm 11 nhà cung cấp và 80 tài liệu mẫu:
Doremon, DragonBall, Naruto, OnePiece, Detective Conan, Slam Dunk,
Kimetsu no Yaiba, My Hero Academia, One Punch Man và Sword Art Online
(mỗi bộ 3 tập), cùng các bộ Harry Potter, Chúa tể những chiếc nhẫn,
Kẻ trộm sách, Nhà giả kim, Đắc nhân tâm, sách Việt Nam, khoa học và
giáo trình. Dữ liệu còn bao gồm bản sao tài liệu, quan hệ nhiều nhà cung cấp,
và các hóa đơn nhập mẫu.

Schema được tạo trong `Database7`; dữ liệu mẫu được tạo trong `SeedData7`.

## Chạy giao diện JSP

Đóng gói web bằng `mvn package`, sau đó triển khai `target/libman.war` lên Tomcat.
Maven được cấu hình để lấy nội dung web từ `src/main/view/`.
Các JSP hiện là giao diện/luồng mẫu đúng theo thiết kế; để lấy dữ liệu động từ SQLite,
cần nối các form với servlet/controller tương ứng.

## Chạy trực tiếp trong VS Code

Đã cấu hình sẵn `.vscode/launch.json` và `.vscode/tasks.json`.
Chỉ cần mở thư mục dự án trong VS Code, nhấn `F5`, chọn **LibMan trên trình duyệt**.
VS Code sẽ tự build WAR, triển khai vào Tomcat, khởi động Tomcat nếu chưa chạy
và mở `http://localhost:8080/libman/`. Nếu Tomcat đã chạy, task sẽ dùng lại tiến trình đó.
