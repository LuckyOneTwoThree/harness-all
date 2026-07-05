# ideation-workshop — Detailed Guidance

> Load on demand from the parent SKILL.md. This file preserves detailed templates and examples outside the default routing context.

## Execution Steps

### Step 1: HMW Problem Reframing [Core]

Based on problem statements and user research data, batch generate HMW statements from 6 dimensions, and perform quality checks and scoring.

#### 1.1 Generate HMW from 6 Dimensions [Core]

AI needs to generate HMW statements for each core problem from the following 6 dimensions:

##### Dimension Descriptions

1. **Remove**
   - Goal: Remove the obstacle factors that cause the problem
   - Problem-oriented: How might we eliminate the obstacles preventing users from achieving their goals?

2. **Reduce**
   - Goal: Reduce the effort, time, or complexity required to solve the problem
   - Problem-oriented: How might we lower the threshold for users to complete tasks?

3. **Accelerate**
   - Goal: Speed up the efficiency of users achieving their goals
   - Problem-oriented: How might we help users achieve their goals faster?

4. **Amplify**
   - Goal: Enhance users' perception and understanding of product value or features
   - Problem-oriented: How might we enable users to better perceive and understand product value?

5. **Expand**
   - Goal: Expand the product's use cases or user groups
   - Problem-oriented: How might we apply the product to more use cases?

6. **Rethink**
   - Goal: Redefine the problem or solution from a completely new angle
   - Problem-oriented: How might we rethink this problem fundamentally?

##### Generation Requirements

- Generate at least 2-3 HMW statements per dimension
- HMW statements should:
  - Start with "How might we"
  - Be specific enough to guide solution generation
  - Be open enough to preserve divergence space
  - Directly relate to insights from user research data

#### 1.2 HMW Quality Check [Conditional]

Perform quality checks on each generated HMW statement:

1. **Too broad**: Does the HMW cover too many problems, making it unable to guide specific solutions
2. **Preset solution**: Does the HMW already imply a specific solution
3. **Specific enough**: Is the HMW specific enough to guide the solution direction
4. **Divergence space**: Does the HMW preserve multiple possible solution paths

Each HMW must simultaneously satisfy: not too broad, no preset solution, specific enough, and has divergence space.

#### 1.3 HMW Scoring [Deep]

Score the divergence potential (1-5 points) of HMW statements that pass the quality check:

- **1 point**: Can only think of 1-2 solutions
- **2 points**: Can think of 2-3 related solutions
- **3 points**: Can think of 3-5 solutions
- **4 points**: Can think of 5-8 diverse solutions
- **5 points**: Can think of more than 8 highly diverse solutions

#### HMW Output Structure

> 📋 See [output-structures.md](./output-structures.md) (HMW Output Structure section)

---

### Step 2: Parallel Divergence [Conditional] (SCAMPER + Reverse Thinking)

Based on the HMW output from Step 1, execute SCAMPER structured divergence and reverse thinking analysis in parallel to maximize creative output.

#### 2A: SCAMPER Structured Solution Generation [Core]

For each selected HMW (recommend selecting those with divergence potential ≥ 3), generate 2-3 solutions from each of the 7 dimensions.

##### SCAMPER Dimension Details

1. **Substitute (S)** — What can replace the existing elements?
2. **Combine (C)** — What can be combined with?
3. **Adapt (A)** — What can be borrowed/adapted?
4. **Modify (M)** — How can it be modified?
5. **Put to other use (P)** — What other uses can it have?
6. **Eliminate (E)** — What can be eliminated?
7. **Reverse (R)** — How can it be reversed?

##### SCAMPER Generation Requirements

- Generate at least 3 solutions per HMW per dimension
- Solutions should directly respond to the problem in the HMW statement
- Reflect the core idea of the corresponding SCAMPER dimension
- Have a certain degree of novelty and differentiation

##### Solution Deduplication and Clustering

1. **Semantic deduplication**: Identify semantically identical or highly similar solutions, merge or delete duplicates
2. **Dimension validation**: Ensure the same solution is not repeatedly categorized into different dimensions
3. **Clustering algorithm**: Cluster based on goal similarity, method similarity, user value similarity, implementation complexity similarity

##### SCAMPER Initial Scoring

