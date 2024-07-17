--1.Tüm cirom ne kadar?
Select SUM((UnitPrice*Quantity)-((UnitPrice*Quantity)*Discount)) as "Tüm Ciro"  from dbo.[Order Details] 
--2.1997 de tüm cirom ne kadar?
Select SUM((UnitPrice*Quantity)-((UnitPrice*Quantity)*Discount)) as "1997 yılındaki tüm ciro"  from dbo.[Order Details] 
inner join Orders on dbo.[Order Details].OrderID=Orders.OrderID 
Where Orders.ShippedDate BETWEEN '1997-01-01 00:00:00.000' AND '1997-12-30 23:59:59.999'
;
--3.Bugün doğum günü olan çalışanlarım kimler?
Select FirstName,LastName,BirthDate from dbo.Employees
where MONTH(BirthDate) =MONTH(GETDATE()) AND DAY(BirthDate) =DAY(GETDATE());
--4.Hangi çalışanım hangi çalışanıma bağlı?

--5.Çalışanlarım ne kadarlık satış yapmışlar?
SELECT dbo.Employees.FirstName,SUM((dbo.[Order Details].UnitPrice*Quantity)-((dbo.[Order Details].UnitPrice*Quantity)*Discount)) as "Satış tutarı" 
from dbo.Employees 
inner join dbo.Orders on dbo.Orders.EmployeeID=dbo.Employees.EmployeeID 
inner join dbo.[Order Details] on dbo.[Order Details].OrderID=dbo.Orders.OrderID
GROUP BY FirstName;
--6.Hangi ülkelere ihracat yapıyorum?
Select DISTINCT ShipCountry as "Ülkeler"from dbo.Orders;
--7.Ürünlere göre satışım nasıl?
Select dbo.Products.ProductName ,count(dbo.Products.ProductName) as "Satış Adedi" from dbo.Orders inner join dbo.[Order Details] 
ON dbo.[Order Details].OrderID=dbo.Orders.OrderID
inner join dbo.Products on dbo.Products.ProductID =dbo.[Order Details].ProductID group by dbo.Products.ProductName;
--8.Ürün kategorilerine göre satışlarım nasıl? (para bazında)
Select dbo.Categories.CategoryName,ROUND(SUM((dbo.[Order Details].UnitPrice*Quantity)-((dbo.[Order Details].UnitPrice*Quantity)*Discount)),2) AS "Toplam Fiyat" from dbo.Categories 
inner join dbo.Products on dbo.Categories.CategoryID=dbo.Products.CategoryID
inner join dbo.[Order Details] on dbo.[Order Details].ProductID=dbo.Products.ProductID
inner join dbo.Orders on dbo.Orders.OrderID = dbo.[Order Details].OrderID
group by dbo.Categories.CategoryName;
--9.Ürün kategorilerine göre satışlarım nasıl? (adet bazında)
Select dbo.Categories.CategoryName,COUNT(dbo.Categories.CategoryName) AS "SATIŞ ADEDİ" from dbo.Categories 
inner join dbo.Products on dbo.Categories.CategoryID=dbo.Products.CategoryID
inner join dbo.[Order Details] on dbo.[Order Details].ProductID=dbo.Products.ProductID
inner join dbo.Orders on dbo.Orders.OrderID = dbo.[Order Details].OrderID
group by dbo.Categories.CategoryName;
--10.Çalışanlar ürün bazında ne kadarlık satış yapmışlar?
--11.Çalışanlarım para olarak en fazla hangi ürünü satmışlar? Kişi bazında bir rapor istiyorum.
--12.Hangi kargo şirketine toplam ne kadar ödeme yapmışım?
--13.Tost yapmayı seven çalışanım hangisi?
SELECT FirstName,LastName from dbo.Employees where Notes like '%toast%';
--14.Hangi tedarikçiden aldığım ürünlerden ne kadar satmışım?
--15.En değerli müşterim hangisi? (en fazla satış yaptığım müşteri)
select top 1 t.CustomerID,t.toplam from (

SELECT dbo.Customers.CustomerID,Sum(Quantity) AS toplam from dbo.Customers
inner join dbo.Orders on dbo.Customers.CustomerID = dbo.Orders.CustomerID
inner join dbo.[Order Details] on dbo.Orders.OrderID = dbo.[Order Details].OrderID
group by dbo.Customers.CustomerID) as t
order by t.toplam desc
--16.Hangi müşteriler para bazında en fazla hangi ürünü almışlar?

--17.Hangi ülkelere ne kadarlık satış yapmışım?
--18.Zamanında teslim edemediğim siparişlerim ID’leri nelerdir ve kaç gün geç göndermişim?
--19.Ortalama satış miktarının üzerine çıkan satışlarım hangisi?
--20.Satışlarımı kaç günde teslim etmişim?
--21.Sipariş verilip de stoğumun yetersiz olduğu ürünler hangisidir? Bu ürünlerden kaç tane eksiğim
--vardır?
--22.Ürünlerin kdv dahil ve hariç fiyatları
SELECT t.ProductName,t.KDVsiz,(t.UnitPrice+t.kdv) 
AS kdvli from (SELECT ProductName,UnitPrice,UnitPrice as KDVsiz ,UnitPrice * 0.2 AS kdv
FROM dbo.Products
WHERE UnitPrice * 0.2 < 20) as t;
--23.KDV’si 10 TL’den düşük olan ürünler hangileridir?
SELECT ProductName, UnitPrice * 0.2 AS kdv
FROM dbo.Products
WHERE UnitPrice * 0.2 < 20;

--24. En pahalı beş ürün nedir?
SELECT TOP 5 dbo.Products.ProductID,dbo.Products.ProductName,dbo.Products.UnitPrice from dbo.Products order by dbo.Products.UnitPrice DESC
--25. En ucuz beş ürünün ortalama fiyatı nedir?
SELECT AVG(t.fiyat) as 'En düşük 5 ürün' from (SELECT top 5 dbo.Products.UnitPrice as fiyat
FROM dbo.Products order by dbo.Products.UnitPrice asc) as t
--26. En pahalı ürünün adı nedir?
SELECT TOP 1 dbo.Products.ProductName from dbo.Products order by dbo.Products.UnitPrice DESC
--27. Hangi sipariş bana ne kadar kazandırmış?
--28. Satışı yapılmayan ürün listesi.
--29. Hangi üründen toplam kaç adet satılmış?
--30.Zamanında teslim edemediğim siparişlerim ID’leri  nelerdir ve kaç gün geç göndermişim?
--31.Ortalama satış miktarının üzerine çıkan satışlarım hangisi?(
