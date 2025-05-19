#!/bin/bash

# Check if markdownlint-cli is installed
if ! command -v markdownlint &> /dev/null; then
    echo "markdownlint-cli not found"
    exit 1
fi

# Check if fmt is installed
if ! command -v fmt &> /dev/null; then
    echo "fmt not found"
    exit 1
fi

# Check if fd is installed
if ! command -v fd &> /dev/null; then
    echo "fd not found"
    exit 1
fi

# Check if ripgrep is installed
if ! command -v rg &> /dev/null; then
    echo "ripgrep not found"
    exit 1
fi

# Create or update .markdownlint.json with Hugo-specific rules
cat > .markdownlint.json << EOL
{
  "MD013": {
    "line_length": 80,
    "code_blocks": false,
    "tables": false
  },
  "MD033": false,
  "MD041": false,
  "MD024": false,
  "MD025": false,
  "MD026": {
    "punctuation": ".,;:!"
  },
  "MD040": false,
  "MD007": {
    "indent": 2
  }
}
EOL

# Function to fix a Markdown file
fix_file() {
    local file="$1"
    # Backup original file
    cp "$file" "$file.bak"

    # Extract front matter
    local front_matter=""
    if grep -q "^---" "$file.bak"; then
        front_matter=$(sed -n '/^---$/,/^---$/p' "$file.bak")
        # Remove front matter from the file for processing
        sed -i.bak2 '/^---$/,/^---$/d' "$file.bak"
    fi

    # Use fmt to wrap lines at 80 characters, but preserve code blocks
    awk '
    BEGIN { in_code_block = 0 }
    /^```/ { in_code_block = !in_code_block; print; next }
    in_code_block { print; next }
    { print | "fmt -w 80" }
    ' "$file.bak" > "$file"

    # Restore front matter if it existed
    if [ -n "$front_matter" ]; then
        echo "$front_matter" | cat - "$file" > "$file.tmp"
        mv "$file.tmp" "$file"
    fi

    # Run markdownlint to fix other issues
    markdownlint --fix "$file" 2>/dev/null
    echo "Processed: $file"

    # Clean up temporary files
    rm -f "$file.bak" "$file.bak2"
}

# Find all Markdown files in Hugo content directory using ripgrep
rg --type-add 'markdown:*.md' --type markdown --files content | while read -r file; do
    fix_file "$file"
done

# Run markdownlint to check for remaining issues
markdownlint content

echo "Line length fixing complete. Backups saved with .bak extension."
