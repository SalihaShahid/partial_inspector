module PartialInspector
  module Utils
    BASE_DIR = "."

    private
    def base_scanner(partial_path)
      lines = []

      files = Dir.glob("./app/**/*.{rb,html.erb,js.erb,turbo_stream.erb}")
      files.each do |file|
        file_content = File.readlines(file)
        file_content.each_with_index do |line, index|
          if (line.include?('render') || line.include?('partial:')) && check_partial_exists(line, partial_path)
            lines << "#{file}:#{index + 1}: #{line.strip}"
          end
        end
      end

      lines
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
      end

      if partial_path[0] == "'"
        partial_path = partial_path[1..-2]
        partial_path = partial_path[0..-2] if partial_path[-1] == "'"
      end

      partial_path == partial
    end
  end
end
