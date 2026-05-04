-- MUSTAFA ERAYDIN - EP_2026 SIFIRLAMA VE TAM KURULUM
USE [EP_2026];
GO

-- 1. ADIM: Eski ve hatalı tabloları siliyoruz (Temiz bir başlangıç için)
-- İlişkiler nedeniyle silme sırası önemlidir.
IF OBJECT_ID('dbo.IslemLoglari', 'U') IS NOT NULL DROP TABLE dbo.IslemLoglari;
IF OBJECT_ID('dbo.CariKayitlar_2026', 'U') IS NOT NULL DROP TABLE dbo.CariKayitlar_2026;
IF OBJECT_ID('dbo.Firmalar', 'U') IS NOT NULL DROP TABLE dbo.Firmalar;
IF OBJECT_ID('dbo.Sektorler', 'U') IS NOT NULL DROP TABLE dbo.Sektorler;
GO

-- 2. ADIM: Tabloları doğru sütunlarla yeniden oluşturuyoruz
CREATE TABLE [dbo].[Sektorler](
    [SektorID] [int] IDENTITY(1,1) PRIMARY KEY,
    [SektorAdi] [nvarchar](50) NOT NULL
);

CREATE TABLE [dbo].[Firmalar](
    [FirmaID] [int] IDENTITY(1,1) PRIMARY KEY,
    [FirmaAdi] [nvarchar](100) NOT NULL,
    [VergiDairesi] [nvarchar](50) NULL,
    [VergiNo] [nvarchar](20) NULL,
    [KurulusYili] [int] NULL,
    [FirmaMerkezi] [nvarchar](150) NULL,
    [SektorID] [int],
    CONSTRAINT [FK_Firmalar_Sektorler] FOREIGN KEY([SektorID]) REFERENCES [dbo].[Sektorler]([SektorID])
);

CREATE TABLE [dbo].[CariKayitlar_2026](
    [CariID] [int] IDENTITY(1,1) PRIMARY KEY,
    [FirmaID] [int] UNIQUE,
    [ToplamHacim] [decimal](18, 2) DEFAULT 0,
    CONSTRAINT [FK_Cari_Firmalar] FOREIGN KEY([FirmaID]) REFERENCES [dbo].[Firmalar]([FirmaID])
);

CREATE TABLE [dbo].[IslemLoglari](
    [LogID] [int] IDENTITY(1,1) PRIMARY KEY,
    [FirmaID] [int],
    [EklenenMiktar] [decimal](18, 2),
    [IslemTarihi] [datetime] DEFAULT GETDATE(),
    CONSTRAINT [FK_Log_Firmalar] FOREIGN KEY([FirmaID]) REFERENCES [dbo].[Firmalar]([FirmaID])
);
GO

-- 3. ADIM: Verileri ekran görüntülerine göre giriyoruz
SET IDENTITY_INSERT [dbo].[Sektorler] ON;
INSERT INTO [dbo].[Sektorler] ([SektorID], [SektorAdi]) VALUES 
(1, N'Vinç'), (2, N'Platform'), (3, N'İnşaat'), (4, N'Temizlik'), (5, N'Komprosör'), 
(6, N'Savunma Sanayi'), (7, N'Kimya'), (8, N'Reklam'), (9, N'Tarım'), (10, N'Elektronik');
SET IDENTITY_INSERT [dbo].[Sektorler] OFF;

SET IDENTITY_INSERT [dbo].[Firmalar] ON;
INSERT INTO [dbo].[Firmalar] ([FirmaID], [FirmaAdi], [VergiDairesi], [VergiNo], [KurulusYili], [FirmaMerkezi], [SektorID]) VALUES 
(1, N'Karali Vinç', N'İlyasbey V.D.', '5171681248', 2024, N'Çayırova', 1),
(2, N'Sürmeneli Vinç', N'İlyasbey V.D.', '7870325713', 2000, N'Gebze', 1),
(3, N'Çalık Grup', N'Kartal V.D.', '99900011122', 2015, N'Gebze', 4),
(4, N'Yimser Platform', N'İlyasbey V.D.', '9810651988', 2021, N'Çayırova', 2),
(5, N'Özgü Vinç', N'İlyasbey V.D.', '77788899900', 2020, N'Gebze', 1),
(6, N'Hleks Gıda', N'Anadolu Kurumlar', '4630023829', 2000, N'Beykoz', 7),
(7, N'GM Bakır Alaşımları', N'Uluçınar V.D.', '4000316136', 2010, N'Gebze', 7),
(8, N'Eksan Yapı İnşaat', N'Uluçınar V.D.', '3610024434', 2020, N'Gebze', 3),
(9, N'Çalışkan Vinç', N'Uluçınar V.D.', '21419572360', 2024, N'Dilovası', 1),
(10, N'SCT İnşaat', N'İlyasbey V.D.', '7570393953', 2022, N'Gebze', 3),
(11, N'Aydesan Savunma Sanayi', N'İlyasbey V.D.', '0690523797', 2015, N'Gebze', 6),
(12, N'Ayhan Çiftçi', N'İlyasbey V.D.', '29353693998', 2022, N'Gebze', 1),
(13, N'Tekopa Komprasör', N'Sarıgazi V.D.', '3300169546', 2018, N'Dudullu', 5),
(14, N'Ersoy İnşaat', N'İlyasbey V.D.', '3690295940', 2020, N'Çayırova', 3),
(15, N'Karacalar Vinç', N'Çorum V.D.', '5050588730', 2025, N'Çorum', 1),
(16, N'Otix Reklam', N'Uluçınar V.D.', '6490872735', 2010, N'Gebze', 8),
(17, N'Paksan Plastik', N'İlyasbey V.D.', '7190231892', 2025, N'Gebze', 7),
(18, N'Viodem Reklam', N'İlyasbey V.D.', '9250526375', 2023, N'Gebze', 8),
(19, N'Çağlayan Elektronik', N'Hocapaşa V.D.', '2190129554', 2010, N'Cağaloğlu', 10),
(24, N'Ordem İnşaat', N'Pendik V.D.', '6450361401', 2018, N'Pendik', 3),
(25, N'Tetra Metal San.', N'İlyasbey V.D.', '8410469905', 2003, N'Gebze', 7),
(26, N'Global Tarım', N'Tuzla V.D.', '3960674560', 2005, N'Tuzla', 9);
SET IDENTITY_INSERT [dbo].[Firmalar] OFF;
GO

-- 4. ADIM: Cari kayıtları 0 ile başlatıyoruz
INSERT INTO [dbo].[CariKayitlar_2026] (FirmaID, ToplamHacim)
SELECT FirmaID, 0 FROM [dbo].[Firmalar];
GO