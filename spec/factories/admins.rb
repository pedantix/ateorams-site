# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :admin do
    username { Faker::Name.name }
    email { Faker::Internet.email }

    password  "arandomhumansentence"
    password_confirmation  "arandomhumansentence"

    factory(:approved_admin) do
      approved true
      factory(:site_admin) do
        site_admin true
      end
    end
  end
end
