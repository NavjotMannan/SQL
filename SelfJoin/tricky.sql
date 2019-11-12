Self Join & Regex:

--1: for below table, desired output:

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

--2: XML-aggregate

insert into emp values (7, 501, 980);
insert into emp values (7, 601, 1080);

output =>

7 18000, 980, 1080

select emp_id, trim(trailing ',' from (xmlagg(TRIM(salary)||',') (varchar(1000)))) from emp where emp_id = 7 group by 1;

     emp_id  Trim(TRAILING ',' FROM XMLAGG((Trim(BOTH FROM salary)||',') RETURNING SEQUENCE))
-----------  ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
          7  18000.00, 980.00, 1080.00

--3. Splitting comma separated values to multiple rows:

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

--4. Nesting String & Regex expression:
select substring('2345roja123' from regexp_instr('2345roja123', '\d+',1,2))
;

 *** Query completed. One row found. One column returned. 
 *** Total elapsed time was 1 second.

Substring('2345roja123' From regexp_instr('2345roja123','\d+',1,2))
-------------------------------------------------------------------
123

 BTEQ -- Enter your SQL request or BTEQ command: 
select substring('2345roja123' from regexp_instr('2345roja123', '\d+',1,2) for 2);

 *** Query completed. One row found. One column returned. 
 *** Total elapsed time was 1 second.

Substring('2345roja123' From regexp_instr('2345roja123','\d+',1,2) For 2)
-------------------------------------------------------------------------
12

--15. Finding rowcount in each table of DB:

Select    

     'Select ' || '''' || trim(databasename) || '.' || trim(tablename) || ''',' ||

     ' Count(*) From ' || trim(databasename) || '.' ||

     trim (tablename)||' Group by 1' || ';' (Title '')

     From dbc.tables

     Where tablekind =  'T'

     and databasename = <DB_NAME>;
     
