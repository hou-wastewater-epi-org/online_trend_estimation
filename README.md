# HHD+Rice CDC Center of Excellence for Wastewater Epidemiology

https://hou-wastewater-epi.org

Tutorial Website: https://hou-wastewater-epi-org.github.io/online_trend_estimation/

Contact email: info\@hou-wastewater-epi.org

Paper: "Online trend estimation and detection of trend deviations in sub-sewershed time series of SARS-CoV-2 RNA measured in wastewater ."

PI of Analytics Group: Dr. Katherine B. Ensor, Department of Statistics, Rice University

Lead Analyst for HHD: Rebecca Schneider, Houston Health Department

Lead Analyst for Rice: Julia Schedler, Department of Statistics, Rice University

## Description

Tutorials detailing Algorithms 1 and 2 in "Online trend estimation and detection of trend deviations in sub-sewershed time series of SARS-CoV-2 RNA measured in wastewater ." are provided in a rendered format here:

### Code

In addition to the code chunks in `Algorithm1.qmd` and `Algorithm2.qmd`, the following R files are included to produce the analyses used in the paper:

-   `KFAS_rolling_estimation.r` applies `KFAS_state_space_spline.r` (wrappers for `KFAS` package functions)
-   `ww_ewma.r` produces the EWMA control charts (a wrapper for `qcc` package functions)
-   `fplot.r`, contains helper functions for producing nice plots.

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

### Data

Synthetic example data in the file `synthetic_ww_time_series.csv`provided in the `Data` folder to produce analysis and figures similar to those found in the paper.

Given the small populations associated with some of the lift stations, real data will be made available on a case-by-case basis by contacting the Houston Wastewater Epidemiology group and subsequent approval by Houston Health Department.

[![CC BY-NC-SA 4.0](https://img.shields.io/badge/License-CC%20BY--NC--SA%204.0-lightgrey.svg)](http://creativecommons.org/licenses/by-nc-sa/4.0/)

### Licensing

Because code and intellectual work have different licensing needs, a separate `LICENSE` file is contained in each folder and applies to the files in that folder:

-   Files in the `Code` folder are licensed under the GNU General Public License, Version 3 (GPL-3).

-   Files in the `Data` folder are licensed under the Creative Commons NonCommercial ShareAlike (CC by-NC-SA) license.

We are happy to discuss the possibility of an alternate (dual) license for the files in either folder. If you encounter a situation where you are unable to use the work for desired purposes, for example, a license compatibility issue, please reach out to  info\@hou-wastewater-epi.org.
