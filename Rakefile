# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/test_*.rb']
end

task default: :test

require 'yard'

# Run `bundle exec rake yard` to generate the HTML documentation under
# the 'doc' folder.
YARD::Rake::YardocTask.new do |t|
  t.files = [
    'lib/**/*.rb'
  ]
  t.options << '--markup=markdown'
  t.options << '--readme=README.md'
  t.options << '--title="MTG Swiss"'
  t.options << '--output-dir=doc'
end
