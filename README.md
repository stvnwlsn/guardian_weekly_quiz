# Scrape Guardian Weekly Quiz

I needed questions for a trivia quiz so I scraped the Guardian website.

Below is my method from a hazy memory.  The scripts are pretty rough.

```
# Find urls of the quiz pages
$ perl gwq_scrape_get_url.pl > urls.txt

# Download the quiz pages locally
$ perl gwq_scrape_get_pages.pl

# Scrape the quiz questions from downloaded pages and
# note any we had trouble scraping.
$ perl gwq_scrape_get_qs_and_as.pl > skipped.txt

# Open the skipped pages and manually copy the questions 
# and answers into text files.
$ bash open-skipped.sh

# Scrape the skipped q and as from text files
# I think I ran this over and over, modifying the text files until they 
# all scraped successfully. 
$ perl gwq_scrape_skipped_qs.pl
```

Next import the csv files into a spreadsheet.  I used '##' double pound as a
delimiter but perhaps another delimiter would be better as there were hashtags
in questions which tripped this up.


