FactoryBot.define do
  factory :leave_request do
    association :company
    association :employee

    date     { Faker::Date.forward(days: 10) }
    duration { [ "0.5 days", "1 day", "2 days" ].sample }
    status   { "En attente de validation" }
  end
end
