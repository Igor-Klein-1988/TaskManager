FactoryBot.define do
  sequence :string, aliases: [:first_name, :last_name, :password] do |n|
    "string#{n}"
  end

  sequence :email do |n|
    "person_#{n}@test.com"
  end
end
