-- array type
#standardSQL
SELECT
['raspberry', 'blackberry', 'strawberry', 'cherry', 1234567] AS
fruit_array;

-- array elements must be of the same type
#standardSQL
SELECT
['raspberry', 'blackberry', 'strawberry', 'cherry', 1234567] AS
fruit_array;

#standardSQL
SELECT person, fruit_array, total_cost FROM `data-to-insights.advanced.fruit_store`;

SELECT
  fullVisitorId,
  date,
  v2ProductName,
  pageTitle
  FROM `data-to-insights.ecommerce.all_sessions`
WHERE visitId = 1501570398
ORDER BY date;

SELECT
  fullVisitorId,
  date,
  ARRAY_AGG(v2ProductName) AS products_viewed,
  ARRAY_AGG(pageTitle) AS pages_viewed
  FROM `data-to-insights.ecommerce.all_sessions`
WHERE visitId = 1501570398
GROUP BY fullVIsitorId, date
ORDER BY date;

SELECT
  fullVisitorId,
  date,
  ARRAY_AGG(v2ProductName) AS products_viewed,
  ARRAY_LENGTH(ARRAY_AGG(v2ProductName)) AS num_products_viewed,
  ARRAY_AGG(pageTitle) AS pages_viewed,
  ARRAY_LENGTH(ARRAY_AGG(pageTitle)) AS num_pages_viewed
  FROM `data-to-insights.ecommerce.all_sessions`
WHERE visitId = 1501570398
GROUP BY fullVIsitorId, date
ORDER BY date;

SELECT
  fullVisitorId,
  date,
  ARRAY_AGG(DISTINCT v2ProductName) AS products_viewed,
  ARRAY_LENGTH(ARRAY_AGG(DISTINCT v2ProductName)) AS distinct_products_viewed,
  ARRAY_AGG(DISTINCT pageTitle) AS pages_viewed,
  ARRAY_LENGTH(ARRAY_AGG(DISTINCT pageTitle)) AS distinct_pages_viewed
  FROM `data-to-insights.ecommerce.all_sessions`
WHERE visitId = 1501570398
GROUP BY fullVIsitorId, date
ORDER BY date;

SELECT
  *
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170801`
WHERE visitId = 1501570398;

SELECT
  visitorId,
  h.page.pageTitle
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170801`,
UNNEST(hits) AS h
WHERE visitId = 1501570398
LIMIT 10;

-- STRUCT（構造体）型
-- メインテーブルに事前に結合された別テーブルみたいなイメージ
-- ・1つ以上のフィールドを含められる
-- ・フィールドのデータ型は同じである必要はない
-- ・固有のエイリアスを持つ

-- STRUCT 型って説明では言っといて、実際は RECORD 型なのなんで？、RECORD ∈ STRUCT ということ？

SELECT
  visitorId,
  totals.*,
  device.*
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170801`
WHERE visitId = 1501570398
LIMIT 10;

#standardSQL
SELECT STRUCT("Rudisha" as name, 23.4 as split) as runner;

#standardSQL
SELECT STRUCT("Rudisha" as name, [23.4, 26.3, 26.4, 26.1] as splits) as runner;

#standardSQL
SELECT * FROM racing.race_results;

#standardSQL
SELECT race, participants.name
FROM racing.race_results
CROSS JOIN
race_results.participants;

-- `,` は暗黙的に CROSS JOIN を表す
-- race, participants.name は相関クロス結合となり、デカルト積のようにはならない
#standardSQL
SELECT race, participants.name
FROM racing.race_results AS r, r.participants;

#standardSQL
SELECT COUNT(participants.name) AS racer_count
FROM racing.race_results AS r, r.participants;

#standardSQL
SELECT COUNT(p.name) AS racer_count
FROM racing.race_results AS r, UNNEST(r.participants) AS p;

#standardSQL
SELECT
  p.name,
  SUM(split_times) as total_race_time
FROM
  racing.race_results AS r,
  r.participants AS p,
  p.splits AS split_times
WHERE
  p.name LIKE 'R%'
GROUP BY
  p.name
ORDER BY
  total_race_time;

#standardSQL
SELECT
  p.name,
  split_time
FROM
  racing.race_results AS r,
  UNNEST(r.participants) AS p,
  UNNEST(p.splits) AS split_time
WHERE
  split_time = 23.2;
