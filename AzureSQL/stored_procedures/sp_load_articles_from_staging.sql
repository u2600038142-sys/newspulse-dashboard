CREATE   PROCEDURE dwh.sp_load_articles_from_staging
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRAN;

/* 1) Truncate dwh.dim_date */
TRUNCATE TABLE dwh.dim_date;
TRUNCATE TABLE dwh.dim_source;
TRUNCATE TABLE dwh.fact_article

    /* 1) Pastikan semua tanggal dari staging (berdasarkan load_ts) ada di dim_date */
    ;WITH d AS (
        SELECT DISTINCT CAST(s.load_ts AS date) AS full_date
        FROM dbo.staging_collect_all_fact_article s
        WHERE s.load_ts IS NOT NULL
    )
    INSERT INTO dwh.dim_date (date_key, full_date, [year], [month], month_name, [day], weekday_name)
    SELECT
        CONVERT(int, FORMAT(d.full_date, 'yyyyMMdd'))      AS date_key,
        d.full_date,
        YEAR(d.full_date)                                  AS [year],
        MONTH(d.full_date)                                 AS [month],
        DATENAME(MONTH, d.full_date)                       AS month_name,
        DAY(d.full_date)                                   AS [day],
        DATENAME(WEEKDAY, d.full_date)                     AS weekday_name
    FROM d
    LEFT JOIN dwh.dim_date dd
           ON dd.full_date = d.full_date
    WHERE dd.full_date IS NULL;

    /* 2) Upsert dim_source dari seluruh staging */

	INSERT INTO dwh.dim_source (source_name, source_url)
    SELECT
        source_name,
        Url
    FROM dbo.staging_collect_all_fact_article s;

    /* 3) Insert ke fact_article
          - date_key = yyyymmdd dari CAST(s.load_ts AS date)
          - load_ts di fact: ambil dari staging; fallback ke SYSUTCDATETIME() jika NULL
          - anti-duplikat pada (date_key, source_id, title)
    */
    INSERT INTO dwh.fact_article (date_key, source_id, title, load_ts)
    SELECT
        CONVERT(int, FORMAT(CAST(s.load_ts AS date), 'yyyyMMdd')) AS date_key,
        dsrc.source_id,
        s.title,
        ISNULL(s.load_ts, SYSUTCDATETIME())                       AS load_ts
    FROM dbo.staging_collect_all_fact_article s
    JOIN dwh.dim_source dsrc
      ON dsrc.source_url = s.Url
    ;

    COMMIT;
END