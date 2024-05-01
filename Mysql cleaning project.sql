-- Data cleaning

Select *
from layoffs;

-- Removing Duplicates

Create table layoffs_dub
like layoffs;

Insert layoffs_dub
select *
from layoffs;

Select *
from layoffs_dub;

-- Identifying rows with duplicates by adding a row number and partitioning by each column 

select *,
row_number () over (PARTITION BY COMPANY, LOCATION, INDUSTRY, TOTAL_LAID_OFF, PERCENTAGE_LAID_OFF, `DATE`, STAGE, COUNTRY, FUNDS_RAISED_MILLIONS) AS ROW_NUM
FROM LAYOFFS_DUB;

WITH Dublicate_cte as
(select *,
row_number () over (PARTITION BY COMPANY, LOCATION, INDUSTRY, TOTAL_LAID_OFF, PERCENTAGE_LAID_OFF, `DATE`, STAGE, COUNTRY, FUNDS_RAISED_MILLIONS) AS ROW_NUM
FROM LAYOFFS_DUB
)
select *
from Dublicate_cte
where row_num > 1;

-- Creating a new table because i cant delete fom a CTE

CREATE TABLE `layoffs_dub2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT layoffs_dub2
select *,
row_number () over (PARTITION BY COMPANY, LOCATION, INDUSTRY, TOTAL_LAID_OFF, PERCENTAGE_LAID_OFF, `DATE`, STAGE, COUNTRY, FUNDS_RAISED_MILLIONS) AS ROW_NUM
FROM LAYOFFS_DUB;

delete 
from layoffs_dub2
where row_num > 1;


select * 
from layoffs_dub2
where row_num > 1;

-- Standardiing the Data 

select company, trim(company)
from layoffs_dub2
order by 1;

update layoffs_dub2
set company = trim(company);

select distinct industry
from layoffs_dub2
order by 1;

select *
from layoffs_dub2
where industry like 'crypto%';

update layoffs_dub2
set industry = 'crypto'
where industry like 'crypto%';

select distinct industry
from layoffs_dub2;

select distinct country
from layoffs_dub2
order by 1;

select `date`
from layoffs_dub2;

update layoffs_dub2
set country = 'United States'
where country like 'United Sta%';

select `date`, str_to_date(`date`, '%m/%d/%Y') New_date
from layoffs_dub2;

update layoffs_dub2
set `date` = str_to_date(`date`, '%m/%d/%Y');


-- Missing data was imputed where feasible

update layoffs_dub2
set industry = null
where industry = '';

select t1.industry, t2.industry
from layoffs_dub2 as t1
join layoffs_dub2 as t2
	on t1.company = t2.company
where t1.industry is null
and t2.industry is not null;

update layoffs_dub2 as t1
join layoffs_dub2 as t2
	on t1.company = t2.company
set t1.industry = t2.industry
where t1.industry is null
and t2.industry is not null;

select industry, company
from layoffs_dub2
where industry is null;


select *
from layoffs_dub2
where total_laid_off is null
and percentage_laid_off is null;

Delete 
from layoffs_dub2
where total_laid_off is null
and percentage_laid_off is null;

select *
from layoffs_dub2;

alter table layoffs_dub2
drop column row_num;

-- End

