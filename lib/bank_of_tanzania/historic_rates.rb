require 'nokogiri'
require 'uri'
require 'net/http'
require 'date'

module BankOfTanzania
  class MissingRates < StandardError; end

  TRANSLATE = { 'Kenya SHS'         => 'KES',
                'Uganda SHS'        => 'UGX',
                'Rwandan Franc'     => 'RWF',
                'Burundi Franc'     => 'BFI',
                'USD'               => 'USD',
                'Pound STG'         => 'GBP',
                'EURO'              => 'EUR',
                'Canadian $'        => 'CAD',
                'Switz. Franc'      => 'CHF',
                'Japanese YEN'      => 'JPY',
                'Swedish Kronor'    => 'SEK',
                'Norweg. Kronor'    => 'NOK',
                'Danish Kronor'     => 'DKK',
                'Australian $'      => 'AUD',
                'Indian RPS'        => 'INR',
                'Pakistan RPS'      => 'PKR',
                'Zambian Kwacha'    => 'ZAK',
                'Malawian Kwacha'   => 'MWK',
                'Mozambique-MET'    => 'MZN',
                'Zimbabwe $'        => 'ZWD',
                'SDR'               => 'XDR',
                'S. African Rand'   => 'ZAR',
                'UAE Dirham'        => 'AED',
                'Singapore $'       => 'SGD',
                'Honk Kong $'       => 'HKD',
                'Saud Arabian Rial' => 'SAR',
                'Kuwait Dinar'      => 'KWD',
                'Botswana Pula'     => 'BWP',
                'Chinese Yuan'      => 'CNY',
                'Malaysia Ringgit'  => 'MYR',
                'South Korea Won'   => 'KRW',
                'Newzealand'        => 'NZD' }


  class HistoricRates
    attr_reader :as_of

    def initialize options = {}
      @as_of = options[:as_of] || Date.yesterday
    end

    def rate(iso_from, iso_to)
      fail MissingRates unless has_rates?

      if iso_from == 'TZS'
        rates[iso_to] ? 1/rates[iso_to] : nil
      elsif iso_to == 'TZS'
        rates[iso_from]
      else
        nil
      end
    end

    # Returns a list of ISO currencies
    def currencies
      fail MissingRates unless has_rates?
      @rates.keys
    end

    # Returns all rates returned
    def rates
      fail MissingRates unless has_rates?
      @rates
    end

    # Returns true when reading the website was successful
    def has_rates?
      !@rates.nil? && !@rates.empty?
    end

    # Triggers the scraping
    def import!
      @rates = scrape(@as_of)
      has_rates?
    end

    def scrape as_of
      self.class.scrape(@as_of)
    end

    # Scrapes the BoT website for the historic exchange rates of a given day
    def self.scrape as_of
      uri = URI('http://www.bot-tz.org/FinancialMarkets/ExchangeRates/ShowExchangeRates.asp')
      params = { 'SelectedExchandeDate' => as_of.strftime('%m/%d/%y') } # sic!
      response = Net::HTTP.post_form(uri, params)

      dom = Nokogiri::HTML(response.body)
      rows = dom.css('#table1 > tr > td > table > tr > td > div > table > tr > td > table > tr')

      Hash[rows.map do |row|
        currency = TRANSLATE[row.css(':nth-child(1) font').text.split.join(' ')]
        buy = Float(row.css(':nth-child(3) font').text.gsub(',', '')) rescue nil
        sell = Float(row.css(':nth-child(4) font').text.gsub(',', '')) rescue nil
        next if currency.nil? || buy.nil? || sell.nil?

        # average of by and sell, divide by 100 b/c conversion is given in 100 units
        [currency, (buy + sell)/200]
      end.compact]
    end
  end
end
