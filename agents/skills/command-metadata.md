# Command Metadata

Read this before adding or changing commands in `bin/`.

Commands in `bin/` can declare CLI metadata in comments near the top of the
file. `bin/apex` scans the first 80 lines, and tests expect command metadata
to remain valid.

Supported metadata keys:

- `# apex:group=...` - override the command group inferred from the filename
- `# apex:name=...` - override the command name inferred from the filename
- `# apex:summary=...` - short help text
- `# apex:args=...` - usage arguments
- `# apex:examples=...` - examples separated with ` | `
- `# apex:alias=...` / `# apex:aliases=...` - alternate routes
- `# apex:hidden=true` - hide from default command listings
- `# apex:requires-sudo=true` - mark commands that require sudo

Only use `apex:examples` where there are args that need explaining.

Prefer explicit metadata for user-facing commands. Keep routes consistent with
the filename unless there is a deliberate alias or compatibility route.

Example:

```bash
# apex:summary=Take a screenshot
# apex:args=[smart|region|windows|fullscreen] [slurp|copy]
# apex:examples=apex screenshot | apex capture screenshot region
```
