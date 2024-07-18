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
select e1.FirstName + e1.LastName,e2.FirstName + e2.LastName from dbo.Employees as e1
inner join [dbo].[Employees] as e2  on e1.EmployeeID=e2.EmployeeID ;
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
SELECT e4.EmployeeID,concat(e4.FirstName,' ',e4.LastName) as "İsim Soyisim",sum(e1.UnitPrice*e2.Quantity)as "Satış" from [dbo].[Products] as e1
inner join [dbo].[Order Details] as e2
on e1.ProductID=e2.ProductID
inner join [dbo].[Orders] as e3
on e2.OrderID=e3.OrderID
inner join [dbo].[Employees] as e4 on e3.EmployeeID=e4.EmployeeID
group by e4.EmployeeID,e4.FirstName ,e4.LastName 
order by e4.EmployeeID;
--11.Çalışanlarım para olarak en fazla hangi ürünü satmışlar? Kişi bazında bir rapor istiyorum. ****Sorulacak
with EmployeeProductSales as (
select e4.EmployeeID,concat(e4.FirstName, ' ', e4.LastName) AS isimsoyisim,e2.ProductID,
SUM(e2.Quantity * e2.UnitPrice) AS Toplam,
ROW_NUMBER() OVER (PARTITION BY e4.EmployeeID ORDER BY SUM(e2.Quantity * e2.UnitPrice) DESC) AS rn
from [dbo].[Products] AS e1
inner join [dbo].[Order Details] AS e2 ON e1.ProductID = e2.ProductID
inner join [dbo].[Orders] AS e3 ON e2.OrderID = e3.OrderID
inner join [dbo].[Employees] AS e4 ON e3.EmployeeID = e4.EmployeeID
group by e4.EmployeeID, e4.FirstName, e4.LastName, e2.ProductID
)select EmployeeID, isimsoyisim, ProductID, Toplam
from EmployeeProductSales
where rn = 1;
--12.Hangi kargo şirketine toplam ne kadar ödeme yapmışım?
SELECT e1.ShipperID,SUM(e2.Freight) as "ödeme" FROM [dbo].[Shippers] as e1
inner join [dbo].[Orders] as e2
on e1.ShipperID=e2.ShipVia group by e1.ShipperID order by e1.ShipperID asc
--13.Tost yapmayı seven çalışanım hangisi?
SELECT FirstName,LastName from dbo.Employees where Notes like '%toast%';
--14.Hangi tedarikçiden aldığım ürünlerden ne kadar satmışım?
select e1.SupplierID,e2.ProductName, COUNT(e3.OrderID) AS TotalSales
from [dbo].[Suppliers] AS e1
inner join [dbo].[Products] AS e2 ON e2.SupplierID = e1.SupplierID
INNER JOIN [dbo].[Order Details] AS e3 ON e2.ProductID = e3.ProductID
GROUP BY e1.SupplierID,e2.ProductName
Order by e1.SupplierID;
--15.En değerli müşterim hangisi? (en fazla satış yaptığım müşteri)
select top 1 t.CustomerID,t.toplam from (
SELECT dbo.Customers.CustomerID,Sum(Quantity) AS toplam from dbo.Customers
inner join dbo.Orders on dbo.Customers.CustomerID = dbo.Orders.CustomerID
inner join dbo.[Order Details] on dbo.Orders.OrderID = dbo.[Order Details].OrderID
group by dbo.Customers.CustomerID) as t
order by t.toplam desc
--16.Hangi müşteriler para bazında en fazla hangi ürünü almışlar?*****Sorulacak
with customerpay as (
select e4.CustomerID, e2.ProductID,
SUM(e2.Quantity * e2.UnitPrice) AS Toplam,
ROW_NUMBER() OVER (PARTITION BY e4.CustomerID ORDER BY SUM(e2.Quantity * e2.UnitPrice) DESC) AS rn
from [dbo].[Products] AS e1
inner join [dbo].[Order Details] AS e2 ON e1.ProductID = e2.ProductID
inner join [dbo].[Orders] AS e3 ON e2.OrderID = e3.OrderID
inner join [dbo].[Customers] AS e4 ON e3.CustomerID = e4.CustomerID
group by e4.CustomerID,e2.ProductID
)select  CustomerID,ProductID, Toplam
from customerpay
where rn = 1;

