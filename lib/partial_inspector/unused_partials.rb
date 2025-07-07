require_relative 'utils'

module PartialInspector
  module UnusedPartials
    include PartialInspector::Utils

    private
    def inspect_unused_partials
      partials = Dir.glob("app/views/**/_*.*erb")
      partial_paths_data = format_partial_paths_for_scanning(partials)
      unused_partials = []
      puts "\e[32mScanning...\e[0m\n"
      partial_paths_data.each do |path_data|
        unless full_path_used(path_data[:full_path]) || partial_name_used(path_data[:partial_name])
          unused_partials << path_data[:partial]
        end
      end

      { 
        total_partials: partials.size,
        unused_partials: unused_partials,
        used_partials: partials.size - unused_partials.size
      }
    end

    def format_partial_paths_for_scanning(partials)
      partial_paths_for_rendering = []
      partials.each do |partial|
        partial_paths_for_rendering << extract_complete_partial_path(partial)
      end

      partial_paths_for_rendering
    end

    def extract_complete_partial_path(partial)
      full_path = partial.split('app/views/')[1]
      formatted_path = ""
      path_components = full_path.split('/')
      path_components[-1] = extract_partial_name(path_components[-1])
      path_components.each do |path_component|
        formatted_path += "#{path_component}/"
      end
      formatted_path = formatted_path[0..-2] if formatted_path[-1] == '/'

      { partial: partial, full_path: formatted_path, partial_name: path_components[-1] }
    end

    def full_path_used(partial_path)
      files = Dir.glob("app/**/*.{rb,html.erb,js.erb,turbo_stream.erb}")
      files.each do |file|
        file_content = File.readlines(file)
        file_content.each do |line|
          return true if line.include?("'#{partial_path}'") || line.include?("\"#{partial_path}\"") 
        end
      end
      return false
    end
  
    def partial_name_used(partial_path)
      partial_dir = build_partial_base_dir_path(partial_path)
      partial_name = extract_partial_name(partial_path)
  
      files =  Dir.glob("app/views/#{partial_dir}*.*.erb")
      files.each do |file|
        file_content = File.readlines(file)
        file_content.each do |line|
          return true if line.include?("'#{partial_name}'") || line.include?("\"#{partial_name}\"") 
        end
      end
    end
  end
end
