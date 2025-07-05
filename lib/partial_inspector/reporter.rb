require_relative "utils"

module PartialInspector
  class Reporter
    include PartialInspector::Utils

    def report_files_rendering_partial(partial_path)
      files = base_scanner(partial_path)
      return "\e[41m\e[34mINVALID PATH\e[0m\e[0m" if files.empty?

      search_results_count = files.size
      grouped_files = combine_unique_files(files)

      puts "\n\e[43mSEARCH SUMMARY\e[0m"
      puts "TOTAL SEARCH RESULTS: \e[32m#{search_results_count}\e[0m"
      puts "TOTAL FILES: \e[32m#{grouped_files.keys.size}\e[0m"

      puts "\n\e[43mDETAILS\e[0m"
      grouped_files.each do |key, value|
        puts "FILE NAME: \e[34m#{key.to_s}\e[0m"
        file_contents = value
        file_contents.each do |file_content|
          puts "LINE #{file_content[:line_number]}: #{file_content[:line_content]} "
        end
        puts "RENDERED \e[32m#{file_contents.size} TIME(S)\e[0m\n\n"
      end
      return
    end

    private
    def combine_unique_files(files)
      results = {}
      files.each do |file|
        same_files = files.filter { |f| f[:file] == file[:file] }

        same_files.each do |same_file|
          files.delete(same_file)
          results[same_file[:file].to_sym] = [] if results[same_file[:file].to_sym] == nil
          results[same_file[:file].to_sym] << { line_number: same_file[:line_number], line_content: file[:line_content] }
        end
      end

      files.each do |file|
        results[file[:file].to_sym] = [{ line_number: file[:line_number], line_content: file[:line_content] }]
      end

      results
    end
  end
end
