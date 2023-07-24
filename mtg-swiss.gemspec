# frozen_string_literal: true

require_relative 'lib/swiss/version'

Gem::Specification.new do |spec|
  spec.name = 'mtg-swiss'
  spec.version = Swiss::VERSION
  spec.authors = ['pioz']
  spec.email = ['epilotto@gmx.com']

  spec.summary = 'MTG Swiss Tournaments for Ruby'
  spec.description = 'A lightweight Ruby library implementing Magic the Gathering Swiss tournament rules. Easily integrate points systems, ranking, and tiebreaker rules for fair and competitive event management. Elevate your tournaments with minimal effort.'
  spec.homepage = 'https://github.com/pioz/mtg-swiss'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 2.7.0'

  spec.metadata['allowed_push_host'] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/pioz/mtg-swiss'
  spec.metadata['rubygems_mfa_required'] = 'true'
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor Gemfile])
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(/\Aexe\//) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
