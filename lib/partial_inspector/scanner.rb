require_relative "utils"

module PartialInspector
  class Scanner
    include PartialInspector::Utils

    def inspect_files_rendering_partial(partial_path)
      puts "CONTROLLER"
      puts inspect_controller_files_rendering_partial(partial_path)
      puts "controller count=#{inspect_controller_files_rendering_partial(partial_path).size}"
      puts "VIEW"
      puts inspect_view_files_rendering_partial(partial_path)
      puts "view count=#{inspect_view_files_rendering_partial(partial_path).size}"
      puts "ADMIN"
      puts inspect_admin_files_rendering_partial(partial_path)
      puts "admin count=#{inspect_admin_files_rendering_partial(partial_path).size}"
    end

    private
    def inspect_controller_files_rendering_partial(partial_path)
      lines = []
      Dir.glob("#{BASE_DIR}/app/controllers/**/*.rb").each do |file|
        file_content = File.readlines(file)
        file_content.each_with_index do |line, index|
          if line.include?('render') && line.include?('partial:') && check_partial_exists(line, partial_path, "controller")
            lines << "#{file}:#{index + 1}: #{line.strip}"
          end
        end
      end

      lines
    end

    def inspect_view_files_rendering_partial(partial_path)
      lines = []
      Dir.glob("#{BASE_DIR}/app/views/**/*.*.erb").each do |file|
        file_content = File.readlines(file)
        file_content.each_with_index do |line, index|
          if line.include?('render') && check_partial_exists(line, partial_path, "view")
            lines << "#{file}:#{index + 1}: #{line.strip}"
          end
        end
      end

      lines
    end

    def inspect_admin_files_rendering_partial(partial_path)
      lines = []
      Dir.glob("#{BASE_DIR}/app/admin/**/*.rb").each do |file|
        file_content = File.readlines(file)
        file_content.each_with_index do |line, index|
          if line.include?('render') && line.include?('partial:') && check_partial_exists(line, partial_path, "admin")
            lines << "#{file}:#{index + 1}: #{line.strip}"
          end
        end
      end

      lines
    end
  end
end
