require 'faraday'
require 'nokogiri'

# Default to using persistent connections.
Faraday.default_adapter = Rails.env.test? ? :net_http : :net_http_persistent

class TransperthClient

  def self.main_connection
    @mobile_connection ||= Faraday.new('http://www.transperth.wa.gov.au/') do |conn|
      conn.request :retry, max: 2, interval: 0.05
      conn.adapter Faraday.default_adapter
    end
  end

  def self.mobile_connection
    @main_connection ||= Faraday.new('http://136213.mobi/') do |conn|
      conn.request :retry, max: 2, interval: 0.05
      conn.adapter Faraday.default_adapter
    end
  end

  URL_SCHEME         = "/TimetablesMaps/LiveTrainTimes/tabid/436/stationname/%s/Default.aspx"
  SMART_RIDER_SCHEME = "/SmartRider/SmartRiderResult.aspx?SRN=%s"
  BUS_STOP_SCHEME    = "/Bus/StopResults.aspx?SN=%s"

  class TrainTime < APISmith::Smash
    property :time
    property :line
    property :pattern
    property :cars
    property :status
    property :on_time
    property :platform
  end

  class BusTime < APISmith::Smash
    property :time
    property :destination
    property :comment
    property :route
    property :approximate
  end

  class SmartRiderStatus < APISmith::Smash
    property :balance
    property :concession_type
    property :concession_expires
    property :autoload
  end

  def self.smart_rider(code)
    code = code.to_s.gsub /\D/, ''
    return nil unless code =~ /^\d{9}$/
    path = SMART_RIDER_SCHEME % URI.escape(code)
    raw  = mobile_connection.get(path).body
    return nil if raw =~ /smartrider number not found/i
    doc = Nokogiri::HTML raw
    nbsp =  Nokogiri::HTML("&nbsp;").text
    SmartRiderStatus.new({
      :balance => doc.at_css('span#lblCurrentBalance').text[/(\d+)\.(\d+)/].to_f,
      :autoload => doc.at_css('span#lblAutoload').text.downcase.include?("true"),
      :concession_type => doc.at_css('span#lblType').text.strip,
      :concession_expires => doc.at_css('span#lblExpires').text.strip.presence
    })
  end

  def self.live_times(station)
    path      = URL_SCHEME % URI.escape(station.to_s)
    raw       = main_connection.get(path).body
    doc       = Nokogiri::HTML raw
    nbsp      = Nokogiri::HTML("&nbsp;").text
    container = doc.css('#dnn_ctr1608_ModuleContent table table tr')
    return [] if container.blank?
    times = container[1..-2].map do |row|
      tds = row.css('td').map { |x| x.text.gsub(nbsp, " ").squeeze(' ').strip }
      # This is the biggest part of the live train train extraction algorithm.
      time     = tds[1]
      line     = tds[2].gsub(/To /, '')
      extra    = tds[3].gsub(/\(\d+ cars\)/, '')
      platform = extra[/platform (\w+)/, 1].to_i
      pattern  = extra[/(\w+) pattern/, 1].to_s.strip.presence
      cars     =  tds[3][/(\d+) cars/].to_i
      status   = tds[5]
      on_time  = !!(status =~ /On Time/i)
      TrainTime.new({
        :time     => time,
        :line     => line,
        :pattern  => pattern,
        :cars     => cars,
        :status   => status,
        :on_time  => on_time,
        :platform => platform
      })
    end
    times
  end

  def self.bus_times(stop_number)
    path = BUS_STOP_SCHEME % URI.escape(stop_number.to_s)
    raw  = mobile_connection.get(path).body
    return [] if raw =~ /not found or no more services/
    doc = Nokogiri::HTML raw
    doc.css('.tpm_row .tpm_row_content').map do |row|
      mapped = Hash[*row.to_html.scan(/<strong>(\w+):?<\/strong>([^<]*)<br>/).map { |r| r.map { |i| i.to_s.strip.presence } }.flatten]
      time = mapped['Time']
      approximate = false
      if time =~ /\*$/
        approximate = true
        time = time[0..-2]
      end
      BusTime.new({
        :comment     => mapped['Comment'],
        :destination => mapped['Destination'],
        :route       => mapped['Route'],
        :time        => time,
        :approximate => approximate
      })
    end
  end

  def self.train_stations
    path = URL_SCHEME % URI.escape("Perth Stn")
    raw = main_connection.get(path).body
    doc = Nokogiri::HTML raw
    doc.css('#dnn_ctr1610_DynamicForms_tblQuestions select option').map { |r| r[:value] }
  end

end