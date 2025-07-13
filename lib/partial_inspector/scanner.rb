require_relative "reporter"

module PartialInspector
  class Scanner

    def inspect_files_rendering_partial(partial_path)
      puts reporter.report_files_rendering_partial(partial_path)
      return
    end

    def scan_unused_partials
      puts reporter.report_unused_partials
      return
    end

    def inspect_partial_tree(partial_path)
      puts reporter.report_partial_tree(partial_path)
      return
    end

    private
    def reporter
      PartialInspector::Reporter.new
    end
  end
end
