require 'rails_helper'

RSpec.describe "Posts", type: :request do
  let(:valid_attributes) {
    { title: 'Teste', content: 'Conteúdo', user: user }
  }

  let(:invalid_attributes) {
    { title: '', content: '' }
  }

  let!(:valid_headers) {
    token = JsonWebToken.encode(user_id: user.id)
    { "Authorization" => "Bearer #{token}" }
  }

  let(:invalid_headers) {
    { "Authorization" => "Bearer Invalid123" }
  }

  let(:user) {
    User.create!(name: "User Test", email: "teste@teste.com", password: "Teste123", password_confirmation: "Teste123")
  }

  describe "GET /posts" do
    it "renders a list of posts" do
      post = Post.create! valid_attributes
      get posts_url, as: :json
      expect(response).to have_http_status(:ok)
      expect(response.parsed_body).to be_an(Array)
      expect(response.parsed_body).to include(a_hash_including("id" => post.id))
    end
  end

  describe "GET /posts/:id" do
    it "renders a post" do
      post = Post.create! valid_attributes
      get post_url(post), as: :json
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['id']).to eq(post.id)
      expect(json['title']).to eq(post.title)
      expect(json['content']).to eq(post.content)
    end
    it "renders a not found response" do
      get post_url(0), as: :json
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /posts" do
    context "without token" do
      it "renders a unauthorized response" do
        post posts_url, params: { post: valid_attributes }, headers: invalid_headers, as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
    context "with token" do
      context "with valid parameters" do
        it "creates a new Post" do
          expect {
            post posts_url,
                params: { post: valid_attributes }, headers: valid_headers, as: :json
          }.to change(Post, :count).by(1)
          expect(Post.last.user).to eq(user)
          expect(response).to have_http_status(:created)
        end

        it "renders a JSON response with the new post" do
          post posts_url,
              params: { post: valid_attributes }, headers: valid_headers, as: :json
          expect(response).to have_http_status(:created)
          expect(response.content_type).to match(a_string_including("application/json"))
        end
      end

      context "with invalid parameters" do
        it "does not create a new Post" do
          expect {
            post posts_url,
                params: { post: invalid_attributes }, as: :json
          }.to change(Post, :count).by(0)
        end

        it "renders a JSON response with errors for the new post" do
          post posts_url,
              params: { post: invalid_attributes }, headers: valid_headers, as: :json
          expect(response).to have_http_status(:unprocessable_content)
          expect(response.content_type).to match(a_string_including("application/json"))
        end
      end
    end
  end

  describe "PATCH /posts/:id" do
    context "without token" do
      it "renders a unauthorized response" do
        post = Post.create! valid_attributes
        patch post_url(post), params: { post: valid_attributes }, headers: invalid_headers, as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "with token" do
      context "with valid parameters" do
        let(:new_attributes) {
          { title: "Novo Título" }
        }

        it "updates the requested post" do
          post = Post.create! valid_attributes
          patch post_url(post),
                params: { post: new_attributes }, headers: valid_headers, as: :json
          post.reload
          expect(post.title).to eq("Novo Título")
        end

        it "renders a JSON response with the post" do
          post = Post.create! valid_attributes
          patch post_url(post),
                params: { post: new_attributes }, headers: valid_headers, as: :json
          expect(response).to have_http_status(:ok)
          expect(response.content_type).to match(a_string_including("application/json"))
        end
      end

      context "with invalid parameters" do
        it "renders a JSON response with errors for the post" do
          post = Post.create! valid_attributes
          patch post_url(post),
                params: { post: invalid_attributes }, headers: valid_headers, as: :json
          expect(response).to have_http_status(:unprocessable_content)
          expect(response.content_type).to match(a_string_including("application/json"))
        end
      end
    end
  end

  describe "DELETE /posts/:id" do
    context "without token" do
      it "renders a unauthorized response" do
        post = Post.create! valid_attributes
        delete post_url(post), headers: invalid_headers, as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
    context "with token" do
      it "destroys the requested post" do
        post = Post.create! valid_attributes
        expect {
          delete post_url(post), headers: valid_headers, as: :json
        }.to change(Post, :count).by(-1)
      end
    end
  end
end
