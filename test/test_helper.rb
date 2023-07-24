# frozen_string_literal: true

if ENV['CODECOV'] == 'true'
  require 'simplecov'
  SimpleCov.start
  require 'simplecov-cobertura'
  SimpleCov.formatter = SimpleCov::Formatter::CoberturaFormatter
end

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'swiss'

require 'minitest/autorun'
