# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Admin.create!(
  email: "test@email.com", ## admin_address
  password: "test50854" ## admin_password
)

days = %w(月 火 水 木 金 土 日 祝日)
days.each{ |day| Day.create!(name: day) }
