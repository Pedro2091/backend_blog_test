require 'rails_helper'

RSpec.describe Post, type: :model do
  it "is valid with title, content and user" do
    user = User.create!(name: "Ana", email: "ana@ex.com", password: "123456")
    post = Post.create!(title: "Post Test 1", content: "Post Test 1 Content", user: user)
    expect(post).to be_valid
  end

  it "is invalid without title" do
    user = User.create!(name: "Ana", email: "ana@ex.com", password: "123456")
    post = Post.new(content: "Post Test 1 Content", user: user)
    expect(post).to be_invalid
  end

  it "is invalid without user" do
    post = Post.new(title: "Post Test 1", content: "Post Test 1 Content")
    expect(post).to be_invalid
  end

  it "is associate to a user" do
    user = User.create!(name: "Ana", email: "ana@ex.com", password: "123456")
    post = Post.new(title: "Post Test 1", content: "Post Test 1 Content", user: user)
    expect(post.user).to eq(user)
  end

  it "has many comments" do
    expect(Post.reflect_on_association(:comments).macro).to eq(:has_many)
  end

  it "delete post delete comments" do
    user = User.create!(name: "Ana", email: "ana@ex.com", password: "123456")
    post = Post.create!(title: "Post Test 1", content: "Post Test 1 Content", user: user)
    comment1 = Comment.create!(name: "Post Test 1", content: "Post Test 1 Content", post: post)
    comment2 = Comment.create!(name: "Post Test 2", content: "Post Test 2 Content", post: post)

    post.destroy

    expect(Comment.exists?(comment1.id)).to be false
    expect(Comment.exists?(comment2.id)).to be false
  end
end
