-- dim_source
CREATE TABLE dbo.dim_source(
  source_id INT IDENTITY(1,1) PRIMARY KEY,
  name NVARCHAR(200) NOT NULL,
  country NVARCHAR(50) NULL,
  lang NVARCHAR(20) NULL,
  homepage NVARCHAR(300) NULL,
  allows_scrape_bit BIT NOT NULL DEFAULT 1
);