Score each solution from 4 dimensions:

1. **Innovation** 1-5 points
2. **Feasibility** 1-5 points
3. **Impact** 1-5 points
4. **Risk** 1-5 points (reverse scoring, 5 points = almost no risk)

#### 2B: Reverse Thinking Analysis [Conditional]

Based on product/feature goals, generate failure paths and reversely transform them into success conditions and design constraints.

##### Generate Failure Paths

Based on product/feature goals, generate 10-15 potential failure paths, covering 5 levels:

1. **User behavior level**: Users don't use it, misunderstand the value, difficult learning curve
2. **Technical implementation level**: Unstable features, performance issues, security vulnerabilities
3. **Business operations level**: Cost over budget, compliance issues, poor market timing
4. **Value perception level**: Users don't perceive value, competitor substitution
5. **Ecosystem level**: Partners don't cooperate, third-party dependency risks

Each failure path includes:
- **Failure Mode**: Clear description of the specific failure manifestation
- **Severity** 1-5 points
- **Likelihood** 1-5 points
- **Priority** = Severity × Likelihood (Critical ≥ 15, High 10-14, Medium 6-9, Low < 6)

##### Reverse Transform to Success Conditions

Reverse-think each failure path and transform it into corresponding success conditions:
- Not "how to avoid failure", but "under what conditions this failure will not occur"
- Success conditions must be specific and clear, observable and verifiable, directly related to the failure path, and not preset specific implementation methods

##### Transform to Design Constraints

Transform high-priority success conditions into specific actionable design constraints, categorized as:

1. **Functional constraints**: Features that must be provided or prohibited
2. **Interaction constraints**: Interaction patterns that must be followed or avoided
3. **Visual constraints**: Visual designs that must be observed or avoided
4. **Performance constraints**: Performance metrics that must be met
5. **Content constraints**: Content elements that must be included or avoided
6. **Technical constraints**: Technical solutions that must be adopted or avoided

Each design constraint must have a clear validation method.

#### Parallel Divergence Output Structure

> 📋 See [output-structures.md](./output-structures.md) (Parallel Divergence Output Structure section)

---

### Step 3: Creative Convergence [Conditional]

Filter high-quality candidates from the SCAMPER solution list and reverse thinking constraints, and provide support for human decision-making through deepening and comparison matrix.

#### 3.1 Solution Filtering

AI automatically filters high-quality candidate solutions:

1. **Feasibility filter**: Exclude solutions with feasibility score < 2
2. **Design constraint conflict detection**: Exclude solutions that conflict with Critical/High level design constraints
3. **Basic quality threshold**: Composite score = (Innovation + Feasibility + Impact + (6-Risk)) / 4 ≥ 3.5, or particularly outstanding in a certain dimension (score ≥ 4.5)
4. **Multi-dimensional consideration**: Balance, differentiation, coverage

#### 3.2 Solution Deepening

Perform in-depth analysis and refinement on the filtered Top 5-10 solutions:

1. **Detailed solution description**: Complete solution narrative, core features, user experience flow, differentiation
2. **Interaction flow design**: Interaction steps for main user scenarios, key pages and components, exception handling
3. **Key assumptions**: Technical assumptions, user assumptions, business assumptions, data assumptions
4. **Risk identification**: Technical risks, user risks, business risks, market risks
5. **MVP scope definition**: Core MVP / Extended MVP / Excluded
6. **Success metrics**: Primary Metrics / Secondary Metrics / Guardrail Metrics

#### 3.3 Solution Comparison Matrix [Deep]

Build a 6-dimension solution comparison matrix:

1. **User Value** 1-5 points, weight 0.25
2. **Implementation Complexity** 1-5 points (reverse), weight 0.15
3. **Innovation** 1-5 points, weight 0.15
4. **Risk** 1-5 points (reverse), weight 0.15
5. **Strategic Alignment** 1-5 points, weight 0.15
6. **Scalability** 1-5 points, weight 0.15

AI provides recommendations based on weighted total score method, dimension-optimal method, comprehensive trade-off method, and scenario-fit method, clearly annotating confidence and recommendation rationale.

#### Creative Convergence Output Structure

> 📋 See [output-structures.md](./output-structures.md) (Creative Convergence Output Structure section)

---
