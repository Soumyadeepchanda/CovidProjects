--Tables Used in this project

--Covid Deaths

Select *
From CovidProject..CovidDeaths$
Where continent is not null 
order by 3,4

Select *
From CovidProject..CovidVaccinations$
Where continent is not null 
order by 3,4

--Covid Vaccinations

select * 
from DashboardVac..vaccinations$

select *
from TypeVacci..['vaccinations-by-manufacturer$']

--Covid Deaths Dashboard Data Exploration

Select Location, date, total_cases, new_cases, total_deaths, population
From CovidProject..CovidDeaths$
Where continent is not null 
order by 1,2


-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country

Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From CovidProject..CovidDeaths$
Where location like '%India%'
and continent is not null 
order by 1,2


-- Total Cases vs Population
-- Shows what percentage of population infected with Covid

Select Location, date, Population, total_cases,  (total_cases/population)*100 as PercentPopulationInfected
From CovidProject..CovidDeaths$
--Where location like '%states%'
order by 1,2


-- Countries with Highest Infection Rate compared to Population

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From CovidProject..CovidDeaths$
Group by Location, Population
order by PercentPopulationInfected desc


-- Countries with Highest Death Count per Population

Select Location, MAX(cast(Total_deaths as bigint)) as TotalDeathCount
From CovidProject..CovidDeaths$
--Where location like '%states%'
Where continent is not null 
Group by Location
order by TotalDeathCount desc



-- SORTING BY CONTINENT

-- Showing contintents with the highest death count per population

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From CovidProject..CovidDeaths$
--Where location like '%states%'
Where continent is not null 
Group by continent
order by TotalDeathCount desc



-- GLOBAL NUMBERS

Select sum(new_cases) as total_cases, SUM(cast(new_deaths as bigint)) as total_deaths, SUM(cast(new_deaths as bigint))/SUM(New_Cases)*100 as DeathPercentage
From CovidProject..CovidDeaths$
where continent is not null
order by 1,2



-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidProject..CovidDeaths$ dea
Join CovidProject..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3


-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From CovidProject..CovidDeaths$ dea
Join CovidProject..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
)
Select *
From PopvsVac

-- Using Temp Table to perform Calculation on Partition By in previous query

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From CovidProject..CovidDeaths$ dea
join CovidProject..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
Select *
From #PercentPopulationVaccinated
where continent is not null
order by 2,3

-- Exploring GDP trend wrt time of various locations
select continent,location, date,avg(GDP_Per_Capita) as Avg_GDP
from CovidProject..CovidVaccinations$
group by continent,location,date
where continent is not null
order by 1,2

--Total vaccination per day in the world
select date,sum(cast(people_vaccinated as bigint)) as Daily_Total_Vaccinations
from CovidProject..CovidVaccinations$
group by date
order by 1,2

--Vaccinations Dashboard

--Covid Vaccination Dashboard Data Exploration

--Vaccine type avialable in diffrent countries

select vaccine,count(vaccine) as CountVaccine
from TypeVacci..['vaccinations-by-manufacturer$']
group by vaccine
order by 1,2

--Total Vaccination administered

select (sum(cast(people_vaccinated as bigint))-sum(cast(people_fully_vaccinated as bigint))) as Single_Doses, sum(cast(people_fully_vaccinated as bigint)) as Fully_vaccinated, sum(cast(total_boosters as bigint)) as Total_Boosters  
from DashboardVac..vaccinations$

--Dosage of vaccinations per type in the world

select vaccine,sum(total_vaccinations)
from TypeVacci..['vaccinations-by-manufacturer$']
group by vaccine

--Vaccinated once vs Fully vaccinated

select continent, (sum(cast(people_vaccinated as bigint))-sum(cast(people_fully_vaccinated as bigint)))/sum(population)*100 as PercentPopuVacOnce,sum(cast(people_fully_vaccinated as bigint))/sum(population)*100 as PercentPopuVacFull
from DashboardVac..vaccinations$
where continent is not null
group by continent
order by continent

--Daily vaccinations per day

select date,sum(daily_vaccinations)
from DashboardVac..vaccinations$
where date is not null
group by date
order by date











