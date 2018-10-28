FactoryGirl.define do
  factory :building do
    broadcasting
    name
    district
    locality
    state 'published'
    latitude
    longitude
    start_date { generate :date }
    finish_date { start_date + 10.days }
    description
  end
end
