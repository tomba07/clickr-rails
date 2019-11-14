FactoryBot.define do
  factory :student do
    school_class
    name { Faker::FunnyName.unique.name }

    after(:build) { |s| s.seat_row, s.seat_col = Faker::Base.unique.regexify(/[0-9]{2}-[0-9]{2}/).split('-') }
  end
end
