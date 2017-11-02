require 'securerandom'
require 'bcrypt'

class UsersController < ApplicationController

  protect_from_forgery unless: -> { request.format.json? }
  

    def create
        @user = User.new(user_params)
        private_key = SecureRandom.base64(64)
        @user.user_salt = BCrypt::Engine.generate_salt
        #encrypt key here
        encrypted_key = BCrypt::Engine.hash_secret(private_key, @user.user_salt)
        @user.user_unique_key = encrypted_key 
        password_tmp = @user.user_password
        #encrypt user password here
        encrypted_password = BCrypt::Engine.hash_secret(password_tmp, @user.user_salt)
        @user.user_password = encrypted_password


        if @user.save
            msg = {:email_address => @user.email_address, 
                       :id => @user.id, 
                       :user_address => @user.user_address, 
                       :user_first_name => @user.user_first_name, 
                       :user_last_name => @user.user_last_name, 
                       :username => @user.username, 
                       :user_unique_key => private_key}
            render json: msg
        else
            format.html {render action: 'new'}
	        format.json { render json: @user.errors,
            status: :unprocessable_entity }
        end
    end

    #PATCH/PUT /users/1
    def update
        @user = User.find(params[:id])
        private_key = params[:user_unique_key]
        @new_password = params[:user_password]
        #encrypt here
        encrypted_key = BCrypt::Engine.hash_secret(private_key, @user.user_salt)
        if (@user.user_unique_key == encrypted_key) 
            if @user.update_attributes!(user_params)
                if @new_password
                    @user.user_password = BCrypt::Engine.hash_secret(@new_password, @user.user_salt)
                end 
                @user.user_unique_key = encrypted_key
                @user.save
                msg = {:msg => "updated"} 
                render json: msg
            else
                msg = {:msg => "no change made"} 
                @user.user_unique_key = encrypted_key
                @user.save
                render json: msg
            end
        else 
            msg = {:msg => "invalid key"} 
            render json: msg
        end
    end

	def info
        logger.debug("wtf")
        @user = User.find(params[:id])
        logger.debug("wtf")
        private_key = params[:user_unique_key]
        logger.debug("wtf")
        #encrypt key below
        encrypted_key = BCrypt::Engine.hash_secret(private_key, @user.user_salt)
        logger.debug("wtf")
        logger.debug(encrypted_key)
        logger.debug(@user.user_unique_key)
        if (@user.user_unique_key == encrypted_key) 
            logger.debug("wtf a")
			render json: @user, include: :items, except: [:user_password, :user_salt, :user_unique_key]
            logger.debug("wtf")
        else
            logger.debug("wtf b")
            msg = {:msg => "invalid_key"}
            format.json {render json: msg}
            logger.debug("wtf")
        end
	end

    def login
        data_params = params[:data]
        @user = User.find_by username: (data_params[:username])
        password_check = @user.user_password
        password_provided = data_params[:password]
        #encrypt password below
        encrypted_password = BCrypt::Engine.hash_secret(password_provided, @user.user_salt)
        #generates a random key
        private_key = SecureRandom.base64(64)
        if (encrypted_password == password_check)
            #saves the random key if login successful
            #encrypt key here
            encrypted_key = BCrypt::Engine.hash_secret(private_key, @user.user_salt)
            @user.user_unique_key = encrypted_key 
            @user.save
            msg = {:email_address => @user.email_address, 
                       :id => @user.id, 
                       :user_address => @user.user_address, 
                       :user_first_name => @user.user_first_name, 
                       :user_last_name => @user.user_last_name, 
                       :username => @user.username, 
                       :user_unique_key => private_key}
            render json: msg
        end
    end
		
	def unique_email
		data_params = params[:data]
		new_email = data_params[:email_address]
		@users = User.all.where('email_address = ?', new_email)
        if (@users.count == 0) 
            respond_to do |format|
                msg = {:msg => "unique"}
                format.json {render json: msg}
            end
        else
            respond_to do |format|
                msg = {:msg => "not_unique"}
                format.json {render json: msg}
            end
        end
	end

	def unique_username
		data_params = params[:data]
		new_username = data_params[:username]
		@users = User.all.where('username = ?', new_username)
        if (@users.count == 0) 
            respond_to do |format|
                msg = {:msg => "unique"}
                format.json {render json: msg}
            end
        else
            respond_to do |format|
                msg = {:msg => "not_unique"}
                format.json {render json: msg}
            end
        end
	end
		




    #methods below here are disallowed in routes.rb
    # DELETE /user/1
    def destroy
        @user = User.find(params[:id])
        if (user.user_unique_key == params[:unique_key])
            User.find(params[:id]).destroy
            flash[:success] = "User deleted"
            redirect_to users_url, notice: 'User was destroyed.'
        end
    end

	def edit
		@user = User.find(params[:id])
	end

	def index
		@users = User.includes(:items)
		respond_to do |format|
			format.html
			format.json {render json: @users, include: :items}
		end
	end

	def new
		@user = User.new
	end
	

	def show
        #add condition for user
		@user = User.find(params[:id])
		respond_to do |format|
			format.html
			format.json {render json: @user, include: :items}
		end
	end
    #

	private
	# See https://rubyplus.com/articles/3281-Mass-Assignment-in-Rails-5
	def user_params
	  params.require(:user).permit(:username,
                                   :user_password,
                                   :email_address,
                                   :user_first_name,
                                   :user_last_name,
                                   :user_address,
                                   :user_unique_key,
                                   :confirmed)
	end  
end
