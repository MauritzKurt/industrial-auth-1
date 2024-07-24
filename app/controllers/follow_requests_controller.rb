class FollowRequestsController < ApplicationController
  before_action :set_follow_request, only: %i[show edit update destroy]
  before_action :authorize_resource

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def show
  end

  def new
    @follow_request = FollowRequest.new
  end

  def edit
  end

  def create
    @follow_request = FollowRequest.new(follow_request_params)
    @follow_request.sender = current_user

    respond_to do |format|
      if @follow_request.save
        format.html { redirect_back fallback_location: root_url, notice: "Follow request was successfully created." }
        format.json { render :show, status: :created, location: @follow_request }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @follow_request.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @follow_request.update(follow_request_params)
        format.html { redirect_back fallback_location: root_url, notice: "Follow request was successfully updated." }
        format.json { render :show, status: :ok, location: @follow_request }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @follow_request.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @follow_request.destroy
    respond_to do |format|
      format.html { redirect_back fallback_location: root_url, notice: "Follow request was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_follow_request
      @follow_request = FollowRequest.find(params[:id])
    end

    def authorize_resource
      authorize @follow_request || FollowRequest
    end

    def follow_request_params
      params.require(:follow_request).permit(:recipient_id, :sender_id, :status)
    end

    def record_not_found
      redirect_to follow_requests_path, alert: 'Follow request not found.'
    end

end
