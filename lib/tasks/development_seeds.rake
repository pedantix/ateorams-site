if Rails.env.development?
  require 'factory_girl'

  namespace :dev do
    desc 'Seed data for development environment'
    task prime: 'db:setup' do
      FactoryGirl.find_definitions
      include FactoryGirl::Syntax::Methods

      # create(:user, email: 'user@example.com', password: 'password')
      


    end

    desc "add 200 posts for dev"
    task posts: :environment do
      require 'ffaker'
      admin = Admin.first_or_create! do |admin|
        admin.email = ENV['SITE_ADMIN_EMAIL']
        admin.password = ENV['SITE_ADMIN_PASSWORD']
        admin.password_confirmation = ENV['SITE_ADMIN_PASSWORD']
        admin.username = ENV['SITE_ADMIN_NAME']
        admin.twitter_handle = ENV['SITE_ADMIN_TWITTER']
      end
      200.times do |n| 
        post =  Post.create!(
          title: Faker::Lorem.word + " #{n}",

          body: Faker::Lorem.paragraphs.join("\n\n")



          )
        post.admins << admin
      end
   
    end
  end
end
