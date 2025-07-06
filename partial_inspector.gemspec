# frozen_string_literal: true

require_relative "lib/partial_inspector/version"

Gem::Specification.new do |spec|
  spec.name = "partial_inspector"
  spec.version = PartialInspector::VERSION
  spec.authors = ["SalihaShahid"]
  spec.email = ["salihashahid1102@gmail.com"]

  spec.homepage = "https://github.com/SalihaShahid/partial_inspector"
  spec.summary = "Partial Inspector"
  spec.required_ruby_version = ">= 2.0.0"
  spec.license = 'MIT'


  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
