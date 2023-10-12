require 'faye/websocket'

class BinanceWebSocketClient
  def initialize
    @socket_url = 'wss://stream.binance.com:9443/ws/!miniTicker@arr'
  end

  def start
    EM.run do
      ws = Faye::WebSocket::Client.new(@socket_url)

      ws.on :message do |event|
        data = JSON.parse(event.data)

        data.each do |item|
          symbol = item['s']
          price = item['c'].to_f
          puts "Coin: #{symbol}, Current Price: #{price}"
          check_price_alert(symbol, price)
        end
      end

      ws.on :close do |_event|
        puts 'WebSocket connection closed'
        EM.stop
      end
    end
  end

  def check_price_alert(symbol, price)
    key = "#{symbol}_#{price}"

    if Redis.key_exists(key) && Redis.get_ttl(key) > 0
      alert_ids = Redis.read_list(key)
      puts alert_ids
      # Enqueue the background job to send mail id's
      AlertEmailJob.perform_async(alert_ids, symbol, price)
      Redis.del_list(key)
    end

end
