## Library Database System
### Introduction
#### This repository contains the implementation of a Library Database System using SQLite. The database is designed to manage library operations such as patron management, book inventory, borrowing records, and book reviews. The schema incorporates various data types and relationships to ensure an efficient and structured system.

### Database Schema
### Visual Representation
![image](https://github.com/user-attachments/assets/45fd24c2-4177-4cca-9c61-8257f77c193b)

#### The database consists of five tables:
#### Patrons – Stores library member details (ID, name, email, birth year, membership level, etc.).
![image](https://github.com/user-attachments/assets/71b9674a-cd06-471a-bb33-bf25436a527f)

#### Publishers – Contains publisher information (ID, name, country, years operating, etc.).
![image](https://github.com/user-attachments/assets/c53a864d-5703-4820-8ac7-6916ea7aa8e0)

#### Books – Represents books in the library (ID, title, genre, price, publisher, etc.).
![image](https://github.com/user-attachments/assets/01a27a51-bd26-4916-be0a-d02b96170fa3)

#### Borrowings – Tracks book borrowings, linking patrons and books.
![image](https://github.com/user-attachments/assets/60e6d17c-93fd-411b-b483-d882195f21d5)

#### BookReviews – Allows patrons to review books, implementing a many-to-many relationship.
![image](https://github.com/user-attachments/assets/7f49be0f-9fa9-4b8e-a190-ebe536bc85ef)

### Features
#### ✔ Normalized Schema – Avoids redundancy and ensures data integrity.
#### ✔ Primary and Foreign Keys – Establishes relationships between tables.
#### ✔ Data Integrity Constraints – Includes CHECK, NOT NULL, and DEFAULT constraints.
#### ✔ Bulk Data Generation – Uses recursive CTEs to insert thousands of records.
#### ✔ Data Privacy Considerations – Ensures compliance with security practices.

### Entity Relationships
#### The database implements several relationships between tables:
#### •	One-to-many relationship between Publishers and Books (via publisher_id foreign key)
#### •	One-to-many relationship between Patrons and Borrowings (via patron_id foreign key)
#### •	One-to-many relationship between Books and Borrowings (via book_id foreign key)
#### •	Many-to-many relationship between Patrons and Books (implemented through the BookReviews table with a composite key)

![image](https://github.com/user-attachments/assets/6e765856-f978-4cc9-b969-5eb2e49331c0)

#### Join
![image](https://github.com/user-attachments/assets/23536a79-c9d1-4a5b-8500-76144bef8d11)
#### Count
![image](https://github.com/user-attachments/assets/b6db0ca6-3782-48af-a224-fd8375953f97)
![image](https://github.com/user-attachments/assets/d919e9c2-e8dd-49c1-8018-cdd2c4254358)
#### GroupBy Clause
![image](https://github.com/user-attachments/assets/cc3760ca-04ed-4c10-8cd5-c864deda0690)

#### This approach recognizes that:
#### 1.	System handling: Applications must properly handle NULL values to prevent errors or data misinterpretation.
#### 2.	Bias in analytics: Reports based on incomplete data may introduce bias if certain demographic groups are more likely to have missing information.
#### 3.	Transparency: Library patrons should be informed about what data is collected and how missing data might affect their service experience.

### SQL Scripts
#### schema.sql – Defines the database schema.
#### insert_data.sql – Contains sample data insertion queries.
#### queries.sql – Includes SQL queries for data validation and analytics.

### Conclusion
#### The library database system successfully meets all requirements, providing a realistic model with:
#### •	Multiple interconnected tables with over 1000 patron records and 2000 borrowing records
#### •	A variety of data types (nominal, ordinal, interval, and ratio)
#### •	Foreign and composite keys implementing complex relationships
#### •	Deliberately inserted missing and duplicate data
#### •	Comprehensive data integrity constraints
