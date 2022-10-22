---importing a data set from excel-------
---we have 2 data set they are CovidDeaths$,CovidVaccinations$-----

***--- DATA EXPLORATION------***

---3,4 means column number-----

select * from CovidDeaths$ order by 3,4

select * from CovidVaccinations$ order by 3,4

select location,date,total_cases,new_cases,total_deaths from CovidDeaths$
order by 1,2



---1.looking for total cases vs total deaths------

select location,date,total_cases,total_deaths ,(total_deaths/total_cases)*100 as DeathPercentage
from CovidDeaths$
where location like '%india%'
order by 1,2



---2.show what percentage of population get covid------------

select location,date,total_cases,population,(total_cases/population)*100 as covid_affected_Percentage
from CovidDeaths$
where location like '%india%'
order by 1,2



---3.looking at country with highest infection rate compared to population---------

select location,population,max(total_cases) as highest_infection_count,max((total_cases/population))*100 as infected_population_Percentage
from CovidDeaths$
group by location,population
order by infected_population_Percentage  desc;



---4.showing countries with highest death count per population-----
***---The CAST() function converts a value (of any datatype) into a specified datatype.-----

select Location,max(cast(Total_deaths as int )) as Total_Death_Count
from CovidDeaths$
where continent is not null
group by Location
order by Total_Death_Count desc;



---5.let's  breaks  things down by continenet------------

select continent,max(cast(Total_deaths as int )) as Total_Death_Count
from CovidDeaths$
where continent is not null
group by continent
order by Total_Death_Count desc;



---6.global numbers ------------------------

select sum(new_cases) as total_casess,sum(cast(new_deaths as int)) as total_deaths,
sum(cast(new_deaths as int))/sum(new_cases)*100 as death_percentage
from CovidDeaths$
where continent is not null
order by 1,2




select * from CovidVaccinations$ 

---7. Looking at total population vs vaccinations-----

select a.continent,a.location,a.date,a.population,b.new_vaccinations,
sum(cast(b.new_vaccinations as int)) over (partition by a.location order by a.location,a.date)
from CovidDeaths$ a
join CovidVaccinations$ b
	on a.location=b.location
	and a.date=b.date
where a.continent is not null
order by 2,3

---Creating a view--------

create view  [percent_population_vaccinated] as 
select a.continent,a.location,a.date,a.population,b.new_vaccinations,
sum(cast(b.new_vaccinations as int)) over (partition by a.location order by a.location,a.date) as rolling_People_vaccinations
from CovidDeaths$ a
join CovidVaccinations$ b
	on a.location=b.location
	and a.date=b.date
where a.continent is not null;

select * from percent_population_vaccinated;


---------------------------------------------------------------------------------------------------------------
---european union--------

select Location,sum(cast(Total_deaths as int )) as Total_Death_Count
from CovidDeaths$
where continent is  null
and Location not in('World','European Union','International')
group by Location
order by Total_Death_Count desc;
---------------------------------------------------------------------------------------------------------------

select location,population,max(total_cases) as highest_infected,max((total_cases/population))*100 as perc_popu_affected
from CovidDeaths$
group by Location,Population
order by perc_popu_affected  desc;


--------------------------------------------------------------------------------------------------------------

select location,population,date,max(total_cases),max((total_cases/population))*100 as perc_popu_affected
from CovidDeaths$
group by Location,Population,date
order by perc_popu_affected  desc;




