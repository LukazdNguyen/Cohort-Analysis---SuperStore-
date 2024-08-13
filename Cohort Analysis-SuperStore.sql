WITH T0 AS
(
	SELECT 
		* 
	FROM [dbo].[encoded-Sample - Superstore - Modified -] 
	WHERE YEAR(OrderDate) = 2016
)
-- SELECT * FROM T0
,T1 AS
(
	SELECT OrderID, OrderDate, CustomerID, Sales, FORMAT(OrderDate, 'yyyy-MM-01') as OrderMonth
	FROM T0
)
--Select * from T1
,T2 as
(
	Select CustomerID, FORMAT(MIN(OrderDate), 'yyyy-MM-01') as CohortMonth
	from T0
	Group by CustomerID
)
--Select * from T2
,T3 as
(
	Select 
		a.*, b.CohortMonth, DATEDIFF(Month, CAST(b.CohortMonth as date), Cast(a.OrderMonth as date)) + 1 as CohortIndex
	From T1 a
	join T2 b
		on a.CustomerID = b.CustomerID
)
--Select * from T3
,T4 as 
(
	Select CohortMonth, OrderMonth, CohortIndex, count(distinct CustomerID) as Count_DistinctCus
	From T3
	group by CohortMonth, OrderMonth, CohortIndex
)
--select * from T4
,T5 as
(
	Select
		CohortMonth, OrderMonth, CohortIndex, SUM(Sales) as TotalSale
	from T3
	group by CohortMonth, OrderMonth, CohortIndex
)
--Select * from T5
,T6 as 
(
	Select * from 
(
	Select CohortMonth, CohortIndex, Count_DistinctCus from T4
) p

PIVOT(
	SUM(Count_DistinctCus) 
	FOR CohortIndex in ([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12])
) piv
)
--Select * from T6
Select CohortMonth,
	ROUND(1.0 * [1]/[1], 2) as [1],
	ROUND(1.0 * [2]/[1], 2) as [2],
	ROUND(1.0 * [3]/[1], 2) as [3],
	ROUND(1.0 * [4]/[1], 2) as [4],
	ROUND(1.0 * [5]/[1], 2) as [5],
	ROUND(1.0 * [6]/[1], 2) as [6],
	ROUND(1.0 * [7]/[1], 2) as [7],
	ROUND(1.0 * [8]/[1], 2) as [8],
	ROUND(1.0 * [9]/[1], 2) as [9],
	ROUND(1.0 * [10]/[1], 2) as [10],
	ROUND(1.0 * [11]/[1], 2) as [11],
	ROUND(1.0 * [12]/[1], 2) as [12]
from T6
