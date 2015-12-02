Gem::Specification.new do |s|
  s.name         = 'bank_of_tanzania'
  s.version      = '0.1.0'
  s.platform     = Gem::Platform::RUBY
  s.date         = '2015-12-02'
  s.summary      = 'Retrieves historic TZS exchange rates from the Bank of Tanzania'
  s.description  = 'Wraps a simple scraper to retrieve the historic exchange rates for Tanzanian Shillings (TZS). Returns the average (between buy and sell) rates for yesterday or any day specified and supported by the Bank of Tanzania.'
  s.authors      = ['Christoph Peschel']
  s.email        = ['hi@chrp.es']
  s.homepage     = 'http://github.com/plugintheworld/bank_of_tanzania'
  s.license      = 'GPL'

  s.add_runtime_dependency 'nokogiri', '~> 1.6'
  s.add_development_dependency 'rspec', '~> 3.3'

  s.require_path = 'lib'
  s.files        = Dir.glob('lib/**/*') + %w(LICENSE README.md)
end
