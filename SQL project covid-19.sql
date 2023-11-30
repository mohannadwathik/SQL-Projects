--checking our data 

-- looking at all datta before 25/6/2022

delete from coviddeaths2
where date >= '2022-06-25 00:00:00.000'

select *
from portfolio_covi19.dbo.coviddeaths2
where continent is not null
order by 3 ,4


select *
from portfolio_covi19.dbo.covidvaccinations2
order by 3, 4



--selecting the data  we are starting with

select location, date, population, total_cases,total_deaths 
from portfolio_covi19.dbo.coviddeaths2
where continent is not null
order by 1, 2


--looking at total_cases vs total_deaths in jordan 

--looking atdeaths percentage 
-- i had to convert total cases and total deaths format to fload because they were Nvarchar

select location, date, total_cases, total_deaths, ((convert (float,total_deaths))/(convert (float, total_cases)))*100 as Death_Percentage
from portfolio_covi19.dbo.coviddeaths2
where location = 'Jordan' and continent is not null
order by 5 desc

--looking at countries with highest infection rate compared to population


select location, max(total_cases) as total_infection_count, population, max(total_cases/population)*100 as population_infected_percentage
from portfolio_covi19.dbo.coviddeaths2
where continent is not null
group by location, population
order by 4 desc


--countries with highest deaths count per population 


select location,population, max (convert(float,total_deaths)) as total_death_count 
from portfolio_covi19.dbo.coviddeaths2
where continent is not null
group by location, population
order by total_death_count desc


--continent with the hightest death count per population

select continent, max (convert(float,total_deaths)) as total_death_count 
from portfolio_covi19.dbo.coviddeaths2
where continent is null
group by continent
order by total_death_count desc



--global number 


select sum(new_cases)as total_cases, sum(new_deaths)as total_deaths, (sum(new_deaths)/sum(new_cases))*100 as death_percentage
from portfolio_covi19.dbo.coviddeaths2
where continent is not null
order by 1,2 



-- total population vs total vaccinations
-- Percentage of Population that has recieved at least one Covid Vaccine

select dea.continent , dea.location , dea.date, dea.population, vac.new_vaccinations, sum(convert(float,vac.new_vaccinations)) over (partition by dea.location order by dea.location , dea.date)as roll_people_vaccinated
from portfolio_covi19.dbo.coviddeaths2 as dea
join portfolio_covi19.dbo.covidvaccinations2 as vac
     on dea.location = vac.location
	 and dea.date = vac.date
	 where dea.continent is not null
 order by 2 ,3


 --use cte

 with PopvsVac (continent, location,date,population,new_vaccinations,roll_people_vaccinated)
 as 
(
 select dea.continent , dea.location , dea.date, dea.population, vac.new_vaccinations, sum(convert(float,vac.new_vaccinations)) over (partition by dea.location order by dea.location , dea.date)as roll_people_vaccinated
from portfolio_covi19.dbo.coviddeaths2 as dea
join portfolio_covi19.dbo.covidvaccinations2 as vac
     on dea.location = vac.location
	 and dea.date = vac.date
	 where dea.continent is not null
 )


select * , (roll_people_vaccinated/population)*100 as percent_population_vaccinated
from popvsvac 


























