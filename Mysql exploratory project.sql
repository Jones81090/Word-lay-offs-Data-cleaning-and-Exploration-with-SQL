-- Exploratory Data Analysis
-- Rolling total lay off by month

select company, sum(total_laid_off)
from layoffs_dub2
group by company
order by 2 desc;

select substring(`date`,1,7) as `month`, sum(total_laid_off)
from layoffs_dub2
group by substring(`date`,1,7);

with rolling_total as 
(select substring(`date`,1,7) as `month`, sum(total_laid_off) as total_off
from layoffs_dub2
where substring(`date`,1,7) is not null
group by substring(`date`,1,7)
order by 1 asc 
)

select `month`, total_off, sum(total_off) over(order by `month`)
from rolling_total;

-- Highest lay off by year and comapny

select company,  Year(`date`) , sum(total_laid_off)
from layoffs_dub2
group by company, Year(`date`);

-- Creating a CTE

WITH Company_rank as 
(select company,  Year(`date`) as `year` , sum(total_laid_off) as lay_off
from layoffs_dub2
group by company, Year(`date`)
),

 
com_top as
(
select company, `year`, lay_off, dense_rank() over(partition by `year` order by lay_off desc) as ranking
from company_rank
where `year` is not null)

-- Created 2 CTE's to get the top 5 companies with the most lay_off for each year.

select *
from com_top
where ranking <= 5;

-- Companies that shut down due to complete layoffs by year.

select company, Year(`date`), percentage_laid_off
from layoffs_dub2
where percentage_laid_off = 1
order by `date`;

-- Trend Analysis
-- How has the total number of layoffs changed over time?

select Year(`date`), sum(total_laid_off)
from layoffs_dub2
where Year(`date`) is not null
group by Year(`date`)
order by 1;

-- Geographical analysis 
-- locations that experienced the highest number of layoffs

select location, sum(total_laid_off)
from layoffs_dub2
where total_laid_off is not null
group by location
order by 2 desc;

-- San francisco experienced the highest number of lay offs due to it  being the home of big tech company

select *, row_number() over()
from layoffs_dub2