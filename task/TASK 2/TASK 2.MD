# Task 2: Database Concepts

### 1. Issues Faced with Excel Files and Database Solutions
* **Data Redundancy and Inconsistency:** In Excel, the same customer or product details can be entered multiple times across different rows, leading to a risk where information is updated in one place but forgotten in another. Relational Databases (RDBMS) solve this by using normalization rules and unique keys to ensure that each piece of data is stored securely in only one location.
* **Concurrency Issues:** When multiple users attempt to edit the same Excel file simultaneously, the file locks up, or users run the risk of overwriting each other's data. Databases, on the other hand, utilize transaction management and locking mechanisms to allow thousands of users to access and modify data safely at the same time.
* **Lack of Security and Authorization:** Excel files do not allow granular, user-based access control; anyone who opens the spreadsheet can view or delete all the cells. Databases solve this via Role-Based Access Control (RBAC), strictly limiting which user can view, insert, or modify specific tables and rows.

### 2. The Purpose of a Primary Key and the Evaluation of Identifiers
A primary key is a specific column that uniquely and unmistakably identifies each row (record) in a table, and it can never contain a NULL value. A student number is an excellent primary key because it is uniquely assigned to each student, remains unchanged, and guarantees absolute uniqueness. Conversely, a first and last name is a poor choice for a primary key because multiple individuals can share the exact same name (e.g., two students named "Ali Yılmaz"), failing to guarantee uniqueness.

### 3. Difference Between a Database Management System (DBMS) and a Database
A database is the physical collection of structured data stored systematically on a computer disk. A Database Management System (DBMS), however, is the software engine that allows us to read, write, secure, and administer this data. The **PostgreSQL** system we are using in this course is a powerful, open-source Database Management System (DBMS).

### 4. Concurrent Modifications by Multiple Users
If two users attempt to modify the exact same database record at the same time, the DBMS activates its concurrency locking mechanism to serialize the operations; this ensures that the first committed transaction takes effect while the competing modification is either queued or safely aborted.
 