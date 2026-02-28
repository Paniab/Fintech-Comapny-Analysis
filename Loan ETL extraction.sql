CREATE TABLE loans (
    id BIGINT,
    year INTEGER,
    issue_d DATE,
    final_d INTEGER,
    emp_length_int NUMERIC,
    home_ownership VARCHAR(50),
    home_ownership_cat INTEGER,
    income_category VARCHAR(50),
    annual_inc NUMERIC,
    income_cat INTEGER,
    loan_amount NUMERIC,
    term VARCHAR(20),
    term_cat INTEGER,
    application_type VARCHAR(50),
    application_type_cat INTEGER,
    purpose VARCHAR(100),
    purpose_cat INTEGER,
    interest_payments VARCHAR(50),
    interest_payment_cat INTEGER,
    loan_condition VARCHAR(50),
    loan_condition_cat INTEGER,
    interest_rate NUMERIC,
    grade VARCHAR(5),
    grade_cat INTEGER,
    dti NUMERIC,
    total_pymnt NUMERIC,
    total_rec_prncp NUMERIC,
    recoveries NUMERIC,
    installment NUMERIC,
    region VARCHAR(50)
);
select * from loans;

select count(*) from loans;

select distinct year from loans order by year;

select distinct home_ownership from loans;

select distinct loan_condition from loans;

select distinct purpose from loans;

/*Identify missing or null values in critical 
columns (loan_amount, interest_rate, annual_inc, 
loan_condition, purpose).*/

select count(*) as missing from loans 
where loan_amount is null;

select count(*) as missing2 from loans where
interest_rate is null;

select count(*) as missing3 from loans where 
annual_inc is null;

select count(*) as missing4 from loans where
loan_condition is null;

select count(*) as missing5 from loans where 
purpose is null;

/* Standardize categorical values — for example, 
convert all home_ownership entries to uppercase 
for consistency.*/

select distinct home_ownership from loans;

/* Create a new column profitability that measures 
the difference between total_pymnt and loan_amount.*/

alter table loans add column profitability numeric;

update loans
set profitability = total_pymnt - loan_amount;

select loan_amount, total_pymnt, profitability
from loans;

/*5. **Create a new column `risk_flag`** based on 
the loan condition:
- If `loan_condition` = ‘Bad Loan’ → risk_flag = 1
- Else → risk_flag = 0 */

alter table loans add column risk_flag integer;

update loans 
set risk_flag = 
case when loan_condition = 'Bad Loan' then 1
else 0 end;

select * from loans;

alter table loans drop column porfitability;

select * from loans;

/*Create a new table loans_cleaned containing only cleaned and 
transformed records (no nulls in key fields).*/

create table loans_cleaned as
select * from loans 
where loan_amount is not null
and interest_rate is not null
and annual_inc is not null
and loan_condition is not null
and purpose is not null;

select count(*) from loans_cleaned;

select * from loans_cleaned;

--Extract loan term as numeric value (e.g., convert ‘36 months’ → 36).

alter table loans_cleaned 
add column term_numeric integer;

update loans_cleaned
set term_numeric = replace(term, ' months', '')::integer;

select term, term_numeric from loans_cleaned limit 10;

select * from loans_cleaned;

/* Add a new column income_to_loan_ratio calculated as the 
borrower’s annual income divided by the loan amount.*/

alter table loans_cleaned
add column income_to_loan_ratio numeric;

update loans_cleaned 
set income_to_loan_ratio = annual_inc / loan_amount;

select annual_inc, loan_amount, income_to_loan_ratio from loans_cleaned
limit 10;

/* Add a default_rate_indicator column that computes the ratio of 
defaulted loans (Bad Loan) to total loans within the same year.*/

alter table loans_cleaned
add column default_rate_indicator numeric;

update loans_cleaned lc
set default_rate_indicator = sub.bad_count::numeric / sub.total_count
from (
    select year,
           count(*) as total_count,
           sum(case when loan_condition = 'Bad Loan' then 1 else 0 end) 
		   as bad_count
    from loans_cleaned
    group by year
) sub
where lc.year = sub.year;

select year, loan_condition, default_rate_indicator
from loans_cleaned
limit 10;

select * from loans_cleaned;






















