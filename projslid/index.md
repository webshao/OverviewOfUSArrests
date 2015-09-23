---
title       : Overview of US Arrests for Violent Crimes in 1973
subtitle    : 
author      : Weber Shao
job         : 
framework   : deckjs       # {io2012, html5slides, shower, dzslides, ...}
highlighter : prettify  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : [mathjax]            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides
---

## A Most Violent Year: Overview of US Arrests for Violent Crimes in 1973

* The application summarizes the number of arrests made by US states for three types of violent crime that occured in the year 1973: Murder, Rape, and Assault, normalized to number of arrests per 100,000 people
* Three ways of data visualization given: data table, bar chart, and geographic map of US states
* Interactive selection of arrest data for one type of crime at a time
* Interactive selection of grouping by one of the following:
  1. State
  2. Division (9 geographic groups: New England, Middle Atlantic, South Atlantic, East South Central, West South Central, East North Central, West North Central, Mountain, Pacific)
  3. Region (4 geographic groups: Northeast, South, North Central, West)

--- .class #id 

## Methods

* Divisional and regional data are weighted by population of the states of inclusion, since the original data has been already normalized to 100,000 people and population information needs to be restored

$$GroupArrests = \frac{\sum_{i=1}^n StatePopulation_i StateArrests_i}{\sum_{i=1}^n StatePopulation_i}$$

* Each state population, in thousands, is given in a data set from July 1, 1975; This is a good estimate since:
  1. Only the correct state population ratio compared to those of other states is needed in the calculation
  2. Population ratio is unlikely to change much since 1973

--- .class #id 

## Methods (Example)

* Example of obtaining number of arrests for assault per 100,000 people for using three Middle Atlantic states, by R's aggregrate _weighted.mean_ function and by manual calculation.


```
##              Assault state.pop.k  state.division
## New Jersey       159        7333 Middle Atlantic
## New York         254       18076 Middle Atlantic
## Pennsylvania     106       11860 Middle Atlantic
```

```
##    state.division Assault
## 2 Middle Atlantic   188.2
```


```r
(159*7333+254*18076+106*11860)/(7333+18076+11860)
```

```
## [1] 188.2103
```

--- .class #id 

## Data Table and Bar Chart

* Data table and bar chart of arrest rate of assault by division

<div style="align: center">
<table>
<tr>
<td><img src = 'assets/img/SampleDataTable.png'></img></td>
<td><img src = 'assets/img/SampleBarChart.png'></img></td>
</table>
</div>

--- .class #id 

## Geographic Map

* Geographic map of arrest rate of assault by division

<span style="align: center">
<img src = 'assets/img/SampleUSMap.png'></img>
</span>
