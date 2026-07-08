# Output Examples

## Output JSON Example

```json
{
  "category_keywords": "Online Education",
  "target_market": "Mainland China",
  "scan_timestamp": "2026-05-10T08:00:00Z",
  "political": {
    "trends": [
      {
        "trend": "Data privacy laws tightening, personal data protection strengthening",
        "direction": "rising",
        "strength": "strong",
        "impact_path": "Rising compliance costs → higher entry barriers for SMBs"
      }
    ],
    "key_signals": [
      {
        "signal": "Implementation rules of the Personal Information Protection Law released",
        "type": "new policy release",
        "timing": "occurred",
        "source": "State Council official website",
        "impact": {
          "direction": "negative",
          "degree": 5,
          "time_window": "medium-term",
          "scope": "industry",
          "recommendation": "Accelerate compliance system building, establish data privacy protection mechanisms"
        },
        "alert": false
      }
    ]
  },
  "economic": {
    "trends": [
      {
        "trend": "GDP growth slowing, pressure on residents' disposable income growth",
        "direction": "declining",
        "strength": "medium",
        "impact_path": "Declining willingness for education spending → lower conversion rates for paid online education"
      }
    ],
    "key_signals": [
      {
        "signal": "Q1 2026 GDP growth dropped to 4.5%",
        "type": "indicator mutation",
        "timing": "occurred",
        "source": "National Bureau of Statistics quarterly bulletin",
        "impact": {
          "direction": "negative",
          "degree": 3,
          "time_window": "medium-term",
          "scope": "industry",
          "recommendation": "Optimize pricing strategy, launch lightweight affordable products to cope with consumption downgrade"
        },
        "alert": false
      }
    ]
  },
  "social": {
    "trends": [
      {
        "trend": "Gen Z consumption habits changing, fragmented learning preference strengthening",
        "direction": "rising",
        "strength": "strong",
        "impact_path": "Fragmented learning scenarios → course product design must adapt to short, high-frequency patterns"
      }
    ],
    "key_signals": [
      {
        "signal": "Short-video learning apps MAU grew 45% YoY",
        "type": "trend inflection",
        "timing": "occurring",
        "source": "QuestMobile annual report",
        "impact": {
          "direction": "positive",
          "degree": 4,
          "time_window": "short-term",
          "scope": "industry",
          "recommendation": "Develop short-video micro-course product format, capture fragmented learning scenarios"
        },
        "alert": true
      }
    ]
  },
  "technological": {
    "trends": [
      {
        "trend": "AI technology spreading, large model education application costs dropping rapidly",
        "direction": "rising",
        "strength": "strong",
        "impact_path": "Declining AI tutoring costs → personalized teaching products can scale"
      }
    ],
    "key_signals": [
      {
        "signal": "Education large model API call costs dropped 60% YoY",
        "type": "technology breakthrough",
        "timing": "occurring",
        "source": "Gartner technology maturity report",
        "impact": {
          "direction": "positive",
          "degree": 4,
          "time_window": "medium-term",
          "scope": "cross-industry",
          "recommendation": "Increase R&D investment in AI personalized tutoring products, build data flywheel"
        },
        "alert": true
      }
    ]
  },
  "alerts": [
    {
      "signal": "Implementation rules of the Personal Information Protection Law released",
      "dimension": "Political",
      "impact_degree": 5,
      "impact_direction": "negative",
      "recommendation": "Accelerate compliance system building, establish data privacy protection mechanisms",
      "timestamp": "2026-05-10T08:00:00Z"
    },
    {
      "signal": "Short-video learning apps MAU grew 45% YoY",
      "dimension": "Social",
      "impact_degree": 4,
      "impact_direction": "positive",
      "recommendation": "Develop short-video micro-course product format, capture fragmented learning scenarios",
      "timestamp": "2026-05-10T08:00:00Z"
    },
    {
      "signal": "Education large model API call costs dropped 60% YoY",
      "dimension": "Technological",
      "impact_degree": 4,
      "impact_direction": "positive",
      "recommendation": "Increase R&D investment in AI personalized tutoring products, build data flywheel",
      "timestamp": "2026-05-10T08:00:00Z"
    }
  ]
}
```

