<!-- 从 SKILL.md 提取的参考材料，按需查阅 -->

# Step 2: PRD 功能/路径/交互示例表

> 来源：SKILL.md「Step 2: 从PRD提取功能埋点需求」中的功能模块、用户路径、交互节点示例

## 2.1 功能模块识别

```
识别PRD中的功能模块 → 定义模块级埋点
```

**示例**：

| PRD功能模块 | 埋点命名空间 | 埋点事件示例 |
|-----------|------------|-------------|
| 用户认证 | user_auth | login_success, logout, register_complete |
| 商品浏览 | product_browse | product_view, product_list_view, search |
| 购物车 | cart | add_to_cart, remove_from_cart, cart_view |
| 订单流程 | order | checkout_start, payment_success, order_complete |
| 用户中心 | user_center | profile_view, settings_view |

---

## 2.2 核心用户路径提取

```
识别PRD描述的用户流程 → 定义路径埋点
```

**示例流程**（电商）：

```
注册/登录 → 首页浏览 → 商品搜索/分类 → 商品详情 → 加入购物车 → 结算支付 → 订单完成
```

**路径埋点设计**：

```json
{
  "user_journey": "注册→浏览→搜索→详情→加购→结算→支付→完成",
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

## 2.3 关键交互节点识别

```
识别PRD中的交互细节 → 定义交互埋点
```

**交互类型**：

| 交互类型 | 触发时机 | 埋点属性 |
|---------|---------|---------|
| 按钮点击 | 点击动作发生时 | button_name, page_name, position |
| 表单提交 | 表单提交成功时 | form_name, submit_result, error_type |
| 滑动手势 | 滑动结束时 | swipe_direction, swipe_distance |
| 输入行为 | 输入完成时 | input_field, input_length, input_type |
| 切换操作 | 切换完成时 | switch_from, switch_to, switch_type |
