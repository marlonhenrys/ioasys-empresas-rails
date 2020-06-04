# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create(
    name: 'System Admin',
    phone: '(00)0000-0000',
    email: 'admin@system.com.br',
    password: 'admin:p@ss',
    role: 'admin'
    )