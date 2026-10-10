
IF DB_ID(N'QLTourDuLich') IS NULL
    CREATE DATABASE QLTourDuLich;
GO

USE QLTourDuLich;
GO


CREATE TABLE dbo.Tour (
    MaTour VARCHAR(20) PRIMARY KEY,
    TenTour NVARCHAR(150) NOT NULL,
    SoNgay INT NOT NULL,
    SoDem INT NOT NULL,
    NgayDi DATE NULL,
    NgayVe DATE NULL,
    SoCho INT NULL,
    LoaiTour NVARCHAR(10) NOT NULL,
    DonGia DECIMAL(18,2) NOT NULL,
    TrangThai NVARCHAR(50) NOT NULL
        DEFAULT N'Đang mở',
    MoTa NVARCHAR(500),

    CONSTRAINT CK_Tour_SoNgay
        CHECK (SoNgay > 0),

    CONSTRAINT CK_Tour_SoDem
        CHECK (SoDem >= 0),

    CONSTRAINT CK_Tour_SoCho
        CHECK (SoCho IS NULL OR SoCho > 0),

    CONSTRAINT CK_Tour_Loai
        CHECK (LoaiTour IN (N'Le', N'Doan')),

    CONSTRAINT CK_Tour_DonGia
        CHECK (DonGia >= 0),

    CONSTRAINT CK_Tour_Ngay
        CHECK (
            (NgayDi IS NULL AND NgayVe IS NULL)
            OR
            (NgayDi IS NOT NULL
             AND NgayVe IS NOT NULL
             AND NgayVe >= NgayDi)
        ),

    CONSTRAINT CK_Tour_Le
        CHECK (
            LoaiTour <> N'Le'
            OR (NgayDi IS NOT NULL AND SoCho IS NOT NULL)
        )
);
GO

CREATE TABLE dbo.DiaDiem (
    MaDiaDiem VARCHAR(20) PRIMARY KEY,
    MaTour VARCHAR(20) NOT NULL,
    TenDiaDiem NVARCHAR(150) NOT NULL,
    LoaiDiaDiem NVARCHAR(50),
    ThuTuThamQuan INT NOT NULL,
    NoiDung NVARCHAR(500),
    YNghia NVARCHAR(500),

    CONSTRAINT FK_DiaDiem_Tour
        FOREIGN KEY (MaTour)
        REFERENCES dbo.Tour(MaTour),

    CONSTRAINT CK_DiaDiem_ThuTu
        CHECK (ThuTuThamQuan > 0),

    CONSTRAINT UQ_DiaDiem_ThuTu
        UNIQUE (MaTour, ThuTuThamQuan)
);
GO

CREATE TABLE dbo.DichVu (
    MaDichVu VARCHAR(20) PRIMARY KEY,
    MaTour VARCHAR(20) NOT NULL,
    TenDichVu NVARCHAR(150) NOT NULL,
    LoaiDichVu NVARCHAR(50) NOT NULL,
    NhaCungCap NVARCHAR(150),
    ChiPhi DECIMAL(18,2) NOT NULL
        DEFAULT 0,
    GhiChu NVARCHAR(500),

    CONSTRAINT FK_DichVu_Tour
        FOREIGN KEY (MaTour)
        REFERENCES dbo.Tour(MaTour),

    CONSTRAINT CK_DichVu_ChiPhi
        CHECK (ChiPhi >= 0)
);
GO

CREATE TABLE dbo.KhachHang (
    MaKhach VARCHAR(20) PRIMARY KEY,
    HoTen NVARCHAR(120) NOT NULL,
    NgaySinh DATE,
    GioiTinh NVARCHAR(12),
    SDT VARCHAR(20),
    DiaChi NVARCHAR(200)
);
GO

CREATE TABLE dbo.PhieuDangKy (
    MaPhieu VARCHAR(20) PRIMARY KEY,
    MaTour VARCHAR(20) NOT NULL,
    MaKhach VARCHAR(20) NOT NULL,
    NgayDangKy DATETIME2 NOT NULL
        DEFAULT SYSDATETIME(),
    LoaiDangKy NVARCHAR(10) NOT NULL,
    SoNguoi INT NOT NULL,
    DiemBanVe NVARCHAR(150),
    TongTien DECIMAL(18,2) NOT NULL,
    TrangThai NVARCHAR(50) NOT NULL
        DEFAULT N'Đã xác nhận',

    CONSTRAINT FK_PhieuDangKy_Tour
        FOREIGN KEY (MaTour)
        REFERENCES dbo.Tour(MaTour),

    CONSTRAINT FK_PhieuDangKy_KhachHang
        FOREIGN KEY (MaKhach)
        REFERENCES dbo.KhachHang(MaKhach),

    CONSTRAINT CK_PhieuDangKy_Loai
        CHECK (LoaiDangKy IN (N'Le', N'Doan')),

    CONSTRAINT CK_PhieuDangKy_SoNguoi
        CHECK (
            (LoaiDangKy = N'Le'
                AND SoNguoi BETWEEN 1 AND 11)
            OR
            (LoaiDangKy = N'Doan'
                AND SoNguoi > 12)
        ),

    CONSTRAINT CK_PhieuDangKy_TongTien
        CHECK (TongTien >= 0)
);
GO

