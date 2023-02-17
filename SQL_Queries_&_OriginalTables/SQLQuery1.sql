--Vaccinations Dashboard

--Data exploration

select * 
from DashboardVac..vaccinations$

select *
from TypeVacci..['vaccinations-by-manufacturer$']

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











