require 'httparty'
require 'nokogiri'

class TransperthClient

  URL_SCHEME = "http://www.transperth.wa.gov.au/TimetablesMaps/LiveTrainTimes/tabid/436/stationname/%s/Default.aspx"

  def self.live_times(station)
    url = URL_SCHEME % URI.escape(station.to_s)
    doc = Nokogiri::HTML HTTParty.get(url)
    nbsp =  Nokogiri::HTML("&nbsp;").text
    doc.css('#dnn_ctr1608_ModuleContent table table tr')[1..-2].map do |row|
      tds = row.css('td').map { |x| x.text.gsub(nbsp, " ").squeeze(' ').strip }
      [tds[1], tds[2], tds[3], tds[5]]
      time = tds[1]
      line = tds[2].gsub(/To /, '')
      pattern = tds[3].gsub(/\(\d+ cars\)/, '')
      cars =  tds[3][/(\d+) cars/].to_i
      status = tds[5]
      on_time = !!(status =~ /On Time/i)
      [time, line, pattern, cars, status, on_time]
    end
  end

  def self.train_stations
    url = URL_SCHEME % URI.escape("Perth Stn")
    doc = Nokogiri::HTML HTTParty.get(url)
    doc.css('#dnn_ctr1610_DynamicForms_tblQuestions select option').map { |r| r[:value] }
  end

end