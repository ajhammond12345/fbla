require 'securerandom'
class UsersController < ApplicationController

  protect_from_forgery unless: -> { request.format.json? }
  

    def create
        @user = User.new(user_params)
        private_key = SecureRandom.base64(64)
        @user.user_unique_key = private_key
        #assign private_key to user
        respond_to do |format|
            if @user.save
                format.html { redirect_to @user, notice:
                              'User was successfully created.'}
                format.json { render json: @user}
            else
                format.html {render action: 'new'}
	            format.json { render json: @user.errors,
                           status: :unprocessable_entity }
            end
        end
    end

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

    def login
        data_params = params[:data]
        @user = User.find_by username: (data_params[:username])
        password_check = @user.user_password
        password_provided = data_params[:password]

        if (data_params[:password] == password_check)
            #generate a random key and save it
            #@user.user_unique_key = someuniquekey
            respond_to do |format|
                format.html
                format.json {render json: @user}
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
		
	def info
        @user = User.find(params[:id])
        if (@user.user_unique_key == params[:user_unique_key])
            #add condition for user
		    @user = User.find(params[:id])
		    respond_to do |format|
			    format.html
			    format.json {render json: @user, include: :items}
		    end
        else
            msg = {:msg => "invalid_key"}
            format.json {render json: msg}
        end
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
    #PATCH/PUT /users/1
    def update
        @user = User.find(params[:id])
        if (@user.user_unique_key == params[:user_unique_key])
            if @user.update_attributes!(user_params)
                msg = {:msg => "updated"}
                render json: msg
            else
                msg = {:msg => "updated"}
                render json: msg
            end
        else 
            msg = {:msg => "invalid key"}
            render json: msg
        end
    end


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
