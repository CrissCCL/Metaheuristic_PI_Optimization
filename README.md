# ⚙️ Metaheuristic Optimization for PI Control  
### Comparative Study on a Nonlinear Tank System

![Control](https://img.shields.io/badge/Control-PI%20Controller-blue)
![Optimization](https://img.shields.io/badge/Optimization-Metaheuristics-orange)
![System](https://img.shields.io/badge/System-Nonlinear%20Tank-lightgrey)
![Simulation](https://img.shields.io/badge/Simulation-MATLAB-yellow)
![License](https://img.shields.io/badge/License-MIT-lightgrey)

---

## 📖 Overview

This repository presents a **comparative study of metaheuristic optimization algorithms**
applied to the **tuning of a PI controller** for a **nonlinear tank system** at laboratory scale.

The objective is to optimize the closed-loop response of the system under **realistic operational constraints**, 
minimizing control error while ensuring feasible actuator behavior.

The study evaluates multiple **metaheuristic and evolutionary algorithms**, comparing:

- Convergence behavior  
- Fitness evolution  
- Computational cost  
- Closed-loop simulation performance  

The work follows an **industrial-style control engineering approach**, prioritizing robustness and practicality over purely theoretical optimality.

---

## 🧪 System Description

- **Process:** Single-tank level control (laboratory-scale plant)
- **Dynamics:** Nonlinear (flow–level relationship)
- **Configuration:** SISO (Single Input – Single Output)
- **Control Variable:** Tank liquid level
- **Manipulated Variable:** Pump voltage
- **Operating Point:** Linearized around nominal steady-state conditions

The nonlinear model is linearized around a chosen operating point to enable classical PI control design, while the optimization algorithms handle the non-idealities and constraints.

---

## 🎛️ Control Architecture

- **Controller type:** PI (Proportional–Integral)
- **Structure:** Unity feedback loop
- **Design focus:**
  - Reference tracking
  - Stable transient response
  - Limited actuator effort

Derivative action is intentionally excluded due to process characteristics and actuator limitations.

### Control Loop Diagram

📌 *Figure placeholder:*  
`docs/fig_control_loop.png`

## 🎯 Optimization Problem Formulation

### Objective Function

The controller parameters are optimized by minimizing an **integral performance criterion** based on the control error:

- **ISE** (Integral of Squared Error)  
- **ITAE** (Integral of Time-weighted Absolute Error), for comparative analysis

The optimization is performed over the closed-loop time response to a step reference.

### Constraints

The optimization is subject to realistic operational constraints:

- **Actuator saturation** (maximum pump voltage)
- **Minimum rise time**, reflecting physical limitations of the plant
- Feasible controller parameter bounds

Only solutions satisfying all constraints are considered valid.

---

## 🧠 Optimization Algorithms Evaluated

The following techniques are implemented and compared:

- **Exhaustive Search** (baseline reference)
- **Particle Swarm Optimization (PSO)**
- **Genetic Algorithm (GA)**
- **Firefly Algorithm**
- **Artificial Bee Colony (ABC)**
- **Bat Algorithm**

Each algorithm is evaluated using the same objective function, constraints, and simulation conditions to ensure a fair comparison.

---

## 🔄 Algorithm Flow Diagrams

📌 *Flow diagram placeholders (one per algorithm):*

- `docs/flow_exhaustive.png`
- `docs/flow_pso.png`
- `docs/flow_ga.png`
- `docs/flow_firefly.png`
- `docs/flow_abc.png`
- `docs/flow_bat.png`

These diagrams illustrate the internal optimization logic and iteration flow for each technique.

## 🚀 How to Run

Each optimization algorithm is executed independently.

Each runner:
- executes the selected optimizer
- generates method-specific plots
- stores convergence history as global_fitness in /results/*.mat

## 📈 Results & Analysis
Fitness Evolution Comparison
> **Important note (Optimality vs. Best Fitness):**  
> In this study, the **Exhaustive Search** is used as the **reference optimum** (within the evaluated grid/bounds).  
> For the metaheuristics (PSO/GA/Firefly/ABC/Bat), the reported curve corresponds to the **best-so-far fitness found during the search**, which **does not necessarily imply global optimality**.  
> Therefore, convergence toward the exhaustive-search optimum is evaluated by **how close the algorithm gets to the reference optimum**, and how efficiently it reaches that region of the search space.

<p align="center">
  <img alt="result" src="https://github.com/user-attachments/assets/f12908db-7383-4404-9525-13751e2158fc" width="700">
</p>

## 📊 Comparative Summary
The comparison shows the evolution of the best fitness value across iterations for all algorithms.

| Algorithm         | Fitness      | Computation Time | Notes                        |
| ----------------- | ------------ | ---------------- | ---------------------------- |
| Exhaustive Search | Optimal      | High             | Baseline reference           |
| PSO               | Optimal      | Low              | Fast and robust convergence  |
| Genetic Algorithm | Near-optimal | Medium           | Stable but slower            |
| Firefly Algorithm | Suboptimal   | Medium           | Sensitive to parameters      |
| ABC               | Near-optimal | Very High        | High computational cost      |
| Bat Algorithm     | Near-optimal | High             | Strong stochastic dependence |

## 🛠️ Tools & Environment

- MATLAB
- Control System Toolbox
- Custom simulation and optimization scripts

All simulations are executed under identical conditions to ensure reproducibility and consistency.

## 🎓 Context & Motivation

This project was originally developed as an academic control engineering study and has been refactored and documented to serve as:

- A reference example of metaheuristic optimization applied to control
- A practical comparison of optimization strategies for nonlinear processes
- A reusable framework for controller tuning under constraints

The methodology and results remain directly applicable to industrial control and process optimization problems.

##  📜 License
MIT License.

