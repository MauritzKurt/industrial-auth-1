class LikesController < ApplicationController
  before_action :set_like, only: [:destroy]
  before_action :set_photo, only: [:create]
  before_action -> { authorize @like || Like }
  before_action :authorize_create_action, only: [:create]
  
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def show
  end

  def new
    @like = Like.new
  end

  def edit
  end

  def create
    @like = @photo.likes.build(fan: current_user)
    respond_to do |format|
      if @like.save
        format.html { redirect_to @like, notice: "Like was successfully created." }
        format.json { render :show, status: :created, location: @like }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @like.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @like.update(like_params)
        format.html { redirect_to @like, notice: "Like was successfully updated." }
        format.json { render :show, status: :ok, location: @like }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @like.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @like.destroy
    respond_to do |format|
      format.html { redirect_to likes_url, notice: "Like was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_photo
    @photo = Photo.find(params[:like][:photo_id])
  end

  def set_like
    @like = Like.find(params[:id])
  end

  def authorize_create_action
    authorize @photo, :create_like?
  end

  def record_not_found
    redirect_to likes_path, alert: 'Like not found.'
  end
end
