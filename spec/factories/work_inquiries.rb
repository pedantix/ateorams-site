# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :work_inquiry do
    client_name { Faker::Name.name }
    client_email { Faker::Internet.email }
    client_phone { Faker::PhoneNumber.phone_number }
    job_description { Faker::Lorem.paragraph }
    budget { Faker::Lorem.sentence }
    reply false

    factory :replied_inquiry do
      reply true
    end
  end
end
