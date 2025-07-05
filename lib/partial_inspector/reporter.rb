require_relative "utils"

module PartialInspector
  class Reporter
    include PartialInspector::Utils

    def report_files_rendering_partial(partial_path)
      files = base_scanner(partial_path)
      files.each do |file|
        puts "FILE: \e[32m#{file[:file]}\e[0m"
        puts "LINE NUMBER: #{file[:line_number]}"
        puts "LINE CONTENT: #{file[:line_content]}"
      end
      return
    end
  end
end
