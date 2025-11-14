#!/usr/bin/env bash
# $gensite.sh > sitemap.html
# generate site map following these rules
ROOT="."
EXCLUDE_DIRS=("scripts" "css" "img" "pages" "cool")
EXCLUDE_FILES=("index.php" "gensite.sh" "README.md" "sitemap.html" "logo.png" "gen.php")

echo '<img src="logo.png" width="100" height="100">'
echo '    <h2>SITE MAP:</h2><p>'
echo '    <a href="cool.html">.</a><br>'
echo '├── <a href="./index.php">Home</a><br>'
print_level() {
    local DIR="$1"
    local PREFIX="$2"

    # Build sorted entry list
    local entries=()
    while IFS= read -r entry; do
        entries+=("$entry")
    done < <(ls -1 "$DIR" | sort)

    for item in "${entries[@]}"; do
        
        # Skip excluded files
        [[ "$item" == "$(basename "$0")" ]] && continue
        for exf in "${EXCLUDE_FILES[@]}"; do
            [[ "$item" == "$exf" ]] && continue 2
        done

        # Skip excluded directories
        for ex in "${EXCLUDE_DIRS[@]}"; do
            [[ "$item" == "$ex" ]] && continue 2
        done

        local ITEMPATH="$DIR/$item"

        # Directory (depth 1)
        if [[ -d "$ITEMPATH" ]]; then
            local NAME="${item%.*}"
            echo "    ${PREFIX}├── <a href=\"./$item\">$NAME</a><br>"

            # Only descend once
            if [[ "$PREFIX" == "│   " ]]; then
                continue
            fi

            # Second-level items
            local subentries=()
            while IFS= read -r sub; do
                subentries+=("$sub")
            done < <(ls -1 "$ITEMPATH" | sort)

            for sub in "${subentries[@]}"; do
                
                # Skip excluded
                for ex in "${EXCLUDE_DIRS[@]}"; do
                    [[ "$sub" == "$ex" ]] && continue 2
                done
                for exf in "${EXCLUDE_FILES[@]}"; do
                    [[ "$sub" == "$exf" ]] && continue 2
                done

                local SUBPATH="$ITEMPATH/$sub"
                if [[ -f "$SUBPATH" ]]; then
                    local SUBNAME="${sub%.*}"
                    echo "    │   └── <a href=\"./$item/$sub\">$SUBNAME</a><br>"
                fi
            done

        # File
        elif [[ -f "$ITEMPATH" ]]; then
            local NAME="${item%.*}"
            echo "    ├── <a href=\"./$item\">$NAME</a><br>"
        fi

    done
}

print_level "$ROOT" ""

echo '<br><br><p>'
echo '</p>'
echo '<!-- End Sitemap -->'

