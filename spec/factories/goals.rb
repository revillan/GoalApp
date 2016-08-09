FactoryGirl.define do
  factory :goal do
    name {Faker::Name.name}
    user_id 1


    factory :private_goal do
      private true
    end

    factory :completed_goal do
      completed true
    end
  end
end
