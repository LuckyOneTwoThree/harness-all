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
