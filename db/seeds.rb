# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# Users
user1 = User.create(name: 'John Doe', email: 'john@example.com')
user2 = User.create(name: 'Jane Smith', email: 'jane@example.com')
user3 = User.create(name: 'No comments', email: 'nocomment@example.com')

# Items
item1 = Item.create(name: 'Laptop', price: 1000, quantity: 1)
item2 = Item.create(name: 'Mouse', price: 25, quantity: 2)

# Orders
Order.create(user: user1, total_price: 100, status: 'completed', item: item1)
Order.create(user: user1, total_price: 50, status: 'pending', item: item2)

# Posts
post1 = Post.create(user: user1, title: 'Learning Rails', content: 'Active Record is amazing!')
post2 = Post.create(user: user2, title: 'Tips for Ruby', content: 'Use irb for quick testing.')

# Comments
Comment.create(commentable: post1, user: user2, content: 'Great post!')
Comment.create(commentable: post2, user: user1, content: 'Thanks for sharing!')

# Categories
category1 = Category.create(name: 'Programming')
category2 = Category.create(name: 'Tips')
post1.categories << category1
post2.categories << [category1, category2]
