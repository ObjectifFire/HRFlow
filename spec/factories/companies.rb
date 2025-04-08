FactoryBot.define do
  factory :company do
    siret        { Faker::Number.unique.number(digits: 14).to_s }
    name         { Faker::Company.name }
    country      { Faker::Address.country }
    revenue_2024 { Faker::Number.number(digits: 6) }
  end
end
