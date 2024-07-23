class CommentsController < ApplicationController
  before_action :set_comment, only: %i[ show edit update destroy ]
  before_action -> { authorize @comment || Comment },except: [:new, :create]

  def new
    @comment = Comment.new
    authorize @comment
  end

  def edit
  end

  def create
    @comment = Comment.new(comment_params)
    @comment.author = current_user
    authorize @comment

    respond_to do |format|
      if @comment.save
        format.html { redirect_back fallback_location: root_path, notice: "Comment was successfully created." }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to root_url, notice: "Comment was successfully updated." }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_back fallback_location: root_url, notice: "Comment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_comment
      @comment = Comment.find(params[:id])
    end

    def comment_params
      params.require(:comment).permit(:author_id, :photo_id, :body)
    end

    def is_an_authorized_user
      if params.key?(:comment)
        photo = params[:comment][:photo_id]
      else
        comment = Comment.find(params[:id])
        photo = comment.photo.id
      end
      
      @photo = Photo.find(photo)
      if current_user != @photo.owner && @photo.owner.private? && !current_user.leaders.include?(@photo.owner)
        redirect_back fallback_location: root_url, alert: "Not Authorized"
      end
    end
end
