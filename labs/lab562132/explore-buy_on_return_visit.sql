#standardSQL
WITH
  all_visitor_stats AS (
    SELECT
      fullvisitorid,
      IF(COUNTIF(totals.transactions > 0 AND totals.newVisits IS NULL) > 0, 1, 0) AS will_by_on_return_visit
  )
SELECT
  COUNT(DISTINCT fullvisitorid) AS total_visitors,
  will_by_on_return_visit
FROM all_visitor_stats
GROUP BY will_by_on_return_visit;
