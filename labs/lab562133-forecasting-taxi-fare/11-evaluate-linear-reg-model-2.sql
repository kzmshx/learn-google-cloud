#standardSQL
SELECT
  SQRT(mean_squared_error) AS rmse
FROM
  ML.EVALUATE(MODEL taxi.taxifare_model_2, (
    WITH
      params AS (SELECT 1 AS TRAIN, 2 AS EVAL),
      daynames AS (SELECT ['Sun', 'Mon', 'Tues', 'Wed', 'Thurs', 'Fri', 'Sat'] AS daysofweek),
      taxitrips AS (
        SELECT
          (tolls_amount + fare_amount) AS total_fare,
          daysofweek[ORDINAL(EXTRACT(DAYOFWEEK FROM pickup_datetime))] AS dayofweek,
          EXTRACT(HOUR FROM pickup_datetime) AS hourofday,
          SQRT(POW((pickup_longitude - dropoff_longitude),2) + POW(( pickup_latitude - dropoff_latitude), 2)) as dist,
          SQRT(POW((pickup_longitude - dropoff_longitude),2)) as longitude,
          SQRT(POW((pickup_latitude - dropoff_latitude), 2)) as latitude,
          passenger_count AS passengers
        FROM
          `nyc-tlc.yellow.trips`, daynames, params
        WHERE TRUE
          AND trip_distance > 0
          AND fare_amount BETWEEN 6 and 200
          AND pickup_longitude > -75 AND pickup_longitude < -73
          AND pickup_latitude > 40 AND pickup_latitude < 42
          AND dropoff_longitude > -75 AND dropoff_longitude < -73
          AND dropoff_latitude > 40 AND dropoff_latitude < 42
          AND MOD(ABS(FARM_FINGERPRINT(CAST(pickup_datetime AS STRING))),1000) = params.TRAIN
      )
    SELECT *
    FROM taxitrips
  ))
