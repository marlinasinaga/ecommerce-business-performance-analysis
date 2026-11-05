# ecommerce-business-performance-analysis
E-commerce Business Performance Analysis using SQL | MySkill Fullstack Data Analysis Final Project


## Dataset Overview

This project uses a simulated Tokopedia e-commerce dataset provided by MySkill as part of the Fullstack Data Analysis Final Project.

The dataset consists of six tables containing information about orders, products, customers, payments, transactions, and marketing funnels.

| Table Name | Description |
|---|---|
| `order_detail` | Order and product-level transaction information |
| `product_detail` | Product attributes, categories, brands, and cost of goods sold (COGS) |
| `customer_detail` | Customer profile and registration information |
| `payment_detail` | Payment method information |
| `funnel_detail` | Customer funnel events and conversion information |
| `transaction_detail` | Transaction-level financial information |

## Table Schema

### 1. order_detail

| Column | Description |
|---|---|
| transaction_id | Unique transaction identifier |
| order_id | Unique order identifier |
| order_date | Order date |
| customer_id | Unique customer identifier |
| channel_type | Sales channel (web, app/play store, offline) |
| sku_id | Unique product identifier |
| quantity | Number of products purchased |
| price | Product unit price |
| before_discount | Total product price before discount |
| discount_item | Total product discount |
| after_discount | Total product price after discount |
| is_gross | Indicates unpaid orders |
| is_valid | Indicates paid orders |
| is_net | Indicates completed transactions (1) or return/cancel (0) |

### 2. product_detail

| Column | Description |
|---|---|
| sku_id | Unique product identifier |
| category | Product category |
| brand | Product brand |
| product | Product name |
| variant | Product variant |
| sku_name | Product SKU name |
| price | Product price |
| cogs | Cost of Goods Sold |

### 3. customer_detail

| Column | Description |
|---|---|
| customer_id | Unique customer identifier |
| registration_date | Customer registration date |
| customer_name | Customer name |
| customer_type | Customer classification |
| dob | Date of birth |
| province | Customer province |
| registration_channel | Customer registration channel |

### 4. payment_detail

| Column | Description |
|---|---|
| id | Payment method identifier |
| payment_method | Payment method name |

### 5. funnel_detail

| Column | Description |
|---|---|
| funnel_id | Unique funnel event identifier |
| sku_id | Product identifier |
| channel_source | Funnel channel source |
| funnel_date | Funnel event date |
| status | Funnel status |
| customer_id | Customer identifier |
| event | Customer funnel event |
| order_id | Order identifier |

### 6. transaction_detail

| Column | Description |
|---|---|
| transaction_id | Unique transaction identifier |
| transaction_date | Transaction date |
| customer_id | Customer identifier |
| payment_method | Payment method used |
| before_tax | Transaction amount before tax |
| tax | Tax amount |
| after_tax | Transaction amount after tax |
| shipping_cost | Shipping cost |
| transaction_discount | Transaction-level discount |
| total_paid | Total amount paid |

## Dataset Access

The complete dataset is hosted on Google Drive due to file size limitations.

[Download Dataset – Google Drive](https://drive.google.com/drive/folders/1-6FNBiOsJpfUNIcAhcErJdefj6YQnQdV?usp=drive_link)

