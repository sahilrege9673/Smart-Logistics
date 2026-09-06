-- BUSINESS QUESTIONS


-- 1. What are the overall business KPIs?

SELECT
    COUNT(*) AS total_trips,

    COUNT(DISTINCT asset_id)
        AS total_assets,

    ROUND(
        SUM(user_transaction_amount),
        2
    ) AS total_revenue,

    ROUND(
        AVG(user_transaction_amount),
        2
    ) AS average_transaction_amount,

    SUM(logistics_delay)
        AS total_delays,

    ROUND(
        100.0 * SUM(logistics_delay) / COUNT(*),
        2
    ) AS delay_percentage,

    ROUND(
        AVG(waiting_time),
        2
    ) AS average_waiting_time,

    ROUND(
        AVG(asset_utilization),
        2
    ) AS average_asset_utilization

FROM smart_logistics;


-- 2. Is revenue increasing or decreasing over time?

SELECT
    DATE_TRUNC(
        'month',
        timestamp
    )::DATE AS month,

    ROUND(
        SUM(user_transaction_amount),
        2
    ) AS total_revenue,

    ROUND(
        AVG(user_transaction_amount),
        2
    ) AS average_transaction_amount

FROM smart_logistics

GROUP BY
    DATE_TRUNC(
        'month',
        timestamp
    )

ORDER BY month;


-- 3. How are shipments distributed by shipment status?

SELECT
    shipment_status,

    COUNT(*) AS total_shipments,

    ROUND(
        100.0 * COUNT(*) /
        SUM(COUNT(*)) OVER (),
        2
    ) AS percentage

FROM smart_logistics

GROUP BY shipment_status

ORDER BY total_shipments DESC;


-- 4. Which assets have the highest utilization?

SELECT
    asset_id,

    COUNT(*) AS total_trips,

    ROUND(
        AVG(asset_utilization),
        2
    ) AS average_utilization

FROM smart_logistics

GROUP BY asset_id

ORDER BY average_utilization DESC;


-- 5. Which assets experience the most delays?

SELECT
    asset_id,

    COUNT(*) AS total_trips,

    SUM(logistics_delay)
        AS total_delays,

    ROUND(
        100.0 * SUM(logistics_delay)
        / COUNT(*),
        2
    ) AS delay_percentage

FROM smart_logistics

GROUP BY asset_id

ORDER BY total_delays DESC;


-- 6. How does traffic affect logistics delays?

SELECT
    traffic_status,

    COUNT(*) AS total_trips,

    SUM(logistics_delay)
        AS total_delays,

    ROUND(
        100.0 * SUM(logistics_delay)
        / COUNT(*),
        2
    ) AS delay_percentage,

    ROUND(
        AVG(waiting_time),
        2
    ) AS average_waiting_time

FROM smart_logistics

GROUP BY traffic_status

ORDER BY delay_percentage DESC;


-- 7. What are the main reasons for logistics delays?

SELECT
    logistics_delay_reason,

    COUNT(*) AS total_records,

    SUM(logistics_delay)
        AS total_delays,

    ROUND(
        AVG(waiting_time),
        2
    ) AS average_waiting_time

FROM smart_logistics

WHERE logistics_delay_reason IS NOT NULL

GROUP BY logistics_delay_reason

ORDER BY total_delays DESC;


-- 8. Does waiting time increase the probability of delays?

SELECT
    CASE
        WHEN waiting_time < 15
            THEN 'Less than 15 minutes'

        WHEN waiting_time BETWEEN 15 AND 30
            THEN '15 to 30 minutes'

        WHEN waiting_time BETWEEN 31 AND 45
            THEN '31 to 45 minutes'

        ELSE 'More than 45 minutes'
    END AS waiting_time_group,

    COUNT(*) AS total_trips,

    SUM(logistics_delay)
        AS total_delays,

    ROUND(
        100.0 * SUM(logistics_delay)
        / COUNT(*),
        2
    ) AS delay_percentage

