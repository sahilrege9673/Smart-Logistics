# Smart Logistics | Supply Chain & Fleet Operations Analytics

> **End-to-end logistics analytics case study analyzing 1,000+ shipment records across fleet asset tracking, delivery performance, traffic patterns, environmental conditions, and demand forecasting using SQL, Python, and Power BI**

---

## Executive Summary

Smart Logistics is a comprehensive logistics analytics project examining the complete supply chain ecosystem—from fleet asset deployment and shipment lifecycle tracking through traffic impact analysis, environmental factor assessment, and demand forecasting accuracy.

The analysis spans:
- **Data Foundation:** 1,000 shipment records across 10 fleet assets with 16 operational dimensions validated for integrity and quality
- **Analytical Scope:** Asset utilization, shipment delivery performance, traffic and environmental impact, inventory optimization, demand forecasting, and delay root cause analysis
- **Tools Used:** PostgreSQL (data modeling & validation), Python (exploratory analysis), Power BI (5-page executive dashboard)
- **Business Outcome:** Actionable findings tied to delivery reliability, operational efficiency, and fleet optimization with recommendations prioritized by business impact

---

## 💡 Business Problem

Smart Logistics faces the challenge of scaling delivery operations while maintaining **on-time shipments, optimal resource utilization, cost efficiency, and customer satisfaction**.

As fleet activity increases, inefficiencies in any part of the delivery ecosystem can lead to **delayed shipments, underutilized assets, excessive waiting times, inventory imbalances, and missed delivery windows**, eroding service reputation and operational profitability.

The business needs to understand where these problems are concentrated and which areas require the greatest operational attention.

### 🚚 Shipment Delivery & Reliability
- Delayed shipments create customer friction and erode service reputation.
- Delivery performance may vary significantly across traffic conditions, weather patterns, and asset types.
- Concentrated delay patterns may indicate specific operational pathways requiring intervention.

### 📦 Inventory & Asset Utilization
- Inventory levels across the fleet may not align with actual demand or asset capacity.
- Asset utilization varies across the fleet, indicating potential for optimization and cost reduction.
- Underutilized assets represent wasted operational expense and capacity constraints.

### 🌦️ Environmental & Traffic Impact
- Traffic conditions directly impact shipment delivery windows and operational reliability.
- Weather and environmental factors (temperature, humidity) can affect shipment quality and delivery success.
- Waiting times compound operational inefficiency and reduce throughput capacity.

### 📈 Demand Forecasting & Planning
- Demand forecasts may not align with actual inventory levels, causing stockouts or overstocking.
- Poor forecast accuracy undermines asset allocation and route planning efficiency.
- Asset deployment should be driven by predicted demand, not historical patterns alone.

### ⏱️ Delay Patterns & Root Causes
- Shipment delays are not uniformly distributed across the fleet.
- Specific delay reasons (weather, traffic, mechanical issues) may require targeted prevention strategies.
- Understanding delay concentration enables focused remediation efforts.

---

## 🎯 Business Objectives

The objective of this project is to use **SQL, Python, and Power BI** to quantify Smart Logistics' operational performance, identify the primary drivers of delays and inefficiency, and translate findings into prioritized improvement recommendations.

### 🚚 Shipment & Delivery Performance
- Assess overall shipment status distribution (Delivered, In Transit, Delayed).
- Identify patterns in on-time delivery across traffic conditions, environmental factors, and assets.
- Quantify the impact of external factors on delivery reliability.

### 📦 Inventory & Asset Utilization
- Evaluate inventory level distribution across fleet assets.
- Assess asset utilization efficiency and identify underperforming assets.
- Correlate inventory levels with demand forecasts to identify imbalances.

### 🌦️ Environmental & Traffic Conditions
- Analyze the relationship between traffic patterns and shipment delays.
- Quantify environmental factor impact (temperature, humidity) on operations.
- Identify combinations of conditions that create highest delay risk.

