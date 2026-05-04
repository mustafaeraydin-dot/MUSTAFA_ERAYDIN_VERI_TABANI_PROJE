namespace EP_2026_Web.Models
{
    public class CariKayit
    {
        public int CariID { get; set; }
        public int FirmaID { get; set; }
        public decimal ToplamHacim { get; set; }

        // Sunumda kolaylık olması için Firma ismini de burada taşıyacağız
        public string? FirmaAdi { get; set; }
    }
}