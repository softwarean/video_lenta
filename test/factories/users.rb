FactoryGirl.define do
  factory :user do
    email
    password
    password_confirmation { password }
    role :moderator

    trait :admin do
      role :admin
    end

    factory :admin, traits: [:admin]
  end
end
