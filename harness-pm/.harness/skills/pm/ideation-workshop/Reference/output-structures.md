<!-- Reference material extracted from SKILL.md, consult as needed -->

# Output Structures

## HMW Output Structure (Step 1)

```json
{
  "hmw_ideas": {
    "hmw_statements": [
      {
        "id": "hmw_001",
        "statement": "How might we eliminate the friction points that cause users to abandon checkout?",
        "dimension": "remove",
        "source_problem": "Users abandon order completion midway",
        "source_data": {
          "type": "interview",
          "user_id": "user_001",
          "quote": "Direct user quote"
        },
        "divergence_potential": 4,
        "quality_check": "passed",
        "quality_issues": [],
        "related_dimensions": ["remove", "reduce"]
      }
    ],
    "summary": {
      "total_hmw": 36,
      "passed": 32,
      "failed": 4,
      "dimension_distribution": {
        "remove": 6,
        "reduce": 6,
        "accelerate": 6,
        "amplify": 6,
        "expand": 6,
        "rethink": 6
      },
      "average_divergence": 3.8,
      "high_potential_count": 18
    }
  }
}
```

## Parallel Divergence Output Structure (Step 2)

```json
{
  "scamper_ideas": {
    "solutions": [
      {
        "id": "solution_001",
        "source_hmw": {
          "id": "hmw_001",
          "statement": "How might we eliminate the friction points that cause users to abandon checkout?"
        },
        "scamper_dimension": "eliminate",
        "solution": "Remove mandatory registration requirement, allow guest checkout",
        "description": "Allow users to complete purchases without creating an account, only requiring necessary shipping and payment information",
        "innovation_score": 3,
        "feasibility_score": 5,
        "impact_score": 4,
        "risk_score": 4,
        "key_assumption": "Users are willing to provide payment information without logging in",
        "cluster": "cluster_001"
      }
    ],
    "clusters": [
      {
        "cluster_id": "cluster_001",
        "cluster_name": "Process Simplification",
        "description": "Simplify the checkout process by reducing steps and fields",
        "solution_ids": ["solution_001", "solution_004", "solution_007"],
        "cluster_potential": 4.2,
        "dominant_dimension": "eliminate"
      }
    ],
    "summary": {
      "total_solutions": 42,
      "total_clusters": 8,
      "average_scores": {
        "innovation": 3.4,
        "feasibility": 3.8,
        "impact": 3.6,
        "risk": 3.5
      },
      "dimension_distribution": {
        "substitute": 6,
        "combine": 5,
        "adapt": 6,
        "modify": 6,
        "put_to_other_use": 6,
        "eliminate": 7,
        "reverse": 6
      }
    }
  },
  "inversion_ideas": {
    "inversion_analysis": [
      {
        "id": "inversion_001",
        "failure_mode": "Users abandon at the checkout page",
        "severity": 5,
        "likelihood": 4,
        "risk_score": 20,
        "priority": "critical",
        "success_condition": "Users can smoothly complete the checkout process without any obstacles",
        "design_constraints": [
          {
            "constraint": "Checkout process has at most 3 steps",
            "category": "Functional constraint",
            "verifiable": true,
            "verification_method": "Functional test verifies step count"
          },
          {
            "constraint": "No more than 5 fields per step",
            "category": "Interaction constraint",
            "verifiable": true,
            "verification_method": "UI review verifies field count"
          }
        ]
      }
    ],
    "summary": {
      "total_failure_modes": 12,
      "priority_distribution": {
        "critical": 3,
        "high": 4,
        "medium": 3,
        "low": 2
      },
      "total_design_constraints": 38,
      "constraints_by_category": {
        "Functional constraint": 8,
        "Interaction constraint": 12,
        "Performance constraint": 6,
        "Visual constraint": 4,
        "Content constraint": 5,
        "Technical constraint": 3
      },
      "critical_success_conditions": 3,
      "high_priority_constraints": 15
    }
  }
}
```

## Creative Convergence Output Structure (Step 3)

