class UsersController < ApplicationController
    before_action :authorize_request, except: :create
    before_action :find_user, except: %i[create index]

    # POST /users
    def create
        @user = User.new(user_params)
        @user.status = 'active'
        if @user.save
            render json: @user, status: :created
        else
            render json: { errors: @user.errors.full_messages },
                   status: :unprocessable_entity
        end

    end

    # PUT /users/{username}
    def update
        unless @user.update(user_params)
            render json: { errors: @user.errors.full_messages },
            status: :unprocessable_entity
        end
    end

    # DELETE /users/{username}
    def destroy
        #its better practice to update status:"inactive" instead of deletign user
        @user.destroy
    end

    # GET /users
    def index
        @users = User.where(status: 'active')
        render json: @users, status: :ok
    end

    # GET /users/{username}
    def show
        render json: @user, status: :ok
    end


    private

    def find_user
        @user = User.find_by(user_name: params[:_username],status: 'active')
        if @user.nil?
          render json: { error: 'User not found' }, status: :not_found
        end
    end

    def user_params
        permitted_params = params.permit(:name, :user_name, :email, :password, :password_confirmation)
        permitted_params[:status] = 'active'
        permitted_params
    end

end
