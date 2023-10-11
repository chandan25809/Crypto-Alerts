# app/services/alerts_service.rb

class AlertsService
  ALLOWED_FILTERS = ['state', 'status'].freeze
  def initialize(alerts, filters, page, per_page)
    @alerts = alerts
    @filters = filters
    @page = page
    @per_page = per_page
  end

  def filter_and_paginate
    apply_filters
    paginate_results
  end

  private

  def validate_and_apply_filters
    valid_filters = @filters.select { |key, _value| ALLOWED_FILTERS.include?(key) }

    valid_filters.each do |key, value|
      @alerts = @alerts.where(key => value)
    end
  end

  def paginate_results
    total_alerts = @alerts.count
    paginated_alerts = @alerts.offset((@page - 1) * @per_page).limit(@per_page)

    return {
      alerts: paginated_alerts,
      total_alerts: total_alerts,
      page: @page,
      per_page: @per_page
    }
  end
end
