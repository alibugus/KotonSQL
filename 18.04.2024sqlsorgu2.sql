--Koton müşterisi 30 adet espresso siparişi versin ve bu siparişler Speedy Express firması ile gönderilsin. Kargo ücreti 80 dolardır, ancak Koton anlaşmalı olduğundan %15 indirimi vardır. Bu siparişle developer ünvanına sahip --çalışanım ilgileniyor. Sipariş verildikten sonra 5 gün içerisinde kargolanmalı.(Trigger kullanılabilir)
--
INSERT INTO [dbo].[Orders] (CustomerID, EmployeeID, OrderDate, RequiredDate, ShippedDate, ShipVia, Freight, ShipCountry)
VALUES ('BLGDM',
		(SELECT TOP 1 EmployeeID FROM [dbo].[Employees] WHERE Title = 'Developer'),
		GETDATE(),
		DATEADD(DAY, 5, GETDATE()),
		NULL,
		(SELECT TOP 1 E1.ShipperID
		FROM [dbo].[Shippers] AS E1 WHERE CompanyName = 'Speedy Express'),80,'Turkey')
insert into [dbo].[Order Details] 
values ((select OrderID from [dbo].[Orders] where CustomerID='BLGDM'),
(select ProductID from [dbo].[Products] 
where ProductName='Espresso'),5,30,0.15)
--Bir önceki maddede belirtilen sipariş 2 gün sonra teslim ediliyor. Gerekli güncellemeyi sisteme yansıtın.
--
UPDATE [dbo].[Orders]
SET ShippedDate = DATEADD(DAY, 2, OrderDate)  -- Sipariş tarihinden 2 gün sonrası
WHERE CustomerID = 'BLGDM'

--Yukarıdaki tüm maddelerde yapılan işlemleri geri alacak sorguyu (sorguları) yazın.
--
DELETE FROM [dbo].[Order Details]
WHERE OrderID = (SELECT OrderID FROM [dbo].[Orders] WHERE CustomerID = 'BLGDM')
AND ProductID = (SELECT ProductID FROM [dbo].[Products] WHERE ProductName = 'Espresso');


DELETE FROM [dbo].[Orders]
WHERE CustomerID = 'BLGDM' 
--Elemanlarımız için kurumsal mail adresi oluşturacağız. Bunun için adının ilk harfi.Soyadı@northwind.com şeklinde bir format belirlendi. Çalışan adı soyadı ve mail adresi şeklinde listeleyin.
--
Select e1.FirstName,e1.LastName,LOWER(CONCAT(LEFT(e1.FirstName,1),'.',e1.LastName,'@northwind.com'))AS MAİL from [dbo].[Employees] as e1;
--Bugünün tarihini kolon isimleri Yıl, Ay ve Gün olacak şekilde listeleyin.
--
SELECT 
YEAR(GETDATE()) AS Yıl,
MONTH(GETDATE()) AS Ay,
DAY(GETDATE()) AS Gün;
--Birebir firma sahibi ile temas kurulan tedarikçileri listeleyin.
--
SELECT SupplierID,CompanyName, ContactName, ContactTitle, Phone
FROM [dbo].[Suppliers];
--Baş harfi A olan, stoklarda bulunan, 10-250 dolar arası ücreti olan ürünleri alfabetik olarak sıralayın.
--
SELECT * FROM [dbo].[Products] AS e1
where LEFT(e1.ProductName,1)='A' AND e1.UnitsInStock <>0 and e1.UnitPrice between 10 and 250;
--Haftanın son günü teslim ettiğim siparişler hangileridir?
--
SELECT *
FROM [dbo].[Orders]
WHERE DATEPART(dw, ShippedDate) = 7;
--Ülkesi Brezilya olan müşterilerimin adreslerinin sonuna ülke adını ekleyin.
--
UPDATE [dbo].[Customers]
SET Address = CONCAT(Address, ', Brazil')
WHERE Country = 'Brazil';

