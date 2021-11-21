--SELECT *
--FROM PortfolioProject1..CovidDeath
--ORDER BY 3,4

--SELECT *
--FROM PortfolioProject1..CovidVax
--ORDER BY 3,4

--1. Selecting Data that we are going to use
SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject1..coviddeath
--WHERE Location = 'Kyrgyzstan'
ORDER BY 1,2 --by columns 1,2 meaning sorting based of location and date columns


--2. Looking at the total cases vs total deaths(what is the percentage of people died who had Covid?)
-- Shows the likelihood of dying if you contract Covid in KG
SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS death_percentage
FROM PortfolioProject1..CovidDeath
WHERE Location = 'Kyrgyzstan'
ORDER BY 1,2 --by columns 1,2 meaning sorting based of location and date columns

-- Shows the likelihood of dying if you contract Covid in the US
SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS death_percentage
FROM PortfolioProject1..CovidDeath
WHERE Location = 'United States'
ORDER BY 1,2

--3. Looking at total cases vs population in KG and the US
-- Shows what percentage of population got Covid in KG
SELECT Location, date, total_cases, population, (total_cases/population)*100 AS percentage_cov
FROM PortfolioProject1..CovidDeath
WHERE Location = 'Kyrgyzstan'
ORDER BY 1,2

-- Shows what percentage of population got Covid in the US
SELECT Location, date, total_cases, population, (total_cases/population)*100 AS percentage_cov
FROM PortfolioProject1..CovidDeath
WHERE Location = 'United States'
ORDER BY 1,2


--4. What country has the highest infection rate compare to population?
SELECT Location, population, MAX(total_cases) AS highest_inf_cnt,  MAX((total_cases/population))*100 AS percentage_cov --percentage_Cov - is the precentage of population infected
FROM PortfolioProject1..CovidDeath
GROUP BY population, location
ORDER BY 4 DESC
-- The highest is Montenegro with 24%  of population contracted Covid
-- The US has 14% 
-- Kyrgyzstan has 3%


--5. Showing top 10 countries with highest death per population
SELECT TOP 10 location, MAX(CONVERT(NUMERIC, total_deaths)) AS total_death_count
    -- here we did convert to NUMERIC because initially data type us NVARCHAR
FROM PortfolioProject1..coviddeath
WHERE continent IS NOT NULL --here we did continent IS NOT NULL, because otherwise we get WORLD and CONTINENTS
GROUP BY location
ORDER BY total_death_count DESC
-- The US has the highest total death count with 768,695 death as of November, 2021
-- Brazil is the second with 612,144 and India is the third with 465,082


-- ANALYSING DATA BY CONTINENT
--6. Which continent has the most people died due to Covid?
SELECT location AS continent, MAX(CONVERT(NUMERIC, total_deaths)) AS total_death_count
    -- here we did convert to NUMERIC because initially data type us NVARCHAR
FROM PortfolioProject1..coviddeath
WHERE continent IS NULL --here we did continent IS NULL, because otherwise we get COUNTRIES
	AND location NOT IN ('World', 'Upper middle income', 'Lower middle income', 'High income', 'Low income', 'European Union', 'International')
GROUP BY location
ORDER BY total_death_count DESC
-- Europe has the highest total death count, must be due to increase death in Russia, totaling 1,374,366
-- Asia is the second, must be due to India with its 465,082 deaths, totaling 1,202,051 for Asia


-- Let's check if my assumption of Russia being the country with the most death in Europe is TRUE or FALSE
SELECT location, MAX(CONVERT(NUMERIC, total_deaths)) AS total_death_count
    -- here we did convert to NUMERIC because initially data type us NVARCHAR
FROM PortfolioProject1..coviddeath
WHERE continent = 'Europe'
GROUP BY location
ORDER BY total_death_count DESC
-- I was right Russia has the highest death rate among European countries with 255,448 deaths
-- The second is UK with 143,999 and Italy is third with 133,034 death


--7. Which continent has the most people vaccinated?
SELECT location AS continent, MAX(CONVERT(NUMERIC, people_vaccinated)) AS people_vaccinated
    -- here we did convert to NUMERIC because initially data type us NVARCHAR
FROM PortfolioProject1..covidvax
WHERE continent IS NULL --here we did continent IS NULL, because otherwise we get COUNTRIES
	AND location NOT IN ('World', 'Upper middle income', 'Lower middle income', 'High income', 'Low income', 'European Union', 'International')
GROUP BY location
ORDER BY 2 DESC
-- Asia is leading in people vaccinated count with 2,830,290,794
-- Europe is the second with 460,645,154 total people vaccinated


--9. Another question arises which country has the most people vaccinated in Asia and it's population? (JOINING TABLES)
SELECT vax.location, vax.date, dea.population, MAX(CONVERT(NUMERIC, vax.people_vaccinated)) OVER (PARTITION BY dea.location) AS people_vaxnated
FROM PortfolioProject1..coviddeath dea
JOIN PortfolioProject1..covidvax vax
	ON dea.location = vax.location
	AND dea.date = vax.date
WHERE dea.continent IS NOT NULL 
ORDER BY 2 DESC
-- China has the most people vaccinated, 1,185,237,000, this is impressive considering total population is 1,444,216,102
-- the article below talks about China implementing vaccine mandates, the answer to why they have so many people vaccinated
-- https://www.latimes.com/opinion/story/2021-09-29/forced-vaccinations-china-ethics-covid 
-- India has 760,532,284 people vaccinated from total population of 1,393,409,033
-- The US has 228,570,531 people vaccinated with total population 332,915,074
-- Kyrgyzstan has only 1,063,125 people vaccinated while total population is 6,628,347


--10. Top 10 countries with the highest number of people vaccinated
SELECT TOP 10 vax.location, MAX(CAST(vax.people_vaccinated AS NUMERIC)) AS people_vaxed
FROM PortfolioProject1..CovidDeath dea
JOIN PortfolioProject1..Covidvax vax
	ON dea.location = vax.location
	AND dea.date = vax.date
WHERE dea.continent IS NOT NULL
GROUP BY vax.location
ORDER BY 2 DESC
-- The highest number of people vaccinated across all countries is China, the second is India, then the US and Brazil


















