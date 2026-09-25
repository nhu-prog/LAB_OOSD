# BÁO CÁO BÀI THỰC HÀNH LAB 3

* **Họ tên:** Nguyễn Thị Huỳnh Như
* **MSSV:** 1250080132
* **Bài Lab:** LAB 3
* **Môi trường:** Visual Studio 2022 (.NET Framework WinForms), SQL Server

---

### 1. Nội dung đã thực hiện
* Thiết kế xong toàn bộ giao diện các Form (Layout, các Label điều hướng, TextBox nhập liệu và DataGridView).
* Khởi tạo thành công Cơ sở dữ liệu trên SQL Server (hoàn thiện các bảng, khóa chính, khóa ngoại).
* Đã xây dựng sườn kiến trúc 3 lớp (DAL, BLL, GUI) để chuẩn bị kết nối.

### 2. Kết quả
* Giao diện hiển thị đúng bố cục, các nút bấm điều hướng hoạt động tốt.
* CSDL đã sẵn sàng để truy vấn.

### 3. Lỗi gặp phải & Cách khắc phục
* **Lỗi gặp phải:** Chưa thể đổ dữ liệu từ SQL Server lên DataGridView do vướng 2 lỗi logic:
  1. Lỗi `SqlException (network-related or instance-specific)`: Chuỗi kết nối (Connection String) đang bị từ chối truy cập khi gọi từ lớp Data Access Layer (DAL) xuống database.
  2. Lỗi `NullReferenceException`: Khi ép kiểu dữ liệu từ `DataTable` lên các cột tự tạo sẵn của `DataGridView`, dữ liệu trả về bị null do chưa đồng bộ chính xác tên các trường (DataPropertyName).
* **Cách khắc phục:** 
  * Cần cấu hình lại Connection String (thêm thuộc tính TrustServerCertificate hoặc kiểm tra lại tên Instance SQL).
  * Đặt thêm các khối `try-catch` ở lớp DAL để bắt lỗi truy vấn, đồng thời map lại chính xác tên cột từ CSDL vào thuộc tính của DataGridView trên file code.