--Bölge bilgisi olmayan tüm müşterilerimin bölge bilgilerine posta kodlarının ilk iki hanesini ekleyin.
--
UPDATE [dbo].[Customers]
SET Region = LEFT(PostalCode,2)
WHERE Region is null
--Satışı devam etmeyen ürünlerimin stokta olanların stok bilgisini sıfırlayın.
--
UPDATE [dbo].[Products]
SET UnitsInStock = 0
WHERE Discontinued = 1 AND UnitsInStock > 0;
--Müşterilerimden internet sitesi olmayanların site bilgilerini 'https://www.w3schools.com/sql/' olarak güncelleyin.(Tabloda internet sitesi yok yerine fax güncellendi)
--
ALTER TABLE [dbo].[Customers]
ALTER COLUMN Fax VARCHAR(255);
UPDATE [dbo].[Customers]
SET Fax='https://www.w3schools.com/sql/'
wHERE Fax is null;
--Kritik seviyeye gelen ürünler için sipariş verdiğimizde gelecek olan ürünlerde kazanacağım parayı UnitPrice kolonuna ekleyin.***
--
--Çarşamba günü alınan, kargo ücreti 20-75$ arası olan, shipdate'i null olmayan siparişlerin ID'lerini büyükten küçüğe sıralayın.
--
select e1.OrderID
from [dbo].[Orders] as e1
where DATEPART(dw, e1.OrderDate) = 4
and e1.Freight BETWEEN 20 and 75
and e1.ShippedDate is not NULL
order by OrderID desc;
--not datepart
--1: Pazar
--2: Pazartesi
--3: Salı
--4: Çarşamba
--5: Perşembe
--6: Cuma
--7: Cumartesi
--Firmamın aldığı ilk siparişi raporlayın.
--
Select top 1 * from [dbo].[Orders] as e1 order by e1.OrderDate asc;
--Bir müşterim şişede sattığım ürünlerin hepsinden birer tane sipariş verdi. Ürünlerin stok miktarlarını güncelleyin.
--
UPDATE Products
SET UnitsInStock = UnitsInStock - 1
WHERE QuantityPerUnit LIKE '%bottle%' AND UnitsInStock > 0;
--Teslim zamanı 2 hafta olan siparişleri listeleyin.
--
Select * from [dbo].[Orders] as e1 where DATEDIFF(DAY,e1.OrderDate,e1.ShippedDate) >14;
--Teslim edilen siparişlerin kaç günde teslim edildiğini raporlayın. SiparişNo | TeslimEdilenGunSayisi
--
Select e1.OrderID,DATEDIFF(DAY,e1.OrderDate,e1.ShippedDate) as TeslimEdilenGunSayisi  from [dbo].[Orders] as e1;
--Stok miktarı kritik seviyeye veya altına düşmesine rağmen hala siparişini vermediğim ürünlerin siparişlerini verin.
--
UPDATE [dbo].[Products]
SET [UnitsInStock] = [UnitsInStock]+20
WHERE [UnitsInStock]<5;
--Londra'da yaşayan personellerimden herhangi birinin adını soyadını tüm tedarikçilerimin ContactName alanına ekleyin.
--
UPDATE [dbo].[Suppliers]
SET ContactName = (
    SELECT TOP 1 CONCAT(FirstName, ' ', LastName)
    FROM [dbo].[Employees]
    WHERE City = 'London'
)
--Şirketimizdeki pozisyon sayısını bulup, yeni bir ürün ekleyin. Bulduğunuz pozisyon sayısı yeni eklenen ürünün stok sayısı olsun.
--
INSERT INTO [dbo].[Products] 
    (ProductName, SupplierID, CategoryID, QuantityPerUnit, UnitPrice, UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued)
