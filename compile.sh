#!/bin/bash

# Define the order of groups
declare -a group_order=("Faculty" "Student" "Alumni")

# Declare associative arrays for each group
declare -A faculty
declare -A alumni
declare -A student

for person in `ls static/people/*.md`; do
    firstname=$(grep -m 1 "firstname:" $person | awk -F': ' '{print $2}' | sed "s/^ *//;s/ *$//" | tr -d '\r')
    lastname=$(grep -m 1 "lastname:" $person | awk -F': ' '{print $2}' | sed "s/^ *//;s/ *$//" | tr -d '\r')
    role=$(grep -m 1 "role:" $person | awk -F': ' '{print $2}' | sed "s/^ *//;s/ *$//" | tr -d '\r')
    group=$(grep -m 1 "group:" $person | awk -F': ' '{print $2}' | sed "s/^ *//;s/ *$//" | tr -d '\r')
    image=$(grep -m 1 "image:" $person | awk -F': ' '{print $2}' | sed "s/^ *//;s/ *$//" | tr -d '\r')
    link=$(grep -m 1 "link:" $person | awk -F': ' '{print $2}' | sed "s/^ *//;s/ *$//" | tr -d '\r')
    linkname="$(basename $person .md)"
    if [ -z "$image" ]; then
        image="doc/image/blank_photo.png"
    fi


    # # Debugging information
    # echo "Processing: $person"
    # echo "Extracted Firstname: $firstname, Lastname: $lastname, Group: $group, Linkname: $linkname"

    key_firstname=$(echo $firstname | sed 's/[_()]//g')
    key_lastname=$(echo $lastname | sed 's/[_()]//g')
    case $group in
        "Faculty")
            faculty["$key_lastname$key_firstname"]="- [$firstname $lastname]($linkname.html)"
            ;;
        "Alumni")
            alumni["$key_lastname$key_firstname"]="- [$firstname $lastname]($linkname.html)"
            ;;
        "Student")
            student["$key_lastname$key_firstname"]="- [$firstname $lastname]($linkname.html)"
            ;;
    esac

    # Create the layout for individual pages
    echo "<div class='individual-header'>" > temp.md
    echo "<h3>$firstname $lastname</h3>" >> temp.md
    echo "<h4>$role</h4>" >> temp.md
    echo "</div>" >> temp.md
    echo "<div class='profile'>" >> temp.md
    echo "<div class='profile-image-container'><img src='$image' alt='$name' class='profile-image'></div>" >> temp.md
    echo "<div class='profile-details'>" >> temp.md
    cat $person >> temp.md
    if [ ! -z "$link" ]; then
        echo "<br><br>" >> temp.md
        echo "<a href='$link' target='_blank'>Personal Website</a>" >> temp.md
    fi
    echo "</div>" >> temp.md
    echo "</div>" >> temp.md


    # Convert to HTML
    pandoc --template template.html -T "CTDSLab" \
           -V "navbar-$linkname=true" \
           -V "activePage=$linkname" \
           --metadata title="$firstname $lastname" \
           -f markdown+link_attributes+header_attributes-smart \
           -t html -o html/$linkname.html temp.md
done

# echo "Student members:"
# for name in "${!student[@]}"; do
#     echo "${student["$name"]}"
# done

# Create the summary page for all people
echo "---" > static/people.md
echo "title: People" >> static/people.md
echo "---" >> static/people.md
echo "<div class='people-container'>" >> static/people.md
# Add grouped people to the summary page in the predefined order

for group in "${group_order[@]}"; do
    echo "<div class='group-column'>" >> static/people.md
    echo "<h3>$group</h3>" >> static/people.md

    # Reset the sorted_names array for each group
    sorted_names=()

    # Determine the current group and populate the sorted_names array
    case $group in
        "Faculty")
            for name in "${!faculty[@]}"; do
                sorted_names+=( "$name" )
            done
            ;;
        "Alumni")
            for name in "${!alumni[@]}"; do
                sorted_names+=( "$name" )
            done
            ;;
        "Student")
            for name in "${!student[@]}"; do
                sorted_names+=( "$name" )
            done
            ;;
    esac

    # Sort the names
    IFS=$'\n' sorted=($(sort <<<"${sorted_names[*]}"))
    unset IFS

    # Print sorted names
    case $group in
        "Faculty")
            for name in "${sorted[@]}"; do
                echo "${faculty["$name"]}" >> static/people.md
            done
            ;;
        "Alumni")
            for name in "${sorted[@]}"; do
                echo "${alumni["$name"]}" >> static/people.md
            done
            ;;
        "Student")
            for name in "${sorted[@]}"; do
                echo "${student["$name"]}" >> static/people.md
            done
            ;;
    esac

    echo "</div>" >> static/people.md
done


echo "</div>" >> static/people.md

# Convert the summary markdown to HTML for people
pandoc --template template.html -T "CTDSLab" \
       -V "navbar-people=true" \
       --metadata title="People" \
       -f markdown+link_attributes+header_attributes-smart \
       -t html -o html/people.html static/people.md

# Process other pages in the static directory
for page in `ls static/*.md`; do
    filename=$(basename -- "$page")
    base="${filename%.*}"
    pandoc --template template.html -T "CTDSLab" \
           -V "navbar-$base=true" \
           -f markdown+link_attributes+header_attributes-smart \
           -t html -o html/$base.html $page
done

# Clean up temporary markdown file
rm temp.md
rm static/people.md
