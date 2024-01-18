#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <commit_message>"
    exit 1
fi

commit_message="$1"
base_directory='/Users/anhkhoakz/CodeVault'
site_directory="$base_directory/anhkhoakz.dev"
public_directory="$site_directory/public"

replace_TOML() {
    filename="hugo.toml"
    original_pattern="$1"
    replace_pattern="$2"

    temp_file=$(mktemp)
    sed "s/$original_pattern/$replace_pattern/g" "$filename" > "$temp_file"
    mv "$temp_file" "$filename"

    echo "Replacement complete. Original pattern '$original_pattern' replaced with '$replace_pattern'. Modified content exported to $filename."
}

# Build page to Github and Codeberg
cd "$site_directory" || exit
echo -e "\nBuild page to Github and CodeBerg"
hugo && \
cd "$public_directory" && \
git add . && \
git commit -m "$commit_message" && \
git push && \
cd "$site_directory"

# Create .gitignore
cd "$public_directory"
echo -e "Creating .gitignore\n.git/\nCNAME\n.DS_Store" > .gitignore
cd "$site_directory"

# Build page to Neocities
echo -e "\nBuild page to Neocities"
replace_TOML 'anhkhoakz\.dev' 'anhkhoakz\.neocities\.org' && \
hugo && \
cd "$public_directory" && \
neocities push . && \
cd "$site_directory"

# Build page to Surge
echo -e "\nBuild page to Surge"
replace_TOML 'anhkhoakz\.neocities\.org' 'anhkhoakz\.surge\.sh' && \
hugo && \
cd "$public_directory" && \
surge . --domain anhkhoakz.surge.sh && \
cd "$site_directory"

# Change hugo.toml back to original
replace_TOML 'anhkhoakz\.surge\.sh' 'anhkhoakz\.dev'

cd "$public_directory"
echo "Removing .gitignore"
rm .gitignore
cd "$site_directory"
hugo

echo "Finish Upload"
