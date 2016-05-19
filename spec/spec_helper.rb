$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'pry'
require 'see_as_vee'

require "codeclimate-test-reporter"
CodeClimate::TestReporter.start
