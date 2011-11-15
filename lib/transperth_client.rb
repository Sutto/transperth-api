require 'httparty'
require 'nokogiri'

class TransperthClient

  URL_SCHEME = "http://www.transperth.wa.gov.au/TimetablesMaps/LiveTrainTimes/tabid/436/stationname/%s/Default.aspx"

  class TrainTime < APISmith::Smash

    property :time
    property :line
    property :pattern
    property :cars
    property :status
    property :on_time
    property :platform

  end

  def self.live_times(station)
    url = URL_SCHEME % URI.escape(station.to_s)
    doc = Nokogiri::HTML HTTParty.get(url)
    nbsp =  Nokogiri::HTML("&nbsp;").text
    doc.css('#dnn_ctr1608_ModuleContent table table tr')[1..-2].map do |row|
      tds = row.css('td').map { |x| x.text.gsub(nbsp, " ").squeeze(' ').strip }
      [tds[1], tds[2], tds[3], tds[5]]
      time = tds[1]
      line = tds[2].gsub(/To /, '')
      extra = tds[3].gsub(/\(\d+ cars\)/, '')
      platform = extra[/platform (\w+)/, 1].to_i
      pattern = extra[/(\w+) pattern/, 1].to_s.strip.presence
      cars =  tds[3][/(\d+) cars/].to_i
      status = tds[5]
      on_time = !!(status =~ /On Time/i)
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
  end

  def self.train_stations
    url = URL_SCHEME % URI.escape("Perth Stn")
    doc = Nokogiri::HTML HTTParty.get(url)
    doc.css('#dnn_ctr1610_DynamicForms_tblQuestions select option').map { |r| r[:value] }
  end

end