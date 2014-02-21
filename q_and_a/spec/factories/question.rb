FactoryGirl.define do 
  factory :question do
    # make it unique
    sequence(:topic){ |n| "#{Faker::Lorem.sentence} #{n}"}
    # title Faker::Lorem.sentence
    body Faker::Lorem.sentence
  end 
end

