
SELECT *
FROM covid..CovidDeaths
ORDER BY 3,4

SELECT *
FROM covid..CovidVaccination
ORDER BY 3,4

-- select data that we are going to be using

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM covid..CovidDeaths
ORDER BY 1,2

-- Looking at total cases vs total deaths
-- Shows likelihood of dying if you contract covid in United States
SELECT location, date, total_cases, Total_deaths, (total_deaths/total_cases)*100 AS Deathpercentage
FROM covid..CovidDeaths
WHERE location like '%states%'
ORDER BY 1,2

-- To show likelihood of dying if you contract covid in Nigeria
SELECT location, date, total_cases, Total_deaths, (total_deaths/total_cases)*100 AS Deathpercentage
FROM covid..CovidDeaths
WHERE location like '%Nigeria%'
ORDER BY 1,2

-- Looking at the total cases vs population
-- Shows what percentage of population got covid
SELECT location, date, population, total_cases, (total_deaths/population)*100 AS Percentagepopulation
FROM covid..CovidDeaths
WHERE location like '%states%'
ORDER BY 1,2

-- To show what percentage of population in Nigeria got covid
SELECT location, date, population, total_cases, (total_deaths/population)*100 AS Percentpopulationinfected
FROM covid..CovidDeaths
WHERE location like '%Nigeria%'
ORDER BY 1,2

-- Looking at countries with highest infection rate compared to population
SELECT location, population, MAX(total_cases) AS Highestinfectioncount, MAX((total_deaths/population))*100 AS Percentpopulationinfected
FROM covid..CovidDeaths
GROUP BY location, population
ORDER BY Percentpopulationinfected DESC

-- For Nigeria
SELECT location, population, MAX(total_cases) AS Highestinfectioncount, MAX((total_deaths/population))*100 AS Percentpopulationinfected
FROM covid..CovidDeaths
WHERE location like '%Nigeria%'
GROUP BY location, population
ORDER BY Percentpopulationinfected DESC

-- Showing the countries with highest death count per population
SELECT location, MAX(CAST(total_deaths AS INT)) AS Totaldeathcount
FROM covid..CovidDeaths
WHERE continent is not null
GROUP BY location
ORDER BY Totaldeathcount DESC

-- Let's break things down by continent
SELECT location, MAX(CAST(total_deaths AS INT)) AS Totaldeathcount
FROM covid..CovidDeaths
WHERE continent is null
GROUP BY location
ORDER BY Totaldeathcount DESC

-- Showing the coninent with highest death count
SELECT continent, MAX(CAST(total_deaths AS INT)) AS Totaldeathcount
FROM covid..CovidDeaths
WHERE continent is not null
GROUP BY continent
ORDER BY Totaldeathcount DESC

-- Global numbers
SELECT SUM(new_cases) as total_cases, SUM(CAST(new_deaths AS INT)) AS total_deaths, SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 AS Deathpercentage
FROM covid..CovidDeaths
WHERE continent is not null
ORDER BY 1,2
-- Group by date
SELECT date, SUM(new_cases) as total_cases, SUM(CAST(new_deaths AS INT)) AS total_deaths, SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 AS Deathpercentage
FROM covid..CovidDeaths
WHERE continent is not null
GROUP BY date
ORDER BY 1,2


-- Joing the two tables
SELECT *
FROM covid..CovidDeaths dea
JOIN covid..CovidVaccination vac
	ON dea.location = vac.location
	AND dea.date = vac.date

-- Looking at total population vs vaccination
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
FROM covid..CovidDeaths dea
JOIN covid..CovidVaccination vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2,3
-- To show rolling count of new vaccination using partition by
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CAST(vac.new_vaccinations AS INT)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) AS Rollingpeoplevaccinated
FROM covid..CovidDeaths dea
JOIN covid..CovidVaccination vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2,3


-- USE CTE
WITH popvsvac (continent, location, date, population, new_vaccinations, Rollingpeoplevaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CAST(vac.new_vaccinations AS INT)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) AS Rollingpeoplevaccinated
FROM covid..CovidDeaths dea
JOIN covid..CovidVaccination vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null
)
SELECT *, (Rollingpeoplevaccinated/population)*100 AS PercentRPV
FROM popvsvac



-- Temp table
DROP TABLE if exists #Percentagepopulationvaccinated
CREATE TABLE #percentagepopulationvaccinated
(
continent nvarchar(225),
location nvarchar(225),
date datetime,
population numeric,
new_vaccinations numeric,
Rollingpeoplevaccinated numeric
)


INSERT INTO #percentagepopulationvaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CAST(vac.new_vaccinations AS INT)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) AS Rollingpeoplevaccinated
FROM covid..CovidDeaths dea
JOIN covid..CovidVaccination vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null 

SELECT *, (Rollingpeoplevaccinated/population)*100 AS PercentRPV
FROM #percentagepopulationvaccinated


-- Creating View to store data for visualization later

CREATE VIEW percentagepopulationvaccinatedd AS 
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CAST(vac.new_vaccinations AS INT)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) AS Rollingpeoplevaccinated
FROM covid..CovidDeaths dea
JOIN covid..CovidVaccination vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null