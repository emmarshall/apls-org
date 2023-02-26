---
editor: 
  markdown: 
    wrap: 72
---

New ap-ls.org site currently at: https://emmarshall.github.io/

![Logo for American Psychology-Law
Society](images/APLS_general_logo.png)

<br />

<p align="center">

<h3 align="center">

NHS Quarto Theme

</h3>

<p align="center">

Developed by <a href="https://github.com/craig-shenton">Craig
Shenton</a> \@ NHS England <br />
<!--<a href="/"><strong>Explore the docs »</strong></a>
    <br />
    <br />-->
<a href="https://github.com/craig-shenton/quarto-nhs-theme/issues">Report
Bug</a> ·
<a href="https://github.com/craig-shenton/quarto-nhs-theme/issues">Request
Feature</a>

</p>

</p>

<!-- TABLE OF CONTENTS -->

<details open="open">

<summary>

<h2 style="display: inline-block">

Table of Contents

</h2>

</summary>

<ol>

<li>

<a href="#about-the-project">About The Project</a>

<ul>

<li><a href="#folder-stucture">Folder Stucture</a></li>

<li><a href="#built-with">Built With</a></li>

</ul>

</li>

<li>

<a href="#getting-started">Getting Started</a>

<li><a href="#roadmap">Roadmap</a></li>

<li><a href="#contributing">Contributing</a></li>

<li><a href="#license">License</a></li>

<!-- <li><a href="#acknowledgements">Acknowledgements</a></li> -->

</ol>

</details>

<!-- ABOUT THE PROJECT -->

## About The Project

An NHS Theme for deploying Quarto websites to GitHub.io pages with
automated GitHub action.

***Note:** No data, public or private are shared in this repository.*

### Site Structure


<pre>

 <b>ap-ls.org</b>  
├─📦 <b>Home</b>  
│ ├─⚙️ <b>About</b>  
│ │ ├─ <a href="https://tidyclust.tidymodels.org/">What is Law-Psychology?</a>   - Clustering in tidymodels  
│ │ ├─ <a href="https://textrecipes.tidymodels.org/">textrecipes</a> - Extra 'Recipes' for Text Processing  
│ │ ├─ <a href="https://github.com/tidymodels/themis">themis</a>      - Extra 'Recipes' steps for unbalanced data  
│ │ └─ <a href="https://github.com/tidymodels/censored/">censored</a>    - Parsnip wrappers for survival models  
│ ├─🎨 <b>Colors</b>  
│ │ ├─ <a href="https://github.com/EmilHvitfeldt/prismatic">prismatic</a>   - Simple color manipulation  
│ │ └─ <a href="https://emilhvitfeldt.github.io/paletteer/">paletteer</a>   - Functions for all R color palettes  
│ ├─📖 <b>Text</b>  
│ │ ├─ <a href="https://emilhvitfeldt.github.io/emoji/">emoji</a>       - Data and functions about emojis  
│ │ ├─ <a href="https://emilhvitfeldt.github.io/friends/">friends</a>     - Complete script transcription of the Friends  
│ │ ├─ <a href="https://emilhvitfeldt.github.io/textdata/">textdata</a>    - Download and Load Various Text Datasets  
│ │ └─ <a href="https://emilhvitfeldt.github.io/wordsalad/">wordsalad</a>   - Extract and Analyze Word Vectors  
│ └─📌 <b>Other</b>  
│   ├─ <a href="https://emilhvitfeldt.github.io/ggpage/">ggpage</a>      - Creates Page Layout Visualizations  
│   └─ <a href="https://github.com/EmilHvitfeldt/gganonymize">gganonumize</a> - Anonymize the labels and text in a ggplot2  
├─🔵 <b>Quarto</b>  
│ ├─ <a href="https://github.com/EmilHvitfeldt/quarto-roughnotation">rough-notation</a>           - Use roughnotation javascript in revealjs presentations  
│ ├─ <a href="https://github.com/EmilHvitfeldt/quarto-revealjs-letterbox">revealjs letterbox theme</a> - A Quarto reveal.js theme for letterbox styled slides  
│ ├─ <a href="https://github.com/EmilHvitfeldt/quarto-nes-theme">NES.css theme</a>            - A Quarto reveal.js theme based on NES.css  
│ └─ <a href="https://github.com/EmilHvitfeldt/quarto-designmode">designMode</a>               - Enable designMode in html Quarto output  
├─🌟 <b>Projects</b>  
│ ├─ <a href="https://github.com/EmilHvitfeldt/R-text-data">R-text-data</a>       - List of textual data in R  
│ ├─ <a href="https://emilhvitfeldt.github.io/r-color-palettes/">r-color-palettes</a>  - Showcase of all color palettes in R  
│ ├─ <a href="https://www.emilhvitfeldt.com/">emilhvitfeldt.com</a> - Personal Blog  
│ └─ <a href="https://xaringan.gallery/">xaringan.gallery</a>  - Collection of examples and custom themes  
├─📚 <b>Books</b>  
│ └─ <a href="https://smltar.com/">smltar</a> - Supervised Machine Learning for Text Analysis in R  
├─🧑‍🏫 <b>Education Material</b>  
│ ├─ <a href="https://emilhvitfeldt.github.io/ISLR-tidymodels-labs/index.html">ISLR tidymodels labs</a> - Tidymodels translation of ISLR labs  
│ └─ <a href="https://github.com/EmilHvitfeldt/emilverse">emilverse</a>            - Collection of personal packages and templates  
└─💡 <b>Other</b>  
  ├─ <a href="https://github.com/EmilHvitfeldt/talks">Talks</a>     - My public talks  
  ├─ <a href="https://github.com/EmilHvitfeldt/workshops">Workshops</a> - My Public Workshops  
  └─ <a href="https://github.com/EmilHvitfeldt/courses">Courses</a>   - My Public Courses

</pre>

### Folder Structure

| Name               | Link                           | Description                                                             |
|------------------|------------------|-------------------------------------|
| .github/workflows  | \[[Link](/.github/workflows)\] | Github Action workflow files that automate the publishing process       |
| docs/              | \[[Link](docs/)\]              | All files for rendering the Quarto website                              |
| docs/\_assets/     | \[[Link](docs/assets)\]        | Art and style assets that build the page theme                          |
| docs/documentation | \[[Link](docs/)\]              | All markdown files here will be added to the documentation sidebar      |
| docs/posts         | \[[Link](docs/)\]              | Blog posts. Each post should be in its own folder as a `index.qmd` file |
| talks              | \[[Link](docs/)\]              | All markdown files here will be added to the tutorial sidebar           |
| resources          |                                |                                                                         |

### Built With

-   [Quarto](https://quarto.org/)
-   [R](https://www.r-project.org/)

## About

Contact email: webmaster\@ap-ls.org
