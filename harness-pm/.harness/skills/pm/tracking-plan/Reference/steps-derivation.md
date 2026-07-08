# Steps: Derivation (Event Source & Derivation Logic)

Merged reference material for tracking-plan Steps 1–3 (metric-derived tracking mapping, PRD feature extraction, deduplication rules). Provenance is preserved per source file below.

---

## Source: step1-metric-mapping.md

<!-- Reference material extracted from SKILL.md, consult as needed -->

# Step 1: Metric-Derived Tracking Mapping Table and Output

> Source: Derivation mapping table and output schema in SKILL.md "Step 1: Derive Tracking Requirements from the Metric System"

## Derivation Mapping Table

| Metric Type | Required Behavior Data | Tracking Event Example |
|---------|------------|-------------|
| Conversion rate metric | Page/feature exposure + click | page_view + button_click |
| Frequency metric | Behavior occurrence count | feature_use |
| Duration metric | Behavior start + end time | session_start + session_end |
| Quality metric | Behavior result + rating | action_result + feedback |
| Coverage rate metric | Feature used vs. unused comparison | feature_use vs non_use |

## Output

```json
{
  "metrics_to_track": [
    {
      "metric_name": "string",
      "required_behavior": "string",
      "proposed_event": {
        "event_name": "string",
        "trigger": "string",
        "required_properties": ["string"]
      }
    }
  ]
}
```

---

## Source: step2-prd-extraction.md

<!-- Reference material extracted from SKILL.md, consult as needed -->

# Step 2: PRD Feature/Path/Interaction Example Table

> Source: Feature module, user path, and interaction node examples in SKILL.md "Step 2: Extract Feature Tracking Requirements from the PRD"

## 2.1 Feature Module Identification

```
Identify feature modules in the PRD → Define module-level tracking
```

**Examples**:

| PRD Feature Module | Tracking Namespace | Tracking Event Example |
|-----------|------------|-------------|
| User authentication | user_auth | login_success, logout, register_complete |
| Product browsing | product_browse | product_view, product_list_view, search |
| Shopping cart | cart | add_to_cart, remove_from_cart, cart_view |
| Order flow | order | checkout_start, payment_success, order_complete |
| User center | user_center | profile_view, settings_view |

---

## 2.2 Core User Path Extraction

```
Identify user flows described in the PRD → Define path tracking
```

**Example flow** (E-commerce):

```
Register/Login → Homepage browsing → Product search/category → Product detail → Add to cart → Checkout payment → Order complete
```

**Path tracking design**:

```json
{
  "user_journey": "Register→Browse→Search→Detail→Add to cart→Checkout→Payment→Complete",
  "touchpoints": [
    "register_success",
    "homepage_view",
    "product_list_view",
    "product_detail_view",
    "add_to_cart",
    "cart_view",
    "checkout_start",
    "payment_page_view",
    "payment_success",
    "order_complete"
  ]
}
```

---

## 2.3 Key Interaction Node Identification

```
Identify interaction details in the PRD → Define interaction tracking
```

**Interaction types**:

| Interaction Type | Trigger Timing | Tracking Properties |
|---------|---------|---------|
| Button click | When the click action occurs | button_name, page_name, position |
| Form submission | When the form is successfully submitted | form_name, submit_result, error_type |
| Swipe gesture | When the swipe ends | swipe_direction, swipe_distance |
| Input behavior | When input is completed | input_field, input_length, input_type |
| Switch operation | When the switch is completed | switch_from, switch_to, switch_type |

---

## Source: step3-dedup-rules.md

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
