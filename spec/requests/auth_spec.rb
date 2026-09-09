require 'rails_helper'

RSpec.describe "Auth", type: :request do
  describe "POST /login" do
    let!(:user) do
      User.create!(name: "User test", email: 'teste@teste.com', password: 'Teste123', password_confirmation: 'Teste123')
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
end