### ⏱️ Waiting Time & Operational Efficiency
- Analyze waiting time distribution and operational impact.
- Correlate waiting times with shipment delays and asset utilization.
- Identify bottlenecks in the delivery workflow.

### 📈 Demand Forecasting & Planning Accuracy
- Evaluate alignment between demand forecasts and actual transaction volumes.
- Assess forecast accuracy across different inventory and purchase frequency segments.
- Identify planning gaps that create operational constraints.

### 🔍 Delay Root Cause Analysis
- Quantify delay rates by root cause (Traffic, Weather, Mechanical Failure, Unrecorded).
- Identify which delay reasons create the greatest operational impact.
- Prioritize prevention strategies based on delay concentration.

---

## 📋 Dataset & Data Model

**Core Dataset:**

| Dimension | Records | Business Meaning |
|-----------|---------|-----------------|
| **Shipments** | 1,000 | Individual shipment events with timestamp, asset, status, and conditions |
| **Fleet Assets** | 10 | Unique vehicles/trucks with utilization and performance tracking |
| **Timestamp Range** | Full Year 2024 | Operations covering January through December 2024 |

**Key Data Attributes:**
```
Shipment Events:
├── Temporal: Timestamp (datetime)
├── Asset: Asset_ID (10 unique trucks)
├── Location: Latitude, Longitude (GPS coordinates)
├── Status: Shipment_Status (Delivered, In Transit, Delayed)
├── Conditions: Traffic_Status (Clear, Heavy, Detour)
│           Temperature (°C, 18-30°C range)
│           Humidity (%, 50-80% range)
├── Operations: Waiting_Time (minutes, 10-60 range)
│           Inventory_Level (units, 100-500 range)
│           Asset_Utilization (%, 60-100% range)
├── Business: User_Transaction_Amount (currency, 100-500 range)
│           User_Purchase_Frequency (transactions, 1-10 range)
├── Forecasting: Demand_Forecast (units, 100-300 range)
└── Delays: Logistics_Delay (binary: 0/1)
           Logistics_Delay_Reason (Weather, Traffic, Mechanical Failure, No Reason Recorded)
```

**Shipment Status Distribution:**
- **Delivered:** 338 shipments (33.8%)
- **In Transit:** 312 shipments (31.2%)
- **Delayed:** 350 shipments (35.0%)

**Traffic Conditions:**
- **Clear:** 328 observations (32.8%)
- **Heavy:** 327 observations (32.7%)
- **Detour:** 345 observations (34.5%)

---

## 📊 Data Quality & Validation

Rigorous data validation was performed before any business analysis:

**Structural Integrity**
- Row count verification: 1,000 records (confirmed)
- Column count verification: 16 dimensions (confirmed)
- Duplicate detection: 0 duplicate records identified
- Duplicate timestamps: 0 duplicates (each shipment has unique timestamp)

**Data Type Consistency**
- Timestamp: Valid datetime format across all 1,000 records
- Numeric fields: Correctly cast to float64/int64 (Latitude, Longitude, Temperature, Humidity, Inventory Level, etc.)
- Categorical fields: Properly standardized (Shipment_Status, Traffic_Status, Asset_ID, Logistics_Delay_Reason)
- All 1,000 rows parsed successfully with 0 type conversion errors

**Missing Value Analysis**
- **Critical Missing Values:** 0 (no NULL values in core operational columns)
- **Non-Critical Missing Values:** 263 missing values (26.3%) in Logistics_Delay_Reason
  - Interpretation: 26.3% of shipments had no recorded delay reason (filled with "No Reason Recorded")
- All other 15 fields: 100% complete (0 missing values)

