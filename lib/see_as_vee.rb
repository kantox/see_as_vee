begin
  require 'filemagic'
rescue LoadError => e
end

require 'axlsx'
require 'simple_xlsx_reader'
require 'csv'

require "see_as_vee/version"
require "see_as_vee/exceptions"

require "see_as_vee/helpers"
require "see_as_vee/sheet"

require "see_as_vee/producers/hashes"

module SeeAsVee
  def harvest whatever, formatters: {}, checkers: {}
    sheet = SeeAsVee::Sheet.new whatever, formatters: formatters, checkers: checkers
    return sheet.each unless block_given?

    sheet.each(&Proc.new)
    sheet
  end
  module_function :harvest

  def csv *args
    SeeAsVee::Producers::Hashes.csv(*args)
  end
  module_function :csv

  def xlsx *args
    SeeAsVee::Producers::Hashes.xlsx(*args)
  end
  module_function :xlsx
end

class String
  def harvest_csv formatters: {}, checkers: {}
    SeeAsVee.harvest self, formatters: formatters, checkers: checkers
  end
end
