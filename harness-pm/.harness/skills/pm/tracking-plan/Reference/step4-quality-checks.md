<!-- 从 SKILL.md 提取的参考材料，按需查阅 -->

# Step 4: 埋点质量检查规则与输出

> 来源：SKILL.md「Step 4: 埋点质量检查」中 4.1~4.5 全部质量检查规则与输出

## 4.1 命名规范检查 [核心]

**命名规则**：

```
事件命名：全部小写 + 下划线分隔
  示例：user_login_success, product_add_to_cart

属性命名：全部小写 + 下划线分隔
  示例：user_id, product_price, page_name
```

**检查项**：

| 检查项 | 规则 | 通过条件 |
|-------|------|---------|
| 字母规范 | 仅允许a-z、0-9、下划线 | 无大写字母、无特殊字符 |
| 分隔规范 | 使用下划线分隔语义单元 | 非驼峰、非连字符 |
| 完整性 | 包含主体_动作_对象 | 至少3个语义单元 |
| 无缩写 | 避免不规范的缩写 | 常见缩写需在规范中定义 |

**检查输出**：

```json
{
  "naming_check": {
    "total_events": 100,
    "passed": 95,
    "failed": 5,
    "issues": [
      {
        "event_name": "UserLoginSuccess",
        "issue": "包含大写字母",
        "suggestion": "user_login_success"
      }
    ]
  }
}
```

---

## 4.2 属性完整性检查 [核心]

**核心属性定义**：

| 属性类型 | 属性名 | 必需 | 说明 |
|---------|-------|------|------|
| 通用属性 | user_id | 是 | 用户唯一标识 |
| 通用属性 | session_id | 是 | 会话唯一标识 |
| 通用属性 | timestamp | 是 | 事件发生时间 |
| 通用属性 | platform | 是 | 平台类型 |
| 通用属性 | app_version | 是 | App版本号 |
| 页面属性 | page_name | 是 | 页面名称 |
| 页面属性 | page_url | 是 | 页面URL |
| 设备属性 | device_type | 是 | 设备类型 |
| 设备属性 | os_version | 是 | 操作系统版本 |

**检查规则**：

```
FOR each event:
  1. 验证核心通用属性是否完整
  2. 验证特定事件类型的必需属性
  3. 计算属性完整率
  4. IF 完整率 < 80% THEN 标记为不通过
```

**检查输出**：

```json
{
  "completeness_check": {
    "total_events": 100,
    "core_attributes_coverage": 0.95,
    "events_with_full_attributes": 92,
    "events_needing_review": [
      {
        "event_name": "product_view",
        "missing_attributes": ["product_category", "source_page"],
        "completeness_rate": 0.70
      }
    ]
  }
}
```

---

## 4.3 核心路径覆盖检查 [条件]

**核心路径定义**：

```
基于指标体系和PRD，定义必须覆盖的核心用户路径
```

**覆盖要求**：

```
核心路径覆盖率 ≥ 90%
```

**检查逻辑**：

```python
def check_core_path_coverage():
    core_paths = get_core_paths_from_prd()
    covered_paths = get_covered_paths_from_tracking()

    coverage_rate = len(covered_paths & core_paths) / len(core_paths)

    return {
        "total_core_paths": len(core_paths),
        "covered_paths": len(covered_paths & core_paths),
        "uncovered_paths": core_paths - covered_paths,
        "coverage_rate": coverage_rate,
        "pass": coverage_rate >= 0.9
    }
```

**检查输出**：

```json
{
  "core_path_coverage": {
    "total_paths": 10,
    "covered": 9,
    "uncovered": ["path_to_checkout"],
    "coverage_rate": 0.90,
    "status": "pass"
  }
}
```

---

## 4.4 异常状态覆盖检查 [深度]

**异常状态定义**：

| 异常类型 | 异常场景 | 埋点需求 |
|---------|---------|---------|
| 加载异常 | 页面/接口加载失败 | error_view, api_error |
| 表单异常 | 表单验证失败、提交失败 | form_error, submit_failed |
| 支付异常 | 支付失败、取消支付 | payment_failed, payment_cancelled |
| 权限异常 | 无权限访问 | permission_denied |
| 网络异常 | 断网、超时 | network_error, timeout |

**检查规则**：

```
FOR each core_flow:
  1. 识别该流程中的异常分支
  2. 检查是否有对应异常埋点
  3. IF 异常场景无埋点 THEN 添加警告
```

**检查输出**：

```json
{
  "anomaly_coverage": {
    "total_anomaly_scenarios": 15,
    "covered_scenarios": 14,
    "missing_scenarios": [
      {
        "scenario": "搜索结果为空",
        "flow": "search",
        "suggested_event": "search_no_result"
      }
    ],
    "coverage_rate": 0.93
  }
}
```

---

## 4.5 冗余检测 [深度]

**冗余规则**：

```
IF 存在以下任一情况 THEN 标记为冗余埋点：
  - 两个事件采集完全相同的数据
  - 父子事件数据重复（父事件已包含子事件数据）
  - 统计口径完全一致的事件重复定义
```

**检测输出**：

```json
{
  "redundancy_check": {
    "duplicates": [
      {
        "event_a": "page_view",
        "event_b": "screen_show",
        "reason": "两者采集相同数据（页面曝光）",
        "recommendation": "保留page_view，删除screen_show"
      }
    ],
    "total_redundant": 1
  }
}
```
