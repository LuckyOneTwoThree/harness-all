# Output Examples

## Complete funnel_analysis YAML Example

```yaml
funnel_analysis:
  analysis_time: "2024-01-15T10:00:00Z"
  
  # Funnel basic info
  funnel_name: "E-commerce Purchase Conversion Funnel"
  date_range:
    start: "2024-01-08"
    end: "2024-01-14"
  
  # Funnel step data
  steps:
    - step: 1
      name: "Product Detail Page View"
      event: "product_view"
      count: 500000
      conversion_from_previous: 100.0  # First step is 100%
      
    - step: 2
      name: "Add to Cart"
      event: "add_to_cart"
      count: 80000
      conversion_from_previous: 16.0
      dropoff_from_previous: 420000
      
    - step: 3
      name: "Start Checkout"
      event: "checkout_start"
      count: 50000
      conversion_from_previous: 62.5
      dropoff_from_previous: 30000
      
    - step: 4
      name: "Complete Payment"
      event: "purchase_complete"
      count: 35000
      conversion_from_previous: 70.0
      dropoff_from_previous: 15000
  
  # Overall conversion rate
  overall_conversion: 7.0  # From first step to final payment
  
  # Comparison with previous period
  vs_last_period:
    change_pct: -5.2
    trend: "declining"
    significant_steps:
      - step: 2  # Add-to-cart conversion declined
        change: -8.3
      - step: 3  # Checkout conversion declined
        change: -3.1
  
  # Critical drop-off analysis
  critical_drop:
    step: 1_to_2  # From browse to add-to-cart
    dropoff_rate: 84.0  # Drop-off rate
    affected_users: 420000
    
    dimension_breakdown:
      platform:
        iOS: 82.0
        Android: 85.0
        Web: 88.0
      user_type:
        new_users: 78.0
        returning_users: 86.0
      traffic_source:
        search: 75.0
        recommendation: 90.0
        direct: 80.0
    
    potential_causes:
      - "Product price higher than user expectation"
      - "Detail page information not attractive enough"
      - "Recommendation algorithm not precise enough"
    
    optimization_suggestions:
      - "Optimize product pricing strategy"
      - "Improve detail page design and content"
      - "Optimize recommendation algorithm, improve relevance"
  
  # Detailed report links
  reports:
    funnel_chart: "docs/metrics/data-analysis-report.md (\"Funnel Analysis\" section)"
    trend_chart: "docs/metrics/data-analysis-report.md (\"Funnel Analysis\" section)"
    dimension_data: "docs/metrics/data-analysis-report.md (\"Funnel Analysis\" section)"
```
