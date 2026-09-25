CREATE DATABASE QuanLyKhachSan;
GO
USE QuanLyKhachSan;
GO

CREATE TABLE KhuVuc (
    MaKhuVuc VARCHAR(20) PRIMARY KEY,
    TenKhuVuc NVARCHAR(100)
);

CREATE TABLE LoaiTienNghi (
    MaLoaiTN VARCHAR(20) PRIMARY KEY,
    TenLoaiTN NVARCHAR(100)
);

CREATE TABLE DichVu (
    MaDV VARCHAR(20) PRIMARY KEY,
    TenDV NVARCHAR(100),
    DonViTinh NVARCHAR(50),
    DonGia DECIMAL(18,2)
);

CREATE TABLE NhanVien (
    MaNV VARCHAR(20) PRIMARY KEY,
    HoTen NVARCHAR(100),
    VaiTro NVARCHAR(50),
    SoDienThoai VARCHAR(15)
);

CREATE TABLE KhachHang (
    MaKhach VARCHAR(20) PRIMARY KEY,
    HoTen NVARCHAR(100),
    SoCMND VARCHAR(20),
    QuocTich NVARCHAR(50),
    SoDienThoai VARCHAR(15)
);

CREATE TABLE Phong (
    SoPhong VARCHAR(20) PRIMARY KEY,
    MaKhuVuc VARCHAR(20) FOREIGN KEY REFERENCES KhuVuc(MaKhuVuc),
    SoNguoiToiDa INT,
    DonGiaNgay DECIMAL(18,2),
    TrangThai NVARCHAR(50)
);

CREATE TABLE QuyDinhDenBu (
    MaQuyDinh VARCHAR(20) PRIMARY KEY,
    MaLoaiTN VARCHAR(20) FOREIGN KEY REFERENCES LoaiTienNghi(MaLoaiTN),
    MucDoThietHai NVARCHAR(255),
    MucDenBu DECIMAL(18,2)
);

CREATE TABLE PhieuDatPhong (
    SoPhieuDat VARCHAR(20) PRIMARY KEY,
    MaKhach VARCHAR(20) FOREIGN KEY REFERENCES KhachHang(MaKhach),
    MaNV VARCHAR(20) FOREIGN KEY REFERENCES NhanVien(MaNV),
    NgayLap DATETIME,
    NgayNhan DATE,
    NgayTraDuKien DATE,
    TienCoc DECIMAL(18,2),
    KenhDat NVARCHAR(50),
    TrangThai NVARCHAR(50),
    NgayNhanThucTe DATETIME,
    NgayTraThucTe DATETIME
);

CREATE TABLE PhieuLapDat (
    SoPhieuLapDat VARCHAR(20) PRIMARY KEY,
    SoPhong VARCHAR(20) FOREIGN KEY REFERENCES Phong(SoPhong),
    MaNV VARCHAR(20) FOREIGN KEY REFERENCES NhanVien(MaNV),
    NgayLap DATE,
    TinhTrang NVARCHAR(100),
    GhiChu NVARCHAR(255)
);

CREATE TABLE TienNghi (
    MaTienNghi VARCHAR(20) PRIMARY KEY,
    MaLoaiTN VARCHAR(20) FOREIGN KEY REFERENCES LoaiTienNghi(MaLoaiTN),
    SoPhieuLapDat VARCHAR(20) FOREIGN KEY REFERENCES PhieuLapDat(SoPhieuLapDat),
    SoThuTu INT,
    TinhTrangHienTai NVARCHAR(100)
);

CREATE TABLE ChiTietDatPhong (
    SoPhieuDat VARCHAR(20),
    SoPhong VARCHAR(20),
    SoNguoi INT,
    PRIMARY KEY (SoPhieuDat, SoPhong),
    FOREIGN KEY (SoPhieuDat) REFERENCES PhieuDatPhong(SoPhieuDat),
    FOREIGN KEY (SoPhong) REFERENCES Phong(SoPhong)
);

CREATE TABLE NguoiLuuTru (
    MaNguoiLT INT IDENTITY(1,1) PRIMARY KEY,
    SoPhieuDat VARCHAR(20),
    SoPhong VARCHAR(20),
    HoTen NVARCHAR(100),
    SoCMND VARCHAR(20),
    QuocTich NVARCHAR(50),
    FOREIGN KEY (SoPhieuDat, SoPhong) REFERENCES ChiTietDatPhong(SoPhieuDat, SoPhong)
);

CREATE TABLE PhieuSuDungDV (
    SoPhieuSDDV VARCHAR(20) PRIMARY KEY,
    SoPhieuDat VARCHAR(20),
    SoPhong VARCHAR(20),
    MaNV VARCHAR(20) FOREIGN KEY REFERENCES NhanVien(MaNV),
    NgaySuDung DATE,
    FOREIGN KEY (SoPhieuDat, SoPhong) REFERENCES ChiTietDatPhong(SoPhieuDat, SoPhong)
);

CREATE TABLE PhieuDenBu (
    SoPhieuDenBu VARCHAR(20) PRIMARY KEY,
    SoPhieuDat VARCHAR(20),
    SoPhong VARCHAR(20),
    MaNV VARCHAR(20) FOREIGN KEY REFERENCES NhanVien(MaNV),
    NgayLap DATETIME,
    TongTien DECIMAL(18,2),
    FOREIGN KEY (SoPhieuDat, SoPhong) REFERENCES ChiTietDatPhong(SoPhieuDat, SoPhong)
);

CREATE TABLE HoaDon (
    SoHoaDon VARCHAR(20) PRIMARY KEY,
    SoPhieuDat VARCHAR(20) FOREIGN KEY REFERENCES PhieuDatPhong(SoPhieuDat),
    MaNV VARCHAR(20) FOREIGN KEY REFERENCES NhanVien(MaNV),
    NgayLap DATETIME,
    SoNgayTinhTien INT,
    TienPhong DECIMAL(18,2),
    TienDichVu DECIMAL(18,2),
    TongTien DECIMAL(18,2),
    TrangThai NVARCHAR(50)
);

CREATE TABLE ChiTietPhieuSuDungDV (
    SoPhieuSDDV VARCHAR(20),
    MaDV VARCHAR(20),
    SoLuong INT,
    DonGia DECIMAL(18,2),
    ThanhTien DECIMAL(18,2),
    PRIMARY KEY (SoPhieuSDDV, MaDV),
    FOREIGN KEY (SoPhieuSDDV) REFERENCES PhieuSuDungDV(SoPhieuSDDV),
    FOREIGN KEY (MaDV) REFERENCES DichVu(MaDV)
);

CREATE TABLE ChiTietPhieuDenBu (
    SoPhieuDenBu VARCHAR(20),
    MaTienNghi VARCHAR(20),
    MucDoThietHai NVARCHAR(255),
    SoTien DECIMAL(18,2),
    PRIMARY KEY (SoPhieuDenBu, MaTienNghi),
    FOREIGN KEY (SoPhieuDenBu) REFERENCES PhieuDenBu(SoPhieuDenBu),
    FOREIGN KEY (MaTienNghi) REFERENCES TienNghi(MaTienNghi)
);

CREATE TABLE ThanhToan (
    MaThanhToan VARCHAR(20) PRIMARY KEY,
    SoHoaDon VARCHAR(20) FOREIGN KEY REFERENCES HoaDon(SoHoaDon),
    NgayThanhToan DATETIME,
    HinhThuc NVARCHAR(50),
    SoTien DECIMAL(18,2)
);