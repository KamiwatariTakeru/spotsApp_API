# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Post.create!(
    [
      {
        name: 'Next.js + Ruby on Rails + Docker の環境構築'
      },
      {
        name: 'React Hooks でカスタムフックを作る'
      },
      {
        name: 'GraphQL と Apollo Client 入門'
      },
      {
        name: '【TypeScript4.3】Template Literal Types'
      },
      {
        name: 'Tailwind CSS でダークモード実装'
      },
    ]
  )