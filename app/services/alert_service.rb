class AlertService
  ALLOWED_FILTERS = ['state', 'status'].freeze
  def initialize(alerts, page, per_page)
    @alerts = alerts
    @page = page
    @per_page = per_page
  end

  def filter_and_paginate
    paginate_results
  end

  private


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
