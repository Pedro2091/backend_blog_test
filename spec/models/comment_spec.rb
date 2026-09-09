require 'rails_helper'

RSpec.describe Comment, type: :model do
 it "is valid with name, content and post" do
    user = User.create!(name: "Ana", email: "ana@ex.com", password: "123456")
    post = Post.create!(title: "Post Test 1", content: "Post Test 1 Content", user: user)
    comment = Comment.create!(name: "Comment Test 1", content: "Comment Test 1 Content", post: post)
    expect(comment).to be_valid
  end

  it "is invalid without content" do
    user = User.create!(name: "Ana", email: "ana@ex.com", password: "123456")
    post = Post.create!(title: "Post Test 1", content: "Post Test 1 Content", user: user)
    comment = Comment.new(name: "Comment Test 1", post: post)
    expect(comment).to be_invalid
  end

  it "is invalid without post" do
    comment = Comment.new(name: "Comment Test 1", content: "Post Test 1 Content")
    expect(comment).to be_invalid
  end

  it "is associate to a post" do
    user = User.create!(name: "Ana", email: "ana@ex.com", password: "123456")
    post = Post.create!(title: "Post Test 1", content: "Post Test 1 Content", user: user)
    comment = Comment.create!(name: "Comment Test 1", content: "Post Test 1 Content", post: post)
    expect(comment.post).to eq(post)
  end
end
