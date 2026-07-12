# ShowMyData: Histograms

![ShowMyData Histograms](images/view.png)

**ShowMyData** is a collection of free, open-source Shiny applications for creating publication-quality data visualizations. Simply copy and paste your data, adjust a few options, and produce elegant graphs suitable for exploration, presentation, or publication.

ShowMyData is built around a simple but surprisingly uncommon design principle: **show the data**. Rather than relying solely on summaries such as means, boxplots, or violin plots, the apps emphasize visualizations that reveal every individual observation whenever practical, helping viewers understand what is really present in the data.

This application creates highly customizable histograms for visualizing quantitative data. It provides extensive control over binning, appearance, and annotation while producing figures suitable for exploration, teaching, and publication.

---

## Launch the app

The easiest way to use this application is through the hosted web version:

**https://showmydata.org**

---

## Run locally

```r
install.packages(c(
  "shiny",
  "tidyverse",
  "ggridges",
  "ggthemes"
))
```

```r
shiny::runGitHub(
  repo = "smd_histogram",
  username = "ShowMyData",
  subdir = "histogram"
)
```

---

## Download the source code

```r
shiny::runApp("histogram")
```

---

## About ShowMyData

ShowMyData is an open-source collection of interactive Shiny applications that make it easy to create elegant, data-rich visualizations for research, teaching, and publication. Our guiding principle is simple: **show the data**. By making individual observations visible whenever practical, the apps help viewers see what is really present in the data.

Learn more at:

**https://showmydata.org**

---

## Citation

If you use this software in research or teaching, please cite:

> Wilmer, J. B. (2022). *Data Visualization Web Apps* (Version 2.0) [Web Apps]. ShowMyData. https://showmydata.org

---

## License

This software is licensed under the GNU Affero General Public License v3.0 (AGPL-3.0).

---

## Feedback

Bug reports, feature requests, and contributions are welcome through the GitHub Issues page.

---