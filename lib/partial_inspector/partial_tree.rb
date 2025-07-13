require_relative 'utils'

module PartialInspector
  module PartialTree
    include PartialInspector::Utils

    private
    def data_to_build_tree(partial_path)
      router(partial_path)
    end

    def router(path)
      base_data = []
      partial_path = path.split('/')[0]=='app' ? path.split('/')[2..-1].join('/') : path
      files = find_base_files_rendering_partial(partial_path)
      return [[path]] if files.empty?
      files.each do |file|
        if rendered_by_partial(file)
          child_traces = router(file)
          child_traces.each do |trace|
            base_data << [path] + trace
          end
        else
          base_data << [path, file]
        end
      end
      base_data
    end

    def find_base_files_rendering_partial(partial_path)
      return [] if partial_path.nil? || partial_path == ''
      base_files = []

      files = Dir.glob("app/**/*.{rb,html.erb,js.erb,turbo_stream.erb}")
      files.each do |file|
        file_content = File.readlines(file)
        file_content.each_with_index do |line, index|
          if (line.include?('render') || line.include?('partial:')) && check_partial_exists(line, partial_path)
            base_files << file
          end
        end
      end

      partial_dir = build_partial_base_dir_path(partial_path)
      partial_name =  extract_partial_name(partial_path)

      base_files + find_base_files_rendering_partial_against_partial_name(partial_dir, partial_name)
    end


    def find_base_files_rendering_partial_against_partial_name(partial_dir, partial_name)
      base_files = []

      Dir.glob("app/views/#{partial_dir}*.*.erb").each do |file|
        file_content = File.readlines(file)
        file_content.each_with_index do |line, index|
          if line.include?('render') && check_partial_exists(line, partial_name)
            base_files << file
          end
        end
      end

      base_files
    end

    def rendered_by_partial(file)
      file.split('/').last[0] == '_'
    end
  end
end
