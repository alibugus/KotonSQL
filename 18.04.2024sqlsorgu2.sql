--Koton müşterisi 30 adet espresso siparişi versin ve bu siparişler Speedy Express firması ile gönderilsin. Kargo ücreti 80 dolardır, ancak Koton anlaşmalı olduğundan %15 indirimi vardır. Bu siparişle developer ünvanına sahip --çalışanım ilgileniyor. Sipariş verildikten sonra 5 gün içerisinde kargolanmalı.
--
--Bir önceki maddede belirtilen sipariş 2 gün sonra teslim ediliyor. Gerekli güncellemeyi sisteme yansıtın.
--
--Yukarıdaki tüm maddelerde yapılan işlemleri geri alacak sorguyu (sorguları) yazın.
--
--Elemanlarımız için kurumsal mail adresi oluşturacağız. Bunun için adının ilk harfi.Soyadı@northwind.com şeklinde bir format belirlendi. Çalışan adı soyadı ve mail adresi şeklinde listeleyin.
--
--Bugünün tarihini kolon isimleri Yıl, Ay ve Gün olacak şekilde listeleyin.
--
--Birebir firma sahibi ile temas kurulan tedarikçileri listeleyin.
--
SELECT 
YEAR(GETDATE()) AS Yıl,
MONTH(GETDATE()) AS Ay,
DAY(GETDATE()) AS Gün;
--Baş harfi A olan, stoklarda bulunan, 10-250 dolar arası ücreti olan ürünleri alfabetik olarak sıralayın.
--

--Haftanın son günü teslim ettiğim siparişler hangileridir?
--
SELECT *
FROM [dbo].[Orders]
WHERE DATEPART(dw, ShippedDate) = 7;
--Ülkesi Brezilya olan müşterilerimin adreslerinin sonuna ülke adını ekleyin.
--
--Bölge bilgisi olmayan tüm müşterilerimin bölge bilgilerine posta kodlarının ilk iki hanesini ekleyin.
--
--Satışı devam etmeyen ürünlerimin stokta olanların stok bilgisini sıfırlayın.
--
--Müşterilerimden internet sitesi olmayanların site bilgilerini 'https://www.w3schools.com/sql/' olarak güncelleyin.
--
--Kritik seviyeye gelen ürünler için sipariş verdiğimizde gelecek olan ürünlerde kazanacağım parayı UnitPrice kolonuna ekleyin.
--
--Çarşamba günü alınan, kargo ücreti 20-75$ arası olan, shipdate'i null olmayan siparişlerin ID'lerini büyükten küçüğe sıralayın.
--
select e1.OrderID
from [dbo].[Orders] as e1
where DATEPART(dw, e1.OrderDate) = 4
and e1.Freight BETWEEN 20 and 75
and e1.ShippedDate is not NULL
order by OrderID desc;
--Firmamın aldığı ilk siparişi raporlayın.
--
Select top 1 * from [dbo].[Orders] as e1 order by e1.OrderDate asc;
--Bir müşterim şişede sattığım ürünlerin hepsinden birer tane sipariş verdi. Ürünlerin stok miktarlarını güncelleyin.
--
--Teslim zamanı 2 hafta olan siparişleri listeleyin.
--
Select * from [dbo].[Orders] as e1 where DATEDIFF(DAY,e1.OrderDate,e1.ShippedDate) >14;
--Teslim edilen siparişlerin kaç günde teslim edildiğini raporlayın. SiparişNo | TeslimEdilenGunSayisi
--
Select e1.OrderID,DATEDIFF(DAY,e1.OrderDate,e1.ShippedDate) as TeslimEdilenGunSayisi  from [dbo].[Orders] as e1;
--Stok miktarı kritik seviyeye veya altına düşmesine rağmen hala siparişini vermediğim ürünlerin siparişlerini verin.
--
--Londra'da yaşayan personellerimden herhangi birinin adını soyadını tüm tedarikçilerimin ContactName alanına ekleyin.
--
--Şirketimizdeki pozisyon sayısını bulup, yeni bir ürün ekleyin. Bulduğunuz pozisyon sayısı yeni eklenen ürünün stok sayısı olsun.
--
--Beverages kategorisine ait ürünleri listeleyin.
--
SELECT * FROM [dbo].[Categories]  as e1
inner join [dbo].[Products] as e2 on e1.CategoryID=e2.CategoryID 
where e1.CategoryName = 'Beverages';
--İndirimli gönderdiğim siparişlerdeki ürün adlarını, birim fiyatını ve indirim tutarını gösterin.
--
Select e3.ProductName,e2.Discount,e2.UnitPrice from [dbo].[Orders] as e1
inner join [dbo].[Order Details] as e2
on e1.OrderID=e2.OrderID 
inner join [dbo].[Products] as e3 on e2.ProductID=e3.ProductID
where e2.Discount <> 0;
--Federal Shipping ile taşınmış ve Nancy'nin almış olduğu siparişleri gösterin.
--
select * from [dbo].[Customers] as e1
inner join [dbo].[Orders] as e2 
on e1.CustomerID=e2.CustomerID
inner join [dbo].[Shippers] as e3
on e2.ShipVia=e3.ShipperID
where e3.CompanyName='Federal Shipping' and e1.CustomerID='Nancy'
--Doğu konumundaki bölgeleri listeleyin.
--

