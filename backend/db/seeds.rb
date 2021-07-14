# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

p "Deleting everything"
Product.destroy_all

p "Creating products..."
product_names = %w(Netflix Dental Masterclass Sushiclass Spotify Newshoes Cinemaclub Surfclass Gym Ubereats)
product_names.each do |product_name|
  Product.create(name: product_name, price: rand(10.00..200.00).round(2))
end
p "Created products!"
