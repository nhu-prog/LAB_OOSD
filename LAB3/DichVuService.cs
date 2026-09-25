using System;
using System.Data;
using System.Data.SqlClient;
using QuanLyKhachSan.Data;

namespace QuanLyKhachSan.Services
{
    public class DichVuService
    {
        public DataTable LayDanhSachSuDung() => Db.Query("SELECT * FROM PhieuSuDungDichVu ORDER BY NgaySuDung DESC");

        public KetQuaXuLy GhiNhan(string phieuLuuTru, string phong, string maDV, DateTime ngay, int soLuong)
        {
            if (string.IsNullOrWhiteSpace(phieuLuuTru) || string.IsNullOrWhiteSpace(phong) || string.IsNullOrWhiteSpace(maDV) || soLuong <= 0)
                return KetQuaXuLy.Fail("Thông tin ghi nhận dịch vụ không hợp lệ.");
            try
            {
                Db.Execute("INSERT INTO PhieuSuDungDichVu(MaPhieuLuuTru, MaPhong, MaDV, NgaySuDung, SoLuong) VALUES(@p, @ph, @d, @n, @sl)",
                    new SqlParameter("@p", phieuLuuTru), new SqlParameter("@ph", phong),
                    new SqlParameter("@d", maDV), new SqlParameter("@n", ngay),
                    new SqlParameter("@sl", soLuong));
                return KetQuaXuLy.Ok("Đã ghi nhận dịch vụ.");
            }
            catch (Exception ex) { return KetQuaXuLy.Fail(ex.Message); }
        }
    }
}