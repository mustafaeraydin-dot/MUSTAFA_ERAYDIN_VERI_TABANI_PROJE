using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.Data.SqlClient;
using EP_2026_Web.Models;

namespace EP_2026_Web.Controllers
{
    public class GirisController : Controller
    {
        // DİKKAT: "VeritabaniAdin" yazan yere kendi SQL veritabanının adını yazmayı unutma!
        string baglantiAdresi = @"Server=.\SQLEXPRESS;Database=EP_2026;Trusted_Connection=True;TrustServerCertificate=True;";

        // --- GİRİŞ YAP KISMI ---
        [HttpGet]
        public IActionResult Index()
        {
            return View();
        }












        //INSERT
        [HttpPost]//Burası SQL tablosuna yeni kayıt ekleme inserti
        public async Task<IActionResult> Index(KullaniciGiris p)//KullaniciGiris önemli
        {
            bool girisBasarili = false;

            using (SqlConnection baglanti = new SqlConnection(baglantiAdresi))
            {
                baglanti.Open();
                SqlCommand komut = new SqlCommand("SELECT * FROM Kullanicilar WHERE KullaniciAdi=@kadi AND Sifre=@sifre", baglanti);
                komut.Parameters.AddWithValue("@kadi", p.KullaniciAdi);
                komut.Parameters.AddWithValue("@sifre", p.Sifre);

                SqlDataReader dr = komut.ExecuteReader();
                if (dr.Read()) // Eğer veritabanında böyle biri varsa
                {
                    girisBasarili = true;
                }
            }

            if (girisBasarili)
            {
                var claims = new List<Claim> { new Claim(ClaimTypes.Name, p.KullaniciAdi) };
                var useridentity = new ClaimsIdentity(claims, "Giris");
                ClaimsPrincipal principal = new ClaimsPrincipal(useridentity);

                await HttpContext.SignInAsync(CookieAuthenticationDefaults.AuthenticationScheme, principal);
                return RedirectToAction("Index", "Home");
            }

            ViewBag.Hata = "Kullanıcı adı veya şifre hatalı!";
            return View();
        }

        // --- KAYIT OL KISMI ---
        [HttpGet]
        public IActionResult KayitOl()
        {
            return View();
        }

        [HttpPost]
        public IActionResult KayitOl(KullaniciGiris p)
        {
            using (SqlConnection baglanti = new SqlConnection(baglantiAdresi))
            {
                baglanti.Open();
                SqlCommand komut = new SqlCommand("INSERT INTO Kullanicilar (KullaniciAdi, Sifre) VALUES (@kadi, @sifre)", baglanti);
                komut.Parameters.AddWithValue("@kadi", p.KullaniciAdi);
                komut.Parameters.AddWithValue("@sifre", p.Sifre);
                komut.ExecuteNonQuery();
            }

            ViewBag.Mesaj = "Kayıt başarılı! Şimdi giriş yapabilirsiniz.";
            return View("Index");
        }

        // --- ÇIKIŞ YAP KISMI ---
        [HttpGet]
        public async Task<IActionResult> CikisYap()
        {
            await HttpContext.SignOutAsync(CookieAuthenticationDefaults.AuthenticationScheme);
            return RedirectToAction("Index", "Giris");
        }
    }
}