create database educore;
use educore;
create table users (
id int primary key ,
nom varchar(255) not null,
email varchar(200) unique not null,
created_at datetime default current_timestamp );
create table courses(
id int ,
titre varchar(255),
prix decimal check(prix>0)

);
create table enrollments(
user_id int ,
course_id int,
progress int default 0 ,
check (progress between 0 and 100),
foreign key (course_id) references courses(id),
foreign key (user_id) references users(id)
);
create table payments (
id int,
amount decimal,
paid_at datetime default current_timestamp
);
alter table payments

ADD CONSTRAINT fk_payments_user
    FOREIGN KEY (user_id) REFERENCES users(id);

truncate table payments;
DESCRIBE payments;
insert into users(id, nom, email) values ( '1','douae', 'sdouae@gmail.com');
insert into users (email) values ('sdouae@gmail.com');
insert into enrollments (progress) values ('111');


insert into users( nom, email) values 
( 'souphyane', 'bsouphayne@gmail.com'),
( 'sini', 'hmohammedamine@gmail.com'),
( 'othmane', 'ycothmane@gmail.com'),
('yassine','hyassine@gmail.com'),
('ilyass','kilyass@gmail.com'),
('yasmine','yasmine@gmail.com'),
('manal','manal@gmail.com'),
('maddison','jmaddison@gmail.com'),
('dominic','sdominic@gmail.com');


insert into courses (id, titre, prix)values
(1, 'Web Development (HTML, CSS, JavaScript)', 199),
(2, 'Java Programming Fundamentals', 249),
(3, 'Python for Data Science', 299),
(4, 'Full Stack Development (MERN)', 399),
(5, 'Cybersecurity Basics', 279),
(6, 'Mobile App Development', 349)
;

insert into enrollments (user_id, course_id, progress) values
(1, 1, 20),
(1, 4, 40),
(1, 3, 60),
(2, 1, 10),
(2, 2, 30),
(2, 4, 50),
(3, 2, 70),
(3, 3, 80),
(3, 5, 90),
(4, 1, 25),
(4, 4, 45),
(4, 6, 65),
(5, 3, 35),
(5, 5, 55),
(5, 6, 75);

insert into payments ( user_id, amount) values
( 1, 199),
(1, 249),
( 2, 399),
( 2, 199),
( 3, 299),
( 3, 279),
(4, 349),
( 4, 199),
( 5, 299),
( 5, 399);


select 'users' as table_name, COUNT(*) as total from users
union all
select 'courses', COUNT(*) from courses
union all
select 'enrollments', COUNT(*) from enrollments
union all
select 'payments', COUNT(*) from payments;

select * 
from enrollments
where progress < 0 or progress > 100;

select e.*
from enrollments e
left join users u on e.user_id = u.id
left join courses c on e.course_id = c.id
where u.id is null or c.id is null;


select *
from payments
where amount <= 0;


