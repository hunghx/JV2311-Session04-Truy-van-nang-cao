# Ham SUM() - hàm tính tổng
use firstdb;
select sum(age)
from student;
#Hàm MIN() - GTNN
select min(age)
from student;
#hàm MAX() - GTLN
select max(student.age)
from student;
#hàm AVG () - tin trung bình
select ROUND(AVG(student.age))
from student;
#Hàm UCase, LCase(), length() - in hoa , in thường, độ dài kí tự của string
select id, ucase(name)
from student;
# Hàm nối chuỗi - Concat
# Hàm làm tròn - Round()
# Hàm với thời gian
Select now();
select curdate();
select curtime();
select month(curdate());
select year(curdate());
select day(curdate());
select hour(curtime());
# truy vấn lồng
--  ví dụ : hãy tìm những sinh viên thuộc lớp có ít hơn 3 sinh viên
-- B1 tìm những lop có từ 5 sinh viên trở lên
select idClasses
from classes c
         join student s
              on c.idClasses = s.classId
group by idClasses
having count(idClasses) >= 3
;
-- B2 hãy tìm những học sinh không nawmf trong những lớp này
select *
from student
where classId not in (select idClasses
                      from classes c
                               join student s
                                    on c.idClasses = s.classId
                      group by idClasses
                      having count(idClasses) >= 2);
# tìm những lớp không có học sinh naò học
-- Cách 1 : left join + right = null
select c.*
from classes c
         left join student s
                   on c.idClasses = s.classId
where s.classId is null;
-- cach 2 : truy vấn lồng
select distinct c.idClasses
from classes c
         join student s
              on c.idClasses = s.classId;
select *
from classes
where idClasses not in (select distinct c.idClasses
                        from classes c
                                 join student s
                                      on c.idClasses = s.classId);
# tìm những sinh viên có tuổi lớn nhất
explain analyze select * from student where age >= ALL (select age from student);
#-> Filter: <not>((student.age < <max>(select #2)))  (cost=0.98 rows=7) (actual time=0.062..0.066 rows=9 loops=1)
#-> Table scan on student  (cost=0.98 rows=11) (actual time=0.037..0.041 rows=11 loops=1)
#    -> Select #2 (subquery in condition; run only once)
#          -> Table scan on student  (cost=1.35 rows=11) (actual time=0.009..0.014 rows=11 loops=1)
select * from student where age >= ALL (select age from student);
explain analyze select * from student where age = (select max(age) from student);
#-> Filter: (student.age = (select #2))  (cost=1.35 rows=1) (actual time=0.056..0.059 rows=9 loops=1)
#-> Table scan on student  (cost=1.35 rows=11) (actual time=0.023..0.025 rows=11 loops=1)
 #   -> Select #2 (subquery in condition; run only once)
  #         -> Aggregate: max(student.age)  (cost=2.45 rows=11) (actual time=0.022..0.022 rows=1 loops=1)
   #        -> Table scan on student  (cost=1.35 rows=11) (actual time=0.008..0.012 rows=11 loops=1)


# truy vấn với union
select id, name from student
union
select idClasses,ClassName from classes;