FROM smart_logistics

GROUP BY
    CASE
        WHEN waiting_time < 15
            THEN 'Less than 15 minutes'

        WHEN waiting_time BETWEEN 15 AND 30
            THEN '15 to 30 minutes'

        WHEN waiting_time BETWEEN 31 AND 45
            THEN '31 to 45 minutes'

        ELSE 'More than 45 minutes'
    END

ORDER BY delay_percentage DESC;


-- 9. Are there inventory shortages?

SELECT
    CASE
        WHEN demand_forecast > inventory_level
            THEN 'Restock Needed'
        ELSE 'Sufficient Stock'
    END AS inventory_status,

    COUNT(*) AS total_records,

    ROUND(
        AVG(inventory_level),
        2
    ) AS average_inventory,

    ROUND(
        AVG(demand_forecast),
        2
    ) AS average_demand

FROM smart_logistics

GROUP BY
    CASE
        WHEN demand_forecast > inventory_level
            THEN 'Restock Needed'
        ELSE 'Sufficient Stock'
    END;


-- 10. Which assets have the largest inventory shortages?

SELECT
    asset_id,

    ROUND(
        AVG(inventory_level),
        2
    ) AS average_inventory,

    ROUND(
        AVG(demand_forecast),
        2
    ) AS average_demand,

    ROUND(
        AVG(
            demand_forecast - inventory_level
        ),
        2
    ) AS inventory_gap

FROM smart_logistics

GROUP BY asset_id

ORDER BY inventory_gap DESC;


-- 11. Does high asset utilization lead to more delays?

SELECT
    CASE
        WHEN asset_utilization >= 85
            THEN 'High Utilization'

        WHEN asset_utilization >= 70
            THEN 'Medium Utilization'

        ELSE 'Low Utilization'
    END AS utilization_group,

    COUNT(*) AS total_records,

    SUM(logistics_delay)
        AS total_delays,

    ROUND(
        100.0 * SUM(logistics_delay)
        / COUNT(*),
        2
    ) AS delay_percentage

FROM smart_logistics

GROUP BY
    CASE
        WHEN asset_utilization >= 85
            THEN 'High Utilization'

        WHEN asset_utilization >= 70
            THEN 'Medium Utilization'

        ELSE 'Low Utilization'
    END

ORDER BY delay_percentage DESC;


-- 12. Which shipment status has the highest waiting time?

SELECT
    shipment_status,

    ROUND(
        AVG(waiting_time),
        2
    ) AS average_waiting_time,

    MAX(waiting_time)
        AS maximum_waiting_time,

    MIN(waiting_time)
        AS minimum_waiting_time

FROM smart_logistics

GROUP BY shipment_status

ORDER BY average_waiting_time DESC;


-- 13. Which traffic condition creates the highest waiting time?

SELECT
    traffic_status,

    COUNT(*) AS total_trips,

    ROUND(
        AVG(waiting_time),
        2
    ) AS average_waiting_time,

    MAX(waiting_time)
        AS maximum_waiting_time

FROM smart_logistics

GROUP BY traffic_status

ORDER BY average_waiting_time DESC;


-- 14. How do delays change over time?

SELECT
    DATE_TRUNC(
        'month',
        timestamp
    )::DATE AS month,

    COUNT(*) AS total_trips,

    SUM(logistics_delay)
        AS total_delays,

    ROUND(
        100.0 * SUM(logistics_delay)
        / COUNT(*),
        2
    ) AS delay_percentage

FROM smart_logistics

GROUP BY
    DATE_TRUNC(
        'month',
        timestamp
    )

ORDER BY month;


-- 15. Which hours experience the most delays?

SELECT
    EXTRACT(
        HOUR FROM timestamp
    ) AS hour,

    COUNT(*) AS total_trips,

    SUM(logistics_delay)
        AS total_delays,

    ROUND(
        100.0 * SUM(logistics_delay)
        / COUNT(*),
        2
    ) AS delay_percentage

