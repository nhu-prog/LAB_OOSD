using System;
using System.Data;
using System.Data.SqlClient;
using QuanLyKhachSan.Data;

namespace QuanLyKhachSan.Services
{
    public class PhongTienNghiService
    {
        // Lấy danh sách toàn bộ phòng
        public DataTable LayDanhSachPhong()
        {
            return Db.Query("SELECT p.Phong, p.Khu, k.TenKhuVuc, p.SucChua, p.DonGia, p.TrangThai " +
                            "FROM Phong p LEFT JOIN KhuVuc k ON p.Khu = k.MaKhuVuc ORDER BY p.Phong");
        }

        // Lấy danh sách tiện nghi được trang bị cho một phòng cụ thể
        public DataTable LayTienNghiTheoPhong(string maPhong)
        {
            string sql = @"SELECT tn.MaLoaiTN, ltn.TenLoaiTN, tn.SoLuong, tn.TinhTrang 
                           FROM ChiTietTienNghi tn 
                           JOIN LoaiTienNghi ltn ON tn.MaLoaiTN = ltn.MaLoaiTN 
                           WHERE tn.MaPhong = @p";
            return Db.Query(sql, new SqlParameter("@p", maPhong));
        }

        // Thêm phòng mới
        public KetQuaXuLy ThemPhong(string phong, string khu, int sucChua, decimal donGia)
        {
            if (string.IsNullOrWhiteSpace(phong) || string.IsNullOrWhiteSpace(khu) || sucChua <= 0 || donGia < 0)
                return KetQuaXuLy.Fail("Thông tin phòng không hợp lệ.");

            try
            {
                string sql = "INSERT INTO Phong(Phong, Khu, SucChua, DonGia, TrangThai) VALUES(@p, @k, @sc, @g, N'Trống')";
                Db.Execute(sql,
                    new SqlParameter("@p", phong),
                    new SqlParameter("@k", khu),
                    new SqlParameter("@sc", sucChua),
                    new SqlParameter("@g", donGia)
                );
                return KetQuaXuLy.Ok("Thêm phòng thành công.");
            }
            catch (Exception ex)
            {
                return KetQuaXuLy.Fail(ex.Message);
            }
        }
    }
}