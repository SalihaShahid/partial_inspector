require_relative 'utils'

module PartialInspector
  module UsedPartials
    include PartialInspector::Utils

    private
    def base_scanner(partial_path)
      return [] if partial_path.nil? || partial_path == ''
      lines = []

      files = Dir.glob("app/**/*.{rb,html.erb,js.erb,turbo_stream.erb}")
      files.each do |file|
        file_content = File.readlines(file)
        file_content.each_with_index do |line, index|
          if (line.include?('render') || line.include?('partial:')) && check_partial_exists(line, partial_path)
            lines << {
              file: file,
              line_number: index + 1,
              line_content: highlight_partial_form_content(partial_path, line.strip)
            }
          end
        end
      end

      partial_dir = build_partial_base_dir_path(partial_path)
      partial_name =  extract_partial_name(partial_path)

      lines + check_partial_against_name(partial_dir, partial_name)
    end

    def check_partial_exists(line, partial)
      partial_path = ""
      line_content = line.split(' ')
      line_content.each_with_index do |value, index|
        if line.include?("render partial:") && value == "render"
          partial_path = line_content[index + 2]
          break
        elsif value == "render"
          partial_path = line_content[index + 1]
          break
        elsif value == "partial:"
          partial_path = line_content[index + 1]
          break
        end
      end
      if partial_path[0] == "\""
        partial_path = partial_path[1..-2]
        partial_path = partial_path[0..-2] if partial_path[-1] == '"'
      elsif partial_path[0] == "'"
        partial_path = partial_path[1..-2]
        partial_path = partial_path[0..-2] if partial_path[-1] == "'"
      end

      partial_path == partial
    end
  
    def build_path(path_components)
      path = ''
      path_components.each do |path_component|
        path = path+"#{path_component}/"
      end
  
      path[0..-2]
    end

    def check_partial_against_name(partial_dir, partial_name)
      lines = []
      
      Dir.glob("app/views/#{partial_dir}*.*.erb").each do |file|
        file_content = File.readlines(file)
        file_content.each_with_index do |line, index|
          if line.include?('render') && check_partial_exists(line, partial_name)
            lines << {
              file: file,
              line_number: index + 1,
              line_content: highlight_partial_form_content(partial_name, line.strip)
            }
          end
        end
      end

      lines
    end

    def highlight_partial_form_content(partial_path, content)
      if content.include?("'#{partial_path}'")
        content_components = content.split("'#{partial_path}'")
        result = if content_components.size < 2
                  content_components[0]+"\e[44m\e[32m'#{partial_path}'\e[0m\e[0m"
                 else
                  content_components[0]+"\e[44m\e[32m'#{partial_path}'\e[0m\e[0m"+content_components[1]
                 end
        return result
      elsif content.include?("\"#{partial_path}\"")
        content_components = content.split("\"#{partial_path}\"")
        result = if content_components.size < 2
                  content_components[0]+"\e[44m\e[32m\"#{partial_path}\"\e[0m\e[0m"
                 else
                  content_components[0]+"\e[44m\e[32m\"#{partial_path}\"\e[0m\e[0m"+content_components[1]
                 end
        return result
      end
    end

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
