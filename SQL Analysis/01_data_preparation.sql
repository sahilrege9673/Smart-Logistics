-- SETUP

CREATE DATABASE smart_logistics_db;

-- Connect to smart_logistics_db before running the code below.

DROP TABLE IF EXISTS smart_logistics;

CREATE TABLE smart_logistics (
    timestamp TIMESTAMP,
    asset_id VARCHAR(50),
    latitude NUMERIC(8,4),
    longitude NUMERIC(9,4),
    inventory_level INTEGER,
    shipment_status VARCHAR(50),
    temperature NUMERIC(5,1),
    humidity NUMERIC(5,1),
    traffic_status VARCHAR(50),
    waiting_time INTEGER,
    user_transaction_amount NUMERIC(10,2),
    user_purchase_frequency INTEGER,
    logistics_delay_reason VARCHAR(50),
    asset_utilization NUMERIC(5,1),
    demand_forecast INTEGER,
    logistics_delay INTEGER
);

SELECT *
FROM smart_logistics
LIMIT 10;

SELECT COUNT(*) AS total_records
FROM smart_logistics;


-- DATA CLEANING

-- Check NULL values before cleaning.

SELECT
    COUNT(*) FILTER (WHERE timestamp IS NULL) AS missing_timestamp,
    COUNT(*) FILTER (WHERE asset_id IS NULL) AS missing_asset_id,
    COUNT(*) FILTER (WHERE latitude IS NULL) AS missing_latitude,
    COUNT(*) FILTER (WHERE longitude IS NULL) AS missing_longitude,
    COUNT(*) FILTER (WHERE inventory_level IS NULL) AS missing_inventory_level,
    COUNT(*) FILTER (WHERE shipment_status IS NULL) AS missing_shipment_status,
    COUNT(*) FILTER (WHERE temperature IS NULL) AS missing_temperature,
    COUNT(*) FILTER (WHERE humidity IS NULL) AS missing_humidity,
    COUNT(*) FILTER (WHERE traffic_status IS NULL) AS missing_traffic_status,
    COUNT(*) FILTER (WHERE waiting_time IS NULL) AS missing_waiting_time,
    COUNT(*) FILTER (
        WHERE user_transaction_amount IS NULL
    ) AS missing_transaction_amount,
    COUNT(*) FILTER (
        WHERE user_purchase_frequency IS NULL
    ) AS missing_purchase_frequency,
    COUNT(*) FILTER (
        WHERE logistics_delay_reason IS NULL
    ) AS missing_delay_reason,
    COUNT(*) FILTER (
        WHERE asset_utilization IS NULL
    ) AS missing_asset_utilization,
    COUNT(*) FILTER (
        WHERE demand_forecast IS NULL
    ) AS missing_demand_forecast,
    COUNT(*) FILTER (
        WHERE logistics_delay IS NULL
    ) AS missing_logistics_delay
FROM smart_logistics;


-- Check blank values.

SELECT
    COUNT(*) FILTER (
        WHERE TRIM(asset_id) = ''
    ) AS blank_asset_id,

    COUNT(*) FILTER (
        WHERE TRIM(shipment_status) = ''
    ) AS blank_shipment_status,

    COUNT(*) FILTER (
        WHERE TRIM(traffic_status) = ''
    ) AS blank_traffic_status,

    COUNT(*) FILTER (
        WHERE TRIM(logistics_delay_reason) = ''
    ) AS blank_delay_reason

FROM smart_logistics;


-- Convert blank text values to NULL.

UPDATE smart_logistics
SET
    asset_id = NULLIF(TRIM(asset_id), ''),
    shipment_status = NULLIF(TRIM(shipment_status), ''),
    traffic_status = NULLIF(TRIM(traffic_status), ''),
    logistics_delay_reason = NULLIF(
        TRIM(logistics_delay_reason),
        ''
    );


-- Standardize text values.

UPDATE smart_logistics
SET
    shipment_status = INITCAP(
        LOWER(shipment_status)
    ),
    traffic_status = INITCAP(
        LOWER(traffic_status)
    ),
    logistics_delay_reason = INITCAP(
        LOWER(logistics_delay_reason)
    );


-- Fix multi-word text formatting.

UPDATE smart_logistics
SET logistics_delay_reason = 'Mechanical Failure'
WHERE LOWER(logistics_delay_reason) = 'mechanical failure';


-- Check NULL values after cleaning.

