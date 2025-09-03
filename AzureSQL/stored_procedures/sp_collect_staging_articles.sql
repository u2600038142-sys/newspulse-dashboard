CREATE   PROCEDURE dbo.sp_collect_staging_articles
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRAN;

    -- 1. Insert semua data dari staging_fact_article
    INSERT INTO dbo.staging_collect_all_fact_article
    SELECT *
    FROM dbo.staging_fact_article;

    -- 2. (Opsional) Kosongkan staging_fact_article setelah dipindah
    TRUNCATE TABLE dbo.staging_fact_article;

    COMMIT;
END