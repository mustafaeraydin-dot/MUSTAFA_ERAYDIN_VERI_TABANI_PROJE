CREATE TABLE Kullanicilar (
    KullaniciID INT IDENTITY(1,1) PRIMARY KEY,
    KullaniciAdi NVARCHAR(50) NOT NULL,
    Sifre NVARCHAR(50) NOT NULL
);

-- Test edebilmemiz için içine hazır bir tane admin ekleyelim
INSERT INTO Kullanicilar (KullaniciAdi, Sifre) VALUES ('admin', '1234');