# frozen_string_literal: true

require_relative "partial_inspector/version"
require_relative "partial_inspector/scanner"

module PartialInspector
  class Error < StandardError; end

  def self.scanner()
    PartialInspector::Scanner.new
  end
end
