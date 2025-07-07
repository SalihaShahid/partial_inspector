module PartialInspector
  module Utils

    private
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

    def build_partial_base_dir_path(partial_path)
      path_components = partial_path.split('/')
      path = ''
      path_components = path_components[0..-2]
      path_components.each do |path_component|
        path = path + "#{path_component}/"
      end

      path
    end
  end
end
