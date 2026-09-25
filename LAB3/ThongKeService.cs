using System;
using System.Data;
using System.Data.SqlClient;
using QuanLyKhachSan.Data;

namespace QuanLyKhachSan.Services
{
    public class ThongKeService
    {
        public DataTable LayDoanhThuDichVu(DateTime tuNgay, DateTime denNgay)
        {
            string sql = @"SELECT p.MaDV, d.TenDV, SUM(p.SoLuong) as TongSoLuong, SUM(p.SoLuong * d.Gia) as TongTien 
                           FROM PhieuSuDungDichVu p 
                           JOIN DichVu d ON p.MaDV = d.MaDV 
                           WHERE p.NgaySuDung BETWEEN @tu AND @den 
                           GROUP BY p.MaDV, d.TenDV";
            return Db.Query(sql, new SqlParameter("@tu", tuNgay), new SqlParameter("@den", denNgay));
        }
    }
}