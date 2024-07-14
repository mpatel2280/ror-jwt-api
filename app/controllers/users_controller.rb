# app/controllers/users_controller.rb
class UsersController < ApplicationController

    include RedisMixin
  
    before_action :authorize_request, except: :create
    #before_action :find_user, except: %i[create index]
    before_action :find_user_by_id, except: %i[create index]
  
    # GET /users
    def index     
      # @users = User.all
      # render json: @users, status: :ok

      # Fetch records from Redis
      @users = fetch_records_from_redis('all_users')

      unless @users
        # If records are not found in Redis, fetch from the database and store in Redis
        @users = User.all
        store_records_in_redis('all_users', @users)
      end

      render json: @users, status: :ok
      
    end
  
    # GET /users/{username}
    def show      
      render json: @user, status: :ok
    end
  
    # POST /users
    def create
      @user = User.new(user_params)
      if @user.save
        #UserMailer.with(user: @user).user_created.deliver_now
        UserMailer.user_created(@user).deliver_now
        delete_records_from_redis('all_users')
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
      @user.destroy
    end
  
    private
  
    def find_user
      @user = User.find_by_username!(params[:_username])
      rescue ActiveRecord::RecordNotFound
        render json: { errors: 'User not found' }, status: :not_found
    end

    def find_user_by_id
        @user = User.find(params[:id])
        rescue ActiveRecord::RecordNotFound
          render json: { errors: 'User not found' }, status: :not_found
      end

    def user_params
      params.permit(
        :name, :username, :email, :password, :password_confirmation
      )
    end

    # def user_params
    #     params.permit(
    #       :avatar, :name, :username, :email, :password, :password_confirmation
    #     )
    # end

  end