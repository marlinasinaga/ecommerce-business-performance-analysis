--CEK DUPLICATE DAN DATA NULL DI CUSTOMER DETAIL 
WITH checked_data AS (
    SELECT *,
           -- Menghitung jumlah kemunculan customer_id 
           ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY registration_date) as row_num,
           COUNT(*) OVER (PARTITION BY customer_id) as total_duplicate
    FROM customer_detail
)
SELECT * 
FROM checked_data
WHERE 
    -- Kondisi untuk cek data NULL 
    customer_id IS NULL OR 
    registration_date IS NULL OR 
    customer_name IS NULL OR 
    customer_type IS NULL OR 
    dob IS NULL OR 
    province IS NULL OR 
    registration_channel IS NULL 
    
    -- Kondisi untuk cek data DUPLIKAT 
    OR total_duplicate > 1;

----------------------------------------------------------------
--FUNNEL DETAIL 
WITH duplicate_check AS (
    SELECT 
        funnel_id,
        customer_id,
        sku_id,
        funnel_date,
        COUNT(*) AS jumlah
    FROM funnel_detail
    GROUP BY funnel_id, customer_id, sku_id, funnel_date
    HAVING COUNT(*) > 1
)
SELECT * 
FROM funnel_detail
WHERE 
    -- 1. cek data NULL di semua kolom
    funnel_id IS NULL OR 
    channel_source IS NULL OR 
    customer_id IS NULL OR 
    sku_id IS NULL OR 
    funnel_date IS NULL OR 
    status IS NULL OR 
    event IS NULL OR 
    order_id IS NULL 
    
    -- 2. cek duplicate
    OR EXISTS (
        SELECT 1 FROM duplicate_check 
        WHERE funnel_id = funnel_id 
          AND customer_id = customer_id 
          AND sku_id = sku_id 
          AND funnel_date = funnel_date
    );
----------------------------==---------------------
---ORDER DETAIL 
WITH duplicate_check AS (
    SELECT 
        transaction_id,
        order_id,
        order_date,
        customer_id,
        channel_type,
        COUNT(*) AS jumlah
    FROM order_detail
    GROUP BY transaction_id, order_id, order_date, customer_id, channel_type
    HAVING COUNT(*) > 1
)
SELECT * 
FROM order_detail
WHERE 
    -- 1. cek data NULL 
    transaction_id IS NULL OR 
    order_id IS NULL OR 
    order_date IS NULL OR 
    customer_id IS NULL OR 
    channel_type IS NULL OR 
    sku_id IS NULL OR 
    quantity IS NULL OR 
    price IS NULL OR 
    before_discount IS NULL OR 
    discount_item IS NULL OR 
    after_discount IS NULL OR 
    is_gross IS NULL OR 
    is_valid IS NULL OR 
    is_net IS NULL 
    
    -- 2. cek duplicate 
    OR (transaction_id, order_id, order_date, customer_id, channel_type) IN (
        SELECT transaction_id, order_id, order_date, customer_id, channel_type 
        FROM duplicate_check
    );
--------------------------====-------------
--PAYMENT DETAIL 
WITH duplicate_check AS (
    SELECT 
        id,
        payment_method,
        COUNT(*) AS jumlah
    FROM payment_detail
    GROUP BY id, payment_method
    HAVING COUNT(*) > 1
)
SELECT * 
FROM payment_detail
WHERE 
    -- 1. cek data NULL
    id IS NULL OR 
    payment_method IS NULL 
    
    -- 2. cek diplicate 
    OR (id, payment_method) IN (
        SELECT id, payment_method 
        FROM duplicate_check
    );
---------------====-------
--PTODUCT DETAIL 
WITH duplicate_check AS (
    SELECT 
        sku_id,
        category,
        brand,
        product,
        variant,
        sku_name,
        price,
        cogs,
        COUNT(*) AS jumlah
    FROM product_detail
    GROUP BY sku_id, category, brand, product, variant, sku_name, price, cogs
    HAVING COUNT(*) > 1
)
SELECT * 
FROM product_detail
WHERE 
    -- 1. cek data NULL 
    sku_id IS NULL OR 
    category IS NULL OR 
    brand IS NULL OR 
    product IS NULL OR 
    variant IS NULL OR 
    sku_name IS NULL OR 
    price IS NULL OR 
    cogs IS NULL 
    
    -- 2. cek duplicate 
    OR (sku_id, category, brand, product, variant, sku_name, price, cogs) IN (
        SELECT sku_id, category, brand, product, variant, sku_name, price, cogs 
        FROM duplicate_check
    );
------------==-----------------------
--TRANSACTION DETAIL 
WITH duplicate_check AS (
    SELECT 
        transaction_id,
        transaction_date,
        customer_id,
        payment_method,
        before_tax,
        tax,
        after_tax,
        shipping_cost,
        transaction_discount,
        total_paid,
        COUNT(*) AS jumlah
    FROM transaction_detail
    GROUP BY transaction_id, transaction_date, customer_id, payment_method, before_tax, tax, after_tax, shipping_cost, transaction_discount, total_paid
    HAVING COUNT(*) > 1
)
SELECT * 
FROM transaction_detail
WHERE 
    -- 1. cek data NULL
    transaction_id IS NULL OR 
    transaction_date IS NULL OR 
    customer_id IS NULL OR 
    payment_method IS NULL OR 
    before_tax IS NULL OR 
    tax IS NULL OR 
    after_tax IS NULL OR 
    shipping_cost IS NULL OR 
    transaction_discount IS NULL OR 
    total_paid IS NULL 
    
    -- 2. Cek duplicate 
    OR (transaction_id, transaction_date, customer_id, payment_method, before_tax, tax, after_tax, shipping_cost, transaction_discount, total_paid) IN (
        SELECT transaction_id, transaction_date, customer_id, payment_method, before_tax, tax, after_tax, shipping_cost, transaction_discount, total_paid 
        FROM duplicate_check
    );