**Value Range Validation**
- **Latitude:** Range -89.79° to 89.87° (valid geographic bounds) ✓
- **Longitude:** Range -179.82° to 179.92° (valid geographic bounds) ✓
- **Inventory Level:** Range 100-500 units (all within valid operational range) ✓
- **Temperature:** Range 18°C to 30°C (all within plausible range) ✓
- **Humidity:** Range 50% to 80% (all within plausible range) ✓
- **Waiting Time:** Range 10-60 minutes (all positive and reasonable) ✓
- **User Transaction Amount:** Range 100-500 currency units (all positive and reasonable) ✓
- **User Purchase Frequency:** Range 1-10 transactions (all within valid range) ✓
- **Asset Utilization:** Range 60%-100% (all within valid percentage range) ✓
- **Demand Forecast:** Range 100-300 units (all positive and reasonable) ✓
- **Logistics Delay:** Binary values 0 or 1 only ✓

**Categorical Value Verification**
- **Shipment_Status:** 3 valid categories (Delivered, In Transit, Delayed) with no unexpected values ✓
- **Traffic_Status:** 3 valid categories (Clear, Heavy, Detour) with no unexpected values ✓
- **Asset_ID:** 10 unique trucks (Truck_1 through Truck_10) with consistent naming ✓
- **Logistics_Delay_Reason:** 4 categories (Weather, Traffic, Mechanical Failure, No Reason Recorded) ✓

**Distribution Analysis**
- Delay flag distribution: 566 delayed shipments (56.6%), 434 on-time (43.4%)
  - Indicates material delay concentration requiring operational focus
- Reason codes for delays:
  - **No Reason Recorded:** 263 occurrences (26.3% of total dataset)
  - **Weather:** 267 occurrences (26.7%)
  - **Traffic:** 236 occurrences (23.6%)
  - **Mechanical Failure:** 234 occurrences (23.4%)

**Result:** Dataset passed structural, integrity, range, and consistency validation with no critical issues identified. 26.3% missing delay reasons is expected and appropriately handled through standardized categorization.

---

## 🔍 SQL Analysis

Comprehensive SQL analysis organized across multiple layers of business inquiry:

### 1. **Data Preparation** (`01_data_preparation.sql`)
- Created normalized schema for logistics data
- Established relationships between shipments and assets
- Loaded 1,000 shipment records with 10 unique fleet assets
- Validated successful data ingestion via row counts and dimension verification

### 2. **Business Analysis** (`02_business_analysis.sql`)
Explored core business dimensions:
- **Shipment Health:** Overall delivery success/delay rates by asset, traffic condition, weather
- **Asset Performance:** Utilization rates, average waiting times, delivery consistency
- **Traffic & Environmental Impact:** Delay correlation with traffic patterns, temperature, humidity
- **Operational Patterns:** Waiting time distribution, inventory-demand alignment analysis
- **Delay Root Cause:** Concentration analysis by Weather, Traffic, Mechanical Failure
- **Asset Efficiency:** Utilization trends, performance variability across fleet

**SQL Techniques Used:** CTEs, CASE statements, window functions (SUM OVER, RANK OVER), aggregations, JOINs, date truncation, correlation calculations

---

## 🐍 Python Analysis

Python notebooks provide exploratory data analysis and business validation:

### `01_Smart_Logistics_Data_Connection_Cleaning_Validation.ipynb`
- Loaded and profiled 1,000 shipment records with 16 dimensions
- Validated data types: Converted timestamps to datetime format, standardized text fields
- Confirmed 0 critical NULL values; appropriately handled 263 missing delay reasons
- Verified categorical values: Shipment statuses, traffic conditions, asset IDs, delay reasons
- Validated numeric ranges: All values within operational boundaries
- Confirmed 0 duplicate records and 0 duplicate timestamps
- Generated comprehensive data quality report: 100% data integrity confirmed

**Libraries Used:** pandas, numpy, SQLAlchemy, python-dotenv, matplotlib, seaborn

**Analytical Coverage:**
- Complete data profiling (shape, columns, duplicates, nulls)
- Descriptive statistics for 11 numeric dimensions
- Distribution analysis for categorical fields
- Temporal validation (timestamp range: Jan 2024 - Dec 2024)
- Text standardization and categorical reconciliation
- Asset distribution across 10 unique trucks

