using System.Data;
using Microsoft.Data.SqlClient;
using EP_2026_Web.Models;

namespace EP_2026_Web.Data
{
    public class VeriErisim
    {
        private readonly string _baglantiCumlesi;

        public VeriErisim(IConfiguration configuration)
        {
            _baglantiCumlesi = configuration.GetConnectionString("DefaultConnection");
        }

        // 1. Firmaları Listeleme (Açılır menü için)
        public List<Firma> FirmalariGetir()
        {
            var firmalar = new List<Firma>();
            using (SqlConnection con = new SqlConnection(_baglantiCumlesi))
            {
                SqlCommand cmd = new SqlCommand("SELECT FirmaID, FirmaAdi FROM Firmalar", con);
                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    firmalar.Add(new Firma { FirmaID = (int)dr["FirmaID"], FirmaAdi = dr["FirmaAdi"].ToString() });
                }
            }
            return firmalar;
        }

        // 2. 2026 Cari Bakiyeleri Listeleme
        public List<CariKayit> CariKayitlariGetir()
        {
            var kayitlar = new List<CariKayit>();
            using (SqlConnection con = new SqlConnection(_baglantiCumlesi))
            {
                string query = @"SELECT C.CariID, F.FirmaAdi, C.ToplamHacim 
                                 FROM CariKayitlar_2026 C
                                 JOIN Firmalar F ON C.FirmaID = F.FirmaID";

                SqlCommand cmd = new SqlCommand(query, con);
                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    kayitlar.Add(new CariKayit
                    {
                        CariID = (int)dr["CariID"],
                        FirmaAdi = dr["FirmaAdi"].ToString(),
                        ToplamHacim = (decimal)dr["ToplamHacim"]
                    });
                }
            }
            return kayitlar;
        }

        // 3. Yeni Cari Girişi Yapma (SQL'deki Procedure'ü tetikler)
        public void CariGuncelle(int firmaId, decimal tutar)
        {
            using (SqlConnection con = new SqlConnection(_baglantiCumlesi))
            {
                SqlCommand cmd = new SqlCommand("sp_CariGirisYap", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@FirmaID", firmaId);
                cmd.Parameters.AddWithValue("@Tutar", tutar);

                con.Open();
                cmd.ExecuteNonQuery();
            }
        }

        // 4. Firmaları Filtreleme (Yeni Eklenen)
        public List<Firma> FirmalariFiltrele(string? merkez, string? vergiDairesi, int? minYil, int? maxYil)
        {
            var firmalar = new List<Firma>();
            using (SqlConnection con = new SqlConnection(_baglantiCumlesi))
            {
                // Dinamik sorgu: Boş bırakılan (null) parametreler filtreye takılmaz
                string query = @"SELECT * FROM Firmalar 
                                WHERE (@Merkez IS NULL OR FirmaMerkezi LIKE '%' + @Merkez + '%')
                                AND (@VergiDairesi IS NULL OR VergiDairesi LIKE '%' + @VergiDairesi + '%')
                                AND (@MinYil IS NULL OR KurulusYili >= @MinYil)
                                AND (@MaxYil IS NULL OR KurulusYili <= @MaxYil)";

                SqlCommand cmd = new SqlCommand(query, con);

                // Parametreleri SQL'e güvenli şekilde gönderiyoruz
                cmd.Parameters.AddWithValue("@Merkez", (object?)merkez ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@VergiDairesi", (object?)vergiDairesi ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@MinYil", (object?)minYil ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@MaxYil", (object?)maxYil ?? DBNull.Value);

                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    firmalar.Add(new Firma
                    {
                        FirmaID = (int)dr["FirmaID"],
                        FirmaAdi = dr["FirmaAdi"].ToString(),
                        FirmaMerkezi = dr["FirmaMerkezi"].ToString(),
                        VergiDairesi = dr["VergiDairesi"].ToString(),
                        KurulusYili = (int)dr["KurulusYili"]
                    });
                }
            }
            return firmalar;
        }
    }
}