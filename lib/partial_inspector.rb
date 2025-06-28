# frozen_string_literal: true

require_relative "partial_inspector/version"

module PartialInspector
  class Error < StandardError; end
  # Your code goes here...

  def self.check_partial_usage(partial_path = '')
    if partial_path == '' || partial_path == nil
      "Invalid Path"
    else
      partial_name = extract_partial_name(partial_path)
      "partial_name: #{partial_name}"
    end
  end

  def self.extract_partial_file_name(partial_path)
    file_name = partial_path.split('/').last
    file_name
  end

  def self.extract_partial_name(partial_path)
    partial_name = partial_path.split('/').last
    partial_name = partial_name.split('.').first
    partial_name = partial_name[1..-1] if partial_name[0] == '_'
    partial_name
  end


end
