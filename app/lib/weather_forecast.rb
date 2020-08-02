class WeatherForecast
  OPENWEATHERMAP_URL = 'http://api.openweathermap.org/data/2.5/forecast'.freeze

  TARGET_TIME = [
    '09:00',
    '12:00',
    '15:00'
  ].freeze

  def initialize(latitude, longitude)
    @data =
      {
        'lat': latitude,
        'lon': longitude,
        'units': 'metric',
        'lang': 'ja',
        'appid': ENV['OPEN_WEATHER_API_KEY']
      }
  end

  def weather_condition(date)
    # 過去日の場合は天気情報を取得しない
    if date >= Date.today
      weather_info = api_request

      weather_condition_list = []
      weather_info['list'].each do |weather_list|
        jst_time = (weather_list['dt_txt'] + ' UTC').in_time_zone('Tokyo')
        forecast_date = jst_time.to_date

        next unless date == forecast_date

        forecast_time = jst_time.strftime('%H:%M')

        next unless TARGET_TIME.include?(forecast_time)

        weather = weather_list['weather']
        description = weather[0]['description']

        weather_condition = {
          time: forecast_time,
          description: description
        }

        weather_condition_list << weather_condition
      end
    end

    weather_condition_list
  end

  private

  def api_request
    query = @data.to_query
    uri = URI("#{OPENWEATHERMAP_URL}?" + query)
    response = open(uri)
    weather_info = JSON.parse(response.read)
  end
end
