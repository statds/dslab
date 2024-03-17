# Connecticut Data Science Lab website

This repository contains the source code and content for the CTDSLab website.

## Pipeline status:

![Deploy status](https://github.com/statds/dslab/actions/workflows/main.yml/badge.svg)


## Directory Structure

+ `static/`: Contains static markdown files.
+ `html/`: Contains the generated HTML files for the website and the
  following subdirectories:
  - `css/`: Contains the CSS stylesheets for the website.
  - `js/`: Contains JavaScript files for the website.
  - `doc`: Media and other files for the website; sync with AWS S3
    bucket via `make` commands.
+ `template.html`: The HTML template used by `Pandoc` for generating
  the website pages.
  - Add a logo for the website by uncommenting the line
    `<!-- <img src="doc/image/logo.png" alt="Logo" class="navbar-logo"> -->`
    in the template.
+ `compile.sh`: Bash script to generate the website from the markdown
  content.
