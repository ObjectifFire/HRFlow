SETUP:
bundle install
rails db:create db:migrate db:seed
rails server

📋 Project Requirements (Summary)
The HR department is migrating to a new system using APIs and has provided several CSV files to seed the database:

companies.csv: List of companies

users.csv: List of employees

companies_users.csv: Company-employee assignments

absences.csv: Employee leave requests

You are free to design and structure the data in the way you think is best to meet HR’s needs.

🎯 Goals
Develop a Ruby or Rails application that can:

Import data from the CSV files into the database

Expose a public API allowing:

List companies (without revenue info)

List/add/delete employees

Required fields: first_name, last_name, email (email must be unique)

Assign or unassign employees to companies

Employees can submit leave requests (create/cancel)

Leave requests are created with status "pending"

Only future, "pending" requests can be canceled

Expose an admin API allowing:

List companies including revenue info

List/add/delete employees (only email is required and must be unique)

Assign/unassign employees to companies

Submit or update any leave request

Admin can set any status (pending, validated, cancel) regardless of the date

