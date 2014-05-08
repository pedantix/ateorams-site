# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :post do
    body { Faker::Lorem.paragraphs.join(". \n\n")}
    sequence :title do |n|
      "my_title #{n}."
    end

    trait :with_author do
      after(:create) do |post, eval|
        post.admins << create(:admin, username:"Shaun Hubbard")
      end

    end
  end
end
