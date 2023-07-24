# frozen_string_literal: true

require 'simplecov'
if ENV['CODECOV'] == 'true'
  require 'codecov'
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
end

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'swiss'

require 'minitest/autorun'
