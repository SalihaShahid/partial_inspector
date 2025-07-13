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

### Find where a partial is used
1. Run the scanner:
      
   ```
   PartialInspector.scanner.inspect_files_rendering_partial('path/to/partial')
   ```
2. Example Output
   
   <img width="803" alt="image" src="https://github.com/user-attachments/assets/9008c2c1-d6ea-4497-945b-1e47823208fc" />

### Find unused partials
1. Run the scanner:
   
   ```
   PartialInspector.scanner.scan_unused_partials
   ```
2. Example Output

   <img width="606" height="263" alt="image" src="https://github.com/user-attachments/assets/f7aef983-be65-4167-9703-810f29631a95" />

### Find partial tree
1. Run the scanner:
   
   ```
   PartialInspector.scanner.inspect_partial_tree('path/to/partial')
   ```
2. Example Output
   
   <img width="739" height="215" alt="image" src="https://github.com/user-attachments/assets/4ddfb898-70c5-4bf2-b849-96b51a741c20" />