--17.Hangi ülkelere ne kadarlık satış yapmışım?
Select e1.ShipCountry,Round(SUM((e2.UnitPrice*e2.Quantity)-((e2.UnitPrice*e2.Quantity)*e2.Discount)),2) as "toplam satıs" from [dbo].[Orders] as e1
inner join [dbo].[Order Details] as e2
on e1.OrderID = e2.OrderID
group by e1.ShipCountry
--18.Zamanında teslim edemediğim siparişlerim ID’leri nelerdir ve kaç gün geç göndermişim?
select o.OrderID,o.ShippedDate,o.RequiredDate,DATEDIFF(DAY,o.RequiredDate,o.ShippedDate)
from [dbo].[Orders] as o where o.RequiredDate < o.ShippedDate;
--19.Ortalama satış miktarının üzerine çıkan satışlarım hangisi? (Genel ortalama mı yoksa ürün bazında ortalamamı)
--Ürün Bazında ortalama
SELECT e.OrderID, e.ProductID, e.Quantity,t.ort
from [dbo].[Order Details] AS e
inner join (SELECT OrderID, AVG(Quantity) AS ort from [dbo].[Order Details] GROUP BY OrderID) AS t
ON e.OrderID = t.OrderID
WHERE e.Quantity > t.ort;
--Genel ortalama
select e.OrderID, e.ProductID, e.Quantity
from [dbo].[Order Details] as e
WHERE e.Quantity > (SELECT AVG(Quantity) as ort FROM [dbo].[Order Details]
);
--20.Satışlarımı kaç günde teslim etmişim?
select o.OrderID,o.ShippedDate,o.OrderDate,DATEDIFF(DAY,o.OrderDate,o.ShippedDate) as gün
from [dbo].[Orders] as o 
--21.Sipariş verilip de stoğumun yetersiz olduğu ürünler hangisidir? Bu ürünlerden kaç tane eksiğim
--vardır?
select e1.ProductID,e1.UnitsInStock,e1.UnitsOnOrder,(e1.UnitsOnOrder-e1.UnitsInStock) AS "GEREKLİ ADET" from [dbo].[Products] as e1
where e1.UnitsInStock<e1.UnitsOnOrder
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
select e2.OrderID,SUM(e2.UnitPrice * e2.Quantity)-SUM(e1.UnitPrice * e2.Quantity)- e3.Freight as "Kar" from [dbo].[Products] as e1
inner join [dbo].[Order Details] as e2 on e1.ProductID=e2.ProductID
inner join [dbo].[Orders] as e3 on e2.OrderID=e3.OrderID group by e2.OrderID,e3.Freight
--28. Satışı yapılmayan ürün listesi.
select e1.ProductID,e2.OrderID from [dbo].[Products] as e1
left join [dbo].[Order Details] as e2 on e1.ProductID=e2.ProductID
inner join [dbo].[Orders] as e3 on e2.OrderID=e3.OrderID where e2.OrderID=NULL order by e1.ProductID asc
--29. Hangi üründen toplam kaç adet satılmış?
select e1.ProductID,SUM(e2.Quantity) from [dbo].[Products] as e1
inner join [dbo].[Order Details] as e2 on e1.ProductID=e2.ProductID
inner join [dbo].[Orders] as e3 on e2.OrderID=e3.OrderID
group by e1.ProductID
order by e1.ProductID asc
--30.Zamanında teslim edemediğim siparişlerim ID’leri  nelerdir ve kaç gün geç göndermişim?
select o.OrderID,o.ShippedDate,o.RequiredDate,DATEDIFF(DAY,o.RequiredDate,o.ShippedDate)
from [dbo].[Orders] as o where o.RequiredDate < o.ShippedDate;
--31.Ortalama satış miktarının üzerine çıkan satışlarım hangisi?(Genel ortalama mı yoksa ürün bazında ortalamamı)
--Ürün Bazında ortalama
SELECT e.OrderID, e.ProductID, e.Quantity,t.ort
from [dbo].[Order Details] AS e
inner join (SELECT OrderID, AVG(Quantity) AS ort from [dbo].[Order Details] GROUP BY OrderID) AS t
ON e.OrderID = t.OrderID
WHERE e.Quantity > t.ort;
--Genel ortalama
select e.OrderID, e.ProductID, e.Quantity
from [dbo].[Order Details] as e
WHERE e.Quantity > (SELECT AVG(Quantity) as ort FROM [dbo].[Order Details]
);
