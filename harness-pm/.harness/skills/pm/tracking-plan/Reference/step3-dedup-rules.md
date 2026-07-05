<!-- Reference material extracted from SKILL.md, consult as needed -->

# Step 3: Similarity Calculation Rules and Deduplication Output

> Source: Similarity calculation rules and deduplication result output in SKILL.md "Step 3: Deduplicate Against Existing Tracking"

## Similarity Calculation Rules

```
Similarity = α × naming similarity + β × trigger timing similarity + γ × property similarity

Where:
  - Naming similarity: Based on string matching and semantic analysis
  - Trigger timing similarity: Based on the semantic distance of trigger descriptions
  - Property similarity: Based on the Jaccard coefficient of common properties

Suggested weights:
  - α = 0.4
  - β = 0.3
  - γ = 0.3
```

## Deduplication Result Output

```json
{
  "deduplication_result": {
    "new_events": [...],        // New tracking events
    "duplicate_events": [...],   // Duplicate tracking events (can reuse existing)
    "similar_events": [...],     // Similar tracking events (need manual confirmation)
    "updated_events": [...]      // Existing tracking events that need property updates
  }
}
```
