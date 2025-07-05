require_relative "utils"

module PartialInspector
  class Reporter
    include PartialInspector::Utils

    def report_files_rendering_partial(partial_path)
      files = base_scanner(partial_path)
      return "\e[41m\e[34mINVALID PATH\e[0m\e[0m" if files.empty?

      files.each do |file|
        puts "\nFILE NAME: \e[34m#{file[:file]}\e[0m"
        puts "LINE NUMBER: #{file[:line_number]}"
        puts "LINE CONTENT: #{file[:line_content]}\n"
      end

      puts "\nTOTAL SEARCH RESULTS: \e[32m#{files.size}\e[0m"
      return
    end
  end
end