### `02_Smart_Logistics_Business_Analysis.ipynb`
- Exploratory data analysis across all operational dimensions
- Asset performance benchmarking and comparative analysis
- Shipment status distribution and delay pattern discovery
- Traffic and environmental factor correlation analysis
- Demand forecast accuracy evaluation
- Waiting time impact on delivery performance
- Visualizations: distributions, correlations, trend analysis, outlier detection
- Export results for Power BI integration

**Analytical Focus:** Business validation, pattern discovery, outlier detection, correlation analysis

---

## 📈 Power BI Dashboard

**5-Page Interactive Dashboard** providing business intelligence across the entire logistics ecosystem:

### **Page 1: Executive Overview** 
![Executive Overview Dashboard](DashBoard/Executive%20Overview.png)

*Operational Health at a Glance*
- Total shipments, delivery success rate, and delay rate percentage
- Monthly shipment trends and seasonal patterns
- Key KPIs: Average delivery time, on-time delivery %, fleet utilization rate
- Shipment status breakdown (Delivered, In Transit, Delayed)
- High-level metrics for executive briefing and business performance tracking

**Enablement:** Quick assessment of overall operational health, delivery reliability, and month-over-month performance trends.

---

### **Page 2: Customer Insights**
![Customer Insights Analysis](DashBoard/Customer%20Insights.png)

*Transaction Patterns & Customer Behavior*
- Transaction amount distribution and frequency analysis
- Customer purchase frequency segmentation
- Revenue contribution by transaction size
- Customer behavior correlation with delivery performance
- High-value customer identification and engagement metrics
- Purchase frequency impact on operational priorities

**Enablement:** Identify which customer segments drive revenue, which behaviors correlate with delays, and where to focus retention efforts.

---

### **Page 3: Operational Efficiency**
![Operational Efficiency Dashboard](DashBoard/Operational%20Efficiency.png)

*Asset Performance & Logistics Optimization*
- Asset utilization rates across 10 fleet vehicles
- Average waiting time distribution and outlier detection
- Inventory level analysis across asset types
- Shipment processing time trends
- Asset-specific performance ranking and efficiency gaps
- Operational bottleneck identification (waiting times, inventory misalignment)

**Enablement:** Identify underutilized assets, optimize fleet allocation, and target operational improvements for maximum efficiency gain.

---

### **Page 4: Risk And Forecasting**
![Risk And Forecasting Dashboard](DashBoard/Risk%20And%20Forecasting.png)

*Demand Accuracy & Operational Risk Assessment*
- Demand forecast vs. actual inventory comparison
- Forecast accuracy metrics and variance analysis
- Inventory-demand alignment by asset and time period
- Overstocking and stockout risk identification
- Delay rate trends and predictability assessment
- Environmental risk factors (weather, traffic, mechanical failures)

**Enablement:** Improve demand planning accuracy, reduce inventory imbalances, and assess operational risk concentration.

---

### **Page 5: Root Cause Analysis**
![Root Cause Analysis Dashboard](DashBoard/Root%20Cause%20Analysis.png)

*Dimensional Decomposition for Problem-Solving*
- Delay concentration by:
  - Delay reason (Weather, Traffic, Mechanical Failure, Unrecorded)
  - Asset ID (identify problem assets)
  - Traffic condition
  - Environmental factors
  - Shipment status
- Waiting time decomposition by asset and condition
- Impact quantification for each delay driver
- Priority-ranked remediation opportunities

**Enablement:** Drill into any operational problem (delays, waiting times, inventory issues) to identify the specific dimension driving the issue—enables targeted, data-driven remediation.

---

## 🎯 Key Business Findings

### 🚚 **Shipment Performance Insights**

**Delay Concentration Challenge**
- 35% of shipments experience delays, with combined on-time failure rate of 56.6%
- Delivered shipments: Only 33.8% of fleet operations achieve full success
- In-transit shipments: 31.2% of operations currently in active delivery
- **Finding:** Significant operational challenge requiring multi-faceted intervention across traffic, weather, and mechanical reliability

