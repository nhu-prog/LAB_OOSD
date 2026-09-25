using System;
using System.Data;
using System.Data.SqlClient;
using QuanLyKhachSan.Data;

namespace QuanLyKhachSan.Services
{
    public class TraPhongService
    {
        public DataTable LayChiTietPhong(string soPhieu) => Db.Query("SELECT Phong, DonGia FROM ChiTietDatPhong WHERE SoPhieu = @p", new SqlParameter("@p", soPhieu));
        public DataTable LayDanhSachHoaDon() => Db.Query("SELECT * FROM HoaDon ORDER BY SoHoaDon DESC");

        public KetQuaXuLy ThanhToan(string soHoaDon, decimal soTien, string hinhThuc)
        {
            if (string.IsNullOrWhiteSpace(soHoaDon) || soTien <= 0)
                return KetQuaXuLy.Fail("Dữ liệu thanh toán không hợp lệ.");
            try
            {
                Db.Execute("UPDATE HoaDon SET TrangThai = N'Đã thanh toán', HinhThuc = @h, TienDaThu = @t WHERE SoHoaDon = @hd",
                    new SqlParameter("@hd", soHoaDon), new SqlParameter("@h", hinhThuc), new SqlParameter("@t", soTien));
                return KetQuaXuLy.Ok("Thanh toán thành công. Đã hoàn tất trả phòng.");
            }
            catch (Exception ex) { return KetQuaXuLy.Fail(ex.Message); }
        }
    }
}
