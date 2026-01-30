-- MISSION 1 : CRÉATION DE LA BASE ET DES TABLES
CREATE DATABASE educore;
USE educore;

-- TABLE DES UTILISATEURS
CREATE TABLE users (
    id INT PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    email VARCHAR(200) UNIQUE NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- TABLE DES COURS
CREATE TABLE courses (
    id INT,
    titre VARCHAR(255),
    prix DECIMAL CHECK (prix > 0)
);

-- TABLE DES INSCRIPTIONS
CREATE TABLE enrollments (
    user_id INT,
    course_id INT,
    progress INT DEFAULT 0,
    CHECK (progress BETWEEN 0 AND 100),
    FOREIGN KEY (course_id) REFERENCES courses(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- TABLE DES PAIEMENTS
CREATE TABLE payments (
    id INT,
    amount DECIMAL,
    paid_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- DESCRIPTION DE LA TABLE PAYMENTS
DESCRIBE payments;

-- INSERTION D'UN UTILISATEUR
INSERT INTO users (id, nom, email)
VALUES (1, 'douae', 'sdouae@gmail.com');

-- TENTATIVE D'INSERTION D'UN EMAIL EN DOUBLE
INSERT INTO users (email)
VALUES ('sdouae@gmail.com');

-- INSERTION DANS ENROLLMENTS AVEC UNE VALEUR DE PROGRESS = 120
INSERT INTO enrollments (progress)
VALUES (120);

-- MISSION 2 : INSERTION DE PLUSIEURS UTILISATEURS
INSERT INTO users (nom, email) VALUES
('souphyane', 'bsouphayne@gmail.com'),
('sini', 'hmohammedamine@gmail.com'),
('othmane', 'ycothmane@gmail.com'),
('yassine', 'hyassine@gmail.com'),
('ilyass', 'kilyass@gmail.com'),
('yasmine', 'yasmine@gmail.com'),
('manal', 'manal@gmail.com'),
('maddison', 'jmaddison@gmail.com'),
('dominic', 'sdominic@gmail.com');

-- INSERTION DES COURS
INSERT INTO courses (id, titre, prix) VALUES
(1, 'Web Development (HTML, CSS, JavaScript)', 199),
(2, 'Java Programming Fundamentals', 249),
(3, 'Python for Data Science', 299),
(4, 'Full Stack Development (MERN)', 399),
(5, 'Cybersecurity Basics', 279),
(6, 'Mobile App Development', 349);

-- INSERTION DES INSCRIPTIONS
INSERT INTO enrollments (user_id, course_id, progress) VALUES
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

-- INSERTION DES PAIEMENTS
INSERT INTO payments (user_id, amount) VALUES
(1, 199),
(1, 249),
(2, 399),
(2, 199),
(3, 299),
(3, 279),
(4, 349),
(4, 199),
(5, 299),
(5, 399);

-- COMPTER CHAQUE TABLE
SELECT 'users' AS table_name, COUNT(*) AS total FROM users
UNION ALL
SELECT 'courses', COUNT(*) FROM courses
UNION ALL
SELECT 'enrollments', COUNT(*) FROM enrollments
UNION ALL
SELECT 'payments', COUNT(*) FROM payments;

-- VÉRIFICATION DES PROGRESS HORS LIMITES
SELECT *
FROM enrollments
WHERE progress < 0 OR progress > 100;

-- VÉRIFICATION QUE CHAQUE ENROLLMENT POINTE UN USER ET UN COURSE EXISTANTS
SELECT e.*
FROM enrollments e
LEFT JOIN users u ON e.user_id = u.id
LEFT JOIN courses c ON e.course_id = c.id
WHERE u.id IS NULL OR c.id IS NULL;

-- VÉRIFICATION QUE LES MONTANTS SONT POSITIFS
SELECT *
FROM payments
WHERE amount <= 0;

-- MISSION 3 : ANALYSE DES COURS ET PAIEMENTS
-- COURS LES PLUS SUIVIS
SELECT
    c.titre,
    COUNT(e.user_id) AS nb_inscrits
FROM courses c
JOIN enrollments e ON c.id = e.course_id
GROUP BY c.id, c.titre
ORDER BY nb_inscrits DESC;

-- COURS LES PLUS RENTABLES (APPROCHE SIMPLE)
SELECT
    c.titre,
    SUM(c.prix) AS revenu_total
FROM courses c
JOIN enrollments e ON c.id = e.course_id
GROUP BY c.id, c.titre
ORDER BY revenu_total DESC;

-- UTILISATEURS AVEC AU MOINS 2 PAIEMENTS
SELECT
    user_id,
    COUNT(*) AS nb_paiements
FROM payments
GROUP BY user_id
HAVING COUNT(*) >= 2;

-- UTILISATEURS N'AYANT JAMAIS PAYÉ
SELECT
    u.nom
FROM users u
LEFT JOIN payments p ON u.id = p.user_id
WHERE p.user_id IS NULL;

-- MISSION 4 : PROGRESSION PAR COURS ET UTILISATEURS
-- PROGRESSION MOYENNE PAR COURS
SELECT
    c.titre,
    AVG(e.progress) AS avg_progress
FROM courses c
JOIN enrollments e ON c.id = e.course_id
GROUP BY c.id, c.titre;

-- IDENTIFICATION DES ABANDONS (PROGRESS < 25)
SELECT
    u.nom,
    c.titre,
    e.progress
FROM enrollments e
JOIN users u ON e.user_id = u.id
JOIN courses c ON e.course_id = c.id
WHERE e.progress < 25;

-- COURS "À RISQUE"
SELECT
    c.titre,
    AVG(e.progress) AS avg_progress,
    COUNT(*) AS nb_inscrits
FROM courses c
JOIN enrollments e ON c.id = e.course_id
GROUP BY c.id, c.titre
HAVING AVG(e.progress) < 50 AND COUNT(*) >= 3;

-- MISSION 5 : SOUS-REQUÊTES & LOGIQUE AVANCÉE
SELECT
    user_id,
    SUM(amount) AS total_spent
FROM payments
GROUP BY user_id;

-- MISSION 6 : VUES MÉTIER
CREATE VIEW v_active_users AS
SELECT DISTINCT
    u.id,
    u.nom,
    u.email
FROM users u
JOIN enrollments e ON u.id = e.user_id;

CREATE VIEW v_monthly_revenue AS
SELECT
    DATE_FORMAT(paid_at, '%y-%m') AS month,
    SUM(amount) AS monthly_revenue
FROM payments
GROUP BY DATE_FORMAT(paid_at, '%y-%m');

CREATE VIEW v_popular_courses AS
SELECT
    c.id,
    c.titre,
    COUNT(e.user_id) AS nb_inscrits
FROM courses c
JOIN enrollments e ON c.id = e.course_id
GROUP BY c.id, c.titre
ORDER BY nb_inscrits DESC;

-- MISSION 7 : PERFORMANCE & INDEX
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_payments_paid_at ON payments(paid_at);
CREATE INDEX idx_enrollments_course_user ON enrollments(course_id, user_id);

-- MISSION 8 : TRANSACTIONS & SÉCURITÉ
START TRANSACTION;

INSERT INTO payments (user_id, amount)
VALUES (1, 199);

UPDATE users
SET nom = CONCAT(nom, ' (client)')
WHERE id = 1;

COMMIT;
