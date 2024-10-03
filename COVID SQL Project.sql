SELECT *
FROM PortfolioProject.dbo.CovidDeaths
--WHERE continent IS NOT NULL
ORDER BY location, date

--SELECT *
--FROM PortfolioProject.dbo.CovidVaccinations
--ORDER BY 3,4

--Select Data that we are going to used

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent IS NOT NULL
ORDER BY location, date



--Looking at Total Cases vs Total Deaths
--Shows likelihood of dying from having a COVID 19 case in your country


--per day
SELECT Location, Date, Total_Cases, Total_Deaths, 
	   CASE 
		WHEN total_cases = 0 OR total_deaths = 0 THEN 0
	    ELSE (total_deaths)/(total_cases)*100
	   END AS Death_Percentage
FROM PortfolioProject..CovidDeaths
--WHERE location like '%state%'
WHERE continent IS NOT NULL
ORDER BY Location, Date


--per year
SELECT Location, 
       YEAR(date) AS Year, 
       SUM(total_cases) AS Total_Cases, 
       SUM(total_deaths) AS Total_Deaths, 
       CASE 
           WHEN SUM(total_cases) = 0 OR SUM(total_deaths) = 0 THEN 0
           ELSE ((SUM(total_deaths) / SUM(total_cases)) * 100)
       END AS Death_Percentage
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY Location, YEAR(date)
ORDER BY Location, YEAR(date)


--overall
SELECT Location, 
       SUM(total_cases) AS Total_Cases, 
	   SUM(total_deaths) AS Total_Deaths,
	   CASE 
		WHEN SUM(total_cases) = 0 OR SUM(total_deaths) = 0 THEN 0
	    ELSE (SUM(total_deaths)/SUM(total_cases)*100)
	   END AS Death_Percentage
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY Location
ORDER BY Total_Cases DESC, 
		 Death_Percentage DESC



--Looking at Total Cases vs Population
--Shows what percentage of population got COVID


--per day
SELECT Location, Date, Population, Total_Cases, 
	   ((total_cases)/(population)*100) AS Covid_Percentage
FROM PortfolioProject..CovidDeaths
--WHERE location like '%state%'
ORDER BY Location, Date


--per year
SELECT Location, 
       YEAR(date) AS Year, 
	   SUM(population) AS Population, 
       SUM(total_cases) AS Total_Cases, 
       CASE 
           WHEN SUM(population) = 0 OR SUM(total_cases) = 0 THEN 0
           ELSE ((SUM(total_cases) / SUM(population)) * 100)
       END AS Covid_Percentage
FROM PortfolioProject.dbo.CovidDeaths
GROUP BY Location, YEAR(date)
ORDER BY Location, YEAR(date)


--overall
SELECT Location, 
	   SUM(population) AS Population, 
       SUM(total_cases) AS Total_Cases, 
       CASE 
           WHEN SUM(population) = 0 OR SUM(total_cases) = 0 THEN 0
           ELSE ((SUM(total_cases) / SUM(population)) * 100)
       END AS Covid_Percentage
FROM PortfolioProject..CovidDeaths
GROUP BY Location
ORDER BY Total_Cases DESC, 
		 Covid_Percentage DESC



--Looking at Countries with Highest Infection rate compared to Population


SELECT Location, Population, MAX(total_cases) AS Highest_Infection_Count, 
	   MAX((total_cases)/(population))*100 AS Percent_Population_Infected
FROM PortfolioProject..CovidDeaths
--WHERE location like '%state%'
GROUP BY Location, Population
ORDER BY Percent_Population_Infected DESC



--Showing Countries with Highest Death Count per Population


SELECT Location, MAX(CAST(total_deaths AS int)) AS Total_Death_Count 
FROM PortfolioProject..CovidDeaths
--WHERE location like '%state%'
WHERE continent IS NOT NULL
GROUP BY Location
ORDER BY Total_Death_Count DESC




--Let's break things down by continent

-- Showing continents with highest death counts


SELECT Continent, MAX(CAST(total_deaths AS int)) AS Total_Death_Count 
FROM PortfolioProject..CovidDeaths
--WHERE location like '%state%'
WHERE continent IS NOT NULL
GROUP BY Continent
ORDER BY Total_Death_Count DESC


-- Global Numbers

SELECT SUM(new_cases) as Total_Cases, SUM(CAST(new_deaths as int)) as Total_Deaths, SUM(CAST(new_deaths as int))/SUM(New_Cases)*100 as Death_Percentage
FROM PortfolioProject..CovidDeaths
--WHERE Location like '%states%'
WHERE Continent is not null 
--GROUP BY Date
ORDER BY 1,2


--Looking at Total Population vs Vaccinations

SELECT dea.continent, dea.location, dea.date, population, vac.new_vaccinations,
       SUM(CAST(vac.new_vaccinations AS int)) 
	   OVER (PARTITION BY dea.location ORDER BY dea.location)
	   AS Rolling_people_vaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
     ON dea.location = vac.location
	 AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3


-- Use CTE

WITH PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated) 
AS (
    SELECT dea.continent, 
           dea.location, 
           dea.date, 
           dea.population, 
           vac.new_vaccinations,
           SUM(COALESCE(CAST(vac.new_vaccinations AS int), 0)) 
               OVER (PARTITION BY dea.location ORDER BY dea.date) AS RollingPeopleVaccinated
    FROM PortfolioProject..CovidDeaths dea
    JOIN PortfolioProject..CovidVaccinations vac
        ON dea.location = vac.location
        AND dea.date = vac.date
    WHERE dea.continent IS NOT NULL
)
SELECT *, 
       CASE 
           WHEN Population = 0 THEN NULL 
           ELSE (RollingPeopleVaccinated / Population) * 100 
       END AS Vaccination_Percentage
FROM PopvsVac



-- Temp Table

DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, 
           dea.location, 
           dea.date, 
           dea.population, 
           vac.new_vaccinations,
           SUM(COALESCE(CAST(vac.new_vaccinations AS int), 0)) 
               OVER (PARTITION BY dea.location ORDER BY dea.date) AS RollingPeopleVaccinated
    FROM PortfolioProject..CovidDeaths dea
    JOIN PortfolioProject..CovidVaccinations vac
        ON dea.location = vac.location
        AND dea.date = vac.date
--WHERE dea.continent IS NOT NULL
--ORDER BY 2,3 

SELECT *, (RollingPeopleVaccinated/Population)*100
FROM #PercentPopulationVaccinated



--Creating View to store data for later Visualizations

CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent, 
           dea.location, 
           dea.date, 
           dea.population, 
           vac.new_vaccinations,
           SUM(COALESCE(CAST(vac.new_vaccinations AS int), 0)) 
               OVER (PARTITION BY dea.location ORDER BY dea.date) AS RollingPeopleVaccinated
    FROM PortfolioProject..CovidDeaths dea
    JOIN PortfolioProject..CovidVaccinations vac
        ON dea.location = vac.location
        AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3 


SELECT *
FROM PercentPopulationVaccinated