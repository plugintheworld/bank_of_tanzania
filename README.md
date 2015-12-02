# Bank of Tanzania Historic Exchange Rates

Wraps a simple scraper to retrieve the historic exchange rates for Tanzanian Shillings (TZS).
Returns the average (between buy and sell) rates for yesterday or any day specified and supported
by the Bank of Tanzania.

## Install

Add this line to your application's Gemfile:

```ruby
  gem 'bank_of_tanzania'
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
  $ gem install bank_of_tanzania
```

## Usage

### Initialize

```ruby
  xe = BankOfTanzania::HistoricRates.new as_of: Date.new(2015, 10, 24)
  xe.import! # => true
```

``import!`` returns ``true`` if rates have been found. Might also throw HTTP errors.
It will also return ``false`` when requesting rates for weekend days.

### Retrieve a specific rate

```ruby
  xe.rate('TZS', 'EUR') # => 2105.625
```

Get all available currencies:

```ruby
  xe.currencies # => ['KES', 'RWF', 'USD', 'EUR', … ]
```

Get all rates

```ruby
  xe.rates # => { 'KES'=>2105.625, 'RWF'=>288.49, … }
```

## Legal

The author of this gem is not affiliated with the National Bank of Rwanda.

### License

GPLv3, see LICENSE file

### No Warranty

The Software is provided "as is" without warranty of any kind, either express or implied,
including without limitation any implied warranties of condition, uninterrupted use,
merchantability, fitness for a particular purpose, or non-infringement.

