require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe BankOfTanzania::HistoricRates do
  DEC1_RATES = {
    'KES' => 21.05625,
    'RWF' => 2.8849,
    'BFI' => 2.05785,
    'USD' => 2151.95375,
    'GBP' => 3228.9017000000003,
    'EUR' => 2275.1536499999997,
    'CAD' => 1608.3942499999998,
    'CHF' => 2086.33695,
    'JPY' => 17.48065,
    'SEK' => 247.07395,
    'NOK' => 247.0781,
    'DKK' => 304.9862,
    'AUD' => 1551.8841,
    'INR' => 32.27725,
    'PKR' => 19.89295,
    'ZAK' => 0.41095,
    'MWK' => 3.3998500000000003,
    'MZN' => 39.1619,
    'ZWD' => 0.40475,
    'XDR' => 2952.8464000000004,
    'ZAR' => 149.08185,
    'AED' => 585.8924000000001,
    'SGD' => 1522.8596499999999,
    'HKD' => 277.6696,
    'SAR' => 573.3182,
    'KWD' => 7059.973400000001,
    'BWP' => 197.55044999999998,
    'CNY' => 336.34,
    'MYR' => 505.21104999999994,
    'KRW' => 1.85755,
    'NZD' => 1412.3294
  }

  let(:dec1) do
    bot = BankOfTanzania::HistoricRates.new as_of: Date.new(2015, 12, 1)
    allow(bot).to receive(:scrape).and_return(DEC1_RATES)
    bot
  end

  let(:future) do
    bot = BankOfTanzania::HistoricRates.new as_of: Date.new(2039, 2, 1)
    allow(bot).to receive(:scrape).and_return({})
    bot
  end

  describe '.import!' do
    it 'returns true when rates could be retrieved' do
      expect(dec1.import!).to be_truthy
    end

    it 'returns false when there are no rates' do
      expect(future.import!).to be_falsey
    end
  end

  describe '.currencies/.rates/.rate' do
    it 'throws an error when import! has not been called yet' do
      expect { dec1.rates }.to raise_error BankOfTanzania::MissingRates
      expect { dec1.currencies }.to raise_error BankOfTanzania::MissingRates
      expect { dec1.rate('ISO', 'ISO') }.to raise_error BankOfTanzania::MissingRates
    end

    it 'throws an error when there are no rates' do
      future.import!
      expect { future.rates }.to raise_error BankOfTanzania::MissingRates
      expect { future.currencies }.to raise_error BankOfTanzania::MissingRates
      expect { future.rate('ISO', 'ISO') }.to raise_error BankOfTanzania::MissingRates
    end
  end

  describe '.has_rates?' do
    it 'returns true when there are rates' do
      dec1.import!
      expect( dec1 ).to have_rates
    end

    it 'returns false when there are no rates' do
      expect( dec1 ).not_to have_rates
    end
  end

  describe '.rate' do
    it 'returns a specific rate' do
      dec1.import!
      expect(dec1.rate('TZS', 'EUR')).to eq 1/2275.1536499999997
    end

    it 'returns the inverse rate' do
      dec1.import!
      expect(dec1.rate('EUR', 'TZS')).to eq 2275.1536499999997
    end

    it 'returns nil when currency is not known' do
      dec1.import!
      expect(dec1.rate('XXX', 'RWF')).to be_nil
      expect(dec1.rate('XXX', 'XXX')).to be_nil
    end
  end

  describe '.currencies' do
    it 'returns an array' do
      dec1.import!
      expect(dec1.currencies).to eq DEC1_RATES.keys
    end
  end

  describe '.rates' do
    it 'returns all rates' do
      dec1.import!
      expect(dec1.rates).to eq DEC1_RATES
    end
  end

  describe '#scrape' do
    it 'returns an empty hash for future dates' do
      result = BankOfTanzania::HistoricRates.scrape Date.new(2039, 2, 1)
      expect(result).to eq({})
    end

    it 'produces a hash with exchange rates' do
      result = BankOfTanzania::HistoricRates.scrape Date.new(2015, 12, 1)
      expect(result).to eq DEC1_RATES
     end
  end
end
