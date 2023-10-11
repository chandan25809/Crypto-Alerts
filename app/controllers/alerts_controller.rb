class AlertsController < ApplicationController
  before_action :authorize_request
  before_action :find_user

  def create
    alert = @user.alerts.new(alert_params)
    unless alert.save
      render json: alert.errors, status: :unprocessable_entity
    else
      redis_key = "#{alert.symbol}_#{alert.price}"
      Redis.add_to_list(redis_key,alert.id)
      render json: alert, status: :created
    end
  end

  def update
    alert = Alert.find_by(id: params[:id],user_id: @user.id)
    if alert.nil?
      render json: { error: 'Alert not found' }, status: :not_found
      return
    end
    update_params = params.permit(:state, :status)
    unless alert.update(params)
      render json: alert.errors, status: :unprocessable_entity
    else
      render json: alert, status: :created
    end
  end

  def destroy
    alert = Alert.find_by(id: params[:id],user_id: @user.id)
    if alert.nil?
      render json: { error: 'Alert not found' }, status: :not_found
      return
    end
    #its better practice to update status:"inactive" instead of deleting alert
    redis_key = "#{alert.symbol}_#{alert.price}"
    Redis.remove_from_list(redis_key,alert.id)
    alert.destroy
    render json: { error: 'alert deleted' }
  end

  #Its better practice to write ListApi in new service
  def index
    page = params[:page].to_i
    per_page = params[:per_page].to_i

    # Set default values for page and per_page
    page = 1 if page <= 0
    per_page = 10 if per_page <= 0
    service = AlertsService.new(Alert.where(user_id: @user.id, status: 'active'), filters, page, per_page)
    result = service.filter_and_paginate

    render json: result
  end



  private
  def find_user
    @user = User.find_by(id: params[:_username],status: 'active')
    if @user.nil?
      render json: { error: 'User not found' }, status: :not_found
    end
  end

  def alert_params
    permitted_params = params.permit(:symbol, :price, :state)
    permitted_params[:status] = 'active'
    permitted_params
  end

end
