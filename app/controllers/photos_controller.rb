class PhotosController < ApplicationController
  before_action :set_photo, only: %i[show edit update destroy]
  before_action :authorize_resource

  def show
  end

  def new
    @photo = Photo.new
  end

  def edit
  end

  def create
    @photo = Photo.new(photo_params)
    @photo.owner = current_user

    respond_to do |format|
      if @photo.save
        format.html { redirect_to @photo, notice: "Photo was successfully created." }
        format.json { render :show, status: :created, location: @photo }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @photo.update(photo_params)
        format.html { redirect_to @photo, notice: "Photo was successfully updated." }
        format.json { render :show, status: :ok, location: @photo }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @photo.destroy
    respond_to do |format|
      format.html { redirect_back_or_to "/#{@photo.owner.id}", notice: "Photo was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_photo
      @photo = Photo.find(params[:id])
    end

    def authorize_resource
      authorize @photo || Photo
    end

    def photo_params
      params.require(:photo).permit(:image, :caption)
    end

    def record_not_found
      redirect_to photos_path, alert: 'Photo not found.'
    end
end
