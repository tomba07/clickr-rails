FactoryBot.define do
  factory :school_class do
    sequence(:name) { |n| "Class #{n}" }
  end
end
