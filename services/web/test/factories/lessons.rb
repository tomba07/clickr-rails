FactoryBot.define do
  factory :lesson do
    name { Faker::Commerce.unique.product_name }
    school_class # short_hand for association with factory
  end
end
