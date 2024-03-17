library(tidyverse)
library(janitor)
#Load the required library 
library(googlesheets4)
#Read google sheets data into R
dsclubs <- read_sheet('https://docs.google.com/spreadsheets/d/13eUYaYWLbr14MU7XE7tcSKqFNeGlovYBiR6QbKFu8RU/edit?resourcekey#gid=1620849106')

dsclubs <- clean_names(dsclubs)
dsclubs <- dsclubs %>% 
  rename(contact_email = email_address_of_contact_person_it_will_be_used_for_data_science_event_communications_only)


# Start diverting output to club_directory.md
sink("../static/club_directory.md")
cat("---\ntitle: Master List of Data Science Clubs\ntitle-home: True\n---\n\n")

for (row in 1:nrow(dsclubs)) {
  cat('\n+', dsclubs[row,]$institution_name, ': ')
  web <- dsclubs[row,]$club_organization_website
  if (is.na(web) == FALSE) {
    cat('[', dsclubs[row,]$club_organization_name, '](', web, ')')
  } else {
    cat(dsclubs[row,]$club_organization_name)
  }
  linked_in <- dsclubs[row,]$linked_in
  if (is.na(linked_in) == FALSE) cat(' | [LinkedIn](', linked_in, ')')

  x <- dsclubs[row,]$x
  if (is.na(x) == FALSE) {
    if (startsWith(x, '@')) {
      cat(' | [X](https://www.twitter.com/', sub('@', '', x), ')', sep = '') 
    } else cat(' | [X](', x, ')')
  }
  
  instagram <- dsclubs[row,]$instagram
  if (is.na(instagram) == FALSE) {
    if (startsWith(instagram, '@')) {
      cat(' | [Instagram](https://www.instagram.com/', sub('@', '', instagram), ')', sep = '') 
    } else cat(' | [Instagram](', instagram, ')')
  }
}

# Stop diverting output to club_directory.md
sink()
