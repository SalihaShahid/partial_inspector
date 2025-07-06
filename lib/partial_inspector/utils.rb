module PartialInspector
  module Utils
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
              line_content: highlight_partial_from_content(partial_path, line.strip)
            }
          end
        end
      end

      partial_dir = build_partial_base_dir_path(partial_path)
      partial_name =  extract_partial_name(partial_path)

      lines + check_partial_against_name(partial_dir, partial_name)
    end

    def extract_partial_file_name(partial_path)
      file_name = partial_path.split('/').last
      file_name
    end

    def extract_partial_name(partial_path)
      partial_name = partial_path.split('/').last
      partial_name = partial_name.split('.').first
      partial_name = partial_name[1..-1] if partial_name[0] == '_'
      partial_name
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

    def build_partial_base_dir_path(partial_path)
      path_components = partial_path.split('/')
      path = ''
      path_components = path_components[0..-2]
      path_components.each do |path_component|
        path = path + "#{path_component}/"
      end

      path
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
              line_content: highlight_partial_from_content(partial_name, line.strip)
            }
          end
        end
      end

      lines
    end

    def highlight_partial_from_content(partial_path, content)
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
  end
end
