-- mission1 : création de la base et des tables
create database educore;
use educore;

-- table des utilisateurs
create table users (
id int primary key ,
nom varchar(255) not null,
email varchar(200) unique not null,
created_at datetime default current_timestamp
);

-- table des cours
create table courses(
id int ,
titre varchar(255),
prix decimal check(prix>0)
);

-- table des inscriptions
create table enrollments(
user_id int ,
course_id int,
progress int default 0 ,
check (progress between 0 and 100),
foreign key (course_id) references courses(id),
foreign key (user_id) references users(id)
);

-- table des paiements
create table payments (
id int,
amount decimal,
paid_at datetime default current_timestamp,
foreign key (user_id) references users(id)
);




-- description de la table payments
DESCRIBE payments;

-- insertion d'un utilisateur
insert into users(id, nom, email) values ( '1','douae', 'sdouae@gmail.com');

-- tentative d'insertion un email en double
insert into users (email) values ('sdouae@gmail.com');

-- insertion dans enrollments avec une valeur de progress = 120
insert into enrollments (progress) values ('120');

-- mission 2 : insertion de plusieurs utilisateurs
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

-- insertion des cours
insert into courses (id, titre, prix)values
(1, 'Web Development (HTML, CSS, JavaScript)', 199),
(2, 'Java Programming Fundamentals', 249),
(3, 'Python for Data Science', 299),
(4, 'Full Stack Development (MERN)', 399),
(5, 'Cybersecurity Basics', 279),
(6, 'Mobile App Development', 349);

-- insertion des inscriptions
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

-- insertion des paiements
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

-- compter chaque table
select 'users' as table_name, COUNT(*) as total from users
union all
select 'courses', COUNT(*) from courses
union all
select 'enrollments', COUNT(*) from enrollments
union all
select 'payments', COUNT(*) from payments;

-- vérification des progress hors limites
select * 
from enrollments
where progress < 0 or progress > 100;

-- vérification que chaque enrollment pointe un user et un course existants
select e.*
from enrollments e
left join users u on e.user_id = u.id
left join courses c on e.course_id = c.id
where u.id is null or c.id is null;

-- vérification que les montants sont positifs
select *
from payments
where amount <= 0;

-- mission 3 : analyse des cours et paiements
-- cours les plus suivis
select 
    c.titre,
    count(e.user_id) as nb_inscrits
from courses c
join enrollments e on c.id = e.course_id
group by c.id, c.titre
order by nb_inscrits desc;

-- cours les plus rentables (approche simple)
select 
    c.titre,
    sum(c.prix) as revenu_total
from courses c
join enrollments e on c.id = e.course_id
group by c.id, c.titre
order by revenu_total desc;

-- utilisateurs avec au moins 2 paiements
select 
    user_id,
    count(*) as nb_paiements
from payments
group by user_id
having count(*) >= 2;

-- utilisateurs n'ayant jamais payé
select 
    u.nom
from users u
left join payments p on u.id = p.user_id
where p.user_id is null;

-- mission 4 : progression par cours et utilisateurs
-- progression moyenne par cours
select 
    c.titre,
    avg(e.progress) as avg_progress
from courses c
join enrollments e on c.id = e.course_id
group by c.id, c.titre;

-- identification des abandons (progress < 25)
select 
    u.nom,
    c.titre,
    e.progress
from enrollments e
join users u on e.user_id = u.id
join courses c on e.course_id = c.id
where e.progress < 25;

-- cours "à risque" : moyenne < 50 et au moins 3 inscrits
select 
    c.titre,
    avg(e.progress) as avg_progress,
    count(*) as nb_inscrits
from courses c
join enrollments e on c.id = e.course_id
group by c.id, c.titre
having avg(e.progress) < 50 and count(*) >= 3;

-- mission 5 : sous-requêtes & logique avancée

-- etape 1 : depense totale par user
select
    user_id,
    sum(amount) as total_spent
from payments
group by user_id;

-- etape 2 : users dont la depense totale est superieure a la moyenne
select
    p.user_id,
    sum(p.amount) as total_spent
from payments p
group by p.user_id
having sum(p.amount) >
(
    select avg(total_user_spent)
    from (
        select sum(amount) as total_user_spent
        from payments
        group by user_id
    ) t
);

-- etape 3 : cours plus chers que la moyenne des prix
select
    titre,
    prix
from courses
where prix >
(
    select avg(prix)
    from courses
);

-- etape 4 : users inscrits a au moins 2 cours
select
    u.nom,
    count(e.course_id) as nb_courses
from users u
join enrollments e on u.id = e.user_id
group by u.id, u.nom
having count(e.course_id) >= 2;

-- etape 5 : cours jamais achetes 

-- on cherche les cours qui ont des inscrits
-- mais dont les users inscrits n'ont fait aucun paiement

select
    c.titre
from courses c
join enrollments e on c.id = e.course_id
left join payments p on e.user_id = p.user_id
group by c.id, c.titre
having count(p.user_id) = 0;

