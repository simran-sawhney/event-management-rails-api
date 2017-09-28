# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create!(:name => 'Simran', :password => '7c4a8d09ca3762af61e59520943dc26494f8941b', :email => 'simran2194@gmail.com', :is_admin => true)