VALUES
    ('kılıc', 1, 1, '10 boxes x 20 bags', 18.00, (select distinct count(Title) from [dbo].[Employees]), 0, 10, 0);

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
select *
from [dbo].[Region] as r
where r.RegionDescription like '%east%';

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
select * from [dbo].[Customers] as e1
inner join [dbo].[Orders] as e2 on e2.CustomerID=e1.CustomerID
inner join [dbo].[Order Details] as e3 on e2.OrderID =e3.OrderID
inner join [dbo].[Products] as e4 on e3.ProductID=e4.ProductID
where e4.ProductName='Chai';
--Ağustos ayında teslim ettiğim siparişlerimdeki ürünlerden, kategorisi içecek olanların isimlerini, teslim tarihlerini ve hangi şehre teslim edildiğini, kargo ücretine göre ters sıralı şekilde listeleyin.
--
Select e1.ProductName,e3.ShippedDate,e3.ShipCity from [dbo].[Categories] as e4 inner join [dbo].[Products] as e1 on e1.CategoryID=e4.CategoryID
inner join [dbo].[Order Details] as e2 on e1.ProductID=e2.ProductID
inner join [dbo].[Orders] as e3 on e2.OrderID=e3.OrderID
where MONTH(e3.ShippedDate)=8 and e4.CategoryID=1
order by e3.Freight desc
--Şirket sahibi ile iletişime geçtiğim Meksikalı müşterilerimin verdiği siparişlerden kargo ücreti 30 doların altında olanlarla hangi çalışanlarım ilgilenmiştir?
--
select e1.orderid , e1.orderdate,e2.companyname,e3.firstname , e3.lastname
from [dbo].[orders] as e1
inner join [dbo].[customers] as e2 on e1.customerid = e2.customerid
inner join [dbo].[employees] as e3 on e1.employeeid = e3.employeeid
where e2.country = 'Mexico' and e1.freight < 30

--Seafood ürünlerimden sipariş gönderdiğim müşterilerimi listeleyin.
--
Select e1.ProductName,e5.CompanyName,e4.CategoryName  from [dbo].[Categories] as e4 inner join [dbo].[Products] as e1 on e1.CategoryID=e4.CategoryID
inner join [dbo].[Order Details] as e2 on e1.ProductID=e2.ProductID
inner join [dbo].[Orders] as e3 on e2.OrderID=e3.OrderID
inner join [dbo].[Customers] as e5 on e3.CustomerID=e5.CustomerID
where e4.CategoryName='Seafood';

--Hangi siparişim hangi müşterime, ne zaman, hangi çalışanım tarafından gerçekleştirilmiş?
--
Select e6.CompanyName, e3.OrderID,e1.ProductName,e3.ShippedDate,e5.FirstName 
from [dbo].[Categories] as e4 
inner join [dbo].[Products] as e1 on e1.CategoryID=e4.CategoryID
inner join [dbo].[Order Details] as e2 on e1.ProductID=e2.ProductID
inner join [dbo].[Orders] as e3 on e2.OrderID=e3.OrderID
inner join [dbo].[Employees] as e5 on e3.EmployeeID=e5.EmployeeID
inner join [dbo].[Customers] as e6 on e3.CustomerID=e6.CustomerID;

--Bölge bilgisi Northern olan çalışanlarımın onayladığı siparişlerdeki kritik stok seviyesinde olan ürünleri listeleyin. Ürün adı ve çalışan adı listelensin ve tekrar eden kayıtlar olmasın.
--

--Hangi tedarikçiden hangi ürünü kaç adet temin etmişim? Tedarikçi | ÜrünAdedi
--
Select e1.SupplierID,e1.CompanyName,e2.ProductID,e2.UnitsInStock from [dbo].[Suppliers] as e1 
inner join [dbo].[Products] as e2
on e1.SupplierID = e2.SupplierID
--Nancy adındaki personelim hangi firmaya toplam kaç adet ürün satmıştır? FirmaAdı | ÜrünAdet
--
Select e4.FirstName,e3.CompanyName,SUM(e1.Quantity) from [dbo].[Order Details] as e1 
inner join [dbo].[Orders] as e2 on e1.OrderID = e2.OrderID
inner join [dbo].[Customers] as e3 on e2.CustomerID=e3.CustomerID
inner join [dbo].[Employees] as e4 on e2.EmployeeID=e4.EmployeeID
where e4.FirstName='Nancy'
group by e4.FirstName,e3.CompanyName;

