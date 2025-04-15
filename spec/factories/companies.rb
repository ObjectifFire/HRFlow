FactoryBot.define do
  factory :company do
    siret        { Faker::Number.unique.number(digits: 14).to_s }
    name         { Faker::Company.name }
    country      { Faker::Address.country }
    revenue_2024 { Faker::Number.number(digits: 6) }

    trait :with_employees do
      transient do
        employees_count { 3 }
      end

      after(:create) do |company, evaluator|
        evaluator.employees_count.times do
          employee = create(:employee)
          create(:companies_employee, company: company, employee: employee)
        end
      end
    end
  end
end