FROM smart_logistics

GROUP BY
    EXTRACT(
        HOUR FROM timestamp
    )

ORDER BY delay_percentage DESC;


-- 16. Do day and night operations perform differently?

SELECT
    CASE
        WHEN EXTRACT(
            HOUR FROM timestamp
        ) BETWEEN 6 AND 17
            THEN 'Day Shift'
        ELSE 'Night Shift'
    END AS shift,

    COUNT(*) AS total_trips,

    SUM(logistics_delay)
        AS total_delays,

    ROUND(
        100.0 * SUM(logistics_delay)
        / COUNT(*),
        2
    ) AS delay_percentage,

    ROUND(
        AVG(waiting_time),
        2
    ) AS average_waiting_time

FROM smart_logistics

GROUP BY
    CASE
        WHEN EXTRACT(
            HOUR FROM timestamp
        ) BETWEEN 6 AND 17
            THEN 'Day Shift'
        ELSE 'Night Shift'
    END

ORDER BY delay_percentage DESC;


-- 17. Which assets generate the highest revenue?

SELECT
    asset_id,

    ROUND(
        SUM(user_transaction_amount),
        2
    ) AS total_revenue,

    ROUND(
        AVG(user_transaction_amount),
        2
    ) AS average_transaction_amount

FROM smart_logistics

GROUP BY asset_id

ORDER BY total_revenue DESC;


-- 18. Do frequent customers generate more revenue?

SELECT
    CASE
        WHEN user_purchase_frequency > 5
            THEN 'High Frequency'
        ELSE 'Regular Frequency'
    END AS customer_segment,

    COUNT(*) AS total_records,

    ROUND(
        AVG(user_purchase_frequency),
        2
    ) AS average_purchase_frequency,

    ROUND(
        AVG(user_transaction_amount),
        2
    ) AS average_transaction_amount,

    ROUND(
        SUM(user_transaction_amount),
        2
    ) AS total_revenue

FROM smart_logistics

GROUP BY
    CASE
        WHEN user_purchase_frequency > 5
            THEN 'High Frequency'
        ELSE 'Regular Frequency'
    END

ORDER BY total_revenue DESC;


-- 19. Which locations experience the most delays?

SELECT
    latitude,

    longitude,

    COUNT(*) AS total_records,

    SUM(logistics_delay)
        AS total_delays

FROM smart_logistics

GROUP BY
    latitude,
    longitude

HAVING SUM(logistics_delay) > 0

ORDER BY total_delays DESC;


-- 20. What is the relationship between traffic and delay reasons?

SELECT
    traffic_status,

    logistics_delay_reason,

    COUNT(*) AS total_records,

    SUM(logistics_delay)
        AS total_delays

FROM smart_logistics

WHERE logistics_delay_reason IS NOT NULL

GROUP BY
    traffic_status,
    logistics_delay_reason

ORDER BY total_delays DESC;


-- 21. What is the average temperature and humidity during delays?

SELECT
    CASE
        WHEN logistics_delay = 1
            THEN 'Delayed'
        ELSE 'Not Delayed'
    END AS delivery_condition,

    ROUND(
        AVG(temperature),
        2
    ) AS average_temperature,

    ROUND(
        AVG(humidity),
        2
    ) AS average_humidity,

    COUNT(*) AS total_records

FROM smart_logistics

GROUP BY
    CASE
        WHEN logistics_delay = 1
            THEN 'Delayed'
        ELSE 'Not Delayed'
    END;


-- 22. Which assets perform better than the overall average?

SELECT
    asset_id,

    ROUND(
        AVG(asset_utilization),
        2
    ) AS average_utilization

FROM smart_logistics

GROUP BY asset_id

HAVING AVG(asset_utilization) >
(
    SELECT
        AVG(asset_utilization)
    FROM smart_logistics
)

ORDER BY average_utilization DESC;


-- POWER BI VIEWS


