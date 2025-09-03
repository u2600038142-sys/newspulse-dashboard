CREATE   PROCEDURE dbo.sp_deduplicate_staging_collect_all
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRAN;

    ;WITH cte AS (
        SELECT *,
               ROW_NUMBER() OVER (
                   PARTITION BY Url
                   ORDER BY (SELECT NULL)
               ) AS rn
        FROM dbo.staging_collect_all_fact_article
    )
    DELETE FROM cte WHERE rn > 1;

    COMMIT;
END