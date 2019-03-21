#!/usr/bin/env bash

set -euo pipefail

script_dir=$(dirname "$(readlink -f "$0")")

if [ -e "${script_dir}/bookmarks.html" ]; then
  rm "${script_dir}/bookmarks.html"
fi

cat "${script_dir}/readme.md" | tail -n +152 | head -n -9 > "${script_dir}/readme-copy.html"
lines=$(cat "${script_dir}/readme-copy.html")
touch "${script_dir}/bookmarks.html"

echo "<TITLE>Bookmarks</TITLE>" >> "${script_dir}/bookmarks.html"
echo "<H1>Bookmarks</H1>" >> "${script_dir}/bookmarks.html"
echo "<DL><p>" >> "${script_dir}/bookmarks.html"
echo "<DT><H3>Awesome Piracy</H3>" >> "${script_dir}/bookmarks.html"
echo "<DL><p>" >> "${script_dir}/bookmarks.html"

while read -r line; do
  if [[ "$line" == *'##'* ]]; then
    heading_text=$(echo $line | sed 's/\#//g')
    html_text="</DL></p>
<DT><H3>${heading_text:1}</H3>
<DL><p>"
    echo "$html_text" >> "${script_dir}/bookmarks.html"
  elif [[ "$line" == *'['* ]]; then
    item_name=$(echo "$line" | cut -d"]" -f1 | cut -d"[" -f2)
    url="$(echo $line | cut -d")" -f1 | cut -d"(" -f2)"
    html_text="<DT><A HREF=\"$url\">$item_name</A>"
    echo "$html_text" >> "${script_dir}/bookmarks.html"
  fi
done <<< "$lines"

echo "</DL></DL><p>" >> "${script_dir}/bookmarks.html"
sed -i '7d' "${script_dir}/bookmarks.html"

if [ -e "${script_dir}/readme-copy.html" ]; then
  rm "${script_dir}/readme-copy.html"
fi