--Batı bölgesinden sorumlu çalışanlara ait müşteri sayısı bilgisini getirin. Çalışan | MüşteriSayısı
--
select e2.EmployeeID,Count(e2.CustomerID) as 'Musteri sayısı' from [dbo].[Employees] as e1
inner join [dbo].[Orders] as e2 on e1.EmployeeID=e2.EmployeeID
inner join [dbo].[Customers] as e3 on e2.CustomerID=e3.CustomerID
where e2.ShipRegion = 'West'
group by e2.EmployeeID
--Kategori adı Confections olan ürünleri hangi ülkelere fiyat olarak toplam ne kadar gönderdik? Ülke | ToplamFiyat
--
select e4.ShipCountry,SUM(e3.Quantity* e3.UnitPrice) as 'Toplam Fiyat' from [dbo].[Categories] as e1
inner join [dbo].[Products] as e2 on e1.CategoryID= e2.CategoryID
inner join [dbo].[Order Details] as e3 on e2.ProductID=e3.ProductID
inner join [dbo].[Orders] as e4 on e3.OrderID=e4.OrderID
inner join [dbo].[Customers] as e5 on e4.CustomerID=e5.CustomerID
where e1.CategoryName='Confections'
group by e4.ShipCountry;
--Her bir ürün için ortalama talep sayısı (ortalama sipariş adeti) bilgisini ürün adıyla beraber listeleyin. ÜrünAdı | OrtalamaTalepSayısı
--
select e1.ProductName, avg(e2.Quantity) from [dbo].[Products] as e1
inner join [dbo].[Order Details] as e2 on e1.ProductID=e2.ProductID
inner join [dbo].[Orders] as e3 on e2.OrderID=e3.OrderID
group by e1.ProductName;
--250'den fazla sipariş taşımış olan kargo firmalarının adlarını, telefon numaralarını ve taşıdıkları sipariş sayılarını getiren sorguyu yazın. FirmaAdı | Telefon | SiparişSayısı
--
with st as (
select e1.CompanyName, count(e2.OrderID) as toplam,e1.Phone from [dbo].[Shippers] as e1
inner join [dbo].[Orders] as e2 on e1.ShipperID=e2.ShipVia
group by e1.CompanyName,e1.Phone)
select CompanyName,Phone,toplam from st where toplam >250;

--Müşterilerimin toplam sipariş adetlerini müşteri adı ile birlikte raporlayın. CustomerName | TotalOrdersCount
--
select e4.CompanyName,sum(e2.Quantity) from [dbo].[Products] as e1
inner join [dbo].[Order Details] as e2 on e1.ProductID=e2.ProductID
inner join [dbo].[Orders] as e3 on e2.OrderID=e3.OrderID
inner join [dbo].[Customers] AS e4 ON e3.CustomerID=e4.CustomerID
group by e4.CompanyName
--Kargo şirketlerine göre taşınan sipariş sayıları nedir? ShipperName | TotalOrdersCount
--
select e1.CompanyName,count(e2.OrderID) from [dbo].[Shippers] as e1
inner join [dbo].[Orders] as e2 on e1.ShipperID=e2.ShipVia
group by e1.CompanyName
--Ürün Id ve isimlerini, bugünkü fiyatı ile birlikte bugüne kadar yer aldığı siparişlerdeki en ucuz fiyat ve bu fiyat ile arasındaki farkı da hesaplayarak listeleyin. ProductID | ProductName | UnitPrice | LowestPrice | Difference
--
--Sevilla şehri hariç İspanya'ya gönderilen kargoların toplam adedi, toplam tutarı ve ortalama tutarını şehirlere göre raporlayın. City | TotalCount | TotalPrice | Average
--
select e1.ShipCity,avg(e2.Quantity*e2.UnitPrice) as ort ,sum(e2.Quantity*e2.UnitPrice) as toplam  from [dbo].[Orders] as e1 
inner join [dbo].[Order Details] as e2 on e1.OrderID=e2.OrderID
where e1.ShipCity <>'Sevilla'
group by e1.ShipCity

