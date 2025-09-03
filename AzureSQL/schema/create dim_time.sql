-- dim_time
CREATE TABLE dbo.dim_time(
  date_key INT PRIMARY KEY, -- yyyymmdd
  [date] DATE NOT NULL,
  [year] INT, [month] TINYINT, [day] TINYINT,
  [week] TINYINT, [dow] TINYINT, is_month_end BIT
);