SELECT
    COUNT(*) FILTER (
        WHERE timestamp IS NULL
    ) AS missing_timestamp,

    COUNT(*) FILTER (
        WHERE asset_id IS NULL
    ) AS missing_asset_id,

    COUNT(*) FILTER (
        WHERE shipment_status IS NULL
    ) AS missing_shipment_status,

    COUNT(*) FILTER (
        WHERE traffic_status IS NULL
    ) AS missing_traffic_status,

    COUNT(*) FILTER (
        WHERE logistics_delay_reason IS NULL
    ) AS missing_delay_reason,

    COUNT(*) FILTER (
        WHERE logistics_delay IS NULL
    ) AS missing_logistics_delay

FROM smart_logistics;


-- Check duplicate records.

SELECT
    timestamp,
    asset_id,
    latitude,
    longitude,
    inventory_level,
    shipment_status,
    COUNT(*) AS duplicate_count

FROM smart_logistics

GROUP BY
    timestamp,
    asset_id,
    latitude,
    longitude,
    inventory_level,
    shipment_status

HAVING COUNT(*) > 1;


-- Check duplicate timestamps.

SELECT
    timestamp,
    COUNT(*) AS duplicate_count

FROM smart_logistics

GROUP BY timestamp

HAVING COUNT(*) > 1;


-- Check inventory level outliers.

WITH inventory_stats AS (
    SELECT
        PERCENTILE_CONT(0.25)
        WITHIN GROUP (
            ORDER BY inventory_level
        ) AS q1,

        PERCENTILE_CONT(0.75)
        WITHIN GROUP (
            ORDER BY inventory_level
        ) AS q3

    FROM smart_logistics
)

SELECT
    inventory_level

FROM smart_logistics

CROSS JOIN inventory_stats

WHERE inventory_level <
    q1 - 1.5 * (q3 - q1)

OR inventory_level >
    q3 + 1.5 * (q3 - q1);


-- Check waiting time outliers.

WITH waiting_stats AS (
    SELECT
        PERCENTILE_CONT(0.25)
        WITHIN GROUP (
            ORDER BY waiting_time
        ) AS q1,

        PERCENTILE_CONT(0.75)
        WITHIN GROUP (
            ORDER BY waiting_time
        ) AS q3

    FROM smart_logistics
)

SELECT
    waiting_time

FROM smart_logistics

CROSS JOIN waiting_stats

WHERE waiting_time <
    q1 - 1.5 * (q3 - q1)

OR waiting_time >
    q3 + 1.5 * (q3 - q1);


-- Check transaction amount outliers.

WITH transaction_stats AS (
    SELECT
        PERCENTILE_CONT(0.25)
        WITHIN GROUP (
            ORDER BY user_transaction_amount
        ) AS q1,

        PERCENTILE_CONT(0.75)
        WITHIN GROUP (
            ORDER BY user_transaction_amount
        ) AS q3

    FROM smart_logistics
)

SELECT
    user_transaction_amount

FROM smart_logistics

CROSS JOIN transaction_stats

WHERE user_transaction_amount <
    q1 - 1.5 * (q3 - q1)

OR user_transaction_amount >
    q3 + 1.5 * (q3 - q1);


-- DATA VALIDATION

-- Check remaining NULL values.

SELECT
    COUNT(*) FILTER (
        WHERE timestamp IS NULL
    ) AS missing_timestamp,

    COUNT(*) FILTER (
        WHERE asset_id IS NULL
    ) AS missing_asset_id,

    COUNT(*) FILTER (
        WHERE shipment_status IS NULL
    ) AS missing_shipment_status,

    COUNT(*) FILTER (
        WHERE traffic_status IS NULL
    ) AS missing_traffic_status,

    COUNT(*) FILTER (
        WHERE logistics_delay IS NULL
    ) AS missing_logistics_delay

FROM smart_logistics;


-- Check logistics delay values.

SELECT *
FROM smart_logistics
WHERE logistics_delay NOT IN (0, 1)
OR logistics_delay IS NULL;


-- Check shipment status values.

SELECT DISTINCT shipment_status
FROM smart_logistics;


-- Check traffic status values.

SELECT DISTINCT traffic_status
FROM smart_logistics;


-- Check delay reason values.

SELECT DISTINCT logistics_delay_reason
FROM smart_logistics;


-- Check invalid geographical coordinates.

SELECT *
FROM smart_logistics
WHERE latitude NOT BETWEEN -90 AND 90
OR longitude NOT BETWEEN -180 AND 180;


-- Check invalid numeric values.

SELECT *
FROM smart_logistics
WHERE inventory_level < 0
OR waiting_time < 0
OR user_transaction_amount < 0
OR user_purchase_frequency < 0
OR asset_utilization < 0
OR asset_utilization > 100
OR humidity < 0
OR humidity > 100
OR demand_forecast < 0;


-- Final dataset check.

SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT asset_id) AS total_assets,
    MIN(timestamp) AS earliest_timestamp,
    MAX(timestamp) AS latest_timestamp
FROM smart_logistics;