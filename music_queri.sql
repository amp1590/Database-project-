-------------------lab 2 : DDL and DML---------------------

--add column
alter table artist add age number(10);
describe artist;

--multiple column add
alter table artist add (recent_album varchar(10),city varchar(10));
describe artist;

--modify
alter table artist modify (recent_album varchar(20),city varchar(10));
describe artist;

--rename
alter table artist rename column recent_album to r_album;
describe artist;

--drop 
alter table artist drop column age;
alter table artist drop column r_album;
alter table artist drop column city;
describe artist;



---UPDATE
select artist_name,country from artist where artist_name='Michel';
update artist set country='Srilanka' where artist_name='Michel';
select artist_name,country from artist where artist_name='Michel';

--DELETE
delete from song where rating=10;
select * from song;

----------------------end of lab 2------------------------

-----------------------lab 3 : key constraints ------------------------

 --done in table_data

---ALTER primary key

--disable primary key
alter table song disable constraint s_name;

--enable primary key
alter table song enable constraint s_name;

--drop primary key
alter table song drop constraint s_name;

---------------lab 3 ends--------------------------

-----------------lab-4 : Select command / Aggregate function ---------------

select song_name,releasedate from song;
select f_id from files;
select distinct (languages) from song;

--and or etc and compound comparision

select song_name,rating from song where rating>5 AND rating<11;

--between

select song_name,rating from song where rating BETWEEN 5 AND 7;
select song_name,rating from song where rating NOT BETWEEN 5 AND 7;

--in operation

select song_name from song where genre_is in ('tagore','nazrul');

--pattern matching
select artist_name from song where languages like '%bangla%';

--single column ordering
select song_name,rating from song order by rating;
--descending order
select song_name,rating from song order by rating desc;
--multiple column ordering
select song_name,rating,releasedate from song order by rating,releasedate;


---- aggregate functions----

select rating from song;
select max(rating) from song;
select count(*), sum(rating), avg(rating) from song;

--group by

select rating, count(rating) from song group by rating;

--having clause

select rating, count(rating) from song group by rating having rating>5;

-----------------lab-4 ends----------------

-------------lab 5 : subquery and set operations ----------------

--subquery
select artist_name,country from artist
where artist_name IN (select artist_name from song where song_name='Just beat it');

--query
select artist_name,country from artist
where artist_name='Farida';

--advance

select a.artist_name, a.country 
from artist a
where a.artist_name IN (select i.artist_name from song i, files f
					where i.f_id=f.f_id and a.country='India'
					);

--union all

select artist_name,country from artist
where gender='male'
union all
select a.artist_name, a.country 
from artist a
where a.artist_name IN (select i.artist_name from song i, files f
					where i.f_id=f.f_id and f.formats='mp4'
					);
--union 

select artist_name,country from artist
where gender='male'
union
select a.artist_name, a.country 
from artist a
where a.artist_name IN (select i.artist_name from song i, files f
					where i.f_id=f.f_id and f.formats='mp4'
					);
--intersect

select artist_name,country from artist
intersect
select a.artist_name, a.country 
from artist a
where a.artist_name IN (select i.artist_name from song i, files f
					where i.f_id=f.f_id and f.formats='mp4'
					);
--minus

select artist_name,country from artist
minus
select a.artist_name, a.country 
from artist a
where a.artist_name IN (select i.artist_name from song i, files f
					where i.f_id=f.f_id and f.formats='mp4'
					);

--precedence of set operator

select artist_name,country from artist
union
select a.artist_name, a.country 
from artist a
where a.artist_name IN (select i.artist_name from song i, files f
					where i.f_id=f.f_id and f.formats='mp4'
					)
INTERSECT
select artist_name,country from artist
where gender='female';

--another approach with paranthesis

select artist_name,country from artist
UNION
(select a.artist_name, a.country 
from artist a
where a.artist_name IN (select i.artist_name from song i, files f
					where i.f_id=f.f_id and f.formats='mp4'
					)
INTERSECT
select artist_name,country from artist
where gender='female'
);

