FactoryGirl.define do

  sequence :name do |n|
    "name_#{n}"
  end

  sequence :email do |n|
    "email_#{n}@example.org"
  end

  sequence :password do |n|
    "password_#{n}"
  end

  sequence :date do |n|
    Date.today - n.days
  end

  sequence :description do |n|
    "description_#{n}"
  end

  sequence :text do |n|
    "text_#{n}"
  end

  sequence :author do |n|
    "author_#{n}"
  end

  sequence :url do |n|
    "rtsp://someone:something#{n}@8.8.8.8:8888/data?snapShotImageType=JPEG"
  end

  sequence :slug do |n|
    "slug_#{n}"
  end

  sequence :locality do |n|
    "locality_#{n}"
  end

  sequence :latitude do |n|
    n.to_f
  end

  sequence :longitude do |n|
    n.to_f
  end
end
