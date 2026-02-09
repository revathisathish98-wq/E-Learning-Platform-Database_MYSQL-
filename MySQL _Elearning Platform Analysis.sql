-- Database Creation --

Create Database if not exists elearning_purchases;
Use elearning_purchases;

-- Table Creation Learners, Courses, Purchases --

Create table learners (
	Learner_id  int Primary Key,
	Full_name varchar(100) not null,
	Country varchar(50) not null
);

Create table courses (
	Course_id int Primary Key,
    Course_name varchar(100) not null,
	Category varchar(50) not null,
	Unit_price decimal(10,2) not null
    );
    
Create table purchases(
	Purchase_id int Primary Key,
    Learner_id int,
	Course_id int,
    Quantity int,
	Purchase_date date not null,
    foreign key (learner_id) references learners(learner_id)
    on update cascade on delete cascade,
    foreign key (course_id) references courses(course_id)
    on update cascade on delete cascade
);

-- Inster values into table --

insert into learners values
(1,'Abi','India'),
(2,'Janani','USA'),
(3,'Soundarya','UAE'),
(4,'Aswathy','India'),
(5,'Mithran','USA');


insert into courses values
(101,'Data Analytics','data visulization',625.00),
(102,'Data Science','Machine Learning',785.98),
(103,'Digital Marketing','communication',525.75),
(104,'Machine Learning','AI', 650.38),
(105,'UI/UX','Designing',435.29);


insert into purchases(purchase_id,learner_id,course_id,quantity,purchase_date) values
(11,1,101,1,'2024-01-01'),
(12,2,102,2,'2024-02-01'),
(13,3,103,2,'2024-02-15'),
(14,4,104,4,'2024-02-01'),
(15,5,105,5,'2024-01-24'),
(16,3,103,3,'2024-01-15'),
(17,1,101,2,'2024-01-21');


-- Data Exploration Using Joins --

select l.learner_id, c.course_name, p.quantity,
format(p.quantity*c.unit_price,2) as total_revenue,
p.purchase_date
from purchases p
inner join learners l on p.learner_id =l.learner_id
inner join courses c on p.course_id=c.course_id
order by total_revenue desc;

SELECT 
l.full_name,
c.course_name,
p.purchase_date
FROM learners l
LEFT JOIN purchases p ON l.learner_id = p.learner_id
LEFT JOIN courses c ON p.course_id = c.course_id;

select l.full_name, c.course_name, p.quantity
from learners l
right join purchases p on l.learner_id=p.learner_id
right join courses c on c.course_id = p.course_id;

-- SQL Queries --
-- Q1. Display each learner’s total spending (quantity × unit_price) along with their country --

SELECT l.full_name, l.country,
FORMAT(SUM(p.quantity * c.unit_price), 2) AS total_spent
FROM learners l
JOIN purchases p ON l.learner_id = p.learner_id
JOIN courses c ON p.course_id = c.course_id
GROUP BY l.full_name, l.country
ORDER BY total_spent DESC;

-- Q2. Find the top 3 most purchased courses based on total quantity sold. --

select c.course_name,sum(p.quantity)as total_quantity_sold from purchases p
join courses c on c.course_id=p.course_id
group by c.course_name
order by total_quantity_sold desc
limit 3;

-- Q3. Show each course category’s total revenue and the number of unique learners who purchased from that category --

select c.category,
sum(p.quantity*c.unit_price) as total_revenue,
count(distinct l.learner_id) as unique_learner
from purchases p inner join courses c on c.course_id=p.course_id
inner join learners l on l.learner_id = p.learner_id
group by c.category
order by total_revenue desc;

-- Q4. List all learners who have purchased courses from more than one category.--

select l.full_name,
count(c.category)as count_category
from learners l
inner join purchases p on l.learner_id = p.learner_id
inner  join courses c on c.course_id=p.course_id
group by l.full_name
having count_category>1;

-- Q5. Identify courses that have not been purchased at all. --

select c.course_name,
c.category
from courses c left join purchases p on p.course_id =c.course_id
where p.purchase_id is null;


-- Q6.Which country generates the highest total revenue --

SELECT l.country,
FORMAT(SUM(p.quantity * c.unit_price), 2) AS total_revenue
FROM learners l
JOIN purchases p ON l.learner_id = p.learner_id
JOIN courses c ON p.course_id = c.course_id
GROUP BY l.country
ORDER BY total_revenue DESC;

-- Q7. Find the least purchased course by total quantity code --

SELECT c.course_name,
SUM(p.quantity) AS total_quantity_sold
FROM courses c
JOIN purchases p ON c.course_id = p.course_id
GROUP BY c.course_id, c.course_name
ORDER BY total_quantity_sold ASC LIMIT 1;

-- Q8. First Purchase Date of Each Learner --

SELECT l.full_name AS learner_name,
MIN(p.purchase_date) AS first_purchase_date
FROM learners l
JOIN purchases p ON l.learner_id = p.learner_id
GROUP BY l.learner_id
ORDER BY first_purchase_date;

-- Q9. Learners Who Made Only One Purchase --

SELECT l.full_name AS learner_name,
COUNT(p.purchase_id) AS total_purchases
FROM learners l
JOIN purchases p ON l.learner_id = p.learner_id
GROUP BY l.learner_id
HAVING COUNT(p.purchase_id) = 1;

-- Q.10 Which category has the highest average course price --

SELECT category,
FORMAT(AVG(unit_price), 2) AS avg_course_price
FROM courses
GROUP BY category
ORDER BY avg_course_price DESC
LIMIT 1;