CREATE TABLE dbo.ThongTinDoan (
    MaDoan VARCHAR(20) PRIMARY KEY,
    MaPhieu VARCHAR(20) NOT NULL UNIQUE,
    TenCoQuan NVARCHAR(150),
    DiaChiCoQuan NVARCHAR(200),
    SDTCoQuan VARCHAR(20),
    NguoiDaiDien NVARCHAR(120) NOT NULL,
    SoNguoi INT NOT NULL,

    DanhSachThanhVien NVARCHAR(MAX) NOT NULL
        DEFAULT N'[]',

    CONSTRAINT FK_ThongTinDoan_Phieu
        FOREIGN KEY (MaPhieu)
        REFERENCES dbo.PhieuDangKy(MaPhieu),

    CONSTRAINT CK_ThongTinDoan_SoNguoi
        CHECK (SoNguoi > 12),

    CONSTRAINT CK_ThongTinDoan_DanhSach
        CHECK (ISJSON(DanhSachThanhVien) = 1)
);
GO

CREATE TABLE dbo.NhanVien (
    MaNV VARCHAR(20) PRIMARY KEY,
    HoTen NVARCHAR(120) NOT NULL,
    SDT VARCHAR(20),
    VaiTro NVARCHAR(60) NOT NULL,
    LuongCoBan DECIMAL(18,2) NOT NULL
        DEFAULT 0,

    CONSTRAINT CK_NhanVien_Luong
        CHECK (LuongCoBan >= 0)
);
GO

CREATE TABLE dbo.PhanCong (
    MaPhanCong VARCHAR(20) PRIMARY KEY,
    MaTour VARCHAR(20) NOT NULL,
    MaNV VARCHAR(20) NOT NULL,
    NgayPhanCong DATE NOT NULL,
    TienCong DECIMAL(18,2) NOT NULL
        DEFAULT 0,
    TrangThai NVARCHAR(50) NOT NULL
        DEFAULT N'Đã phân công',

    CONSTRAINT FK_PhanCong_Tour
        FOREIGN KEY (MaTour)
        REFERENCES dbo.Tour(MaTour),

    CONSTRAINT FK_PhanCong_NhanVien
        FOREIGN KEY (MaNV)
        REFERENCES dbo.NhanVien(MaNV),

    CONSTRAINT CK_PhanCong_TienCong
        CHECK (TienCong >= 0),

    CONSTRAINT UQ_PhanCong
        UNIQUE (MaTour, MaNV)
);
GO

CREATE TABLE dbo.ThanhToan (
    MaThanhToan VARCHAR(20) PRIMARY KEY,
    MaPhieu VARCHAR(20) NOT NULL,
    NgayThanhToan DATETIME2 NOT NULL
        DEFAULT SYSDATETIME(),
    SoTien DECIMAL(18,2) NOT NULL,
    PhuongThuc NVARCHAR(50) NOT NULL,
    LoaiGiaoDich NVARCHAR(30) NOT NULL,

    CONSTRAINT FK_ThanhToan_Phieu
        FOREIGN KEY (MaPhieu)
        REFERENCES dbo.PhieuDangKy(MaPhieu),

    CONSTRAINT CK_ThanhToan_SoTien
        CHECK (SoTien > 0),

    CONSTRAINT CK_ThanhToan_Loai
        CHECK (
            LoaiGiaoDich IN (
                N'DatCoc',
                N'TienVe',
                N'BoSung',
                N'HoanTien'
            )
        )
);
GO

CREATE TABLE dbo.PhieuKhaoSat (
    MaKhaoSat VARCHAR(20) PRIMARY KEY,
    MaPhieu VARCHAR(20) NOT NULL UNIQUE,
    NgayGui DATE NOT NULL
        DEFAULT CONVERT(DATE, GETDATE()),
    DiemDanhGia INT,
    NoiDungGopY NVARCHAR(1000),

    CONSTRAINT FK_KhaoSat_Phieu
        FOREIGN KEY (MaPhieu)
        REFERENCES dbo.PhieuDangKy(MaPhieu),

    CONSTRAINT CK_KhaoSat_Diem
        CHECK (DiemDanhGia BETWEEN 1 AND 5)
);
GO

CREATE TABLE dbo.BangLuong (
    MaBangLuong VARCHAR(20) PRIMARY KEY,
    MaNV VARCHAR(20) NOT NULL,
    Thang INT NOT NULL,
    Nam INT NOT NULL,
    LuongCoBan DECIMAL(18,2) NOT NULL,
    TienCongTour DECIMAL(18,2) NOT NULL,
    TongLuong DECIMAL(18,2) NOT NULL,

    CONSTRAINT FK_BangLuong_NhanVien
        FOREIGN KEY (MaNV)
        REFERENCES dbo.NhanVien(MaNV),

    CONSTRAINT CK_BangLuong_Thang
        CHECK (Thang BETWEEN 1 AND 12),

    CONSTRAINT UQ_BangLuong
        UNIQUE (MaNV, Thang, Nam)
);
GO
