Select * from Covid..CovidDeaths
order by 3,4;

--Select * from Covid..CovidVaccinations
--order by 3,4;

-- Select data that we are going to be using

Select cd.location,cd.date,cd.total_cases,cd.new_cases,cd.total_deaths,cd.population
From Covid..CovidDeaths cd
order by 1,2;

-- Looking at total cases vs total deaths 
SELECT 
    cd.location,
    cd.date,
    cd.total_cases,
    cd.total_deaths,
    (CAST(cd.total_deaths AS FLOAT) / NULLIF(CAST(cd.total_cases AS FLOAT), 0)) * 100 AS DeathPercentage
FROM 
    Covid..CovidDeaths cd
where location like '%India%'
ORDER BY 
    1, 2;


	-- Looking at total cases vs population

Select location,date,population,total_cases , (Cast(total_cases as float)/nullif(CAST(population as float),0))*100 as DeathPercantage
from Covid..CovidDeaths
where location like '%India%' 
order by 1,2;


-- Looking at Countries with highest infection rate compared to population

Select location,population,Max(total_cases) as HighestInfectionCount , 
Max((Cast(total_cases as float)/nullif(CAST(population as float),0)))*100 as PercentPopulationInfected
from Covid..CovidDeaths
where continent is not null
--where location like '%India%'
Group by location,population
order by PercentPopulationInfected desc;


--Showing Countries with Highest death Count per Population

Select location,MAX(total_deaths) as TotalDeathCount 
from Covid..CovidDeaths
where continent is not null
Group by location
order by TotalDeathCount desc;


-- Let's Break things down by continent

Select location,MAX(total_deaths) as TotalDeathCount 
from Covid..CovidDeaths
where continent is null
Group by location
order by TotalDeathCount desc;

Select continent,MAX(total_deaths) as TotalDeathCount 
from Covid..CovidDeaths
where continent is not null
Group by continent
order by TotalDeathCount desc;

-- showing continents with highest death count per population 
Select continent,MAX(total_deaths) as TotalDeathCount 
from Covid..CovidDeaths
where continent is not  null
Group by continent 
order by TotalDeathCount desc;

--Global Number 

SELECT 
    date,
    SUM(new_cases) AS total_cases, 
    SUM(new_deaths) AS total_deaths,
    (SUM(CAST(new_deaths AS FLOAT)) / NULLIF(SUM(CAST(new_cases AS FLOAT)), 0)) * 100 AS DeathPercentage
FROM 
    Covid..CovidDeaths
WHERE 
    continent IS NOT NULL 
GROUP BY 
    date
ORDER BY 
    total_cases DESC;

	SELECT 
    SUM(new_cases) AS total_cases, 
    SUM(new_deaths) AS total_deaths,
    (SUM(CAST(new_deaths AS FLOAT)) / NULLIF(SUM(CAST(new_cases AS FLOAT)), 0)) * 100 AS DeathPercentage
FROM 
    Covid..CovidDeaths
WHERE 
    continent IS NOT NULL 
ORDER BY 
    total_cases DESC;




SELECT 
    cd.continent,
    cd.location,
    cd.date,
    cd.population,
    cv.new_vaccinations,
    SUM(Cast(cv.new_vaccinations as bigint)) OVER (PARTITION BY cd.location ORDER BY cd.date ,cd.location)
FROM 
    Covid..CovidDeaths cd
JOIN 
    Covid..CovidVaccinations cv 
ON 
    cd.location = cv.location 
    AND cd.date = cv.date 
WHERE 
    cd.continent IS NOT NULL and cd.location like '%India%'
ORDER BY 
    cd.location, cd.date;
