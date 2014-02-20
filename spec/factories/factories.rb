FactoryGirl.define do

  sequence :email do |n|
    "person#{n}@example.com"
  end

  factory :attendee do
    email { generate(:email) }
    name "Me"
    company "CodeCore"
  end

  factory :attendance do
    event
    attendee

    trait :waitlisted do
      waitlisted 'true'
    end
  end

  factory :category do
    name 'Category Name'
  end

  factory :categories do
    title 'Upcoming Event'
    date 7.days.from_now
    seats 10

    trait :full do
      seats 0
    end
  end

  factory :event do
    title 'Upcoming Event'
    date 7.days.from_now
    seats 10

    trait :full do
      seats 0
    end
  end

  factory :user do
    email { generate(:email) }
    password 'password'
  end

end