--Şehri Londra olan tedarikçilerimden temin ettiğim ve stoğumda yeterli sayıda bulunan, birim fiyatı 30 ile 60 arasında olan ürünlerim nelerdir?
--
select e1.ProductID, e1.ProductName, e1.UnitPrice, e1.UnitsInStock
from [dbo].[Products] e1
inner join [dbo].[Suppliers] e2 on e1.SupplierID = e2.SupplierID
where e2.City = 'London'
and e1.UnitsInStock > 0
and e1.UnitPrice BETWEEN 30 AND 60;
--Chai ürünümü hangi müşterilerime satmışım?
--
--Ağustos ayında teslim ettiğim siparişlerimdeki ürünlerden, kategorisi içecek olanların isimlerini, teslim tarihlerini ve hangi şehre teslim edildiğini, kargo ücretine göre ters sıralı şekilde listeleyin.
--
--Şirket sahibi ile iletişime geçtiğim Meksikalı müşterilerimin verdiği siparişlerden kargo ücreti 30 doların altında olanlarla hangi çalışanlarım ilgilenmiştir?
--
--Seafood ürünlerimden sipariş gönderdiğim müşterilerimi listeleyin.
--
--Hangi siparişim hangi müşterime, ne zaman, hangi çalışanım tarafından gerçekleştirilmiş?
--
--Bölge bilgisi Northern olan çalışanlarımın onayladığı siparişlerdeki kritik stok seviyesinde olan ürünleri listeleyin. Ürün adı ve çalışan adı listelensin ve tekrar eden kayıtlar olmasın.
--
--Hangi tedarikçiden hangi ürünü kaç adet temin etmişim? Tedarikçi | ÜrünAdedi
--
--Nancy adındaki personelim hangi firmaya toplam kaç adet ürün satmıştır? FirmaAdı | ÜrünAdet
--
--Batı bölgesinden sorumlu çalışanlara ait müşteri sayısı bilgisini getirin. Çalışan | MüşteriSayısı
--
--Kategori adı Confections olan ürünleri hangi ülkelere fiyat olarak toplam ne kadar gönderdik? Ülke | ToplamFiyat
--
--Her bir ürün için ortalama talep sayısı (ortalama sipariş adeti) bilgisini ürün adıyla beraber listeleyin. ÜrünAdı | OrtalamaTalepSayısı
--
--250'den fazla sipariş taşımış olan kargo firmalarının adlarını, telefon numaralarını ve taşıdıkları sipariş sayılarını getiren sorguyu yazın. FirmaAdı | Telefon | SiparişSayısı
--
--Müşterilerimin toplam sipariş adetlerini müşteri adı ile birlikte raporlayın. CustomerName | TotalOrdersCount
--
select e1.CustomerID AS CustomerName,COUNT(e3.OrderID) AS TotalOrdersCount
from Customers e1
inner join [dbo].[Orders] as e2  ON e1.CustomerID = e2.CustomerID
inner join [dbo].[Order Details] e3 ON e2.OrderID = e3.OrderID
group by e1.CustomerID
order by TotalOrdersCount DESC;
--Kargo şirketlerine göre taşınan sipariş sayıları nedir? ShipperName | TotalOrdersCount
--
--Ürün Id ve isimlerini, bugünkü fiyatı ile birlikte bugüne kadar yer aldığı siparişlerdeki en ucuz fiyat ve bu fiyat ile arasındaki farkı da hesaplayarak listeleyin. ProductID | ProductName | UnitPrice | LowestPrice | Difference
--
--Sevilla şehri hariç İspanya'ya gönderilen kargoların toplam adedi, toplam tutarı ve ortalama tutarını şehirlere göre raporlayın. City | TotalCount | TotalPrice | Average
--
--Her yıl hangi ülkeye kaç adet sipariş göndermişim? Year | Country | TotalOrdersCount
--
--En değerli müşterim kim? (Bana en çok para kazandıran)
--
--Şehir bazında sipariş adetlerim nelerdir? City | Count
--
--Hangi sipariş, hangi müşteriye, ne zaman, hangi çalışanının onayı ile verilmiştir? OrderNo | OrderDate | Customer | Employee
--
--Son 10 siparişte satılan ürünleri, kategorileri ile birlikte listeleyin. OrderNo | ProductName | Category
--
--İlk 15 sipariş hangi firmalardan alınmış?
--
--Kuzey (Northern) bölgesinden sorumlu çalışan(lar) kim?
--
--New York şehrinden sorumlu çalışan(lar) kim?
--
--Amerika'da yaşayan çalışanların almış olduğu siparişleri listeyin. EmployeeFullName | OrderNo
--
--İndirim uygulanan siparişlerde hangi ürüne ne kadar indirim uygulanmış? OrderNo | ProductName | DiscountAmount
--
--Federal Shipping ile taşınmış ve Nancy'nin almış olduğu siparişleri listeleyin. OrderNo | OrderDate | ShipperName | Employee
--
--Çalışan numarası 1 olan çalışanının satmış olduğu ürünleri listeleyin.
--
--Dörtten az sipariş veren müşteriler hangileridir? Customer | OrderCount
--
--Müşterilerin ilk gerçekleştirdiği siparişleri tarihleriyle beraber listeleyin. Customer | FirstOrderDate
--
--Kargo ücreti, içerdiği en pahalı üründen yüksek olan siparişleri listeleyin. OrderID | MostExpensiveProduct | MostExpensiveProductPrice | Freight
--
--ALFKI koduna sahip müşterim hangi kategorilerden ürün satın alıyor?
--
--Kategori bazında ne kadarlık satış yapmışım? Category | TotalPrice | TotalCount
--
--Çalışanlarımın her birinin kazandırdıkları toplam ücreti nedir? Employee | TotalWinnings
--
--Çalışanlarımın her birinin en çok ciro yaptıkları ürünler hangileridir? Employee | Endorsement | Product
--
--Hangi kargo şirketi hangi ürünü en fazla taşımıştır? Shipper | Product | TransferCount
--
--01.01.1996-01.01.1997 tarihleri arasında en fazla hangi ürün satın alınmıştır?
--
--Londra'da çalışan ve en az satış yapan çalışanım hangisidir?
--
--Speedy Express ile taşınmış ürünlerden güncel fiyatına göre en pahalı olan ürün ve bu ürünün siparişini almış olan çalışanı raporlayın. Product | Employee
--
--Her yılın en çok taşıma yapan kargo firması hangisidir? Year | Shipper | TransferCount
--
--Her kategorinin en çok kazanç sağlayan ürünlerinin güncel stok durumları nedir? Category | Product | Winnings | Stock
--
--20'den fazla kez sipariş verilmiş ürünler hangi ülkelere gönderilmiştir? Product | Country | OrderCount
--
--Hangi tedarikçiden en fazla ürünü hangi çalışan sipariş etmiştir? Supplier | Employee | ProductCount
--
--İndirimli siparişlerin kaç günde teslim edildiğini listeleyin. OrderNo | DeliveryDays

