require 'rails_helper'

RSpec.describe "/comments", type: :request do
  let!(:valid_attributes) {
    { name: 'Commenter', content: 'Conteúdo' }
  }

  let(:invalid_attributes) {
    { name: '', content: '' }
  }

  let(:user) {
    User.create!(name: "User Test", email: "teste@teste.com", password: "Teste123", password_confirmation: "Teste123")
  }

  let(:post_record) {
    Post.create!(title: "Test Post", content: "Post content", user: user)
  }

  describe "GET /posts/:post_id/comments" do
    it "renders a list of comments for the specified post" do
      comment = Comment.create!(valid_attributes.merge(post: post_record))
      get post_comments_url(post_record), as: :json
      expect(response).to have_http_status(:ok)
      expect(response.parsed_body).to be_an(Array)
      expect(response.parsed_body).to include(a_hash_including("id" => comment.id, "post_id" => post_record.id))
    end
  end

  describe "POST /posts/:post_id/comments" do
    context "with valid parameters" do
      it "creates a new Comment" do
        expect {
          post post_comments_url(post_record),
               params: { comment: valid_attributes }, as: :json
        }.to change(Comment, :count).by(1)
        expect(response).to have_http_status(:created)
      end

      it "renders a JSON response with the new comment" do
        post post_comments_url(post_record),
             params: { comment: valid_attributes }, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Comment" do
        expect {
          post post_comments_url(post_record),
               params: { comment: invalid_attributes }, as: :json
        }.to change(Comment, :count).by(0)
      end

      it "renders a JSON response with errors for the new comment" do
        post post_comments_url(post_record),
             params: { comment: invalid_attributes }, as: :json
        expect(response).to have_http_status(:unprocessable_content)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
    context "in a inexistent post" do
      it "does not create a new Comment" do
        expect {
          post post_comments_url(0),
               params: { comment: invalid_attributes }, as: :json
        }.to change(Comment, :count).by(0)
      end

      it "renders a not found response" do
        post post_comments_url(0),
             params: { comment: invalid_attributes }, as: :json
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
