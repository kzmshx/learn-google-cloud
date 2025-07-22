-- Vertex AI モデルへの外部接続を追加
-- 外部接続のサービスアカウントに Vertex AI User ロールを追加

-- Cloud Storage のデータ
-- images/ -> 分析対象の画像データ
-- customer_reviews.csv -> 分析対象のテキストデータ

LOAD DATA OVERWRITE
  gemini_demo.customer_reviews ( customer_review_id INT64,
    customer_id INT64,
    location_id INT64,
    review_datetime DATETIME,
    review_text STRING,
    social_media_source STRING,
    social_media_handle STRING )
FROM FILES ( format = 'CSV',
    uris = ['gs://qwiklabs-gcp-01-3c667a9940ea-bucket/gsp1246/customer_reviews.csv'] );

SELECT
  *
FROM
  gemini_demo.customer_reviews
LIMIT
  10;

CREATE OR REPLACE EXTERNAL TABLE
  `gemini_demo.review_images`
WITH CONNECTION `us.gemini_conn` OPTIONS( object_metadata = 'SIMPLE',
    uris = ['gs://qwiklabs-gcp-01-3c667a9940ea-bucket/gsp1246/images/*'] );

CREATE OR REPLACE MODEL
  `gemini_demo.gemini_pro` REMOTE
WITH CONNECTION `us.gemini_conn` OPTIONS (endpoint = 'gemini-2.0-flash');

CREATE OR REPLACE MODEL
  `gemini_demo.gemini_flash` REMOTE
WITH CONNECTION `us.gemini_conn` OPTIONS (endpoint = 'gemini-2.0-flash-lite');

CREATE OR REPLACE TABLE
  `gemini_demo.customer_reviews_keywords` AS (
  SELECT
    ml_generate_text_llm_result,
    social_media_source,
    review_text,
    customer_id,
    location_id,
    review_datetime
  FROM
    ML.GENERATE_TEXT( MODEL `gemini_demo.gemini_pro`,
      (
      SELECT
        social_media_source,
        customer_id,
        location_id,
        review_text,
        review_datetime,
        CONCAT( 'For each review, provide keywords from the review. Answer in JSON format with one key: keywords. Keywords should be a list.', review_text) AS prompt
      FROM
        `gemini_demo.customer_reviews` ),
      STRUCT( 0.2 AS temperature,
        TRUE AS flatten_json_output)));

SELECT
  *
FROM
  `gemini_demo.customer_reviews_keywords`;

CREATE OR REPLACE TABLE
  `gemini_demo.customer_reviews_analysis` AS (
  SELECT
    ml_generate_text_llm_result,
    social_media_source,
    review_text,
    customer_id,
    location_id,
    review_datetime
  FROM
    ML.GENERATE_TEXT( MODEL `gemini_demo.gemini_pro`,
      (
      SELECT
        social_media_source,
        customer_id,
        location_id,
        review_text,
        review_datetime,
        CONCAT( 'Classify the sentiment of the following text as positive or negative.', review_text, "In your response don't include the sentiment explanation. Remove all extraneous information from your response, it should be a boolean response either positive or negative.") AS prompt
      FROM
        `gemini_demo.customer_reviews` ),
      STRUCT( 0.2 AS temperature,
        TRUE AS flatten_json_output)));

SELECT * FROM `gemini_demo.customer_reviews_analysis`
ORDER BY review_datetime;

SELECT
  *
FROM
  `gemini_demo.customer_reviews_analysis`
ORDER BY
  review_datetime;

CREATE OR REPLACE VIEW
  gemini_demo.cleaned_data_view AS
SELECT
  REPLACE(REPLACE(REPLACE(LOWER(ml_generate_text_llm_result), '.', ''), ' ', ''), '\n', '') AS sentiment,
  REGEXP_REPLACE( REGEXP_REPLACE( REGEXP_REPLACE(social_media_source, r'Google(\+|\sReviews|\sLocal|\sMy\sBusiness|\sreviews|\sMaps)?', 'Google'), 'YELP', 'Yelp' ), r'SocialMedia1?', 'Social Media' ) AS social_media_source,
  review_text,
  customer_id,
  location_id,
  review_datetime
FROM
  `gemini_demo.customer_reviews_analysis`;

SELECT
  sentiment,
  COUNT(*) AS count
FROM
  `gemini_demo.cleaned_data_view`
WHERE
  sentiment IN ('positive',
    'negative')
GROUP BY
  sentiment;

SELECT
  sentiment,
  social_media_source,
  COUNT(*) AS count
FROM
  `gemini_demo.cleaned_data_view`
WHERE
  sentiment IN ('positive')
  OR sentiment IN ('negative')
GROUP BY
  sentiment,
  social_media_source
ORDER BY
  sentiment,
  count;