--Her yıl hangi ülkeye kaç adet sipariş göndermişim? Year | Country | TotalOrdersCount
--
select YEAR(e1.ShippedDate) as yıl,e1.ShipCountry,sum(e2.Quantity*e2.UnitPrice) as toplam  from [dbo].[Orders] as e1 
inner join [dbo].[Order Details] as e2 on e1.OrderID=e2.OrderID
group by e1.ShipCountry,YEAR(e1.ShippedDate);


--En değerli müşterim kim? (Bana en çok para kazandıran)
--
select top 1 t.CustomerID,t.toplam from (
SELECT dbo.Customers.CustomerID,Sum(Quantity*UnitPrice) AS toplam from dbo.Customers
inner join dbo.Orders on dbo.Customers.CustomerID = dbo.Orders.CustomerID
inner join dbo.[Order Details] on dbo.Orders.OrderID = dbo.[Order Details].OrderID
group by dbo.Customers.CustomerID) as t
order by t.toplam desc
--Şehir bazında sipariş adetlerim nelerdir? City | Count
--
select e1.ShipCity,count(e1.OrderID) as siparissayı  from [dbo].[Orders] as e1
group by e1.ShipCity
--Hangi sipariş, hangi müşteriye, ne zaman, hangi çalışanının onayı ile verilmiştir? OrderNo | OrderDate | Customer | Employee
select e1.OrderID as OrderNo,
e1.OrderDate,e2.CompanyName as Customer,e3.FirstName ,e3.LastName
from [dbo].[Orders] as e1
inner join [dbo].[Customers] AS e2 on e1.CustomerID = e2.CustomerID
INNER JOIN [dbo].[Employees] AS e3 ON e1.EmployeeID = e3.EmployeeID
order by e1.OrderID;

--
--Son 10 siparişte satılan ürünleri, kategorileri ile birlikte listeleyin. OrderNo | ProductName | Category
--
select top 10 e1.OrderID,E3.ProductName,e4.CategoryName from [dbo].[Orders] as e1 
inner join [dbo].[Order Details] as e2
on e1.OrderID=e2.OrderID
inner join [dbo].[Products] as e3 on e2.ProductID=e3.ProductID
inner join [dbo].[Categories] as e4 on e3.CategoryID=e4.CategoryID
order by e1.OrderDate

--İlk 15 sipariş hangi firmalardan alınmış?
--
select top 15 e1.CustomerID,e2.CompanyName from [dbo].[Orders] as e1
inner join [dbo].[Customers] as e2 on 
e1.CustomerID=e2.CustomerID
order by e1.OrderDate 
--Kuzey (Northern) bölgesinden sorumlu çalışan(lar) kim?
--
select * from [dbo].[Employees] as e1
inner join [dbo].[EmployeeTerritories] as e2
on e1.EmployeeID=e2.EmployeeID
inner join [dbo].[Territories] as e3
on e2.TerritoryID=e3.TerritoryID
inner join [dbo].[Region] as e4 
on e3.RegionID=e4.RegionID
where e4.RegionDescription='Northern';
--New York şehrinden sorumlu çalışan(lar) kim?
--
select * from [dbo].[Employees] as e1
inner join [dbo].[EmployeeTerritories] as e2
on e1.EmployeeID=e2.EmployeeID
inner join [dbo].[Territories] as e3
on e2.TerritoryID=e3.TerritoryID
inner join [dbo].[Region] as e4 
on e3.RegionID=e4.RegionID
where e3.TerritoryDescription='New York'
--Amerika'da yaşayan çalışanların almış olduğu siparişleri listeyin. EmployeeFullName | OrderNo
--
select e1.FirstName,e1.LastName,e2.OrderID from [dbo].[Employees] as e1
inner join [dbo].[Orders] as e2 on e1.EmployeeID=e2.EmployeeID
where e1.Country='USA';
--İndirim uygulanan siparişlerde hangi ürüne ne kadar indirim uygulanmış? OrderNo | ProductName | DiscountAmount
--
select e2.OrderID,e1.ProductName,(e2.Quantity*e2.UnitPrice)*e2.Discount as discount from [dbo].[Products] as e1
inner join [dbo].[Order Details] as e2 on
e1.ProductID=e2.ProductID
inner join [dbo].[Orders] as e3
on e2.OrderID=e3.OrderID
where e2.Discount<>0
--Federal Shipping ile taşınmış ve Nancy'nin almış olduğu siparişleri listeleyin. OrderNo | OrderDate | ShipperName | Employee
--
select e1.orderid,e1.orderdate,e2.companyname,e3.firstname, e3.lastname
from [dbo].[Orders] as e1
inner join [dbo].[Shippers] as e2 on e1.shipvia = e2.shipperid
inner join [dbo].[Employees] as e3 on e1.employeeid = e3.employeeid
inner join [dbo].[Customers] as e4 on e1.customerid = e4.customerid
where e2.companyname = 'Federal Shipping' and e3.FirstName= 'Nancy';