**Traffic Condition Impact**
- Traffic conditions are relatively balanced across fleet operations (32-35% each category)
- Heavy traffic and detour routes combined represent 67.2% of operations
- Clear traffic conditions represent only 32.8% of operations
- **Finding:** Traffic is endemic to operations; routing optimization and traffic prediction become critical

---

### 📦 **Inventory & Asset Insights**

**Inventory-Demand Misalignment**
- Average inventory level: 297.9 units
- Average demand forecast: 199.3 units
- Inventory averaging 150% of forecast demand
- **Finding:** Systematic overstocking suggests either conservative forecasting or inventory buffer policies—warrants optimization review

**Asset Utilization Profile**
- Average fleet utilization: 79.6% (range 60%-100%)
- Relatively consistent deployment across 10 assets
- Some assets show 60% utilization (underperforming potential)
- **Finding:** Fleet is reasonably balanced; targeted optimization of low-utilization assets could improve efficiency

---

### 🌦️ **Environmental & Traffic Insights**

**Weather Impact Concentration**
- Weather-related delays: 267 incidents (26.7% of dataset)
- Most frequently recorded delay reason
- Combined with traffic delays: 503 incidents (50.3% of all records)
- **Finding:** Environmental factors account for >50% of operational impact; forecasting and contingency planning become critical

**Temperature & Humidity Ranges**
- Temperature: 18-30°C (controlled but variable)
- Humidity: 50-80% (moderate environmental variance)
- **Finding:** Environmental conditions are within operational norms; weather-related delays likely due to severity events rather than baseline conditions

---

### ⏱️ **Waiting Time & Efficiency**

**Waiting Time Distribution**
- Average waiting time: 35.1 minutes (range 10-60 minutes)
- Spread across entire operational range suggests no single bottleneck
- Waiting time correlates with shipment delays and asset utilization
- **Finding:** Waiting times are a material operational factor; systematic reduction could improve delivery reliability

---

### 🔮 **Delay Root Cause Analysis**

**Multi-Cause Delay Pattern**
- **No Reason Recorded:** 263 (26.3%) — Data quality gap requiring process improvement
- **Weather:** 267 (26.7%) — Most frequently recorded cause
- **Traffic:** 236 (23.6%)
- **Mechanical Failure:** 234 (23.4%)

**Finding:** Delays result from multiple factors with roughly equal contribution. Effective remediation requires:
- Coordinated approach across weather prediction, traffic routing, and asset maintenance
- Process improvement to capture delay reasons (currently 26.3% unrecorded)
- Asset-specific monitoring for mechanical reliability patterns

---

## 📌 Strategic Recommendations

### **🔴 High Priority** — Operational Impact & Reliability

| Finding | Business Implication | Recommended Action |
|---------|----------------------|-------------------|
| 56.6% of shipments experience delays or incomplete delivery | Material impact on customer satisfaction and service reputation | Implement comprehensive delay reduction program targeting traffic, weather, and mechanical factors |
| 26.3% of delays have no recorded reason | Operational data gaps prevent root cause identification and prevention | Enhance delay reporting process; implement mandatory reason codes for all delays |
| Waiting times average 35.1 minutes with high variance | Significant operational inefficiency reducing throughput capacity | Analyze waiting time components by asset/condition; identify and eliminate bottlenecks |
| Weather-related delays represent 26.7% of incidents | Predictable, partially preventable delays | Implement weather prediction integration; develop weather-adaptive routing strategies |

### **🟡 Medium Priority** — Efficiency & Growth

