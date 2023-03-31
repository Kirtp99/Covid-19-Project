Select *
 From Covid_Project..[covid-death-data]
 Where location like '%income%'
 order by 3,4

 --Select *
 --From Covid_Project..[covis-vaccine-data]
 --order by 3,4

 -- Select data that will be used

Select location, date, total_cases,new_cases,total_deaths, population
 From Covid_Project..[covid-death-data]
 Where continent is not null
 order by 1,2


 -- Looking at the Total Case vs Total Deaths (Mortality Rate)
 
Select location, date, total_cases, total_deaths, (cast(total_deaths as float)/total_cases)*100 as Mortality_Rate
 From Covid_Project..[covid-death-data]
 Where continent is not null
 -- Where location like '%United Kingdom%'
 order by 1,2

 
 -- Looking at the Total Cases vs Population (Infection Rate)

Select location, date, population, total_cases, (cast(total_cases as float)/population)*100 as Infection_Rate
 From Covid_Project..[covid-death-data]
 Where continent is not null
 -- Where location like '%United Kingdom%'
 order by 1,2

 
 -- Showing coutries with the highest infection rates

Select location, population, MAX(cast(total_cases as int)) as Total_Cases, MAX((total_cases/population))*100 as Infection_Rate
 From Covid_Project..[covid-death-data]
 Where continent is not null
 -- Where location like '%United Kingdom%'
 Group by location, population
 order by Infection_Rate desc


 -- Showing countries with the highest Mortality Count

 Select location, population, MAX(cast(total_deaths as int)) as Total_Deaths
 From Covid_Project..[covid-death-data]
 Where continent is not null
 -- Where location like '%United Kingdom%'
 Group by location, population
 order by Total_Deaths desc

 -- Breakdown by continents
  -- Showing continents daily  infection/mortality rates + cases/deaths
  
 Select location, population, date, total_cases, total_deaths
 , (cast(total_cases as float))/(cast(population as float))*100 as Infection_Rate, (cast(total_deaths as float))/(cast(total_cases as float))*100 as Mortality_Rate
 From Covid_Project..[covid-death-data]
 Where continent is null
 and location not like ('%income%')
 and location not like ('%world%')
 and location not like ('%Union%')
 order by 1,2

 -- Showing continents total infection/mortality rates + total cases/deaths

 Select location, MAX(cast(total_cases as int)) as Total_cases, MAX(cast(total_deaths as int)) as Total_Deaths
 , MAX(cast(total_cases as float))/MAX(cast(population as float))*100 as Infection_Rate, MAX(cast(total_deaths as float))/MAX(cast(total_cases as float))*100 as Mortality_Rate
 From Covid_Project..[covid-death-data]
 Where continent is null
 and location not like ('%income%')
 and location not like ('%world%')
 Group by location
 order by Total_Deaths desc

 --Looking at daily Global figures

 Select date, SUM(cast(total_cases as float)) as Total_cases, SUM(cast(total_deaths as float)) as Total_Deaths
 , SUM(cast(total_cases as float))/SUM(cast(population as float))*100 as Infection_Rate, SUM(cast(total_deaths as float))/SUM(cast(total_cases as float))*100 as Mortality_Rate
 From Covid_Project..[covid-death-data]
 Where continent is not null
 Group by date
 order by 1,2

 Select location, MAX(cast(total_cases as int)) as Total_cases, MAX(cast(total_deaths as int)) as Total_Deaths
 , MAX(cast(total_cases as float))/MAX(cast(population as float))*100 as Infection_Rate, MAX(cast(total_deaths as float))/MAX(cast(total_cases as float))*100 as Mortality_Rate
 From Covid_Project..[covid-death-data]
 Where location like ('%World%')
 Group by location
 order by Total_Deaths desc


 --Now looking at Vaccine Rollout data as well
 --Total poluation vs Vaccinations per country
 --USE a CTE

 
 With P_V_V (continent, location, date, population, new_vaccinations, Vaccine_Rollout)
 as
 (
 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
 , SUM(convert(bigint,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as Vaccine_Rollout
 From Covid_Project..[covid-death-data] dea
 Join Covid_Project..[covis-vaccine-data] vac
     On dea.location = vac.location
	 and dea.date = vac.date
 Where dea.continent is not null 
 --order by 2,3
 )
 Select *, (Vaccine_Rollout/population)*100 as Percentage_of_population_vaccinated
 From P_V_V


-- Temp table

DROP Table if exists Percentage_of_population_vaccinated
Create Table Percentage_of_population_vaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
Vaccine_Rollout numeric
)
Insert into Percentage_of_population_vaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
 , SUM(convert(bigint,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date) as Vaccine_Rollout
 From Covid_Project..[covid-death-data] dea
 Join Covid_Project..[covis-vaccine-data] vac
     On dea.location = vac.location
	 and dea.date = vac.date
Where dea.continent is not null 
order by 2,3

Select *, (Vaccine_Rollout/population)*100 as Percentage_of_population_vaccinated
From Percentage_of_population_vaccinated


-- Vaccine rollout per continent 

 With P_V_V_C (continent, location, date, population, new_vaccinations, Vaccine_Rollout)
 as
 (
 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
 , SUM(convert(bigint,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as Vaccine_Rollout
 From Covid_Project..[covid-death-data] dea
 Join Covid_Project..[covis-vaccine-data] vac
     On dea.location = vac.location
	 and dea.date = vac.date
 Where dea.continent is null
 and dea.location not like ('%income%')
 and dea.location not like ('%world%')
 --order by 2,3
 )
 Select *, (Vaccine_Rollout/population)*100 as Percentage_of_population_vaccinated
 From P_V_V_C

 
 -- Global Vaccination numbers

 With P_V_V_G (location, date, population, new_vaccinations, Vaccine_Rollout)
 as
 (
 Select dea.location, dea.date, dea.population, vac.new_vaccinations
 , SUM(convert(bigint,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as Vaccine_Rollout
 From Covid_Project..[covid-death-data] dea
 Join Covid_Project..[covis-vaccine-data] vac
    on dea.date = vac.date
	and dea.location = vac.location
 Where dea.continent is null
 and dea.location like ('%world%')
 --order by 1
 )
 Select *, (Vaccine_Rollout/population)*100 as Percentage_of_population_vaccinated
 From P_V_V_G



 -- Creating view to store data for Power BI

-- total cases/deaths + infection/mortality rate + % population vaccinated per country

 Create View Figures_per_country as
 With P_V_V (continent, location, population, date, new_cases, total_cases, new_deaths, total_deaths, new_vaccinations, Vaccine_Rollout)
 as
 (
 Select dea.continent, dea.location, dea.population, dea.date, dea.new_cases, dea.total_cases, new_deaths, dea.total_deaths, vac.new_vaccinations
 , SUM(convert(bigint,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as Vaccine_Rollout
 From Covid_Project..[covid-death-data] dea
 Join Covid_Project..[covis-vaccine-data] vac
     On dea.location = vac.location
	 and dea.date = vac.date
 Where dea.continent is not null 
 )

 Select *, (cast(total_cases as float)/population)*100 as Infection_Rate, (cast(total_deaths as float)/total_cases)*100 as Mortality_Rate
 , (Vaccine_Rollout/population)*100 as Percentage_of_population_vaccinated
 From P_V_V




-- total cases/deaths + infection/mortality rate + % population vaccinated per continent

 Create View Figures_per_continent as
 With P_V_V_C (location, population, date, new_cases, total_cases, new_deaths, total_deaths, new_vaccinations, Vaccine_Rollout)
 as
 (
 Select dea.location, dea.population, dea.date, dea.new_cases, dea.total_cases, new_deaths, dea.total_deaths, vac.new_vaccinations
 , SUM(convert(bigint,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as Vaccine_Rollout
 From Covid_Project..[covid-death-data] dea
 Join Covid_Project..[covis-vaccine-data] vac
     On dea.location = vac.location
	 and dea.date = vac.date
 Where dea.continent is null
 and dea.location not like ('%income%')
 and dea.location not like ('%world%')
 )
 Select *, (cast(total_cases as float))/(cast(population as float))*100 as Infection_Rate, (cast(total_deaths as float))/(cast(total_cases as float))*100 as Mortality_Rate
 , (Vaccine_Rollout/population)*100 as Percentage_of_population_vaccinated
 From P_V_V_C


 -- total global cases/deaths + infection/mortality rate + % polulation vaccinated
 
 Create View Figures_global as
 With P_V_V_G (location, population, date, new_cases, total_cases, new_deaths, total_deaths, new_vaccinations, Vaccine_Rollout)
 as
 (
 Select dea.location, dea.population, dea.date, dea.new_cases, dea.total_cases, new_deaths, dea.total_deaths, vac.new_vaccinations
 , SUM(convert(bigint,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as Vaccine_Rollout
 From Covid_Project..[covid-death-data] dea
 Join Covid_Project..[covis-vaccine-data] vac
    on dea.date = vac.date
	and dea.location = vac.location
 Where dea.continent is null
 and dea.location like ('%world%')
 )
 Select *, cast(total_cases as float)/cast(population as float)*100 as Infection_Rate, cast(total_deaths as float)/cast(total_cases as float)*100 as Mortality_Rate
 , (Vaccine_Rollout/population)*100 as Percentage_of_population_vaccinated
 From P_V_V_G




-- total infection and mortality rate global
Create View Infection_Mortlaity_Rate_World as
 Select location, MAX(cast(total_cases as int)) as Total_cases, MAX(cast(total_deaths as int)) as Total_Deaths
 , MAX(cast(total_cases as float))/MAX(cast(population as float))*100 as Infection_Rate, MAX(cast(total_deaths as float))/MAX(cast(total_cases as float))*100 as Mortality_Rate
 From Covid_Project..[covid-death-data]
 Where location like '%World%'
 Group by location
 

-- total for continents

Create View Total_Infection_Mortlaity_Rate_Continent as
Select location, MAX(cast(total_cases as int)) as Total_cases, MAX(cast(total_deaths as int)) as Total_Deaths
, MAX(cast(total_cases as float))/MAX(cast(population as float))*100 as Infection_Rate, MAX(cast(total_deaths as float))/MAX(cast(total_cases as float))*100 as Mortality_Rate
From Covid_Project..[covid-death-data]
Where continent is null
and location not like ('%income%')
and location not like ('%world%')
and location not like ('%Union')
Group by location


-- total for countries

Create View Total_Infection_Mortlaity_Rate_Countries as
Select location, MAX(cast(total_cases as int)) as Total_cases, MAX(cast(total_deaths as int)) as Total_Deaths
, MAX(cast(total_cases as float))/MAX(cast(population as float))*100 as Infection_Rate, MAX(cast(total_deaths as float))/MAX(cast(total_cases as float))*100 as Mortality_Rate
From Covid_Project..[covid-death-data]
Where continent is not null
Group by location



