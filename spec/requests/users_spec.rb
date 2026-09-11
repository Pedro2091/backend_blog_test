require 'rails_helper'

RSpec.describe "/users", type: :request do
  let(:valid_attributes) {
    { name: "Maria", email: "novo_usuario@teste.com", password: "Teste123", password_confirmation: "Teste123" }
  }

  let(:invalid_attributes) {
    { email: "", password: "123", password_confirmation: "456" }
  }

  let!(:valid_headers) {
    admin = User.create!(name: "Admin", email: "admin@teste.com", password: "Teste123", password_confirmation: "Teste123")
    token = JsonWebToken.encode(user_id: admin.id)
    { "Authorization" => "Bearer #{token}" }
  }

  let(:invalid_headers) {
    { "Authorization" => "Bearer Invalid123" }
  }

  describe "GET /users" do
    context "without token" do
      it "renders a unauthorized response" do
        get users_url, params: { user: valid_attributes }, headers: invalid_headers, as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "with token" do
      it "renders a list of users" do
        user = User.create! valid_attributes
        get users_url, headers: valid_headers, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body).to be_an(Array)
        expect(response.parsed_body).to include(a_hash_including("id" => user.id))
      end
    end
  end

  describe "GET /users/:id" do
    context "without token" do
      it "renders a unauthorized response" do
        user = User.create! valid_attributes
        get users_url(user),
          params: { user: valid_attributes }, headers: invalid_headers, as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "with token" do
      context "with existent id" do
        it "renders a user" do
          user = User.create! valid_attributes
          get user_url(user), headers: valid_headers, as: :json
          expect(response).to have_http_status(:ok)
          json = JSON.parse(response.body)
          expect(json['id']).to eq(user.id)
          expect(json['email']).to eq(user.email)
          expect(json['name']).to eq(user.name)
        end
      end

      context "with inexistent id" do
        it "renders a not found response" do
          get user_url(0), headers: valid_headers, as: :json
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end

  describe "POST /users" do
    context "without token" do
      it "renders a unauthorized response" do
        post users_url,
          params: { user: valid_attributes }, headers: invalid_headers, as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "with token" do
      context "with valid parameters" do
        it "creates a new User" do
          expect {
          post users_url,
            params: { user: valid_attributes }, headers: valid_headers, as: :json
          }.to change(User, :count).by(1)
          expect(response).to have_http_status(:created)
        end

        it "renders a JSON response with the new user" do
          post users_url,
              params: { user: valid_attributes }, headers: valid_headers, as: :json
          expect(response).to have_http_status(:created)
          expect(response.content_type).to match(a_string_including("application/json"))
        end
      end

      context "with invalid parameters" do
        it "does not create a new User and returns errors" do
          expect {
            post users_url,
                params: { user: invalid_attributes }, headers: valid_headers, as: :json
          }.to change(User, :count).by(0)
            expect(response).to have_http_status(:unprocessable_content)
            json = JSON.parse(response.body)
            expect(json).to be_present
        end

        it "renders a JSON response with errors for the new user" do
          post users_url,
              params: { user: invalid_attributes }, headers: valid_headers, as: :json
          expect(response).to have_http_status(:unprocessable_content)
          expect(response.content_type).to match(a_string_including("application/json"))
        end
      end
    end
  end

  describe "PATCH /users/:id" do
    context "without token" do
      it "renders a unauthorized response" do
        user = User.create! valid_attributes
        patch user_url(user),
             params: { user: valid_attributes }, headers: invalid_headers, as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
    context "with token" do
      context "with valid parameters" do
        let(:new_attributes) {
          { email: "novo@teste.com" }
        }

        it "updates the requested user" do
          user = User.create! valid_attributes
          patch user_url(user),
                params: { user: new_attributes }, headers: valid_headers, as: :json
          user.reload
          expect(user.email).to eq("novo@teste.com")
        end

        it "renders a JSON response with the user" do
          user = User.create! valid_attributes
          patch user_url(user),
                params: { user: new_attributes }, headers: valid_headers, as: :json
          expect(response).to have_http_status(:ok)
          expect(response.content_type).to match(a_string_including("application/json"))
        end
      end

      context "with invalid parameters" do
        it "renders a JSON response with errors for the user" do
          user = User.create! valid_attributes
          patch user_url(user),
                params: { user: invalid_attributes }, headers: valid_headers, as: :json
          expect(response).to have_http_status(:unprocessable_content)
          expect(response.content_type).to match(a_string_including("application/json"))
        end
      end
    end
  end

  describe "DELETE /users/:id" do
    context "without token" do
      it "renders a unauthorized response" do
        user = User.create! valid_attributes
        delete user_url(user), headers: invalid_headers, as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
    context "with token" do
      it "destroys the requested user" do
        user = User.create! valid_attributes
        expect {
          delete user_url(user), headers: valid_headers, as: :json
        }.to change(User, :count).by(-1)
      end
    end
  end
end
