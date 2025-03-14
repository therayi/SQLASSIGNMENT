-- Drop tables if they exist
DROP TABLE IF EXISTS BookReviews;
DROP TABLE IF EXISTS Borrowings;
DROP TABLE IF EXISTS Books;
DROP TABLE IF EXISTS Publishers;
DROP TABLE IF EXISTS Patrons;

-- Create the Patrons table with various data types
CREATE TABLE Patrons (
    patron_id INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name TEXT NOT NULL,                                         -- Nominal data
    last_name TEXT NOT NULL,                                          -- Nominal data
    email TEXT,                                                       -- Nominal data (no UNIQUE constraint)
    birth_year INTEGER CHECK (birth_year BETWEEN 1920 AND 2015),      -- Ratio data
    member_level TEXT CHECK (member_level IN                          -- Ordinal data
        ('Platinum', 'Gold', 'Silver', 'Basic')),
    preferred_reading_time REAL                                       -- Interval data (hours)
);

-- Create the Publishers table
CREATE TABLE Publishers (
    publisher_id INTEGER PRIMARY KEY AUTOINCREMENT,
    publisher_name TEXT NOT NULL,                                     -- Nominal data
    country TEXT,                                                     -- Nominal data
    email TEXT,                                                       -- Nominal data (no UNIQUE constraint)
    years_operating INTEGER                                           -- Ratio data
);

-- Create the Books table
CREATE TABLE Books (
    book_id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,                                              -- Nominal data
    genre TEXT NOT NULL,                                              -- Nominal data
    price REAL CHECK (price >= 0),                                    -- Ratio data
    popularity_score INTEGER CHECK (popularity_score BETWEEN 1 AND 10), -- Ordinal data
    shelf_life_days INTEGER,                                          -- Interval data
    publisher_id INTEGER,
    FOREIGN KEY (publisher_id) REFERENCES Publishers(publisher_id)
);

-- Create the Borrowings table
CREATE TABLE Borrowings (
    borrowing_id INTEGER PRIMARY KEY AUTOINCREMENT,
    patron_id INTEGER,
    book_id INTEGER,
    borrow_date DATE DEFAULT (DATE('now')),                           -- Interval data
    return_percentage REAL,                                           -- Ratio data (time used vs. allowed)
    FOREIGN KEY (patron_id) REFERENCES Patrons(patron_id),
    FOREIGN KEY (book_id) REFERENCES Books(book_id)
);

-- Create BookReviews table with composite key
CREATE TABLE BookReviews (
    patron_id INTEGER,
    book_id INTEGER,
    rating INTEGER CHECK (rating BETWEEN 1 AND 5),                    -- Ordinal data
    review_date DATE DEFAULT (DATE('now')),                           -- Interval data
    PRIMARY KEY (patron_id, book_id),                                 -- Composite key
    FOREIGN KEY (patron_id) REFERENCES Patrons(patron_id),
    FOREIGN KEY (book_id) REFERENCES Books(book_id)
);

-- Insert data into Patrons table
INSERT INTO Patrons (first_name, last_name, email, birth_year, member_level, preferred_reading_time)
VALUES
-- Using a mix of complete and incomplete data to demonstrate missing values
('John', 'Smith', 'john.smith123@example.com', 1985, 'Gold', 2.5),
('Emma', 'Johnson', 'emma.johnson456@example.com', 1992, 'Platinum', 3.0),
('Michael', 'Williams', NULL, 1978, 'Silver', 1.8),                -- Missing email
('Sophia', 'Brown', 'sophia.brown789@example.com', 2001, 'Basic', NULL), -- Missing preferred reading time
('David', 'Jones', 'david.jones234@example.com', 1993, 'Gold', 2.2),
('Olivia', 'Miller', 'emma.johnson456@example.com', 1997, 'Silver', 1.5), -- Duplicate email but no constraint
('Daniel', 'Davis', 'daniel.davis567@example.com', 1988, 'Basic', NULL),  -- Missing preferred reading time
('Emily', 'Garcia', NULL, 2005, 'Silver', 2.0),                     -- Missing email
('James', 'Rodriguez', 'james.rodriguez890@example.com', 1972, 'Basic', 3.4),
('Ava', 'Wilson', 'ava.wilson123@example.com', 1999, 'Platinum', 2.7);

