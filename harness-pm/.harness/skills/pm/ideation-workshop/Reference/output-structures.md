<!-- 从 SKILL.md 提取的参考材料，按需查阅 -->

# 输出结构

## HMW输出结构（Step 1）

```json
{
  "hmw_ideas": {
    "hmw_statements": [
      {
        "id": "hmw_001",
        "statement": "How might we eliminate the friction points that cause users to abandon checkout?",
        "dimension": "remove",
        "source_problem": "用户在中途放弃完成订单",
        "source_data": {
          "type": "interview",
          "user_id": "user_001",
          "quote": "用户原话引用"
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

## 并行发散输出结构（Step 2）

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
        "solution": "移除强制注册要求，允许游客结账",
        "description": "允许用户在不创建账号的情况下完成购买，只需提供必要的配送和支付信息",
        "innovation_score": 3,
        "feasibility_score": 5,
        "impact_score": 4,
        "risk_score": 4,
        "key_assumption": "用户愿意在不登录的情况下提供支付信息",
        "cluster": "cluster_001"
      }
    ],
    "clusters": [
      {
        "cluster_id": "cluster_001",
        "cluster_name": "流程简化类",
        "description": "通过减少步骤和字段来简化结账过程",
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
        "failure_mode": "用户在结账页面放弃",
        "severity": 5,
        "likelihood": 4,
        "risk_score": 20,
        "priority": "critical",
        "success_condition": "用户能够顺利完成结账流程，没有任何阻碍",
        "design_constraints": [
          {
            "constraint": "结账流程最多3个步骤",
            "category": "功能约束",
            "verifiable": true,
            "verification_method": "功能测试验证步骤数"
          },
          {
            "constraint": "每步不超过5个字段",
            "category": "交互约束",
            "verifiable": true,
            "verification_method": "UI审查验证字段数量"
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
        "功能约束": 8,
        "交互约束": 12,
        "性能约束": 6,
        "视觉约束": 4,
        "内容约束": 5,
        "技术约束": 3
      },
      "critical_success_conditions": 3,
      "high_priority_constraints": 15
    }
  }
}
```

## 创意收敛输出结构（Step 3）

```json
{
  "converged_ideas": {
    "converged_solutions": [
      {
        "id": "solution_001",
        "title": "允许游客结账",
        "detailed_description": {
          "overview": "允许用户在不创建账号的情况下完成购买...",
          "key_features": ["功能1", "功能2", "功能3"],
          "user_experience": "用户可以直接输入配送和支付信息...",
          "differentiation": "与现有方案相比，我们通过消除注册门槛..."
        },
        "interaction_flow": {
          "steps": [
            {
              "step": 1,
              "action": "用户点击购买按钮",
              "ui_elements": ["购买按钮", "商品信息"],
              "user_goal": "开始购买流程"
            }
          ],
          "main_scenarios": ["标准购买流程", "中断恢复流程", "支付失败重试"]
        },
        "assumptions": {
          "technical": ["用户愿意在不登录的情况下提供支付信息"],
          "user": ["新用户更倾向于先体验再注册"],
          "business": ["短期订单完成率提升可以弥补注册率下降"]
        },
        "risks": {
          "technical": {
            "description": "支付信息安全性需要额外保障",
            "severity": "medium",
            "mitigation": "采用第三方支付平台处理敏感信息"
          }
        },
        "mvp_scope": {
          "core": ["商品展示", "购物车", "简化结账", "基础支付"],
          "extended": ["账户创建引导", "订单追踪", "个性化推荐"],
          "excluded": ["复杂会员体系", "积分系统", "多地址管理"]
        },
        "success_metrics": {
          "primary": ["订单完成率", "转化率"],
          "secondary": ["用户满意度", "平均订单价值"],
          "guardrails": ["退款率", "欺诈率"]
        }
      }
    ],
    "comparison_matrix": {
      "dimensions": [
        {
          "name": "用户价值",
          "weight": 0.25,
          "description": "对用户需求的满足程度"
        },
        {
          "name": "实现复杂度",
          "weight": 0.15,
          "description": "技术实现难度（反向）",
          "reverse": true
        },
        {
          "name": "创新程度",
          "weight": 0.15,
          "description": "方案的新颖性和差异化"
        },
        {
          "name": "风险程度",
          "weight": 0.15,
          "description": "实施和运营风险（反向）",
          "reverse": true
        },
        {
          "name": "战略对齐",
          "weight": 0.15,
          "description": "与公司战略的一致性"
        },
        {
          "name": "可扩展性",
          "weight": 0.15,
          "description": "未来的扩展灵活性"
        }
      ],
      "solutions": [
        {
          "solution_id": "solution_001",
          "title": "允许游客结账",
          "scores": {
            "用户价值": 4,
            "实现复杂度": 5,
            "创新程度": 3,
            "风险程度": 4,
            "战略对齐": 4,
            "可扩展性": 4
          },
          "weighted_score": 4.05,
          "pros": ["直接降低结账门槛", "实现简单，风险可控"],
          "cons": ["创新程度中等", "可能影响后续用户运营"],
          "recommendation": "强烈推荐",
          "ai_confidence": 0.85
        }
      ],
      "recommendations": {
        "overall_top": "solution_001",
        "by_dimension": {
          "用户价值": "solution_003",
          "实现复杂度": "solution_001",
          "创新程度": "solution_007",
          "风险程度": "solution_001",
          "战略对齐": "solution_004",
          "可扩展性": "solution_002"
        }
      }
    },
    "human_decision_package": {
      "summary": "方案收敛总结",
      "ai_recommendation": "AI推荐说明",
      "decision_factors": ["决策考虑因素"],
      "next_steps": ["后续行动项"],
      "approval_required": true,
      "decision_maker": "产品负责人"
    }
  }
}
```

## ideation-workshop.json 完整数据结构

```json
{
  "hmw_ideas": {
    "hmw_statements": ["...（见Step 1输出结构）"],
    "summary": {}
  },
  "scamper_ideas": {
    "solutions": ["...（见Step 2A输出结构）"],
    "clusters": [],
    "summary": {}
  },
  "inversion_ideas": {
    "inversion_analysis": ["...（见Step 2B输出结构）"],
    "summary": {}
  },
  "converged_ideas": {
    "converged_solutions": ["...（见Step 3输出结构）"],
    "comparison_matrix": {},
    "human_decision_package": {}
  }
}
```
