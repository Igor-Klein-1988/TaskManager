FactoryBot.define do
  factory :task do
    name { generate :string }
    description { generate :string }
    association :author, factory: :manager
    association :assignee, factory: :developer
    state { 'in_development' }
    expired_at { 10.days.from_now }
  end
end
