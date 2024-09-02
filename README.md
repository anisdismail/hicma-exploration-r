# A Deep Dive into the Text Corpus of the HICMA Dataset
Curious about exploring the HICMA dataset, and not sure where to start? 
<!-- PROJECT SHIELDS -->
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![CNC Liscence][license-shield]][license-url]

<!-- TABLE OF CONTENTS -->
<details open="open">
  <summary><h2 style="display: inline-block">Table of Contents</h2></summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      </li>
     <li> <a href="#built-with">Built With</a>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#contributing">Contributing</a></li>
   <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project
In this project, we will **explore the text corpus of the HICMA dataset**, which features over 5,000 images across five distinct styles. Each image is paired with descriptive text and a corresponding style label. It's crucial to conduct an exploratory data analysis of the dataset before diving into modeling as it helps to gain a deeper understanding of the structure and characteristics of the text corpus.

**We are especially interested in answering the following questions:**

- How does the word distribution differ across the three sources?
- Do the three sources share any common semantic topics?
- What are the most used words in the three sources, and how do these words relate to the topics in each source?
- How do the words cluster in the dataset, and is it possible to relate this clustering to the semantic relationships between the words?
- How do the word relationships differ across the three sources? Is there any common pattern that can be also observed in the complete dataset?
- Are there any outliers that might need to be removed or preprocessed from the dataset before any modeling step?

For a detailed analysis of the results obtained, I encourage you to take a look on my latest [blog](https://anisdismail.com/posts/hicma_exploration/). 

### Built With

* [tidyr](https://CRAN.R-project.org/package=tidyr): Easily tidy data 
* [dplyr](https://CRAN.R-project.org/package=dplyr): Data manipulation tools 
* [ggplot2](http://ggplot2.org): Elegant graphics for data analysis

## Getting Started

To get a local copy up and running follow these simple steps:

### Prerequisites
Get the HICMA dataset from the official website of the dataset found [here](https://hicma.net/dataset.html). Press download to get the dataset file in zip format. 

### Installation

1. Clone the repo
   ```sh
   git clone https://github.com/anisdismail/hicma-exploration-r
   ```
2. Change to the project repositry:
   ```sh
   cd hicma-exploration-r

   ```
3. Unzip the dataset file inside the repository.
4. Open your favorite R IDE (RStudio) and run the `install_packages.R` file to install the required packages to the environment.

## Usage
To run the project, run the `main.R` file in your favorite R IDE (RStudio). 

<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to be learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<!--LICENSE -->
## License

The HICMA dataset is publicly available and is published for research purposes under the Attribution-NonCommercial 4.0 International (CC BY-NC 4.0) licence. See [here](https://github.com/anisdismail/HICMA-benchmark/blob/main/LICENSE) for more information. 

The code used in this project is licensed under the MIT License, see [here](https://github.com/anisdismail/hicma-exploration-r/blob/main/LICENSE) for more information. 


<!-- CONTACT -->
## Contact

[Anis Ismail](https://linkedin.com/in/anisdimail)



<!-- MARKDOWN LINKS & IMAGES -->
[contributors-shield]: https://img.shields.io/github/contributors/anisdismail/hicma-exploration-r.svg?style=for-the-badge
[contributors-url]: https://github.com/anisdismail/hicma-exploration-r/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/anisdismail/hicma-exploration-r.svg?style=for-the-badge
[forks-url]: https://github.com/anisdismail/hicma-exploration-r/network/members
[stars-shield]: https://img.shields.io/github/stars/anisdismail/hicma-exploration-r.svg?style=for-the-badge
[stars-url]: https://github.com/anisdismail/hicma-exploration-r/stargazers
[issues-shield]: https://img.shields.io/github/issues/anisdismail/hicma-exploration-r.svg?style=for-the-badge
[issues-url]: https://github.com/anisdismail/hicma-exploration-r/issues
[license-shield]: https://img.shields.io/badge/license-MIT-green?style=for-the-badge
[license-url]: https://github.com/anisdismail/hicma-exploration-r/LICENSE
