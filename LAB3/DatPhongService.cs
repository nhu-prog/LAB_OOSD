using System;
using System.Data;
using System.Data.SqlClient;
using QuanLyKhachSan.Data;

namespace QuanLyKhachSan.Services
{
    public class DatPhongService
    {
        public DataTable LayDanhSachPhongTrong() => Db.Query("SELECT Phong, Khu, SucChua, DonGia FROM Phong WHERE TrangThai = N'Trống'");
        public DataTable LayDanhSachPhieuDat() => Db.Query("SELECT * FROM PhieuDatPhong ORDER BY NgayNhan DESC");

        public KetQuaXuLy LapPhieuDat(string soPhieu, string khach, string kenh, decimal tienCoc)
        {
            if (string.IsNullOrWhiteSpace(soPhieu) || string.IsNullOrWhiteSpace(khach))
                return KetQuaXuLy.Fail("Số phiếu và tên khách không được để trống.");
            try
            {
                Db.Execute("INSERT INTO PhieuDatPhong(SoPhieu, KhachHang, KenhDat, TienCoc, TrangThai) VALUES(@p, @k, @kenh, @c, N'Đã đặt')",
                    new SqlParameter("@p", soPhieu), new SqlParameter("@k", khach),
                    new SqlParameter("@kenh", kenh), new SqlParameter("@c", tienCoc));
                return KetQuaXuLy.Ok("Lập phiếu đặt phòng thành công.");
            }
            catch (Exception ex) { return KetQuaXuLy.Fail(ex.Message); }
        }
    }
}