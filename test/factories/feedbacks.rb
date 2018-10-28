FactoryGirl.define do
  factory :feedback do
    reason "broadcast_quality"
    text
    author
    email
  end
end
