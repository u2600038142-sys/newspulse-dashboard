-- fact_article (staging & final)
CREATE TABLE dbo.fact_article(
  article_id BIGINT IDENTITY(1,1) PRIMARY KEY,
  source_id INT NOT NULL FOREIGN KEY REFERENCES dbo.dim_source(source_id),
  date_key INT NOT NULL FOREIGN KEY REFERENCES dbo.dim_time(date_key),
  published_at DATETIME2 NOT NULL,
  canonical_url NVARCHAR(500) NOT NULL,
  title NVARCHAR(500) NULL,
  summary NVARCHAR(MAX) NULL,
  lang NVARCHAR(20) NULL,
  sentiment TINYINT NULL,
  content_hash CHAR(64) NOT NULL,
  topics NVARCHAR(400) NULL, -- pipe/comma separated for MVP
  CONSTRAINT UQ_fact_article UNIQUE (canonical_url, content_hash)
);