CREATE OR REPLACE VIEW vw_logistics_overview AS

SELECT
    timestamp,

    timestamp::DATE AS trip_date,

    EXTRACT(
        YEAR FROM timestamp
    ) AS trip_year,

    EXTRACT(
        MONTH FROM timestamp
    ) AS trip_month,

    EXTRACT(
        HOUR FROM timestamp
    ) AS trip_hour,

    asset_id,
    latitude,
    longitude,
    inventory_level,
    demand_forecast,

    demand_forecast - inventory_level
        AS inventory_gap,

    shipment_status,
    temperature,
    humidity,
    traffic_status,
    waiting_time,
    user_transaction_amount,
    user_purchase_frequency,
    logistics_delay_reason,
    logistics_delay,
    asset_utilization

FROM smart_logistics;


CREATE OR REPLACE VIEW vw_asset_performance AS

SELECT
    asset_id,

    COUNT(*) AS total_trips,

    ROUND(
        AVG(asset_utilization),
        2
    ) AS average_utilization,

    SUM(logistics_delay)
        AS total_delays,

    ROUND(
        100.0 * SUM(logistics_delay)
        / COUNT(*),
        2
    ) AS delay_percentage,

    ROUND(
        AVG(waiting_time),
        2
    ) AS average_waiting_time,

    ROUND(
        SUM(user_transaction_amount),
        2
    ) AS total_revenue

FROM smart_logistics

GROUP BY asset_id;


CREATE OR REPLACE VIEW vw_monthly_trends AS

SELECT
    DATE_TRUNC(
        'month',
        timestamp
    )::DATE AS month,

    COUNT(*) AS total_trips,

    SUM(logistics_delay)
        AS total_delays,

    ROUND(
        100.0 * SUM(logistics_delay)
        / COUNT(*),
        2
    ) AS delay_percentage,

    ROUND(
        SUM(user_transaction_amount),
        2
    ) AS total_revenue,

    ROUND(
        AVG(waiting_time),
        2
    ) AS average_waiting_time

FROM smart_logistics

GROUP BY
    DATE_TRUNC(
        'month',
        timestamp
    );


CREATE OR REPLACE VIEW vw_delivery_performance AS

SELECT
    shipment_status,

    traffic_status,

    COUNT(*) AS total_trips,

    SUM(logistics_delay)
        AS total_delays,

    ROUND(
        100.0 * SUM(logistics_delay)
        / COUNT(*),
        2
    ) AS delay_percentage,

    ROUND(
        AVG(waiting_time),
        2
    ) AS average_waiting_time

FROM smart_logistics

GROUP BY
    shipment_status,
    traffic_status;


CREATE OR REPLACE VIEW vw_inventory_analysis AS

SELECT
    asset_id,

    CASE
        WHEN demand_forecast > inventory_level
            THEN 'Restock Needed'
        ELSE 'Sufficient Stock'
    END AS inventory_status,

    COUNT(*) AS total_records,

    ROUND(
        AVG(inventory_level),
        2
    ) AS average_inventory,

    ROUND(
        AVG(demand_forecast),
        2
    ) AS average_demand,

    ROUND(
        AVG(
            demand_forecast - inventory_level
        ),
        2
    ) AS average_inventory_gap

FROM smart_logistics

GROUP BY
    asset_id,

    CASE
        WHEN demand_forecast > inventory_level
            THEN 'Restock Needed'
        ELSE 'Sufficient Stock'
    END;


CREATE OR REPLACE VIEW vw_traffic_analysis AS

SELECT
    traffic_status,

    COUNT(*) AS total_trips,

    SUM(logistics_delay)
        AS total_delays,

    ROUND(
        100.0 * SUM(logistics_delay)
        / COUNT(*),
        2
    ) AS delay_percentage,

    ROUND(
        AVG(waiting_time),
        2
    ) AS average_waiting_time

FROM smart_logistics

GROUP BY traffic_status;