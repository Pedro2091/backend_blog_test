require 'rails_helper'

RSpec.describe User, type: :model do
  it "is valid with name, email and password" do
    user = User.new(name: "Ana", email: "ana@ex.com", password: "123456")
    expect(user).to be_valid
  end

  it "is invalid without name" do
    user = User.new(email: "ana@ex.com", password: "123456")
    expect(user).to be_invalid
  end

  it "is invalid without password" do
    user = User.new(name: "Ana", email: "ana@ex.com")
    expect(user).to be_invalid
  end

  it "is invalid without email" do
    user = User.new(name: "Ana", password: "123456")
    expect(user).to be_invalid
  end

  # it "is invalid with a invalid email" do
  #   user = User.create!(name: "Ana", email: "stringwhatever", password: "123456")
  #   expect(user).to be_invalid
  # end

  it "is invalid with email duplicated" do
    User.create!(name: "Ana", email: "ana@ex.com", password: "123456")
    user2 = User.new(name: "Bia", email: "ana@ex.com", password: "654321")
    expect(user2).to be_invalid
  end

  it "is password save in hash" do
    user = User.create!(name: "Ana", email: "ana@ex.com", password: "123456")

    expect(user.password_digest).not_to eq("123456")
    expect(user.password_digest).to be_present
  end

  it "has many posts" do
    expect(User.reflect_on_association(:posts).macro).to eq(:has_many)
  end
  it "delete user delete posts" do
    user = User.create!(name: "Ana", email: "ana@ex.com", password: "123456")
    post1 = Post.create!(title: "Post Test 1", content: "Post Test 1 Content", user: user)
    post2 = Post.create!(title: "Post Test 2", content: "Post Test 2 Content", user: user)

    user.destroy

    expect(User.exists?(user.id)).to be false
    expect(Post.exists?(post1.id)).to be false
    expect(Post.exists?(post2.id)).to be false
  end
end
