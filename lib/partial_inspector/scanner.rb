require_relative "reporter"

module PartialInspector
  class Scanner

    def inspect_files_rendering_partial(partial_path)
      puts reporter.report_files_rendering_partial(partial_path)
      return
    end

    private
    def reporter
      PartialInspector::Reporter.new
    end
  end
end