-----------------------------lab-5 ends----------------------------

-------------------------lab 6 : join multiple tables-----------------------

--normal join operation
select i.song_name , i.languages from song i join files f on i.f_id=f.f_id;

-- using clause
select i.song_name , i.languages from song i join files using(f_id);

--multiple condition
select i.song_name, i.artist_name, f.file_size from song i join files f on ((i.f_id=f.f_id) and (i.artist_name=f.artist_name));

--natural join
select i.song_name , i.languages from song i natural join files f;

-- cross join
select i.song_name , i.languages from song i cross join files f;

--outer joins

select i.song_name , i.languages from song i left outer join files f on i.f_id=f.f_id;
select i.song_name , i.languages from song i right outer join files f on i.f_id=f.f_id;
select i.song_name , i.languages from song i full outer join files f on i.f_id=f.f_id;


--------------------------------lab 6 ends----------------------------

-------------------------lab 7 : pl/sql ----------------------------

--pl/sql
set serveroutput on

declare 
	max_rating song.rating%type;

begin
	select max(rating) into max_rating from song;
	dbms_output.put_line('Maximum rated song has the rating: '||max_rating);
end;
/ 

--more

SET  SERVEROUTPUT ON
DECLARE
  the_song song.song_name%TYPE;
  filesize files.file_size%TYPE :='4.58 MB';
BEGIN
  SELECT song_name INTO the_song
  FROM song, files
  WHERE song.f_id=files.f_id AND
  file_size = filesize;  
  DBMS_OUTPUT.PUT_LINE('the size of the song ' || the_song || ' is '|| filesize);
END;
/


--conditional

SET SERVEROUTPUT ON
DECLARE
    full_rating song.rating%type;
    name  VARCHAR2(100);
    bonus_point song.rating%type;
	
BEGIN
    name := 'Just beat it';

    SELECT rating  INTO full_rating
    FROM song
    WHERE song_name like name ;

    IF full_rating < 3  THEN
                 bonus_point := full_rating;
    ELSIF full_rating >= 3 and full_rating <= 4   THEN
               bonus_point :=  full_rating - (full_rating*0.25);
   ELSE
	bonus_point :=  full_rating - (full_rating*0.5); 
    END IF;

DBMS_OUTPUT.PUT_LINE (' " ' || name || ' " song has rating: '||full_rating||' bonus point: '|| ROUND(bonus_point,2));
EXCEPTION
         WHEN others THEN
	      DBMS_OUTPUT.PUT_LINE (SQLERRM);
END;
/
SHOW errors


---------------lab-7 ends------------------------

---------------lab-8-loops, cursor and procedure ,pl/sql, function continues-------------

-- while loop

set serveroutput on

declare 

counter number(2):=1;
username files.artist_name%type;
song_duration files.duration%type;

begin

while counter<=5

loop 
	
	select artist_name, duration into username, song_duration from files where f_id=counter;

	dbms_output.put_line('Record '||counter);
	dbms_output.put_line(username ||' ' ||song_duration);

	counter :=counter+1;

	end loop;

	exception
	when others then dbms_output.put_line(sqlerrm);
end;
/

--for loop

set serveroutput on

declare 
counter number(2);
username files.artist_name%type;
song_duration files.duration%type;

begin

	for counter in 1..5
	loop
	select artist_name, duration into username, song_duration from files where f_id=counter;
	dbms_output.put_line('Record '||counter);
	dbms_output.put_line(username ||' ' ||song_duration);
	end loop;
exception
when others then 
dbms_output.put_line(sqlerrm);
end;
/

--loop

set serveroutput on

declare
counter number(2):=0;
username files.artist_name%type;
song_duration files.duration%type;
begin

loop
	
	counter:=counter+1;
	select artist_name, duration into username, song_duration from files where f_id=counter;
	dbms_output.put_line(username ||' ' ||song_duration);
	exit when counter>5;

	end loop;
