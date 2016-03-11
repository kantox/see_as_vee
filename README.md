# SeeAsVee

Easy dealing with CSV import, including, but not limited to:

* import in any format: `String`, `csv`, `xlsx`;
* additional input formatting;
* input checkers;
* callbacks on errors;
* producing of “suggested edits” version of input (both `csv` and `xlsx` formats).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'see_as_vee'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install see_as_vee

## Usage

```ruby
    sheet = SeeAsVee.harvest(
      'spec/fixtures/velocity.xlsx', # file exists ⇒ will be loaded
      formatters: { reference: ->(v) { v.round.to_s } }, # safe reference input
      checkers: { reference: ->(v) { v.nil? } } # must be present
    ) do |idx, errors, hash| # row index, errors, row as hash { header: value }
      # Errors: {"Reference"=>"☣2̶4̶3̶7̶2̶3̶1̶1̶4̶"}
      expect(errors["Reference"]).to eq "#{SeeAsVee::Sheet::CELL_ERROR_MARKER}2̶4̶3̶7̶2̶3̶1̶1̶4̶"
      # Hash: {"Reference"=>"☣2̶4̶3̶7̶2̶3̶1̶1̶4̶", ... }
      expect(hash["Reference"]).to eq "#{SeeAsVee::Sheet::CELL_ERROR_MARKER}2̶4̶3̶7̶2̶3̶1̶1̶4̶"
    end
    csv, xlsx = sheet.produce csv: true, xlsx: true
    # in CSV cells, that did not pass validation, are striked out
    expect(File.exist?(csv.path)).to eq true
    expect(csv.length > 0).to eq true
    # in XLSX cells, that did not pass validation, are marked with red background
    expect(File.exist?(xlsx.path)).to eq true
    expect(xlsx.length > 0).to eq true
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/see_as_vee. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
