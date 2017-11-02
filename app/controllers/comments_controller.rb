class CommentsController < ApplicationController

  protect_from_forgery unless: -> { request.format.json? }
  

def create
    @comment = Comment.new(comment_params)
    respond_to do |format|
      if @comment.save
        format.html { redirect_to @comment, notice: 'Comment was successfully created.'}
        format.json { render json: @comment.errors, status: :created }
      else
        format.html {render action: 'new'}
	format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
end

  # DELETE /comments/1
  def destroy
    Comment.find(params[:id]).destroy
    flash[:success] = "Comment deleted"

    redirect_to comments_url, notice: 'Comment was successfully destroyed.'
  end

	def edit
		@comment = Comment.find(params[:id])	
	end

	def index
		@comments = Comment.all
		respond_to do |format|
			format.html
			format.json {render json: @comments }
		end
	end

	def new
		@comment = Comment.new
	end
	
	def show
		@comment = Comment.find(params[:id])
		respond_to do |format|
			format.html
			format.json {render json: @comment }
		end
	end
#
#  # PATCH/PUT /comments/1
  def update
    @comment = Comment.find(params[:id])
    if @comment.update_attributes!(comment_params)
#      redirect_to @comment, notice: 'Comment was successfully updated.'
      render action: 'edit'
    else
      render action: 'edit'
    end
  end
#

#	def nicolas
#	    1400.upto(1430) do |i|
#		if Comment.exists?(i) then
#			@comment = Comment.find(i)
#			@comment.destroy
#		end
#	end
#		@comments = Comment.all
#		render 'index'
#	end

	private

	# See https://rubyplus.com/articles/3281-Mass-Assignment-in-Rails-5
	def comment_params
	  params.require(:comment).permit(:comment_text,
			:item_id)
	end  
end
