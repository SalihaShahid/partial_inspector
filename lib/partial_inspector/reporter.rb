require_relative "used_partials"
require_relative "unused_partials"

module PartialInspector
  class Reporter
    include PartialInspector::UsedPartials
    include PartialInspector::UnusedPartials

    def report_files_rendering_partial(partial_path)
      files = base_scanner(partial_path)
      return "\e[41m\e[34mINVALID PATH\e[0m\e[0m" if files.empty?

      search_results_count = files.size
      grouped_files = combine_unique_files(files)

      puts "\n\e[36mSEARCH SUMMARY\e[0m"
      puts "\e[35mTOTAL SEARCH RESULTS\e[0m: \e[32m#{search_results_count}\e[0m"
      puts "\e[35mTOTAL FILES\e[0m: \e[32m#{grouped_files.keys.size}\e[0m"

      puts "\n\e[36mDETAILS\e[0m"
      grouped_files.each do |key, value|
        puts "\e[35mFILE NAME\e[0m: \e[34m#{key.to_s}\e[0m"
        file_contents = value
        file_contents.each do |file_content|
          puts "\e[35mLINE #{file_content[:line_number]}\e[0m: #{file_content[:line_content]} "
        end
        puts "RENDERED \e[32m#{file_contents.size} TIME(S)\e[0m\n\n"
      end
      return
    end

    def report_unused_partials
      partials = inspect_unused_partials
      unused_partials = partials[:unused_partials]

      puts "\n\e[36mSEARCH SUMMARY\e[0m"
      puts "\e[35mTOTAL PARTIALS\e[0m: \e[32m#{partials[:total_partials]}\e[0m"
      puts "\e[35mUSED PARTIALS\e[0m: \e[32m#{unused_partials.size}\e[0m"
      puts "\e[35mUNUSED PARTIALS\e[0m: \e[32m#{partials[:used_partials]}\e[0m"
       
      unless unused_partials.empty?
        puts "\n\e[36mDETAILS\e[0m"
        unused_partials.each do |partial|
          puts partial
        end
      end
      return
    end
  end
end
