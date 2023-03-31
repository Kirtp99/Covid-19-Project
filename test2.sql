
-- by countries

Select continent,location,population, date, total_cases, total_deaths
, (cast(total_cases as float)/population)*100 as Infection_Rate, (cast(total_deaths as float)/total_cases)*100 as Mortality_Rate
 From Covid_Project..[covid-death-data]
 Where continent is not null
 order by 2,4

 Create View Figures_per_country as
 With P_V_V (continent, location, population, date, total_cases, total_deaths, new_vaccinations, Vaccine_Rollout)
 as
 (
 Select dea.continent, dea.location, dea.population, dea.date, dea.total_cases, dea.total_deaths, vac.new_vaccinations
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

 
 
 
 --continents

  Select location, population, date, total_cases, total_deaths
 , (cast(total_cases as float))/(cast(population as float))*100 as Infection_Rate, (cast(total_deaths as float))/(cast(total_cases as float))*100 as Mortality_Rate
 From Covid_Project..[covid-death-data]
 Where continent is null
 and location not like ('%income%')
 and location not like ('%world%')
 and location not like ('%Union%')
 order by 1,2


 Create View Figures_per_continent as
 With P_V_V_C (location, population, date, total_cases, total_deaths, new_vaccinations, Vaccine_Rollout)
 as
 (
 Select dea.location, dea.population, dea.date, dea.total_cases, dea.total_deaths, vac.new_vaccinations
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


 --global values
 Select location, date, total_cases, total_deaths
 , cast(total_cases as float)/cast(population as float)*100 as Infection_Rate, cast(total_deaths as float)/cast(total_cases as float)*100 as Mortality_Rate
 From Covid_Project..[covid-death-data]
 Where location like ('%world%')
 order by 2
 

 Create View Figures_global as
 With P_V_V_G (location, population, date, total_cases, total_deaths, new_vaccinations, Vaccine_Rollout)
 as
 (
 Select dea.location, dea.population, dea.date, dea.total_cases, dea.total_deaths, vac.new_vaccinations
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
