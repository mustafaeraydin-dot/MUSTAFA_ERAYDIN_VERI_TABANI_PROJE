-- MUSTAFA ERAYDIN - EP_2026 PROJE KURULUMU
USE [master]
GO
CREATE DATABASE [EP_2026]
GO
USE [EP_2026]
GO

-- 1. TABLO: SEKTORLER
CREATE TABLE [dbo].[Sektorler](
    [SektorID] [int] IDENTITY(1,1) PRIMARY KEY,
    [SektorAdi] [nvarchar](50) NOT NULL
)
GO

-- 2. TABLO: FIRMALAR
CREATE TABLE [dbo].[Firmalar](
    [FirmaID] [int] IDENTITY(1,1) PRIMARY KEY,
    [FirmaAdi] [nvarchar](100) NOT NULL,
    [VergiDairesi] [nvarchar](50) NULL,
    [VergiNo] [nvarchar](11) NULL,
    [KurulusYili] [int] NULL,
    [FirmaMerkezi] [nvarchar](150) NULL,
    [SektorID] [int],
    CONSTRAINT [FK_Firmalar_Sektorler] FOREIGN KEY([SektorID]) REFERENCES [dbo].[Sektorler]([SektorID])
)
GO

-- 3. TABLO: 2026 CARI KAYITLAR (BAKIYE TABLOSU)
CREATE TABLE [dbo].[CariKayitlar_2026](
    [CariID] [int] IDENTITY(1,1) PRIMARY KEY,
    [FirmaID] [int] UNIQUE,
    [ToplamHacim] [decimal](18, 2) DEFAULT 0,
    CONSTRAINT [FK_Cari_Firmalar] FOREIGN KEY([FirmaID]) REFERENCES [dbo].[Firmalar]([FirmaID])
)
GO

-- 4. TABLO: ISLEM LOGLARI (GIRILEN TUTARLARIN TARIHCE TABLOSU)
CREATE TABLE [dbo].[IslemLoglari](
    [LogID] [int] IDENTITY(1,1) PRIMARY KEY,
    [FirmaID] [int],
    [EklenenMiktar] [decimal](18, 2),
    [IslemTarihi] [datetime] DEFAULT GETDATE(),
    CONSTRAINT [FK_Log_Firmalar] FOREIGN KEY([FirmaID]) REFERENCES [dbo].[Firmalar]([FirmaID])
)
GO

-- VERI ISLEME: SEKTORLER (EKRAN GORUNTUSUNE GORE)
SET IDENTITY_INSERT [dbo].[Sektorler] ON
INSERT [dbo].[Sektorler] ([SektorID], [SektorAdi]) VALUES (1, N'Vinç'), (2, N'Platform'), (3, N'İnşaat'), (4, N'Temizlik'), (5, N'Komprosör'), (6, N'Savunma Sanayi'), (7, N'Kimya'), (8, N'Reklam'), (9, N'Tarım'), (10, N'Elektronik')
SET IDENTITY_INSERT [dbo].[Sektorler] OFF
GO

-- VERI ISLEME: FIRMALAR (EKRAN GORUNTUSUNE GORE)
SET IDENTITY_INSERT [dbo].[Firmalar] ON
INSERT [dbo].[Firmalar] ([FirmaID], [FirmaAdi], [VergiDairesi], [VergiNo], [KurulusYili], [FirmaMerkezi], [SektorID]) VALUES 
(1, N'Karali Vinç', N'İlyasbey V.D.', N'5171681248', 2024, N'Çayırova', 1),
(2, N'Sürmeneli Vinç', N'İlyasbey V.D.', N'7870325713', 2000, N'Gebze', 1),
(3, N'Çalık Grup', N'Kartal V.D.', N'99900011122', 2015, N'Gebze', 4),
(4, N'Yimser Platform', N'İlyasbey V.D.', N'9810651988', 2021, N'Çayırova', 2),
(5, N'Özgü Vinç', N'İlyasbey V.D.', N'77788899900', 2020, N'Gebze', 1),
(6, N'Hleks Gıda', N'Anadolu Kurumlar', N'4630023829', 2000, N'Beykoz', 7),
(7, N'GM Bakır Alaşımları', N'Uluçınar V.D.', N'4000316136', 2010, N'Gebze', 7),
(8, N'Eksan Yapı İnşaat', N'Uluçınar V.D.', N'3610024434', 2020, N'Gebze', 3),
(9, N'Çalışkan Vinç', N'Uluçınar V.D.', N'21419572360', 2024, N'Dilovası', 1),
(10, N'SCT İnşaat', N'İlyasbey V.D.', N'7570393953', 2022, N'Gebze', 3),
(11, N'Aydesan Savunma Sanayi', N'İlyasbey V.D.', N'0690523797', 2015, N'Gebze', 6),
(12, N'Ayhan Çiftçi', N'İlyasbey V.D.', N'29353693998', 2022, N'Gebze', 1),
(13, N'Tekopa Komprasör', N'Sarıgazi V.D.', N'3300169546', 2018, N'Dudullu', 5),
(14, N'Ersoy İnşaat', N'İlyasbey V.D.', N'3690295940', 2020, N'Çayırova', 3),
(15, N'Karacalar Vinç', N'Çorum V.D.', N'5050588730', 2025, N'Çorum', 1),
(16, N'Otix Reklam', N'Uluçınar V.D.', N'6490872735', 2010, N'Gebze', 8),
(17, N'Paksan Plastik', N'İlyasbey V.D.', N'7190231892', 2025, N'Gebze', 7),
(18, N'Viodem Reklam', N'İlyasbey V.D.', N'9250526375', 2023, N'Gebze', 8),
(19, N'Çağlayan Elektronik', N'Hocapaşa V.D.', N'2190129554', 2010, N'Cağaloğlu', 10),
(24, N'Ordem İnşaat', N'Pendik V.D.', N'6450361401', 2018, N'Pendik', 3),
(25, N'Tetra Metal San.', N'İlyasbey V.D.', N'8410469905', 2003, N'Gebze', 7),
(26, N'Global Tarım', N'Tuzla V.D.', N'3960674560', 2005, N'Tuzla', 9)
SET IDENTITY_INSERT [dbo].[Firmalar] OFF
GO

-- OTOMATIK CARI ACILISI: TUM FIRMALAR ICIN 0 DEGERIYLE KAYIT OLUSTURUR
INSERT INTO [dbo].[CariKayitlar_2026] (FirmaID, ToplamHacim)
SELECT FirmaID, 0 FROM [dbo].[Firmalar]
GO