-- Generate 990+ more Patron records using a loop
WITH RECURSIVE counter(i) AS (
    SELECT 1
    UNION ALL
    SELECT i+1 FROM counter WHERE i < 990
)
INSERT INTO Patrons (first_name, last_name, email, birth_year, member_level, preferred_reading_time)
SELECT
    -- Random selection from first names array
    CASE (abs(random()) % 10)
        WHEN 0 THEN 'John' WHEN 1 THEN 'Emma' WHEN 2 THEN 'Michael' 
        WHEN 3 THEN 'Sophia' WHEN 4 THEN 'David' WHEN 5 THEN 'Olivia'
        WHEN 6 THEN 'Daniel' WHEN 7 THEN 'Emily' WHEN 8 THEN 'James'
        ELSE 'Ava'
    END,
    -- Random selection from last names array
    CASE (abs(random()) % 10)
        WHEN 0 THEN 'Smith' WHEN 1 THEN 'Johnson' WHEN 2 THEN 'Williams' 
        WHEN 3 THEN 'Brown' WHEN 4 THEN 'Jones' WHEN 5 THEN 'Miller'
        WHEN 6 THEN 'Davis' WHEN 7 THEN 'Garcia' WHEN 8 THEN 'Rodriguez'
        ELSE 'Wilson'
    END,
    -- Email with random number suffix, ~5% will be NULL to represent missing data
    CASE WHEN (abs(random()) % 100) < 5 THEN NULL
    -- Using a different email pattern to avoid accidental conflicts
    ELSE 'patron' || i || '@mail.org'
    END,
    -- Random birth year between 1920 and 2015
    1920 + (abs(random()) % 96),
    -- Random member level
    CASE (abs(random()) % 4)
        WHEN 0 THEN 'Platinum' WHEN 1 THEN 'Gold' 
        WHEN 2 THEN 'Silver' ELSE 'Basic'
    END,
    -- Preferred reading time, ~10% will be NULL
    CASE WHEN (abs(random()) % 100) < 10 THEN NULL
    ELSE round(0.5 + (abs(random()) % 40) / 10.0, 1)
    END
FROM counter;

-- Insert data into Publishers table
INSERT INTO Publishers (publisher_name, country, email, years_operating)
VALUES
('Nova Books', 'USA', 'info@novabooks.com', 45),
('Global Publishing', 'UK', 'contact@globalpub.co.uk', 78),
('Sunrise Media', NULL, 'sunrise@media.org', 12),                 -- Missing country
('Literary Press', 'France', NULL, 23),                           -- Missing email
('Mountain Books', 'Canada', 'mountain@books.ca', 67),
('Ocean Publishers', 'Australia', NULL, 8),                       -- Missing email
('Galaxy Books', 'Germany', 'galaxy@books.de', 34),
('Horizon Press', 'Japan', 'info@horizonpress.jp', 19),
('Meadow Publishing', 'Italy', 'meadow@publishing.it', 51),
('Desert Books', 'UAE', 'info@desertbooks.ae', 15);

-- Generate 10 more Publisher records
WITH RECURSIVE counter(i) AS (
    SELECT 1
    UNION ALL
    SELECT i+1 FROM counter WHERE i < 10
)
INSERT INTO Publishers (publisher_name, country, email, years_operating)
SELECT
    'Publisher ' || (i+10),
    -- Random country
    CASE (abs(random()) % 10)
        WHEN 0 THEN 'Brazil' WHEN 1 THEN 'China' WHEN 2 THEN 'India' 
        WHEN 3 THEN 'Spain' WHEN 4 THEN 'Mexico' WHEN 5 THEN 'South Africa'
        WHEN 6 THEN 'Russia' WHEN 7 THEN 'Sweden' WHEN 8 THEN 'Netherlands'
        ELSE 'Singapore'
    END,
    -- Email with random number suffix, ~5% will be NULL
    CASE WHEN (abs(random()) % 100) < 5 THEN NULL
    ELSE 'publisher' || (i+10) || '@publishing.org'
    END,
    -- Random years operating between 1 and 120
    1 + (abs(random()) % 120)
FROM counter;

-- Insert data into Books table
INSERT INTO Books (title, genre, price, popularity_score, shelf_life_days, publisher_id)
VALUES
('The Mystery of the Lost Key', 'Mystery', 14.99, 8, 730, 1),
('Coding for Beginners', 'Technical', 29.99, 6, 1825, 2),
('A Journey Through Time', 'Fantasy', 19.99, 9, 1095, NULL),  -- No publisher assigned
('Healthy Cooking at Home', 'Cookbook', 24.99, 7, 545, 4),
('Business Strategy Guide', 'Business', 49.99, 5, 912, 5);

-- Generate 45 more Book records
WITH RECURSIVE counter(i) AS (
    SELECT 1
    UNION ALL
    SELECT i+1 FROM counter WHERE i < 45
)
INSERT INTO Books (title, genre, price, popularity_score, shelf_life_days, publisher_id)
SELECT
    'Book Title ' || (i+5),
    -- Random genre
    CASE (abs(random()) % 6)
        WHEN 0 THEN 'Fiction' WHEN 1 THEN 'Science' 
        WHEN 2 THEN 'History' WHEN 3 THEN 'Biography'
        WHEN 4 THEN 'Self-Help' ELSE 'Travel'
    END,
    -- Random price between 9.99 and 59.99
    round(9.99 + (abs(random()) % 50) + (abs(random()) % 100) / 100.0, 2),
    -- Random popularity score between 1 and 10
    1 + (abs(random()) % 10),
    -- Random shelf life between 30 and 2190 days (1 month to 6 years)
    30 + (abs(random()) % 2161),
    -- Random publisher ID, ~10% will be NULL
    CASE WHEN (abs(random()) % 100) < 10 THEN NULL
    ELSE 1 + (abs(random()) % 20)
    END
