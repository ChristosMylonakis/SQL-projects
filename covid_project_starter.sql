SELECT *
FROM Portfolio_Project..CovidDeaths
WHERE  continent IS NOT NULL
ORDER BY 3,4

--SELECT *
--FROM Portfolio_Project..CovidVaccinations
--ORDER BY 3,4

-- select data that we are going to use

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM Portfolio_Project..CovidDeaths
ORDER BY 1,2

-- Total cases / Total deaths

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)* 100 AS DeathPercentage
FROM Portfolio_Project..CovidDeaths
WHERE location = 'GREECE'
ORDER BY 1,2


-- Total Cases / Population

SELECT location, date, total_cases, population, (total_cases/population)* 100 AS PercentageOfPopulationwithCovid
FROM Portfolio_Project..CovidDeaths
WHERE location = 'GREECE'
ORDER BY 1,2


--Countries with highest infection Rate compared to population

SELECT location, population, max(total_cases) as HighestInfectionRate, max((total_cases/population)* 100) AS PercentageOfPopulationwithCovid
FROM Portfolio_Project..CovidDeaths
--WHERE location = 'GREECE'
GROUP BY location, population
ORDER BY PercentageOfPopulationwithCovid DESC

-- Countries with highest total deaths
-- cast it 'cause there's issue with data type
SELECT location, MAX(cast(total_deaths as int)) AS TotalDeathCount
FROM Portfolio_Project..CovidDeaths
WHERE  continent IS NOT NULL
--WHERE location = 'GREECE'
GROUP BY location
ORDER BY TotalDeathCount DESC

-- Break things down by continent
SELECT continent, MAX(cast(total_deaths as int)) AS TotalDeathCount
FROM Portfolio_Project..CovidDeaths
WHERE  continent IS not NULL
--WHERE location = 'GREECE'
GROUP BY continent
ORDER BY TotalDeathCount DESC

-- Continents with highest death count

SELECT continent, MAX(cast(total_deaths as int)) AS TotalDeathCount
FROM Portfolio_Project..CovidDeaths
WHERE  continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC

-- GLOBAL NUMBERS
-- BY DATE DEATH/CASES

SELECT DATE, SUM(new_cases) AS TOTALCASES, SUM(CAST(new_deaths AS INT)) AS TOTALDEATHS, SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 AS DeathPercentage
FROM Portfolio_Project..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1,2


-- TOTAL POPULATION VS VACCINATION
-- JOIN THE TABLES
SELECT DEA.continent, DEA.location, DEA.date, DEA.population, VAC.new_vaccinations
, SUM(CAST(VAC.new_vaccinations AS INT)) OVER (PARTITION BY DEA.LOCATION ORDER BY DEA.LOCATION,
DEA.DATE) AS ROLLING_SUM_COUNTRY_VACCINATED
,
FROM Portfolio_Project..CovidDeaths AS DEA
JOIN Portfolio_Project..CovidVaccinations AS VAC
	ON DEA.location = VAC.location
	AND DEA.date = VAC.date
WHERE DEA.continent IS NOT NULL
ORDER BY 2,3

-- USE CTE
WITH PopvsVac (continent, location, date, population, new_vaccinations, ROLLING_SUM_COUNTRY_VACCINATED)
as
(
SELECT DEA.continent, DEA.location, DEA.date, DEA.population, VAC.new_vaccinations
, SUM(CAST(VAC.new_vaccinations AS INT)) OVER (PARTITION BY DEA.LOCATION ORDER BY DEA.LOCATION,
DEA.DATE) AS ROLLING_SUM_COUNTRY_VACCINATED
FROM Portfolio_Project..CovidDeaths AS DEA
JOIN Portfolio_Project..CovidVaccinations AS VAC
	ON DEA.location = VAC.location
	AND DEA.date = VAC.date
WHERE DEA.continent IS NOT NULL
--ORDER BY 2,3
)
select *, 
from PopvsVac

-- temp table
drop table if exists #percentPopulationVaccinated
create table #percentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
Rolling_sum_country_vaccinated numeric
)

insert into #percentPopulationVaccinated
SELECT DEA.continent, DEA.location, DEA.date, DEA.population, VAC.new_vaccinations
, SUM(CAST(VAC.new_vaccinations AS INT)) OVER (PARTITION BY DEA.LOCATION ORDER BY DEA.LOCATION,
DEA.DATE) AS ROLLING_SUM_COUNTRY_VACCINATED
FROM Portfolio_Project..CovidDeaths AS DEA
JOIN Portfolio_Project..CovidVaccinations AS VAC
	ON DEA.location = VAC.location
	AND DEA.date = VAC.date
WHERE DEA.continent IS NOT NULL
--ORDER BY 2,3

select *
from #percentPopulationVaccinated



--create view to store data for later visualizations
create view PercentPopVaccinated as
SELECT DEA.continent, DEA.location, DEA.date, DEA.population, VAC.new_vaccinations
, SUM(CAST(VAC.new_vaccinations AS INT)) OVER (PARTITION BY DEA.LOCATION ORDER BY DEA.LOCATION,
  DEA.DATE) AS ROLLING_SUM_COUNTRY_VACCINATED
FROM Portfolio_Project..CovidDeaths AS DEA
JOIN Portfolio_Project..CovidVaccinations AS VAC
	ON DEA.location = VAC.location
	AND DEA.date = VAC.date
WHERE DEA.continent IS NOT NULL

select *
from PercentPopVaccinated
