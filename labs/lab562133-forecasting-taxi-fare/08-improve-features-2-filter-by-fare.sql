#standardSQL
SELECT
  COUNT(fare_amount) AS num_fares,
  MIN(fare_amount) AS low_fare,
  MAX(fare_amount) AS high_fare,
  AVG(fare_amount) AS avg_fare,
  STDDEV(fare_amount) AS stddev
FROM
  `nyc-tlc.yellow.trips`
WHERE TRUE
  AND trip_distance > 0
  AND fare_amount BETWEEN 6 AND 200
