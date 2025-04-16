require 'csv'

EMPLOYEES_CSV = 'db/csv/users.csv'
COMPANIES_CSV = 'db/csv/companies.csv'
COMPANIES_EMPLOYEES_CSV = 'db/csv/companies_users.csv'
LEAVE_REQUESTS_CSV = 'db/csv/absences.csv'

puts "Importing employees..."
employees = []
hr_id_sequence = 1

CSV.foreach(EMPLOYEES_CSV, headers: true) do |row|
  employees << Employee.new(
    email: row['Email'],
    first_name: row['Prénom'],
    last_name: row['Nom'],
    country: row['Pays'],
    employee_hr_id: "HR#{hr_id_sequence.to_s.rjust(5, '0')}" # HR00001, HR00002...
  )
  hr_id_sequence += 1
end

employees.each_slice(999) do |batch|
  Employee.import batch, validate: true, on_duplicate_key_ignore: true
end


puts "Importing companies..."
companies = []
CSV.foreach(COMPANIES_CSV, headers: true) do |row|
  companies << Company.new(
    siret: row['SIRET'],
    name: row['Nom'],
    country: row['Pays'],
    revenue_2024: row['CA 2024'].to_i
  )
end

companies.each_slice(999) do |batch|
  Company.import batch, validate: true, on_duplicate_key_ignore: true
end

puts "Linking companies and employees..."
links = []
CSV.foreach(COMPANIES_EMPLOYEES_CSV, headers: true) do |row|
  employee = Employee.find_by(email: row['Email'])
  company = Company.find_by(siret: row['SIRET'])
  next unless employee && company

  links << CompaniesEmployee.new(employee: employee, company: company)
end

links.each_slice(999) do |batch|
  CompaniesEmployee.import batch, validate: false
end

puts "Importing leave_requests..."
CSV.foreach(LEAVE_REQUESTS_CSV, headers: true) do |row|
  employee = Employee.find_by(email: row['Email'])
  company = employee.company
  next unless employee && company

  LeaveRequest.insert_all([
    {
      employee_id: employee.id,
      company_id: company.id,
      date: Date.strptime(row['Date'], '%d/%m/%y'),
      duration: row['Durée'],
      created_at: Time.current,
      updated_at: Time.current
    }
  ])
end

puts "Seeding complete!"