FROM counter;

-- Insert data into Borrowings table
-- First, create some specific borrowings
INSERT INTO Borrowings (patron_id, book_id, borrow_date, return_percentage)
VALUES
(1, 1, '2023-01-15', 92.5),
(1, 2, '2023-03-20', 78.3),
(2, 1, '2023-02-05', 100.0),
(3, 3, '2023-04-10', NULL),  -- In progress, no return yet
(4, 2, '2023-01-30', 85.7),
(5, 4, '2023-05-12', 45.2);

-- Generate 2000+ more Borrowing records
WITH RECURSIVE counter(i) AS (
    SELECT 1
    UNION ALL
    SELECT i+1 FROM counter WHERE i < 2000
),
-- Get patron and book counts
stats(patron_count, book_count) AS (
    SELECT 
        (SELECT COUNT(*) FROM Patrons),
        (SELECT COUNT(*) FROM Books)
)
INSERT INTO Borrowings (patron_id, book_id, borrow_date, return_percentage)
SELECT
    -- Random patron_id
    1 + (abs(random()) % (SELECT patron_count FROM stats)),
    -- Random book_id
    1 + (abs(random()) % (SELECT book_count FROM stats)),
    -- Random borrow date within the last 2 years
    date('now', '-' || (abs(random()) % 730) || ' days'),
    -- Random return percentage, ~30% will be NULL (currently borrowed)
    CASE WHEN (abs(random()) % 100) < 30 THEN NULL
    ELSE round((abs(random()) % 10000) / 100.0, 1)
    END
FROM counter;

-- Insert data into BookReviews table - FIXED VERSION
-- This approach guarantees no primary key violations
INSERT OR IGNORE INTO BookReviews (patron_id, book_id, rating, review_date)
WITH PotentialReviews AS (
    SELECT 
        patron_id,
        book_id,
        -- Random rating between 1 and 5
        1 + (abs(random()) % 5) AS rating,
        -- Review date after borrow date
        date(borrow_date, '+' || (abs(random()) % 90) || ' days') AS review_date
    FROM (
        SELECT DISTINCT patron_id, book_id, MAX(borrow_date) AS borrow_date
        FROM Borrowings
        GROUP BY patron_id, book_id
    ) AS UniqueBorrowings
    ORDER BY random() -- Random ordering
    LIMIT 1500  -- Aim for 1500 ratings
)
SELECT 
    patron_id, 
    book_id, 
    rating, 
    review_date
FROM PotentialReviews;

-- Verification queries to check data
-- Count records in each table
SELECT 'Patrons' AS Table_Name, COUNT(*) AS Record_Count FROM Patrons
UNION ALL
SELECT 'Publishers', COUNT(*) FROM Publishers
UNION ALL
SELECT 'Books', COUNT(*) FROM Books
UNION ALL
SELECT 'Borrowings', COUNT(*) FROM Borrowings
UNION ALL
SELECT 'BookReviews', COUNT(*) FROM BookReviews;

-- Display all table schemas
SELECT 'Patrons' AS Table_Name;
PRAGMA table_info(Patrons);

SELECT 'Publishers' AS Table_Name;
PRAGMA table_info(Publishers);

SELECT 'Books' AS Table_Name;
PRAGMA table_info(Books);

SELECT 'Borrowings' AS Table_Name;
PRAGMA table_info(Borrowings);

SELECT 'BookReviews' AS Table_Name;
PRAGMA table_info(BookReviews);

-- Sample of data from each table (limited to 10 records)
SELECT * FROM Patrons LIMIT 10;
SELECT * FROM Publishers LIMIT 10;
SELECT * FROM Books LIMIT 10;
SELECT * FROM Borrowings LIMIT 10;
SELECT * FROM BookReviews LIMIT 10;

-- Example report query with sample join
SELECT p.first_name, p.last_name, b.title, br.borrow_date, br.return_percentage
FROM Borrowings br
JOIN Patrons p ON br.patron_id = p.patron_id
JOIN Books b ON br.book_id = b.book_id
LIMIT 10;

-- Check for missing data
SELECT 
    COUNT(CASE WHEN email IS NULL THEN 1 END) AS PatronsWithoutEmail,
    COUNT(CASE WHEN preferred_reading_time IS NULL THEN 1 END) AS PatronsWithoutReadingTime
FROM Patrons;

-- Check for duplicate emails
SELECT email, COUNT(*) AS EmailCount
FROM Patrons
WHERE email IS NOT NULL
GROUP BY email
HAVING COUNT(*) > 1;

-- Check composite key usage
SELECT patron_id, COUNT(*) AS BooksReviewed
FROM BookReviews
GROUP BY patron_id
ORDER BY BooksReviewed DESC
LIMIT 5;