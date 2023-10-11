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

        end
      end

      ws.on :close do |_event|
        puts 'WebSocket connection closed'
        EM.stop
      end
    end
  end

  def helper(symbol,price)
  #trigger the notification
  redis
  key="{symbol}_{price}"
  value=[alert_ids]
  end

end
