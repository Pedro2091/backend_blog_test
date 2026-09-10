class AuthController < ApplicationController
    def login
        user = User.find_by(email: params[:email])

        if user&.authenticate(params[:password])
            token = JsonWebToken.encode(user_id: user.id)
            render json: { token: token }, status: :ok
        else
            render json: { error: "Invalid Credentials" }, status: :unauthorized
        end
    end

    def register
        user = User.new(registration_params)
        if user.save
            token = JsonWebToken.encode(user_id: user.id)
            render json: { token: token }, status: :created
        else
            render json: user.errors, status: :unprocessable_content
        end
    end

    private

    def registration_params
        params.expect(user: [ :name, :email, :password, :password_confirmation ])
    end
end
