FactoryBot.define do
  factory :employee do
    first_name { Faker::Name.first_name }
    last_name  { Faker::Name.last_name }
    sequence(:email) { |n| "user#{n}@gmail.com" }
    sequence(:employee_hr_id) { |n| "HR#{n.to_s.rjust(5, '0')}" } # HR00001, HR00002...
    country    { Faker::Address.country }
  end
end
