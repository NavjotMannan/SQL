 Co-orelated Subquery questions(With Self joins):
 
  create multiset volatile table emp
 (
 emp_id INTEGER,
 dept_id INTEGER,
 salary DECIMAL(18,2)
 )
 primary index(emp_id) ON COMMIT PRESERVE ROWS;
 
insert into emp values (1, 101, 2000);
insert into emp values (2, 102, 5000);
insert into emp values (3, 103, 7500);
insert into emp values (4, 102, 17500);
insert into emp values (5, 103, 10100);
insert into emp values (7, 103, 18000);
insert into emp values (6, 101, 980);

 
 --1. Employee with Salary greater than avg of all departments:
 
select e.emp_id, e.salary from emp e where salary > (select avg(salary) from emp e1);

 *** Query completed. 3 rows found. 2 columns returned. 
 *** Total elapsed time was 1 second.

     emp_id                salary
-----------  --------------------
          4              17500.00
          5              10100.00
          7              18000.00
 
 --2. Employee with Salary greater than avg of own departments:
 
select e.emp_id, e.salary from emp e where salary > (select avg(salary) from emp e1 where e1.dept_id = e.dept_id);

 *** Query completed. 3 rows found. 2 columns returned. 
 *** Total elapsed time was 1 second.

     emp_id                salary
-----------  --------------------
          4              17500.00
          7              18000.00
          1               2000.00
          
--3: Max salary for each department:

select e.emp_id, e.salary from emp e where salary =  
(select max(salary) AS salary from emp e1 where e1.dept_id = e.dept_id);

 *** Query completed. 3 rows found. 2 columns returned. 
 *** Total elapsed time was 1 second.

     emp_id                salary
-----------  --------------------
          1               2000.00
          4              17500.00
          5              10100.00

--4: Min salary for each department:

select e.emp_id, e.salary from emp e where salary =  
(select min(salary) AS salary from emp e1 where e1.dept_id = e.dept_id);


 *** Query completed. 3 rows found. 2 columns returned. 
 *** Total elapsed time was 1 second.

     emp_id                salary
-----------  --------------------
          6                980.00
          3               7500.00
          2               5000.00

--5. Top 3 salaries:

select e.emp_id, e.salary from emp e 
qualify row_number() over (order by e.salary desc) <=3;

 *** Query completed. 3 rows found. 2 columns returned. 
 *** Total elapsed time was 1 second.

     emp_id                salary
-----------  --------------------
          7              18000.00
          4              17500.00
          5              10100.00 

--6: Top N Salary:

3rd Top Salary:

select e.emp_id, e.salary from emp e where 2 = (select count(*) from emp e1 where e1.salary > e.salary);

OR

select e.emp_id, e.salary from emp e qualify row_number() over (order by e.salary desc) =3;

 *** Query completed. One row found. 2 columns returned. 
 *** Total elapsed time was 1 second.

     emp_id                salary
-----------  --------------------
          5              10100.00

--Mysql:

select e.emp_id, e.salary from emp e order by salary desc limit 2, 1;

--7: for below table, desired output:

delhi-ahmedabad 1
delhi-kolkata 4

create table travel
(
source varchar(50),
destination varchar(50),
duration integer
); 

insert into travel values 
('Delhi','Ahmedabad',1),
('Kolkata','Delhi',4),
('Ahmedabad','Delhi',1),
('Delhi','Kolkata',4);

select * from travel;

--LEAST OPTIMAL(WITH GROUP AND WHERE CONDITION):
select concat(t1.source,"-",t1.destination) AS name,t1.duration from travel t1, travel t2
where t1.source = t2.source AND t1.source <> t2.destination AND t1.source = 'Delhi'
group by 1,2;
--MORE OPTIMAL(WITHOUT GROUP BY AND WHERE): **But, most critical for interview
select concat(t1.source,"-",t1.destination) AS name,t1.duration from travel t1, travel t2
where t1.source = t2.destination AND t1.destination <> t2.source;
--MOST OPTIMAL(ONLY WHERE):
select t1.source, t1.destination from travel t1 where t1.source = 'Delhi';

--8: XML-aggregate

insert into emp values (7, 501, 980);
insert into emp values (7, 601, 1080);

output =>

7 18000, 980, 1080

select emp_id, trim(trailing ',' from (xmlagg(TRIM(salary)||',') (varchar(1000)))) from emp where emp_id = 7 group by 1;

     emp_id  Trim(TRAILING ',' FROM XMLAGG((Trim(BOTH FROM salary)||',') RETURNING SEQUENCE))
-----------  ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
          7  18000.00, 980.00, 1080.00

--9. Splitting comma separated values to multiple rows:

SELECT t.str_val
FROM TABLE(
    STRTOK_SPLIT_TO_TABLE(100, 'A,B,C', ',')
    RETURNS (outkey integer, token integer, str_val char(1))
) AS t
;

 *** Query completed. 3 rows found. One column returned. 
 *** Total elapsed time was 1 second.

str_val
-------
A
B
C

--10. Nesting String & Regex expression:
select substring('2345roja123' from regexp_instr('2345roja123', '\d+',1,2))
;

 *** Query completed. One row found. One column returned. 
 *** Total elapsed time was 1 second.

Substring('2345roja123' From regexp_instr('2345roja123','\d+',1,2))
-------------------------------------------------------------------
123

 BTEQ -- Enter your SQL request or BTEQ command: 
select substring('2345roja123' from regexp_instr('2345roja123', '\d+',1,2) for 2);

select substring('2345roja123' from regexp_instr('2345roja123', '\d+',1,2) 
for 2);

 *** Query completed. One row found. One column returned. 
 *** Total elapsed time was 1 second.

Substring('2345roja123' From regexp_instr('2345roja123','\d+',1,2) For 2)
-------------------------------------------------------------------------
12

--11. Finding rowcount in each table of DB:

Select    

     'Select ' || '''' || trim(databasename) || '.' || trim(tablename) || ''',' ||

     ' Count(*) From ' || trim(databasename) || '.' ||

     trim (tablename)||' Group by 1' || ';' (Title '')

     From dbc.tables

     Where tablekind =  'T'

     and databasename = <DB_NAME>;
     
