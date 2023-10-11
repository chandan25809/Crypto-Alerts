require_relative '../../app/services/binance_websocket_client'

class BackgroundTaskJob
  include Sidekiq::Job

  def perform(*args)
    binance_client = BinanceWebSocketClient.new
    binance_client.start
  end
end
