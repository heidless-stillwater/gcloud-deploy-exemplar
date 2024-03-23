# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# 10.times do |x|
#   Post.create(title: "Title", body: "Body words go here...")
# end

User.create(email: 'rob.lockhart@yahoo.com.uk', password: 'password', password_confirmation: 'password')

10.times do |n|
  title  = "title 1 - #{n} - minimum length"
  body = "body here - #{n} - minimum length"
  Post.create!(
    title: title,
    body: body,
    user_id: User.first.id)
end

# 99.times do |n|
#   name  = Faker::Name.name
#   email = "example-#{n+1}@railstutorial.org"
#   password = "password"
#   User.create!(name: name,
#               email: email,
#               password:              password,
#               password_confirmation: password,
#               activated: true,
#               activated_at: Time.zone.now)
# end