exception
when others then 
dbms_output.put_line(sqlerrm);
end;
/

--cursor

SET SERVEROUTPUT ON
DECLARE
     CURSOR artist_cur IS
    SELECT artist_name,gender FROM artist;
    record artist_cur%ROWTYPE;

BEGIN
OPEN artist_cur;
      LOOP
        FETCH artist_cur INTO record;
        EXIT WHEN artist_cur%ROWCOUNT > 3;
      DBMS_OUTPUT.PUT_LINE ('Artist Name : ' || record.artist_name || ' Gender : ' || record.gender);
      END LOOP;
      CLOSE artist_cur;   
END;
/

--procedure

set serveroutput on;

create or replace procedure ratesong is 
	the_song song.song_name%type;
	rating_is song.rating%type;

begin
	the_song:='My love';
	select rating into rating_is from song where song_name=the_song;
	dbms_output.put_line('rating : '|| rating_is);
end;
/
show errors

begin
 ratesong;
 end;
 /

--another procedure

set serveroutput on;

create or replace procedure showdate is 
	songname song.song_name%type;
	songdate song.releasedate%type;

begin
	songname:='My love';
	select releasedate into songdate from song where song_name=songname;
	dbms_output.put_line('Song : '|| songname ||' released on date : ' || songdate );
end;
/
show errors

begin
 showdate;
 end;
 /

--a procedure for inserting data into artist table

set serveroutput on;

CREATE OR REPLACE PROCEDURE add_artist(
  insertname artist.artist_name%TYPE,
  insertcountry artist.country%TYPE) IS
BEGIN
  INSERT INTO artist(artist_name,country)
  VALUES (insertname,insertcountry);
  COMMIT;
END add_artist;
/
SHOW ERRORS


BEGIN
add_artist('Bonna','Bangladesh');
END;
/

SELECT * FROM artist;
 

-- functions

create or replace function avgrate return number is
avg_rate song.rating%type;

begin
select avg(rating) into avg_rate from song;
return avg_rate;
end;
/

set serveroutput on
begin
dbms_output.put_line('average rating: '|| avgrate );
end;
/

--complex operation in function

CREATE OR REPLACE FUNCTION get_bonus_point(
  resol  IN song.resolution%TYPE,
  rate IN song.rating%TYPE)
 RETURN NUMBER IS
BEGIN
  RETURN ((NVL(resol,0) / 1000) + (NVL(rate,0) * .25));
END get_bonus_point;
/

SELECT song_name,
       get_bonus_point(resolution,rating) "Bonus Point"
FROM   song
WHERE song_name='My love';
/

-------------lab-8 ends-------------

------------------lab 9 trigger, transaction,date ------------------

--trigger
create or replace trigger rate_song before insert or update on song
	for each row
	declare
	r_min constant number(8) :=5;
	r_max constant number(8) :=10;

begin
if :new.rating>r_max or :new.rating<r_min then
raise_application_error(-2000,'your rating is too low or high');
end if;
end;
/  

--more on trigger

create or replace trigger resol
before update or insert on song
for each row
begin
if:new.resolution>1080 then
:new.rating:=5;
elsif:new.resolution>780 and :new.resolution<1080 then
:new.rating:=4;
elsif:new.resolution>512 and :new.resolution<780 then
:new.rating:=3;
elsif:new.resolution>320 and :new.resolution<512 then
:new.rating:=2;
end if;
end resol;
/

--DISABLE triggers
alter table song disable all triggers;

--ENABLE triggers
alter table song enable all triggers;


--date

select sysdate from dual;

select current_date from dual;

select systimestamp from dual;

--add months
select add_months(releasedate,1) as one_month from song where song_name='My love';
--last day
select last_day(releasedate) from song;
--extract

select song_name,extract(month from releasedate) as months from song;

--extract continues

select song_name,extract(year from releasedate) as year from song;

--------------lab 9 ends-------------------

