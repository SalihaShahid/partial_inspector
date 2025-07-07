# Partial Inspector
A tiny, developer-focused gem to help you find where your Rails partials are used.

When working on large Rails projects, it's easy to lose track of where a partial is rendered throughout the codebase. **partial_inspector** scans your project and shows exactly which files render a given partial, making it much easier to refactor, test or remove unused partials confidently.

## Installation

```
gem install partial_inspector
```


## How it works?
1. Open irb
2. Require the gem:
   
 ```
require "partial_inspector"
  ```
3. Run the scanner:
   
   ```
PartialInspector.scanner.inspect_files_rendering_partial('path/to/partial')
   ```
