# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

User.create!(id: 0, email: "admin@email.com", password: "password", balance: 1000, role: 2, confirmed_at: DateTime.now)
User.create!(id: 1, email: "test1@email.com", password: "password", balance: 100000, role: 1, confirmed_at: DateTime.now)