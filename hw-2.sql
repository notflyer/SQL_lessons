-- 1	Посчитайте общую сумму продаж в США в 1 квартале 2012 года? Решить 2-мя  способами Джойнами и Подзапросами

-- подзапрос
select
  sum((select sum(UnitPrice * Quantity) from sales_items where sales_items.SalesId = s.SalesId)) as "TotalAmount"
from
  sales as s
where
  s.ShipCountry = 'USA'
  and
  s.SalesDate between date('2012-01-01') and date ('2012-03-31')
;

-- джойн
select 
sum(i.UnitPrice * i.Quantity) as "TotalAmount"
from
	sales as s
    inner join sales_items as i on i.SalesId = s.SalesId
where
   s.ShipCountry = 'USA'
   and
   s.SalesDate between date('2012-01-01') and date ('2012-03-31')
;

-- 2	Покажите имена клиентов, которых нет среди работников.
--	Решить 3-мя способами: подзапросами, джойнами и логическим вычитанием.

-- джойном
select distinct
  c.FirstName as Name
from
  customers as c
  left outer join employees as e on e.FirstName = c.FirstName
where
  e.EmployeeId is null;

-- подзапросом
select distinct
	FirstName
from
	customers
where
	(select EmployeeID from employees where employees.FirstName = customers.FirstName) is null;

-- логическим вычитанием
select
  FirstName
from
  customers
except
select
  FirstName
from
  employees;
  

-- 3	Теоретический вопрос
--	Вернет ли данный запрос  одинаковый результат?  Да или НЕТ. 
--	Если  ДА. Объяснить почему.
--	Если НЕТ. Объяснить почему. Какой  запрос вернет больше строк ?

 	select *
 	from T1 LEFT JOIN T2
		ON T1.column1=T2.column1
	 where   T1.column1=0
 	
	 select *
	 from T1 LEFT JOIN T2
		ON T1.column1=T2.column1 and   T1.column1=0;
        
-- Второй запрос вернет больше записей, так как в первом таблица T1 фильтруется по значению column1=0, а во втором T1 выводится целиком


-- 4	Посчитайте количество треков в каждом альбоме. В результате должно быть:  имя альбома и кол-во треков.
-- Решить  2-мя способами: подзапросом и джойнами

-- подзапросом
select
  Title,
  (
    select
      count(*)
    from
      tracks
    where
      tracks.AlbumId = albums.AlbumId
  ) as "Qty"
from
  albums;
  
-- джойном
select
  a.Title,
  count(t.TrackId) as "Qty"
from
  albums as a
  left join tracks as t on t.AlbumId = a.AlbumId
group by
  a.Title;
  

-- 5	Покажите фамилию и имя покупателей немцев сделавших заказы в 2009 году, товары которых были отгружены в город Берлин?

select distinct c.LastName, c.FirstName
from customers as c
	inner join
    sales as s on s.CustomerId = c.CustomerId
where 
	c.Country = 'Germany'
    and
    s.ShipCity = 'Berlin';


-- 6	Покажите фамилии  клиентов которые  купили больше 30 музыкальных треков ?
--	Решить  задачу ,как минимум, 2-мя способами: джойнами и подзапросами

-- подзапросом
select 
	(select LastName from customers where customers.CustomerId = sales.CustomerId) as "LastName"
from sales
group by CustomerId
having sum((select sum(Quantity) from sales_items where sales_items.SalesId = sales.SalesId)) > 30
;

-- джойном
select 
	c.LastName
from customers as c
	inner join sales as s on s.CustomerId = c.CustomerId
    inner join sales_items as i on i.SalesId = s.SalesId
group by
	c.LastName
having sum(i.Quantity) > 30
;    


-- 7	В базе есть таблица музыкальных треков и жанров Назовите среднюю стоимстость музыкального трека в каждом жанре?
select g.Name, avg(t.UnitPrice)
from genres as g
	inner join tracks as t on t.GenreId = g.GenreId
group by g.Name
;


-- 8	В базе есть таблица музыкальных треков и жанров. Покажите жанры у которых средняя стоимость одного трека больше 1-го рубля

select g.Name
from genres as g
	inner join tracks as t on t.GenreId = g.GenreId
group by g.Name
having avg(t.UnitPrice) > 1
;

