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
SELECT location, MAX(cast(total_deaths as int)) AS TotalDeathCount
FROM Portfolio_Project..CovidDeaths
WHERE  continent IS NULL
--WHERE location = 'GREECE'
GROUP BY location
ORDER BY TotalDeathCount DESC

--39:26 - 1:17:08