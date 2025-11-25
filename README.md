# CarDealershipDatabase – Dealership Management SQL System

## Description of the Project

CarDealershipDatabase is a fully structured SQL project that simulates a car dealership management system.
It includes a complete database creation script that builds all tables, relationships, and sample data required for managing dealerships, vehicles, inventory, sales contracts, and optional lease contracts.

This project also includes a set of test SQL files that verify functionality such as retrieving dealerships, locating vehicles, searching by VIN, and viewing sales records by date range.

## User Stories

- As a database administrator, I want to run a single SQL script, so I can create or recreate the entire dealership database easily.

- As a dealership manager, I want to store dealerships, vehicles, and inventory records, so I can track which cars belong to which location.

- As a salesperson, I want to record sales contracts, so I can keep accurate sales history and buyer information.

- As an inventory specialist, I want to search for cars by VIN, make, model, or color, so I can locate vehicles efficiently.

- As a business owner, I want to run analytical queries, so I can understand performance, demand, and sales patterns.

- As a developer, I want the database script to be clean, well-formatted, and error-free, so it can be easily maintained and improved.

## Setup

Instructions on how to set up and run the project using MySQL Workbench.

### Prerequisites

- MySQL Workbench

Ensure you have MySQL Workbench installed.
Download here: https://dev.mysql.com/downloads/workbench/

- MySQL Server

Make sure MySQL Server is installed and running on your machine.

### Running the Project in MySQL Workbench

Follow these steps to create and test your database:

Open MySQL Workbench.

Connect to your local MySQL Server instance.

Click File → New Query Tab.

Open the file car_dealership_db.sql and paste or load it into the query window.

Click the lightning bolt ⚡ (Execute) to run the script.

Once executed, the database will be created automatically and seeded with sample data.

To test functionality, open each file inside the /queries folder and run them individually (e.g., “Get all dealerships”, “Find car by VIN”, etc.).

## Technologies Used

- MySQL Server & MySQL Workbench

- SQL (DDL, DML, indexing, constraints)

- Relational Database Design

- Entity Relationships (1–many, many–many via link tables)

- Sample data seeding scripts

- Modular query testing

## Future Work
- Add stored procedures for automated reporting

- Add triggers for automatic sold/available status updates

- Add a dealership revenue analytics view

- Add audit logging tables

- Add user roles (admin, sales, service, etc.)

## Resources
These references supported the creation of this project:

- MySQL Documentation – https://dev.mysql.com/doc/

- W3Schools SQL Guide – https://www.w3schools.com/sql/

- Northwind Database Schema Reference

- SQL Indexing Best Practices

## Team Members

- Wasid Chowdhury

## Thanks

- Thank you to Raymond Potato Sensei for continuous support and guidance.
