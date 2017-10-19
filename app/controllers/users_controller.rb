class UsersController < ApplicationController

  protect_from_forgery unless: -> { request.format.json? }
  

    def create
        @user = User.new(user_params)
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
        User.find(params[:id]).destroy
        flash[:success] = "User deleted"

        redirect_to users_url, notice: 'User was successfully destroyed.'
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
		respond_to do |format|
			format.html
			format.json {render json: @users}
		end
	end

    def login
        data_params = params[:data]
        @user = User.find_by username: (data_params[:username])
        password_check = @user.user_password
        if (data_params[:password] == password_check)
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
		respond_to do |format|
			format.html
			format.json {render json: @users}
		end
	end
		
	def show
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
        if @user.update_attributes!(user_params)
        #redirect_to @user, notice: 'User was successfully updated.'
        render action: 'edit'
        else
            render action: 'edit'
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
                                   :confirmed)
	end  
end
