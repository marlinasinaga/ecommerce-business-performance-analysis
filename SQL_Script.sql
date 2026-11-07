-----Case no 1----
SELECT
    EXTRACT(MONTH FROM transaction_date) AS bulan,
    SUM(total_paid) AS total_sales
FROM transaction_detail
WHERE transaction_date >= DATE '2024-01-01'
  AND transaction_date < DATE '2025-01-01'
GROUP BY EXTRACT(MONTH FROM transaction_date)
ORDER BY bulan;

------Case no 2------
SELECT
    pd.category,
    SUM(od.quantity) FILTER (
        WHERE EXTRACT(YEAR FROM od.order_date) = 2020
    ) AS "2020",
    SUM(od.quantity) FILTER (
        WHERE EXTRACT(YEAR FROM od.order_date) = 2021
    ) AS "2021",
    SUM(od.quantity) FILTER (
        WHERE EXTRACT(YEAR FROM od.order_date) = 2022
    ) AS "2022",
    SUM(od.quantity) FILTER (
        WHERE EXTRACT(YEAR FROM od.order_date) = 2023
    ) AS "2023",
    SUM(od.quantity) FILTER (
        WHERE EXTRACT(YEAR FROM od.order_date) = 2024
    ) AS "2024"
FROM order_detail od
JOIN product_detail pd
    ON od.sku_id = pd.sku_id
WHERE od.is_valid = 1
  AND od.order_date >= DATE '2020-01-01'
  AND od.order_date < DATE '2025-01-01'
GROUP BY pd.category
ORDER BY pd.category;

-----case no 3-------------
--3a
SELECT
    TO_CHAR(order_date, 'YYYY-MM') AS month,
    channel_type,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(after_discount) AS revenue
FROM order_detail
WHERE order_date >= DATE '2024-01-01'
  AND order_date < DATE '2025-01-01'
  AND is_valid = 1
  AND channel_type IN ('Website', 'App Store', 'Offline Store')
GROUP BY
    TO_CHAR(order_date, 'YYYY-MM'),
    channel_type
ORDER BY
    month,
    channel_type;

-----3b--------
WITH monthly_sales AS (
    SELECT
        EXTRACT(MONTH FROM order_date) AS month,
        channel_type,

        SUM(after_discount) FILTER (
            WHERE EXTRACT(YEAR FROM order_date) = 2023
        ) AS revenue_2023,

        SUM(after_discount) FILTER (
            WHERE EXTRACT(YEAR FROM order_date) = 2024
        ) AS revenue_2024

    FROM order_detail
    WHERE order_date >= DATE '2023-01-01'
      AND order_date < DATE '2025-01-01'
      AND is_valid = 1
      AND channel_type IN ('Website', 'App Store', 'Offline Store')

    GROUP BY
        EXTRACT(MONTH FROM order_date),
        channel_type
)

SELECT
    month,
    channel_type,
    COALESCE(revenue_2023, 0) AS revenue_2023,
    COALESCE(revenue_2024, 0) AS revenue_2024,

    ROUND(
        (
            (revenue_2024 - revenue_2023)
            / NULLIF(revenue_2023, 0)
        ) * 100,
        2
    ) AS growth_pct

FROM monthly_sales
ORDER BY
    channel_type,
    month;

----case no 4-----
SELECT
    channel_source,
    COUNT(event) AS total_events,
    COUNT(DISTINCT order_id) AS total_conv_orders,
    ROUND(
        COUNT(DISTINCT order_id)::NUMERIC
        / NULLIF(COUNT(event), 0) * 100,
        2
    ) AS conv_rate
FROM funnel_detail
WHERE funnel_date >= DATE '2024-01-01'
  AND funnel_date < DATE '2025-01-01'
  AND event = 'Organic'
GROUP BY channel_source
ORDER BY conv_rate DESC;

-----case no 5--------
WITH reg AS (
    SELECT
        DATE_TRUNC('month', registration_date)::DATE AS month,
        registration_date,
        registration_channel,
        customer_id
    FROM customer_detail
    WHERE registration_date >= DATE '2024-01-01'
      AND registration_date < DATE '2025-01-01'
),

first_order AS (
    SELECT
        customer_id,
        MIN(order_date)::DATE AS first_order_date
    FROM order_detail
    WHERE is_valid = 1
    GROUP BY customer_id
)

SELECT
    TO_CHAR(r.month, 'Mon YYYY') AS reg_month,
    r.registration_channel,
    COUNT(DISTINCT r.customer_id) AS new_customer,
    ROUND(
        AVG(f.first_order_date - r.registration_date)::NUMERIC,
        2
    ) AS avg_days_to_first_purchase
FROM reg r
JOIN first_order f
    ON r.customer_id = f.customer_id
GROUP BY
    r.month,
    r.registration_channel
ORDER BY
    r.month,
    r.registration_channel;