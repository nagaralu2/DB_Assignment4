/*
1. Write a query to return users who have admin roles
in my seeding data there were no admin roles, so the query is for owner
*/
SELECT users.userName as userName, roles.roleName as roleName FROM [users]
JOIN [roles] ON users.roleId = roles.ID
WHERE roles.roleName = 'owner'

/*
2. Write a query to return users who have admin roles and information about their taverns
again updated to owner role
*/
SELECT users.userName as userName, roles.roleName as roleName, taverns.tavernName as tavern FROM [users]
JOIN [roles] ON users.roleId = roles.ID
JOIN [taverns] ON taverns.ownerId = users.ID
WHERE roles.roleName = 'owner' 


/*
3. Write a query that returns all guests ordered by name (ascending) and their classes and corresponding levels
*/
SELECT guests.guestName AS guestName, class.className AS class, levels.level AS level FROM [guests]
JOIN [levels] ON levels.guestID = guests.ID
JOIN [class] ON levels.classID = class.ID
ORDER BY guests.guestName ASC

/*

4. Write a query that returns the top 10 sales in terms of sales price and what the services were
*/
SELECT TOP (10) services.serviceName AS serviceName, sales.price AS price FROM [sales]
JOIN [services] ON sales.servicesId = services.ID
ORDER BY sales.price ASC

/*
5. Write a query that returns guests with 2 or more classes
*/
SELECT * FROM (SELECT guests.guestName AS guestName, COUNT(levels.guestId) AS numberofClasses FROM [guests]
JOIN [levels] ON levels.guestId = guests.ID
GROUP BY guests.guestName) AS g
WHERE g.numberofClasses > 1

/*
6. Write a query that returns guests with 2 or more classes with levels higher than 5
*/
SELECT * FROM (SELECT guests.guestName AS guestName, COUNT(levels.guestId) AS numberofClasses, MAX(levels.level) as level FROM [guests]
JOIN [levels] ON levels.guestId = guests.ID
GROUP BY guests.guestName) AS g
WHERE g.numberofClasses > 1 AND g.level > 5
ORDER BY g.guestName ASC

/*
7. Write a query that returns guests with ONLY their highest level class
*/


/*

8. Write a query that returns guests that stay within a date range. Please remember that guests can stay 
for more than one night AND not all of the dates they stay have to be in that range (just some of them)
*/
/*

9. Using the additional queries provided, take the lab’s SELECT ‘CREATE query’ and add any IDENTITY and 
PRIMARY KEY constraints to it.


For Number 9:
---
select sysObj.name, sysCol.name, *
from sys.objects sysObj inner join sys.columns sysCol on sysObj.object_id = sysCol.object_id
--select  * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Taverns';
--select * from INFORMATION_SCHEMA.KEY_COLUMN_USAGE WHERE TABLE_NAME = 'Taverns';
--select * from INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS;
--select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
---*/

DECLARE @max_column INT, @tableName VARCHAR(240)
SET @tableName = 'Taverns'
SELECT @max_column = MAX(ORDINAL_POSITION) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = @tableName
SELECT CONCAT('CREATE TABLE ', @tableName, ' (')  AS queryPiece
UNION ALL
SELECT CONCAT(cols.COLUMN_NAME, ' ', DATA_TYPE,
(CASE WHEN CHARACTER_MAXIMUM_LENGTH IS NOT NULL THEN CONCAT('(', CHARACTER_MAXIMUM_LENGTH, ')') END),
(CASE WHEN tableConst.CONSTRAINT_NAME = keys.CONSTRAINT_NAME  THEN CONCAT(' ', tableConst.CONSTRAINT_TYPE) END),
(CASE WHEN sysCol.is_identity = 1 THEN ' IDENTITY(1,1)' END),
(CASE WHEN constKeys.CONSTRAINT_NAME = refConst.UNIQUE_CONSTRAINT_NAME THEN CONCAT(' REFERENCES ', constKeys.TABLE_NAME, '(', constKeys.COLUMN_NAME, ')') END),
(CASE WHEN cols.ORDINAL_POSITION != @max_column THEN ',' END)) AS queryPiece
FROM INFORMATION_SCHEMA.COLUMNS AS cols 
LEFT JOIN information_schema.key_column_usage AS keys ON (keys.TABLE_NAME = cols.TABLE_NAME AND keys.COLUMN_NAME = cols.COLUMN_NAME)
LEFT JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS tableConst ON (tableConst.CONSTRAINT_NAME = keys.CONSTRAINT_NAME)
LEFT JOIN information_schema.referential_constraints AS refConst ON (refConst.CONSTRAINT_NAME = keys.CONSTRAINT_NAME)
-- did not understood this last left join below, whay again? why keys does not work ?
LEFT JOIN information_schema.key_column_usage AS constKeys ON (constKeys.CONSTRAINT_NAME = refConst.UNIQUE_CONSTRAINT_NAME)
LEFT JOIN sys.objects AS sysObj ON sysObj.name = keys.CONSTRAINT_NAME 
LEFT join sys.columns AS sysCol ON sysCol.object_id = sysObj.object_id 
WHERE cols.TABLE_NAME = @tableName
UNION ALL
SELECT ')'  AS queryPieces