class AlertsController < ApplicationController
  before_action :authorize_request
  before_action :find_user
  before_action :deep_symbolize_params

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
    unless alert.update(update_params)
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
    #its good practice to update status:"inactive" instead of deleting alert
    redis_key = "#{alert.symbol}_#{alert.price}"
    Redis.remove_from_list(redis_key,alert.id)
    alert.destroy
    render json: { message: 'alert deleted' }
  end

  def index
    page = params[:page].to_i
    per_page = params[:per_page].to_i
    filters = params[:filters]
    # Set default values for page and per_page
    page = 1 if page <= 0
    per_page = 10 if per_page <= 0
    service = AlertService.new(Alert.where(user_id: @user.id, status: 'active'), filters, page, per_page)
    result = service.filter_and_paginate

    render json: result
  end



  private

  def deep_symbolize_params
    return unless params.is_a?(Hash)  # Return early if params is not a hash
    params.deep_symbolize_keys!
  end

  def find_user
    @user = User.find_by(user_name: params[:_username],status: 'active')
    if @user.nil?
      render json: { error: 'User not found' }, status: :not_found
    end
  end

  def alert_params
    permitted_params = params.permit(:symbol, :price)
    permitted_params[:status] = 'active'
    permitted_params[:state]= 'created'
    permitted_params
  end

end
