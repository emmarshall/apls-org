

New ap-ls.org site currently at: https://emmarshall.github.io/

![Logo for American Psychology-Law
Society](images/APLS_general_logo.png)


# AP-LS Website <img src="images/APLS_general_logo.png" align="right" width = "120" />

## Website Basics

This ap-ls.org website is built in [RStudio](https://www.rstudio.com/) using [Quarto](https://quarto.org). The content for the site is stored on the AP-LS Google Drive and on [GitHub](https://github.com). The site is published using [Netlify](https://www.netlify.com/). When the site is updated in the Github respository, the new published content will appear in the `_site` directory.


## Site file structure

The main content for the site is stored in the following files and directories:

- `_quarto.yml` controls site-wide parameters and defines navbar/sidebar/footer content
- `_variables.yml` controls site-wide variables that can be inserted using shortcodes
- `apls_functions.R` in `_site` runs the `r` functions that are used to build aspects of the site including the image carousel. Do not change this. 
- `index.qmd` is the home page
- `about`, `contact`, `documents`, `events`, and `news` contain those respective pages for the site
  - `documents`, `events`, and `news` are listing pages
      - The `index.qmd` file in each directory controls parameters for the post listings
  - `contact` has a listing section for displaying member profiles
- `404.qmd` is the 404 page for the site
- `styles.css` and `theme.scss` in the `assets` directory are used for additional CSS and SASS styling for the site's appearance, such as fonts and colors
  - `docs` - The root directory contains the published site.
    ```

## Notes

**Freeze**

The pages are frozen so that the documents are not
individually re-rendered during a global project render. 

## Quarto

The site is built using [Quarto](https://quarto.org/docs/get-started/) which provides an extensive [guide](https://quarto.org/docs/guide/) and [reference](https://quarto.org/docs/reference/) materials.