--Londra'da ikamet eden çalışanların ad ve soyadları
--
select e1.FirstName,e1.LastName from [dbo].[Employees] as e1
where e1.City = 'London'
--Birim fiyatı 50 ile 80 arası olan ürünler
--
select e1.ProductName  from [dbo].[Products] as e1
where e1.UnitPrice between 50 and 80;
--04.07.1996 ile 31.12.1996 tarihleri arasında verilen siparişler
--
select e1.OrderID  from [dbo].[Orders] as e1
where e1.OrderDate between '1996-07-04 00:00:00.000' AND '1996-12-31 23:59:59.999'

--Ürün adları ve fiyatları ile KDV bilgisi
--
SELECT 
    ProductName,
    UnitPrice,
    UnitPrice * 0.20 as KDV
FROM 
    [dbo].[Products];

--Dairy Products kategorisine ait ürünler
--
select e1.ProductName, e1.UnitPrice, e2.CategoryName
from Products e1
inner join Categories e2 ON e1.CategoryID = e2.CategoryID
where e2.CategoryName = 'Dairy Products';

--Çalışanların açık adresleri ve telefonları
--
--Her bir müşterinin şirket adı ve açık adreslerini '/' ile birleştirerek listelemek
--
--Çalışanların adını ve soyadını başında unvanları ile birlikte listelemek
--
--Almanca bilen çalışanlar
--
-- İsmi 'chai' olan veya kategorisi 3 olan ve 29'dan fazla stoğu olan ürünler
--
select e1.ProductID, e1.ProductName, e1.CategoryID, e1.UnitsInStock
from [dbo].[Products] as e1
where (ProductName = 'chai' OR CategoryID = 3)
AND UnitsInStock > 29;
-- Londra ve Seattle dışında yaşayan çalışanlar
--
-- Henüz teslimatı gerçekleşmemiş siparişler
--
-- Kendi bilgilerinizle çalışan eklemek
--
INSERT INTO [dbo].[Employees] (LastName, FirstName,Title,TitleOfCourtesy,BirthDate,HireDate,Address,City,Region,PostalCode,Country)
VALUES ('Bugus', 'Ali','stajyer','stajyer','2002-09-14','2024-07-16','kucukcekmece','İstanbul','Marmara','34000','Turkey');
-- Eklenen kayıttaki unvan bilgisini 'developer' olarak güncellemek
--
UPDATE [dbo].[Employees]
set Title = 'Developer'
where LastName = 'Bugus';

-- Kahve isminde bir kategori oluşturmak
--
-- Espresso isimli ürünü kahve kategorisine eklemek
--
-- BLGDM kodu ile Koton isimli müşteriyi eklemek
            