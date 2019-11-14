FactoryBot.define do
  factory :school_class do
    name { Faker::Name.unique.initials }
  end
end