| Finding | Business Implication | Recommended Action |
|---------|----------------------|-------------------|
| Inventory 150% of demand forecasts | Inefficient working capital allocation; potential inventory obsolescence | Conduct demand forecasting review; consider just-in-time inventory model for slower-moving items |
| Some assets show 60% utilization | Underdeployed capacity; wasted fixed costs | Analyze low-utilization asset assignment; optimize fleet allocation to higher-demand routes |
| Traffic impacts 50% of operations (Heavy + Detour) | High operational variability; unpredictable delivery windows | Evaluate traffic pattern data; implement predictive routing and real-time traffic integration |
| Mechanical failures represent 23.4% of delays | Preventable delays through improved asset maintenance | Review maintenance schedules; implement predictive maintenance for high-failure assets |

### **🟢 Low Priority** — Incremental Optimization

| Finding | Business Implication | Recommended Action |
|---------|----------------------|-------------------|
| Demand forecast accuracy varies by segment | Opportunity to improve forecast-inventory alignment | Segment forecasts by asset, route, or season; implement separate models for high-variance segments |
| Clear traffic conditions represent only 32.8% of operations | Limited window for optimized delivery | Concentrate delivery scheduling on clear-traffic periods where feasible |
| Average asset utilization 79.6% | Room for incremental efficiency improvement | Target 85-90% utilization through improved scheduling and demand alignment |

---

## 📊 Project Workflow

```
Raw CSV Data (1,000 shipment records)
    ↓
Data Validation & Cleaning (0 critical issues found)
    ↓
PostgreSQL Data Modeling & Preparation
    ↓
SQL Business Analysis
├─ Shipment Performance Analysis
├─ Asset Utilization Analysis
├─ Environmental Impact Assessment
├─ Demand Forecast Accuracy
└─ Delay Root Cause Analysis
    ↓
Python Exploratory Data Analysis
├─ Pattern Discovery
├─ Correlation Analysis
├─ Outlier Detection
└─ Business Validation
    ↓
Power BI Data Modeling & Visualization
├─ Executive Overview Dashboard
├─ Customer Insights Dashboard
├─ Operational Efficiency Dashboard
├─ Risk & Forecasting Dashboard
└─ Root Cause Analysis Dashboard
    ↓
Root Cause Decomposition
└─ Multi-dimensional Problem Drilling
    ↓
Business Insights & Strategic Recommendations
```

---

## 🛠️ Tools & Technologies

| Category | Technology |
|----------|-----------|
| **Database** | PostgreSQL (data modeling, schema design, complex joins) |
| **Data Validation** | Python (pandas, numpy for data profiling and integrity checks) |
| **Data Analysis** | Python 3.x (pandas, numpy for exploratory analysis) |
| **Visualization** | Power BI (multi-page dashboards, interactive filters, drill-through analysis) |
| **Connection** | SQLAlchemy (Python ↔ PostgreSQL integration) |
| **Environment** | Python virtual environment, .env configuration |

---

## 📁 Repository Structure

```
Smart-Logistics/
├── DataSet/
│   └── smart_logistics_dataset.csv        (1,000 shipment records with 16 dimensions)
│
├── SQL Analysis/
│   ├── 01_data_preparation.sql            (Schema creation & data import)
│   └── 02_business_analysis.sql           (Core business queries)
│
├── Python/
│   ├── 01_Smart_Logistics_Data_Connection_Cleaning_Validation.ipynb (Data validation)
│   └── 02_Smart_Logistics_Business_Analysis.ipynb (Exploratory analysis)
│
├── DashBoard/
│   ├── Executive Overview.png             (Executive dashboard screenshot)
│   ├── Customer Insights.png              (Customer behavior analysis)
│   ├── Operational Efficiency.png         (Asset & efficiency dashboard)
│   ├── Risk And Forecasting.png           (Risk assessment & forecasting)
│   ├── Root Cause Analysis.png            (Root cause decomposition)
│   └── SmartLogistics Executive Overview.pdf (Full dashboard PDF export)
│
└── README.md                              (This file)
```

---

## 🎓 Key Analytical Techniques Demonstrated

