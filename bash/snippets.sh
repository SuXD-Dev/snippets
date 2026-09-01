#!/usr/bin/env bash
# Useful Bash code snippets

# --- String Operations ---
upper="hello"
echo "${upper^^}"  # HELLO
lower="WORLD"
echo "${lower,,}"  # world

# Substring
text="Hello World"
echo "${text:0:5}"   # Hello
echo "${text:6}"     # World

# Replace
echo "${text/World/Bash}"  # Hello Bash

# String length
str="hello"
echo "${#str}"  # 5

# --- Array Operations ---
arr=(apple banana cherry "dragon fruit")
echo "${#arr[@]}"        # 4
echo "${arr[0]}"          # apple
echo "${arr[@]:1:2}"      # banana cherry

# Append
arr+=(elderberry)

# Loop
for item in "${arr[@]}"; do
    echo "$item"
done

# --- File Operations ---
if [[ -r "$file" ]]; then
    content=$(< "$file")
fi

# Find and process files
find . -name "*.log" -mtime +30 -delete

# Rename extension
for f in *.txt; do mv "$f" "${f%.txt}.md"; done

# --- Process Management ---
command -v python3 &>/dev/null && echo "Python found" || echo "Not found"

# --- Math ---
result=$(( (5 + 3) * 2 ))
echo "$result"  # 16

echo "scale=2; 10 / 3" | bc  # 3.33
random=$(( RANDOM % 100 ))
echo "Random: $random"
