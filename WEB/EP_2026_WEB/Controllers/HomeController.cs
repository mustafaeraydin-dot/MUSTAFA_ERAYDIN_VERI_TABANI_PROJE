using Microsoft.AspNetCore.Mvc;
using EP_2026_Web.Data;
using EP_2026_Web.Models;
using Microsoft.AspNetCore.Authorization;
namespace EP_2026_Web.Controllers
{
    [Authorize]
    public class HomeController : Controller
    {
        private readonly VeriErisim _veri;

        public HomeController(IConfiguration configuration)
        {
            _veri = new VeriErisim(configuration);
        }

        // Ana Sayfa: Cari kayıtları ve firmaları gösterir
        public IActionResult Index()
        {
            ViewBag.Firmalar = _veri.FirmalariGetir(); // Dropdown için
            var model = _veri.CariKayitlariGetir();   // Tablo için
            return View(model);
        }







        //INSERT
        // Kaydet Butonu: Veriyi SQL'e gönderir
        [HttpPost]
        public IActionResult CariGuncelle(int firmaId, decimal tutar)
        {
            if (tutar > 0)
            {
                _veri.CariGuncelle(firmaId, tutar);
            }
            return RedirectToAction("Index");
        }
        // Filtreleme sayfasının ilk açılış hali (boş liste döner)
        public IActionResult Filtrele()
        {
            return View(new List<Firma>());
        }

        // "Ara" butonuna basıldığında çalışan kısım
        [HttpPost]
        public IActionResult Filtrele(string merkez, string vergiDairesi, int? minYil, int? maxYil)
        {
            // Veri motorumuzu çağırıp sonuçları alıyoruz
            var sonuc = _veri.FirmalariFiltrele(merkez, vergiDairesi, minYil, maxYil);
            return View(sonuc);
        }
    }
}