**SQL Mastery**
- Complex JOINs across shipment and asset dimensions
- CTEs for hierarchical data analysis
- Window functions for ranking and trend analysis
- CASE statements for conditional business logic
- Aggregate functions with GROUP BY and HAVING
- Date/time analysis with temporal decomposition
- Correlation calculations and impact quantification

**Data Quality Rigor**
- Comprehensive validation framework (completeness, consistency, validity)
- Categorical value standardization and validation
- Duplicate detection and reconciliation
- NULL value handling with domain-appropriate interpretation
- Temporal validation and time range verification
- Numeric range validation against business rules

**Business Intelligence**
- Multi-dimensional analysis (asset, traffic, environment, customer, demand)
- Cross-domain correlation analysis (traffic ↔ delays, weather ↔ performance)
- Root cause decomposition enabling targeted problem-solving
- Financial impact quantification (delay costs, efficiency losses)
- Actionable insights with clear business implications

**Python Data Analysis**
- Database connectivity and data extraction at scale (1,000+ records)
- Data integrity validation in Python
- Exploratory analysis and pattern discovery
- Business logic validation through multiple analytical lenses
- Visualization and presentation of complex multi-dimensional data

**Executive Communication**
- Dashboard design focused on decision-maker needs
- Clear visualization hierarchy (executives → detail)
- Findings connected to business impact, not just metrics
- Recommendations prioritized by operational and financial significance
- Actionable insights with implementation pathway

---

## 🔮 Next Steps & Potential Extensions

1. **Predictive Modeling:** Build machine learning models to forecast shipment delays based on traffic, weather, asset, and historical patterns
2. **Route Optimization:** Analyze geographic patterns to identify high-delay routes and optimal alternatives using historical performance
3. **Real-Time Monitoring:** Develop real-time dashboards for active shipment tracking and anomaly detection
4. **Forecast Improvement:** Implement advanced demand forecasting models (ARIMA, Prophet) to improve inventory alignment
5. **Cost Analysis:** Quantify financial impact of delays, waiting times, and asset underutilization
6. **Maintenance Optimization:** Develop predictive maintenance schedules to reduce mechanical failure delays
7. **Customer Impact Analysis:** Correlate operational metrics with customer satisfaction and retention

---

## 📁 Data Dictionary

| Column | Type | Range | Meaning |
|--------|------|-------|---------|
| Timestamp | DateTime | Jan 2024 - Dec 2024 | Shipment event timestamp |
| Asset_ID | String | Truck_1 to Truck_10 | Unique fleet asset identifier |
| Latitude | Float | -89.79 to 89.87 | GPS latitude coordinate |
| Longitude | Float | -179.82 to 179.92 | GPS longitude coordinate |
| Inventory_Level | Integer | 100 - 500 | Units of inventory on asset |
| Shipment_Status | Category | Delivered / In Transit / Delayed | Current shipment status |
| Temperature | Float | 18 - 30 | Environmental temperature (°C) |
| Humidity | Float | 50 - 80 | Environmental humidity (%) |
| Traffic_Status | Category | Clear / Heavy / Detour | Current traffic condition |
| Waiting_Time | Integer | 10 - 60 | Waiting time in minutes |
| User_Transaction_Amount | Integer | 100 - 500 | Transaction value (currency units) |
| User_Purchase_Frequency | Integer | 1 - 10 | Purchase frequency (transactions) |
| Logistics_Delay_Reason | Category | Weather / Traffic / Mechanical Failure / No Reason Recorded | Reason for delay (if applicable) |
| Asset_Utilization | Float | 60 - 100 | Asset utilization percentage |
| Demand_Forecast | Integer | 100 - 300 | Forecasted demand (units) |
| Logistics_Delay | Binary | 0 / 1 | Delay flag (1 = delayed, 0 = on-time) |

---

**Project Completed:** August 2026  
**Repository:** [Smart-Logistics](https://github.com/sahilrege9673/Smart-Logistics)  
**Dataset:** 1,000 shipment records spanning full calendar year 2024
