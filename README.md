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
4. Example Output
   
   <img width="803" alt="image" src="https://github.com/user-attachments/assets/9008c2c1-d6ea-4497-945b-1e47823208fc" />

