FactoryBot.define do
  factory :student do
    school_class
    sequence(:name) { |n| "Max #{n}" }
    sequence(:seat_row) { |n| n }
    sequence(:seat_col) { |n| n }
  end
end
