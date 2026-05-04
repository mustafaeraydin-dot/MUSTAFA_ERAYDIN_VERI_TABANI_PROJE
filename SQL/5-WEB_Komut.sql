CREATE PROCEDURE [dbo].[sp_CariGirisYap]
    @FirmaID int,
    @Tutar decimal(18,2)
AS
BEGIN
    -- 1. Ana cari tablosundaki rakamı arttırıyoruz
    UPDATE CariKayitlar_2026 
    SET ToplamHacim = ToplamHacim + @Tutar 
    WHERE FirmaID = @FirmaID;

    -- 2. Bu işlemi tarih ve miktar ile log tablosuna yazıyoruz
    INSERT INTO IslemLoglari (FirmaID, EklenenMiktar) 
    VALUES (@FirmaID, @Tutar);
END
GO