--Çalışan numarası 1 olan çalışanının satmış olduğu ürünleri listeleyin.
--
select e1.ProductID,e1.ProductName from[dbo].[Products] as e1
inner join [dbo].[Order Details] as e2 on
e1.ProductID=e2.ProductID
inner join [dbo].[Orders] as e3
on e2.OrderID=e3.OrderID
inner join [dbo].[Employees] as e4
on e3.EmployeeID=e4.EmployeeID
where e4.EmployeeID=1;
--Dörtten az sipariş veren müşteriler hangileridir? Customer | OrderCount
--
with st as  (select e4.CompanyName,count(e2.OrderID) as t from [dbo].[Products] as e1
inner join [dbo].[Order Details] as e2 on e1.ProductID=e2.ProductID
inner join [dbo].[Orders] as e3 on e2.OrderID=e3.OrderID
inner join [dbo].[Customers] AS e4 ON e3.CustomerID=e4.CustomerID
group by e4.CompanyName)

select st.CompanyName,st.t from st
where st.t<4;
--Müşterilerin ilk gerçekleştirdiği siparişleri tarihleriyle beraber listeleyin. Customer | FirstOrderDate
--
select e1.CompanyName,min(e2.OrderDate) from [dbo].[Customers] as e1
inner join [dbo].[Orders] as e2
on e1.CustomerID=e2.CustomerID
group by e1.CompanyName
--Kargo ücreti, içerdiği en pahalı üründen yüksek olan siparişleri listeleyin. OrderID | MostExpensiveProduct | MostExpensiveProductPrice | Freight
--
--ALFKI koduna sahip müşterim hangi kategorilerden ürün satın alıyor?
--
select distinct 
e5.categoryname from [dbo].[customers] as e1
inner join [dbo].[orders] as e2 on e1.customerid = e2.customerid
inner join [dbo].[order details] as e3 on e2.orderid = e3.orderid
inner join [dbo].[products] as e4 on e3.productid = e4.productid
inner join [dbo].[categories] as e5 on e4.categoryid = e5.categoryid
where e1.customerid = 'ALFKI';
--Kategori bazında ne kadarlık satış yapmışım? Category | TotalPrice | TotalCount
--
select e1.categoryname as Category, sum(e3.unitprice * e3.quantity) as fiyat,sum(e3.quantity) as adet
from [dbo].[categories] as e1
inner join [dbo].[products] as e2 on e1.categoryid = e2.categoryid
inner join [dbo].[order details] as e3 on e2.productid = e3.productid
inner join [dbo].[orders] as e4 on e3.orderid = e4.orderid
group by e1.categoryname;

