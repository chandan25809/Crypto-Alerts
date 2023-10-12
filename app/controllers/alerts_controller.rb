class AlertsController < ApplicationController
  before_action :authorize_request
  before_action :deep_symbolize_params

  def create
    alert = @current_user.alerts.new(alert_params)
    unless alert.save
      render json: alert.errors, status: :unprocessable_entity
    else
      redis_key = "#{alert.symbol}_#{alert.price}"
      Redis.add_to_list(redis_key,alert.id)
      puts Redis.read_list(redis_key)
      render json: alert, status: :created
    end
  end

  def update
    alert = Alert.find_by(id: params[:id],user_id: @current_user.id)
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
    alert = Alert.find_by(id: params[:id],user_id: @current_user.id)
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
    status = params[:status] || 'active'
    state = params[:state]
    page = (params[:page] || 1).to_i
    per_page = (params[:per_page] || 10).to_i
    alerts_query = Alert.where(user_id: @current_user.id, status: status)
    alerts_query = alerts_query.where(state: state) if state.present?
    service = AlertService.new(alerts_query, page, per_page)

    result = service.filter_and_paginate

    render json: result
  end



  private

  def deep_symbolize_params
    return unless params.is_a?(Hash)  # Return early if params is not a hash
    params.deep_symbolize_keys!
  end


  def alert_params
    permitted_params = params.permit(:symbol, :price)
    permitted_params[:status] = 'active'
    permitted_params[:state]= 'created'
    permitted_params
  end

end
