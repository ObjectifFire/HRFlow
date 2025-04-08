FactoryBot.define do
  factory :leave_request do
    company { nil }
    employee { nil }
    date { "2025-04-08" }
    duration { "MyString" }
    status { "MyString" }
  end
end
