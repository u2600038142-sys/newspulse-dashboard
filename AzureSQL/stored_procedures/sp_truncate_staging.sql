-- Versi TRUNCATE SEMUA
CREATE   PROCEDURE dbo.sp_truncate_staging
AS
BEGIN
  SET NOCOUNT ON;
  TRUNCATE TABLE dbo.staging_fact_article;
END