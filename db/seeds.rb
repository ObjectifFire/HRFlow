require 'csv'

EMPLOYEES_CSV = 'db/csv/users.csv'
COMPANIES_CSV = 'db/csv/companies.csv'
COMPANIES_EMPLOYEES_CSV = 'db/csv/companies_users.csv'
ABSENCES_CSV = 'db/csv/absences.csv'

puts "Importing employees..."
employees = []
CSV.foreach(EMPLOYEES_CSV, headers: true) do |row|
  employees << Employee.new(
    email: row['Email'],
    first_name: row['Prénom'],
    last_name: row['Nom'],
    country: row['Pays']
  )
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

puts "Importing absences..."
absences = []
CSV.foreach(ABSENCES_CSV, headers: true) do |row|
  employee = Employee.find_by(email: row['Email'])
  company = Company.find_by(siret: row['SIRET'])
  next unless employee && company

  absences << Absence.new(
    employee: employee,
    company: company,
    date: Date.strptime(row['Date'], '%d/%m/%y'),
    duration: row['Durée'],
    status: row['Etat']
  )
end

absences.each_slice(999) do |batch|
  Absence.import batch, validate: true
end

puts "Seeding complete!"
