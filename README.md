![Logo for American Psychology-Law Society](images/APLS_general_logo.png)

# AP-LS Website <img src="images/APLS_general_logo.png" align="right" width="120"/>

## Website Basics

This new ap-ls.org website is built in [RStudio](https://www.rstudio.com/) using [Quarto](https://quarto.org). The content for the site is stored on the AP-LS Google Drive and on [GitHub](https://github.com). The site is published using [Netlify](https://www.netlify.com/). The root directory that contains the published site is `docs`.

[![Netlify Status](https://api.netlify.com/api/v1/badges/60c754e7-3b21-48ae-b752-84935991712f/deploy-status)](https://app.netlify.com/sites/ap-ls/deploys)

## Site file structure

The main content for the site is stored in the following files and directories:

-   `_quarto.yml` controls site-wide parameters and defines navbar/sidebar/footer content
-   `_variables.yml` controls site-wide variables that can be inserted using shortcodes
-   `apls_functions.R` in `_site` runs the `r` functions that are used to build aspects of the site including the image carousel. Do not change this.
-   `index.qmd` is the home page
-   `about`, `conferences`, `publications`, `resources`, and `membership` are folders that contain those respective pages for the site and other listing pages
    -   The main page for each section is saved as `index.qmd`
    -   For the pages that include listings, the `index.qmd` file in each folder specifies what is included
-   `404.qmd` is the 404 page for the site
-   `styles.css` and `theme.scss` in the `assets` directory are used for additional CSS and SASS styling for the site's appearance, such as fonts and colors
    -   `index.css` in `conferences/` has additional styling for the conference page

## Notes

**Freeze**

The pages are frozen so that the documents are not individually re-rendered during a global project render.

## Quarto

The site is built using [Quarto](https://quarto.org/docs/get-started/) which provides an extensive [guide](https://quarto.org/docs/guide/) and [reference](https://quarto.org/docs/reference/) materials.

## Editing content on the site

The project uses `renv` to ensure that all edits to the website use the same package versions. To edit the site, you need to:

1.  Clone the `emarshall/apls-org` repository
2.  Start a new R session in your new project directory and initialize `renv`. If you are not sure if you have the `renv` package installed you can run the following:

``` r
         # Install the 'renv' package if not already installed
if (!requireNamespace("renv", quietly = TRUE)) {
  install.packages("renv")
}

# Initialize 'renv' in your project directory
renv::init()

# Restore the project's packages (this installs packages from the 'renv.lock' file)
renv::restore()
```

4. To preview the site from your terminal use: 

``` r
quarto preview apls-org
```

## How to Change the website

Each page has its own `.qmd` file in the `apls-org/` directory. However, many pages (i.e., job postings, image carousel, etc.) need to be updated by making changes to the accompanying `.yml` file. See below for instructions editing this type of content: 

### How to Change the Image Carousel 

The content on the home is determined by the `apls-org/index.qmd` file. It is located in the main `apls-org/` directory. The images for the carousel that appears at the top of the page are stored in `apls-org/images/`. The items in the carousel are determined by the content in the `apls-org/carousel.yml` file. To add (or remove) an item you need to: 

1. Save the image file in `apls-org/images/`.
2. Create a new entry in the `carousel.yml` file, with the following information: 
  -   `caption`: Insert text to appear under image 
  -   `image`: path to image file
  -   `link`: url to open when image is clicked (if no link is avialable, use "")

  ``` .yaml
  Example: 
  - caption: "2024 AP-LS Call for Conference Proposals!"
    image: "images/2024_call_for_proposals.jpeg"
    link: "https://ap-ls.org/conferences/"
  ```
3. Render new `apls-org/index.qmd` file

### How to Add/Remove a Job Posting 

The job postings content is located in the `resources/job-postings/` directory. The `index.qmd` file sets the content for the job-postings page. The items that appear on the page are determined by the `academic-jobs.yml` and `professional-jobs.yml` files. To add or remove an item you need to: 

1. Locate the correct `yml` file for the posting (ie., academic vs professional)
2. Create a new entry in the `academic-jobs.yml` or `professional-jobs.yml` file, with the following information: 
  -   `title`: name of position available
  -   `date`: Current date (YYYY-MM-DD)
  -   `organization`: Name of institution or business 
  -   `location`: Where position is located
  -   `url`: External link to job posting

  ``` .yaml
  Example: 
  - title: Assistant Professor of Psychology
    date: 2023-08-02
    organization: University of Nebraska, Department of Psychology
    location: Lincoln, Nebraska
  url: https://unl.example.com/
  ```
3. Render new `apls-org/resources/job-postings/index.qmd` file


## To do:

-   Proofread content pages
-   Create r package to store functions
-   Newsletter archives - index and format listings (include pds)
-   TTC Education and Teaching materials
-   How to add a new post/page write up
