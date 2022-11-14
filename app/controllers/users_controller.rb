class UsersController < ApplicationController
    before_action :authorized, only: [:auto_login]

    # def new
    #     @user = User.new
    # end

    #register
    def create 
        @user = User.create(user_params)
        if @user.valid?
            token = encode_token({user_id: @user.id})
            render json: {user: @user, token: token}
        else
            render json: {error: "Invalid username or password"}
        end
    end

    #Logging in
    def login
        @user = User.find_by(username: params[:username])

        if @user && @user.authenticate(params[:password])
            token = encode_token(user_id: @user.id)
            render json: {user: @user, token: token}
            # render json: {error: "Invalid username or Password"}
        else
            render json: {error: "Invalid username or Password"}
        end
    end

    def auto_login
        render json: @user
    end

    private

    def user_params
        params.permit(:username, :password, :age)
    end

    # def logged_in?
    #     !!logged_in_user
    # end

    # def authorized
    #     render json: { message: 'Login to continue' }, status: :unauthorized unless
    #     logged_in?
    # end
end
