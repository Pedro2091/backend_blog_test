# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

user = User.create!(name: "User 1", email: "test@gmail.com")

Rails.logger.info "O valor da variável é: #{@user}"

5.times do |i|
  post = Post.create!(title: "Post ##{i}", content: "A post.", user_id: user.id)
  5.times do |j|
    Comment.create!(name: "Coment ##{j}", content: "A comment.", post_id: post.id)
  end
end
