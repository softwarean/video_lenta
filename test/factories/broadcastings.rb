FactoryGirl.define do
  factory :broadcasting do
    url
    slug
    camera_type :http

    trait :active do
      last_frame_time Time.now
    end

    factory :active_broadcasting, traits: [:active]
  end
end
