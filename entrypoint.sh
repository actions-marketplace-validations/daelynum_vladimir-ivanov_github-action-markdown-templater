#!/usr/bin/env bash

# Fail the script if any command fails
set -eu

NC='\033[0m' # No Color
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'

# The extension of the files we are working with, in this case .md
FILE_EXTENSION=".md"

# The path to the template file
TEMPLATE_FILE="$1"

# The path to the directory containing the replacement variables
REPLACEMENT_DIRECTORY="$2"

# If yes, only check modified files. If no, check all files.
CHECK_MODIFIED_FILES_ONLY="$3"

# The base branch against which to compare for modified files
BASE_BRANCH="$4"

# Display the variables
echo -e "${BLUE}TEMPLATE_FILE: $1${NC}"
echo -e "${BLUE}REPLACEMENT_DIRECTORY: $2${NC}"
echo -e "${BLUE}CHECK_MODIFIED_FILES_ONLY: $3${NC}"
echo -e "${BLUE}BASE_BRANCH: $4${NC}"

# Function to check for modified .md files in git
check_modified_files () {

   # Display the base branch
   echo -e "${BLUE}BASE_BRANCH: $BASE_BRANCH${NC}"

   # Configure git to add safe directory globally
   git config --global --add safe.directory '*'

   # Fetch the base branch from origin
   git fetch origin "$BASE_BRANCH" --depth=1 > /dev/null
   MASTER_HASH=$(git rev-parse origin/"$BASE_BRANCH")

   # Map the modified files into an array
   mapfile -t FILE_ARRAY < <( git diff --name-only --diff-filter=AM "$MASTER_HASH" )

   # For each modified .md file, replace variables
   for i in "${FILE_ARRAY[@]}"
   do
      if [ "${i##*.}" == "${FILE_EXTENSION#.}" ]; then
         FILE_PATH="${i}"
         echo "Processing $FILE_PATH"    # <--- Add this line to display the file being processed
         replace_variables
      fi
   done

}

# Function to replace the template variables in a given file
replace_variables () {

   # Display the file being processed
   echo "Processing $FILE_PATH"

   while IFS= read -r line
   do
      REPLACEMENT_VARIABLE=$(echo "$line" | awk -F= '{print $1}')
      REPLACEMENT_VALUE=$(echo "$line" | awk -F= '{print $2}')
      echo $line
      sed -i -e 's/{{'"$REPLACEMENT_VARIABLE"'}}/'"$REPLACEMENT_VALUE"'/g' "$FILE_PATH"
   done < "$REPLACEMENT_DIRECTORY"
}

# If we are only checking modified files, do so. Otherwise, replace variables in all .md files.
if [ "$CHECK_MODIFIED_FILES_ONLY" = "yes" ]; then
   check_modified_files
else
   for file in $(find . -type f -name "*$FILE_EXTENSION"); do
      FILE_PATH="${file}"
      replace_variables
   done
fi
