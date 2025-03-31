CREATE temporary TABLE  Salary_over_65k
SELECT *
FROM employee_salary
WHERE salary >= 65000;

SELECT *
FROM Salary_over_65k;

SELECT *
FROM layoffs;

CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT *
FROM layoffs_staging;

SELECT *
FROM layoffs_staging;

SELECT *, count(*)
FROM layoffs_staging
GROUP BY company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions
HAVING count(*) >1;

SELECT *
FROM layoffs_staging
where company = 'yahoo';



DELETE FROM layoffs_staging
WHERE (company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions) NOT IN
	(SELECT *
FROM layoffs_staging
GROUP BY company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions
HAVING count(*) =1);

CREATE TABLE layoffs_staging2 AS
SELECT DISTINCT company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions
FROM layoffs_staging;

SELECT *
FROM layoffs_staging2;

SELECT *, count(*)
FROM layoffs_staging2
GROUP BY company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions
HAVING count(*) >2;

SELECT *
FROM layoffs_staging2
where company = 'yahoo';

DROP layoffs_staging
ALTER layoffs_staging2 RENAME TO layoffs_staging;

SELECT *
FROM layoffs_staging2;

SELECT distinct company
FROM layoffs_staging2;

SELECT company, TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company =  TRIM(company);

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging2
SET industry =  'crypto'
WHERE industry LIKE 'crypto%';

SELECT distinct country
FROM layoffs_staging2
order by country;

UPDATE layoffs_staging2
SET country = 'united states'
WHERE country LIKE 'united states%';

SELECT Distinct country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY country;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'united states%';


SELECT `date`
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = str_to_date(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

SELECT *
FROM layoffs_staging2;


SELECT *
FROM layoffs_staging2
WHERE company = 'Airbnb';

UPDATE layoffs_staging2
SET industry = 'Travel'
WHERE company = 'Airbnb' AND industry = '';

SELECT *
FROM layoffs_staging2;

DELETE 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT max(total_laid_off), max(percentage_laid_off)
FROM layoffs_staging2;

SELECT * 
FROM layoffs_staging2
where percentage_laid_off = 1
order by total_laid_off DESC;

SELECT company, sum(total_laid_off) 
FROM layoffs_staging2
group by company
order by sum(total_laid_off) DESC;

SELECT min(date), max(date)
FROM layoffs_staging2;


SELECT industry, sum(total_laid_off) 
FROM layoffs_staging2
group by industry
order by sum(total_laid_off) DESC;

SELECT country, sum(total_laid_off) 
FROM layoffs_staging2
group by country
order by sum(total_laid_off) DESC;

SELECT date, sum(total_laid_off) 
FROM layoffs_staging2
group by date
order by sum(total_laid_off) DESC;

SELECT year(date), sum(total_laid_off) 
FROM layoffs_staging2
group by year(date)
order by sum(total_laid_off) DESC;


WITH rolling_total AS
(SELECT substring(`date`, 1,7) AS `Month`, SUM(total_laid_off) as Total_off
FROM layoffs_staging2
WHERE substring(`date`, 1,7) IS NOT NULL
GROUP BY `Month`
Order by `Month`)
SELECT `Month`, Total_off, SUM(Total_off) OVER(ORDER BY `Month`) AS Rolling_total
FROM rolling_total;



