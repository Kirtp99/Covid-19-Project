  -- global adding new cases/deaths
 
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



 -- continent adding new cases/deaths

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



  -- country adding new cases/deaths

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