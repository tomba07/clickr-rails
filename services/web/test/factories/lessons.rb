FactoryBot.define do
  factory :lesson do
    sequence(:name) { |n| "Lesson #{n}" }
    school_class # short_hand for association with factory
  end
end
