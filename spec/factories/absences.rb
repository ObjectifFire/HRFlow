FactoryBot.define do
  factory :absence do
    company { nil }
    employee { nil }
    date { "2025-04-08" }
    duration { "MyString" }
    status { "MyString" }
  end
end
