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