-- 1. SEKTÖRLER TABLOSU
CREATE TABLE [dbo].[Sektorler](
    [SektorID] [int] IDENTITY(1,1) PRIMARY KEY,
    [SektorAdi] [nvarchar](50) NOT NULL
);

-- 2. FİRMALAR TABLOSU
CREATE TABLE [dbo].[Firmalar](
    [FirmaID] [int] IDENTITY(1,1) PRIMARY KEY,
    [FirmaAdi] [nvarchar](100) NOT NULL,
    [VergiNo] [nvarchar](11) UNIQUE,
    [FirmaMerkezi] [nvarchar](150) NULL,
    [SektorID] [int],
    CONSTRAINT [FK_Firmalar_Sektorler] FOREIGN KEY([SektorID]) REFERENCES [dbo].[Sektorler]([SektorID])
);

-- 3. 2026 CARİ KAYITLAR TABLOSU
-- (Tüm firmalar burada 0 bakiye ile başlayacak)
CREATE TABLE [dbo].[CariKayitlar_2026](
    [CariID] [int] IDENTITY(1,1) PRIMARY KEY,
    [FirmaID] [int] UNIQUE,
    [ToplamHacim] [decimal](18, 2) DEFAULT 0,
    CONSTRAINT [FK_Cari_Firmalar] FOREIGN KEY([FirmaID]) REFERENCES [dbo].[Firmalar]([FirmaID])
);

-- 4. İŞLEM LOGLARI (Her veri girişinin kaydı)
CREATE TABLE [dbo].[IslemLoglari](
    [LogID] [int] IDENTITY(1,1) PRIMARY KEY,
    [FirmaID] [int],
    [EklenenMiktar] [decimal](18, 2),
    [Aciklama] [nvarchar](250),
    [IslemTarihi] [datetime] DEFAULT GETDATE(),
    CONSTRAINT [FK_Log_Firmalar] FOREIGN KEY([FirmaID]) REFERENCES [dbo].[Firmalar]([FirmaID])
);