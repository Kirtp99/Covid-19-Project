# Covid-19-Project

The COVID-19 pandemic, caused by the novel coronavirus SARS-CoV-2, has fundamentally transformed the way we live, work, and interact with the world. Since its emergence in late 2019, this global health crisis has prompted unprecedented efforts to track, understand, and mitigate its impact. 

In this project, we delve into the world of COVID-19 data analysis, leveraging the power of SQL and Power BI. 

Our analysis encompasses a wide range of COVID-19-related topics, including but not limited to:
- Epidemiological Trends: examine the spread of COVID-19 over time and across different geographic regions. Looking at total cases, infection and death rates across the world.
- Vaccination Coverage: vaccines became a central tool in combating the pandemic, we will assess vaccination rates and their impact on reducing COVID-19 infection and death rates.

Starting out on SQL I import the data from https://ourworldindata.org/covid-deaths. Then writing queries to do the following:
- Data Extraction: Selecting the COVID-19 data from a database, particularly focusing on the "covid-death-data" table. Focusing on data relevant to cases, deaths, and vaccinations.
- Basic Metrics: Calculating metrics like infection rates and mortality rates for various countries and continents.
- Country and Continental Level Analysis: presenting daily infection and mortality rates, as well as total cases and deaths.
- Global Analysis: global COVID-19 data, providing insights into global trends, including total cases, total deaths, infection rates, and mortality rates.
- Vaccine Rollout: integrate data with vaccine data, tracking the number of new vaccinations per country and continent. This data is used to calculate the percentage of the population vaccinated.
- Data Views: creating data views that store relevant and calculated data for use in Power BI, making it easier to create interactive data visualizations.

The SQL queries provide a comprehensive analysis of COVID-19 data, including daily and cumulative metrics, infection rates, mortality rates, and vaccine rollout statistics. The calculated data is then prepared for further visualization and exploration using Power BI.


Looking at the interactive dashboard we can see visualise data at country, continent and  global levels. 
The insights:
- Global: The global infection rate was 8.24% while the mortality rate was around 2.5%. We can see spikes in the monthly cases around Jan 22 and Dec 22.
- Continent: Asia had the most number of cases at around 295 million followed closely by Europe at 247 million. Both continents had similar mortality rates at 1.9% and 2% respectively however their infection rate differ wildly. 6% compared to 16% respectively, mainly caused by the disparity in population. Europe has a far smaller population at 746 million while Asia has a population of roughly 4.6 billion. North America had a similar mortality rate to Europe but a lower infection rate at 9.2%. One of the reasons for the lower infection rate in NA could be due to the lower population density in the continent coming in at 61 people per square mile compared to Europe which is triple at around 187 per square mile. South America has a comparable infection rate to North America but has one of the highest mortality rates of any continent at 2.99%. Africa had an incredibly low infection rate at 2% due to the sparse population density but had the highest mortality rate at 3.9%.
- Country: Going through every country worldwide would be too extensive for this project so I will only look at a few countries with differing responses to the outbreak:
  - South Korea: Their infection rate was 14% with a mortality rate of 0.99%. South Korea's recent experience with the MERS outbreak in 2015 helped them during the COVID-19 pandemic, even though South Korea had the largest outbreak of MERS outside of the Middle East. As a result of MERS, South Korea had put policies and planning in place for pandemics that proved critical when COVID-19 hit. They did not rely on lockdowns like most other countries but relied on social distancing and a robust test/track/isolate system which proved effective. This was effective due to accessibility to testing and the ability of South Korean public health teams to trace a person’s activity over the previous week using phone and credit card data and closed-circuit TV if they test positive for COVID. If you were positive for the virus then you would have to isolate at your residence or at an isolation center where your vital were closely monitored, this was the main contributing factor towards low mortality rate. This prevented patients from showing up to hospital with low oxygen levels resulting in far fewer deaths.
  -               
  
  