```json
{
  "converged_ideas": {
    "converged_solutions": [
      {
        "id": "solution_001",
        "title": "Allow Guest Checkout",
        "detailed_description": {
          "overview": "Allow users to complete purchases without creating an account...",
          "key_features": ["Feature 1", "Feature 2", "Feature 3"],
          "user_experience": "Users can directly enter shipping and payment information...",
          "differentiation": "Compared to the existing solution, we eliminate the registration barrier..."
        },
        "interaction_flow": {
          "steps": [
            {
              "step": 1,
              "action": "User clicks the purchase button",
              "ui_elements": ["Purchase button", "Product information"],
              "user_goal": "Start the purchase process"
            }
          ],
          "main_scenarios": ["Standard purchase flow", "Interrupted resume flow", "Payment failure retry"]
        },
        "assumptions": {
          "technical": ["Users are willing to provide payment information without logging in"],
          "user": ["New users prefer to experience before registering"],
          "business": ["Short-term order completion rate increase can offset registration rate decrease"]
        },
        "risks": {
          "technical": {
            "description": "Payment information security requires additional safeguards",
            "severity": "medium",
            "mitigation": "Use third-party payment platforms to handle sensitive information"
          }
        },
        "mvp_scope": {
          "core": ["Product display", "Shopping cart", "Simplified checkout", "Basic payment"],
          "extended": ["Account creation guidance", "Order tracking", "Personalized recommendations"],
          "excluded": ["Complex membership system", "Points system", "Multi-address management"]
        },
        "success_metrics": {
          "primary": ["Order completion rate", "Conversion rate"],
          "secondary": ["User satisfaction", "Average order value"],
          "guardrails": ["Refund rate", "Fraud rate"]
        }
      }
    ],
    "comparison_matrix": {
      "dimensions": [
        {
          "name": "User Value",
          "weight": 0.25,
          "description": "Degree of meeting user needs"
        },
        {
          "name": "Implementation Complexity",
          "weight": 0.15,
          "description": "Technical implementation difficulty (reverse)",
          "reverse": true
        },
        {
          "name": "Innovation",
          "weight": 0.15,
          "description": "Novelty and differentiation of the solution"
        },
        {
          "name": "Risk",
          "weight": 0.15,
          "description": "Implementation and operational risk (reverse)",
          "reverse": true
        },
        {
          "name": "Strategic Alignment",
          "weight": 0.15,
          "description": "Consistency with company strategy"
        },
        {
          "name": "Scalability",
          "weight": 0.15,
          "description": "Future expansion flexibility"
        }
      ],
      "solutions": [
        {
          "solution_id": "solution_001",
          "title": "Allow Guest Checkout",
          "scores": {
            "User Value": 4,
            "Implementation Complexity": 5,
            "Innovation": 3,
            "Risk": 4,
            "Strategic Alignment": 4,
            "Scalability": 4
          },
          "weighted_score": 4.05,
          "pros": ["Directly lowers checkout barrier", "Simple implementation, controllable risk"],
          "cons": ["Medium innovation", "May affect subsequent user operations"],
          "recommendation": "Strongly recommended",
          "ai_confidence": 0.85
        }
      ],
      "recommendations": {
        "overall_top": "solution_001",
        "by_dimension": {
          "User Value": "solution_003",
          "Implementation Complexity": "solution_001",
          "Innovation": "solution_007",
          "Risk": "solution_001",
          "Strategic Alignment": "solution_004",
          "Scalability": "solution_002"
        }
      }
    },
    "human_decision_package": {
      "summary": "Solution convergence summary",
      "ai_recommendation": "AI recommendation description",
      "decision_factors": ["Decision considerations"],
      "next_steps": ["Follow-up action items"],
      "approval_required": true,
      "decision_maker": "Product Owner"
    }
  }
}
```

## ideation-workshop.json Complete Data Structure

```json
{
  "hmw_ideas": {
    "hmw_statements": ["... (see Step 1 output structure)"],
    "summary": {}
  },
  "scamper_ideas": {
    "solutions": ["... (see Step 2A output structure)"],
    "clusters": [],
    "summary": {}
  },
  "inversion_ideas": {
    "inversion_analysis": ["... (see Step 2B output structure)"],
    "summary": {}
  },
  "converged_ideas": {
    "converged_solutions": ["... (see Step 3 output structure)"],
    "comparison_matrix": {},
    "human_decision_package": {}
  }
}
```