--Çalışanlarımın her birinin kazandırdıkları toplam ücreti nedir? Employee | TotalWinnings
--
select 
e1.firstname, e1.lastname as Employee,sum((e3.unitprice * e3.quantity)-(e3.Discount*e3.UnitPrice)) as toplamkazanc
from [dbo].[employees] as e1
inner join [dbo].[orders] as e2 on e1.employeeid = e2.employeeid
inner join [dbo].[order details] as e3 on e2.orderid = e3.orderid
group by e1.firstname, e1.lastname

--Çalışanlarımın her birinin en çok ciro yaptıkları ürünler hangileridir? Employee | Endorsement | Product *** sorulacak
--
--Hangi kargo şirketi hangi ürünü en fazla taşımıştır? Shipper | Product | TransferCount *** sorulacak
--
--01.01.1996-01.01.1997 tarihleri arasında en fazla hangi ürün satın alınmıştır?
--
select top 1 e3.ProductName,sum(Quantity) as t from [dbo].[Orders] as e1
inner join [dbo].[Order Details] as e2
on e1.OrderID=e2.OrderID
inner join [dbo].[Products] as e3 
on e2.ProductID=e3.ProductID
where e1.OrderDate between '1996-01-01' and '1997-01-01'
group by e3.ProductName
order by t desc

--Londra'da çalışan ve en az satış yapan çalışanım hangisidir?
--
select top 1 e1.EmployeeID,e1.FirstName, e1.LastName as Employee,sum(e3.UnitPrice * e3.Quantity) as toplam from [dbo].[Employees] as e1
inner join [dbo].[Orders] as e2 on e1.EmployeeID  = e2.EmployeeID 
inner join [dbo].[Order Details] as e3 on e2.OrderID = e3.OrderID where e1.City = 'London' 
group by e1.EmployeeID, e1.FirstName, e1.LastName
order by toplam;
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
select distinct e2.OrderID,DATEDIFF(DAY, e2.OrderDate, e2.ShippedDate) as gün
from [dbo].[Order Details] as e1
inner join [dbo].[Orders] as e2 on e1.OrderID = e2.OrderID
inner join [dbo].[Products] as e3 on e1.ProductID = e3.ProductID
where e1.Discount>0
and e2.ShippedDate is not null
order by e2.OrderID;

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
SELECT e1.Address,e1.HomePhone FROM [dbo].[Employees] as e1;

--Her bir müşterinin şirket adı ve açık adreslerini '/' ile birleştirerek listelemek
--
select CONCAT([CompanyName],'/',[Address]) from [dbo].[Customers] as e1
--Çalışanların adını ve soyadını başında unvanları ile birlikte listelemek
--
SELECT CONCAT(e1.Title,' ',e1.FirstName,' ',e1.LastName) FROM [dbo].[Employees] as e1;
--Almanca bilen çalışanlar
--
SELECT * FROM [dbo].[Employees] as e1 where e1.Notes like '%german%' or e1.Country ='Germany';
-- İsmi 'chai' olan veya kategorisi 3 olan ve 29'dan fazla stoğu olan ürünler
--
select e1.ProductID, e1.ProductName, e1.CategoryID, e1.UnitsInStock
from [dbo].[Products] as e1
where (ProductName = 'chai' OR CategoryID = 3)
AND UnitsInStock > 29;
-- Londra ve Seattle dışında yaşayan çalışanlar
--
SELECT * FROM [dbo].[Employees] as e1 where e1.City <> 'London' and e1.City <> 'Seattle';
-- Henüz teslimatı gerçekleşmemiş siparişler
--
SELECT * FROM [dbo].[Orders] as e1 where e1.ShippedDate is null
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
insert into [dbo].[Categories] (CategoryName)values ('Kahve')
-- Espresso isimli ürünü kahve kategorisine eklemek
--
insert into [dbo].[Products] (ProductName,CategoryID)values ('Espresso',(SELECT CategoryID FROM [dbo].[Categories] as e1 WHERE e1.CategoryName = 'Kahve'));

-- BLGDM kodu ile Koton isimli müşteriyi eklemek
  insert into [dbo].[Customers] ([CustomerID],[CompanyName])values ('BLGDM','Koton')          
