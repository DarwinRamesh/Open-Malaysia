
# Malaysian CPI Headline

The Consumer Price Index (CPI) is widely used as a measure of inflation as it tracks the purchasing power of a currency. The calculation is done by comparing the average change of prices per basket of goods. If the CPI has increased for any given goods or service, it means that it has gotten more expensive. 

It is not an entirely accurate representation of how much purchasing power one really has as it cannot fully accurately capture the concept of how the quality of goods may change relative to their prices.

```sql all_dates
SELECT date FROM openmalaysia.mart_cpi_headline
```

<DateRange
name="cpi_dates"
data={all_dates}
dates=date
label="Select Period"
/>

```sql cpi
SELECT 
    date, 
    division, 
    index 
FROM openmalaysia.mart_cpi_headline
WHERE date BETWEEN '${inputs.cpi_dates.start}' AND '${inputs.cpi_dates.end}'
ORDER BY date ASC
```

<LineChart
data={cpi}
x=date
y=index
series=division
title="Monthly CPI Analysis"
chartAreaHeight=400
/>