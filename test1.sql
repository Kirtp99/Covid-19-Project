Create View Mortality_Rate_per_country as
Select location, date, total_cases, total_deaths, (cast(total_deaths as float)/total_cases)*100 as Mortality_Rate
 From Covid_Project..[covid-death-data]
 Where continent is not null

Create view Infection_Rate_per_country as
Select location, date, population, total_cases, (cast(total_cases as float)/population)*100 as Infection_Rate
From Covid_Project..[covid-death-data]
Where continent is not null
order by 1,2

Create View Infection_Mortality_Rate_per_continent as
 Select location, MAX(cast(total_cases as int)) as Total_cases, MAX(cast(total_deaths as int)) as Total_Deaths
 , MAX(cast(total_cases as float))/MAX(cast(population as float))*100 as Infection_Rate, MAX(cast(total_deaths as float))/MAX(cast(total_cases as float))*100 as Mortality_Rate
 From Covid_Project..[covid-death-data]
 Where continent is null
 and location not like ('%income%')
 and location not like ('%world%')
 Group by location
 
 
Create View Infection_Mortlaity_Rate_World as
 Select location, MAX(cast(total_cases as int)) as Total_cases, MAX(cast(total_deaths as int)) as Total_Deaths
 , MAX(cast(total_cases as float))/MAX(cast(population as float))*100 as Infection_Rate, MAX(cast(total_deaths as float))/MAX(cast(total_cases as float))*100 as Mortality_Rate
 From Covid_Project..[covid-death-data]
 Where location like '%World%'
 Group by location

Create View Daily_Global_figures as
 Select date, SUM(cast(total_cases as float)) as Total_cases, SUM(cast(total_deaths as float)) as Total_Deaths
 , SUM(cast(total_cases as float))/SUM(cast(population as float))*100 as Infection_Rate, SUM(cast(total_deaths as float))/SUM(cast(total_cases as float))*100 as Mortality_Rate
 From Covid_Project..[covid-death-data]
 Where continent is not null
 Group by date


Create View PPV_continent as
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


 Create View Percentage_of_population_vaccinated as
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





Create View Global_Vaccine_Rollout as
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