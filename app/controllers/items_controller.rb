class ItemsController < ApplicationController

  protect_from_forgery unless: -> { request.format.json? }
  



def create
    @user = User.find(params[:user_id])
    if (@user.user_unique_key == params[:user_unique_key])
        @item = Item.new(item_params)
	    logger.debug("#{params[:va_image_data]} VAIMAGEDATA")
        @item.decode_image_data(params[:va_image_data])
	    logger.debug("#{@item[:item_image]} ITEMIMAGE")
        respond_to do |format|
            if @item.save
                format.html { redirect_to @item, notice: 'Item was successfully created.'}
                format.json { render json: @item.id, status: :created }
            else
                msg = {:msg => "failed_to_donate"}
                render json: msg 
            end
        end
    else 
        msg = {:msg => "invalid_key"}
        render json: msg 
    end
end

  # DELETE /items/1
  def destroy
    Item.find(params[:id]).destroy
    flash[:success] = "Item deleted"

    redirect_to items_url, notice: 'Item was successfully destroyed.'
  end

	def edit
		@item = Item.find(params[:id])	
	end

	def index
		@items = Item.includes(:comments)
		respond_to do |format|
            format.html
			format.json {render json: @items, include: :comments, except: :user_id}
		end
		
	end

	def total

		respond_to do |format|
			format.html
			format.json {render json: amount_raised}
		end
	end 

	def new
		@item = Item.new
	end

	def filtered_list
		data_params = params[:data]

		# convert to integer to avoid SQL injection issues
		condition_min = data_params[:condition_min]
		condition_max = data_params[:condition_max]
		price_min = data_params[:price_min]
		price_max = data_params[:price_max]
		condition_min ||= 0
		condition_max ||= 10000
		price_min ||= 0
		price_max ||= 100000000
		condition_min = condition_min.to_i
		condition_max = condition_max.to_i
		price_min = price_min.to_i
		price_max = price_max.to_i

		@items = Item.includes(:comments).where('item_price_in_cents >= ? and item_price_in_cents <= ? and item_condition >= ? and item_condition <= ?', price_min, price_max, condition_min, condition_max)
		respond_to do |format|
			format.html
			format.json {render json: @items, include: :comments}
		end
	end

	
	def show
		@item = Item.find(params[:id])
		respond_to do |format|
			format.html
			format.json {render json: @item, include: :comments, except: :user_id }
		end
	end


#   PATCH/PUT /items/1
  def update
    @user = User.find(params[:user_id])
    if (@user.user_unique_key == params[:user_unique_key])
        @item = Item.find(params[:id])
        if @item.update_attributes!(item_params)
            msg = {:msg => "updated"}
            render json: msg 
        else
            msg = {:msg => "updated"}
            render json: msg 
        end
    else
        msg = {:msg => "invalid_key"}
        render json: msg 
    end
  end

	private

	# See https://rubyplus.com/articles/3281-Mass-Assignment-in-Rails-5
	def item_params
	  params.require(:item).permit(:user_id, 
			:item_name,
			:item_condition,
			:item_description,
			:item_price_in_cents,
			:item_purchase_state, 
			:item_image) 
	end  
end
