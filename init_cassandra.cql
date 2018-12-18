CREATE KEYSPACE givemesomecredit WITH replication = {'class': 'SimpleStrategy', 'replication_factor' : 1};

CREATE TABLE givemesomecredit.credits( id INT, SeriousDlqin2yrs INT, RevolvingUtilizationOfUnsecuredLines FLOAT, age INT, NumberOfTime30_59DaysPastDueNotWorse INT, DebtRatio FLOAT, MonthlyIncome INT, NumberOfOpenCreditLinesAndLoans INT, NumberOfTimes90DaysLate INT, NumberRealEstateLoansOrLines INT, NumberOfTime60_89DaysPastDueNotWorse INT, NumberOfDependents INT, PRIMARY KEY (id) );


