-- View data in Customer table
SELECT * FROM Customer;

-- View data in Product table
SELECT * FROM Product;

-- Insert new grape flavor product into table
INSERT INTO Product(
    ProductID,
    ProductCode,
    ProductName,
    Size,
    Variety,
    Price,
    Status
  )
VALUES (
    17,
    'MWPRA20',
    'Mineral Water',
    20,
    'Grape',
    '1.79',
    'ACTIVE'
  );
  
  -- Sort Orders table
SELECT * FROM Orders
ORDER BY CreationDate DESC;

-- Find null values in Customer table
SELECT * 
FROM Customer
WHERE FirstName IS NULL OR
LastName IS NULL OR
Email IS NULL OR 
Phone IS NULL;

-- Remove null values from customer table
SELECT FirstName,
LastName,
Email,
Phone 
FROM Customer
WHERE Email IS NOT NULL AND 
Phone IS NOT NULL;

-- Create new month columns
SELECT *,
MONTH(CreationDate) as MonthNumber,
MONTHNAME(CreationDate) as MonthName  
FROM Orders;

-- Insert new customer into Customer table
INSERT INTO Customer(
    CustomerID,
    FirstName,
    LastName,
    Email,
    Phone,
    Address,
    City,
    State,
    Zipcode
  )
VALUES (
    1100,
    'Jane',
    'Paterson',
    'jane.paterson@gmail.com',
    '(912)459-2910',
    '4029 Park Street',
    'Kansas City',
    'MO',
    '64161'
  );
  
SELECT * FROM Customer
WHERE CustomerID= 1100;

-- Find how many products sold
SELECT 
COUNT(DISTINCT ProductID) as TotalUniqueProducts,
SUM(Quantity) as TotalQuantity
FROM OrderItem;

-- Determine which items are discontinued
SELECT *
FROM Product
WHERE Status = "DISCONTINUED";

-- Determine which sales people made no sales
SELECT Salesperson.SalespersonID,
FirstName,
LastName
FROM Salesperson
LEFT OUTER JOIN Orders
ON Salesperson.SalespersonID = Orders.SalespersonID 
WHERE Orders.SalespersonID IS NULL;

-- Find top product size sold
SELECT Size,
SUM(Quantity) as TotalQuantity
FROM OrderItem
LEFT OUTER JOIN Product
ON OrderItem.ProductID = Product.ProductID
GROUP BY Size
ORDER BY TotalQuantity DESC;

-- Find top 3 items sold
SELECT Variety,
Size,
SUM(Quantity) as TotalQuantity
FROM OrderItem
LEFT OUTER JOIN Product
ON OrderItem.ProductID = Product.ProductID
GROUP BY Product.ProductID
ORDER BY TotalQuantity DESC
LIMIT 3;

-- Find sales by month and year
SELECT
MONTHNAME(CreationDate) as MonthName,
YEAR(CreationDate) as OrderYear,
COUNT(Orders.OrderID) as TotalOrders,
SUM(Quantity) as TotalQuantity,
SUM(TotalDue) as TotalAmount
FROM Orders
LEFT OUTER JOIN OrderItem
ON Orders.OrderID = OrderItem.OrderID
GROUP BY MonthName, OrderYear
ORDER BY OrderYear, MONTH(CreationDate);

-- Find average daily sales
SELECT 
SUM(Quantity) /
COUNT(DISTINCT CreationDate) as AverageDailySales
FROM Orders
LEFT OUTER JOIN OrderItem
ON Orders.OrderID = OrderItem.OrderID;

-- Find top customers
SELECT
FirstName,
LastName,
COUNT(DISTINCT Orders.OrderID) as TotalOrders,
SUM(Quantity) as TotalQuantity,
SUM(TotalDue) as TotalAmount
FROM Orders
LEFT OUTER JOIN OrderItem
ON Orders.OrderID = OrderItem.OrderID
LEFT OUTER JOIN Customer
ON Orders.CustomerID = Customer.CustomerID
GROUP BY Customer.CustomerID
ORDER BY TotalAmount DESC;

-- Find infrequent customers
SELECT
Customer.CustomerID,
FirstName,
LastName,
COUNT(DISTINCT OrderID) as TotalOrders
FROM Orders
LEFT OUTER JOIN Customer
ON Orders.CustomerID = Customer.CustomerID
GROUP BY Customer.CustomerID
HAVING COUNT(DISTINCT OrderID) = 1;

-- Determine top customer state
SELECT
State,
SUM(Quantity) as TotalQuantity
FROM Orders
LEFT OUTER JOIN OrderItem
ON Orders.OrderID = OrderItem.OrderID
LEFT OUTER JOIN Customer
ON Orders.CustomerID = Customer.CustomerID
GROUP BY State
ORDER BY TotalQuantity DESC
LIMIT 1;

-- Determine what products sold together
SELECT a.ProductID as ProductID1,
b.ProductID as ProductID2,
COUNT(*) as TimesPurchased
FROM OrderItem as a
INNER JOIN OrderItem as b
ON a.OrderID = b.OrderID
AND a.ProductID < b.ProductID
GROUP BY a.ProductID, b.ProductID
ORDER BY TimesPurchased DESC;

-- Calculate repeat customer rate
WITH Repeat_Customers as
(
  SELECT
CustomerID as Repeat_Cus
FROM Orders
GROUP BY CustomerID
HAVING COUNT(OrderID) > 1
)
SELECT 
(COUNT(DISTINCT Repeat_Cus)/
COUNT(DISTINCT CustomerID))*100
as CustomerRepeatRate
FROM Orders
LEFT OUTER JOIN Repeat_Customers
ON Orders.CustomerID = Repeat_Customers.Repeat_Cus;

-- Determine new customers
SELECT
FirstName,
LastName,
COUNT(OrderID) as TotalOrders
FROM Customer
LEFT OUTER JOIN Orders
ON Customer.CustomerID = Orders.CustomerID 
GROUP BY Customer.CustomerID
HAVING COUNT(OrderID) = 0;

