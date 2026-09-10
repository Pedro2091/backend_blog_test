require 'rails_helper'

RSpec.describe "Auth", type: :request do
  describe "POST /login" do
    let!(:user) do
      User.create!(name: "Teste", email: 'teste@teste.com', password: 'Teste123', password_confirmation: 'Teste123')
    end
    context "with correct email and password" do
      it "returns 200 and a token" do
        post '/login', params: { email: 'teste@teste.com', password: 'Teste123' }

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['token']).to be_present
      end
    end

    context "with incorrect password" do
      it "returns 401 unauthorized" do
        post '/login', params: { email: 'teste@teste.com', password: 'senha_errada' }

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "with inexistent email" do
      it "returns 401 unauthorized" do
        post '/login', params: { email: 'naoexiste@teste.com', password: 'Teste123' }

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "with no email and password" do
      it "returns 401 unauthorized" do
        post '/login', params: { email: '', password: '' }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "POST /register" do
  context "with valid parameters" do
    it "creates a user and returns 201 with a token" do
      post '/register', params: {
        user: { name: "Maria", email: "nova@teste.com", password: "Teste123", password_confirmation: "Teste123" }
      }

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json['token']).to be_present
    end
  end

  context "with invalid parameters (password confirmation mismatch)" do
    it "returns 422 with errors" do
      post '/register', params: {
        user: { name: "Maria", email: "nova@teste.com", password: "Teste123", password_confirmation: "outrasenha" }
      }

      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  context "with duplicate email" do
    it "returns 422" do
      User.create!(name: "Maria", email: "existente@teste.com", password: "Teste123", password_confirmation: "Teste123")

      post '/register', params: {
        user: { name: "Maria", email: "existente@teste.com", password: "Teste123", password_confirmation: "Teste123" }
      }

      expect(response).to have_http_status(:unprocessable_content)
    end
  end
end
end
