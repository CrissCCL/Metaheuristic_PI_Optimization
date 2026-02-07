# ⚙️ Metaheuristic Optimization for PI Control  
### Comparative Study on a Nonlinear Tank System

![Control](https://img.shields.io/badge/Control-PI%20Controller-blue)
![Optimization](https://img.shields.io/badge/Optimization-Metaheuristics-orange)
![System](https://img.shields.io/badge/System-Nonlinear%20Tank-lightgrey)
![Simulation](https://img.shields.io/badge/Simulation-MATLAB-yellow)
![License](https://img.shields.io/badge/License-MIT-lightgrey)

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


## 📂 Contents

- **Exhaustive search:**    Exhaustive grid search implementation used as reference optimum; *Main script:* `run_exhaustive.m`
- **PSO:**    Particle Swarm Optimization (PSO) implementation and execution scripts; *Main script:* `run_pso.m`
- **GA:**    Genetic Algorithm (GA) implementation and execution scripts;  *Main script:* `run_ga.m`
- **firefly:**    Firefly Algorithm implementation and execution scripts;  *Main script:* `run_firefly.m`
- **ABC:**    Artificial Bee Colony (ABC) implementation and execution scripts;  *Main script:* `run_abc.m`
- **results:**    Result comparison scripts and stored fitness evolution data (`.mat` files); *Main script:* `plot_comparison.m`

> Each folder contains a self-contained implementation of the corresponding optimization algorithm.

## 🧪 System Description

- **Process:** Single-tank level control (laboratory-scale plant)
- **Dynamics:** Nonlinear (flow–level relationship)
- **Configuration:** SISO (Single Input – Single Output)
- **Control Variable:** Tank liquid level
- **Manipulated Variable:** Pump voltage
- **Operating Point:** Linearized around nominal steady-state conditions

The nonlinear model is linearized around a chosen operating point to enable classical PI control design, while the optimization algorithms handle the non-idealities and constraints.


## 🎛️ Control Architecture

- **Controller type:** PI (Proportional–Integral)
- **Structure:** Unity feedback loop
- **Design focus:**
  - Reference tracking
  - Stable transient response
  - Limited actuator effort

Derivative action is intentionally excluded due to process characteristics and actuator limitations.

### Control Loop Diagram

The following diagrams illustrate the closed-loop control structure
and the physical tank system considered in this study.

<table align="center">
  <tr>
    <td align="center">
      <img alt="Closed-loop PI control architecture"
           src="https://github.com/user-attachments/assets/63206eb0-f6d7-4aab-8958-d43ca0dbf8d9"
           width="450"><br>
      <sub><b>Figure 1.</b> Closed-loop PI control architecture.</sub>
    </td>
    <td align="center">
      <img alt="Laboratory-scale tank system"
           src="https://github.com/user-attachments/assets/cb2c5ea4-0884-4866-a1bc-5da1a3cd7daa"
           width="200"><br>
      <sub><b>Figure 2.</b> Laboratory-scale single-tank system.</sub>
    </td>
  </tr>
</table>



## 🎯 Optimization Problem Formulation

### Objective Function

The PI controller tuning problem is formulated as a constrained optimization task
using the **Integral of Squared Error (ISE)** as performance index:

$$
J = \int_0^{T} e^2(t)dt
$$

The ISE criterion is selected to penalize transient errors more strongly,
making it suitable for evaluating closed-loop dynamic performance.

### Constraints

The optimization is subject to the following physical and operational constraints:

$$
0 \leq u(t) \leq 5 \ \text{[V]}
\qquad
T_r \geq 10 \ \text{[s]}
$$

where $$u(t)$$ is the control signal limited by the actuator voltage,
and $$T_r$$ is the rise time of the closed-loop response.
The minimum rise time reflects inherent limitations of the system architecture
and actuator dynamics under maximum operating conditions.

Candidate solutions violating these constraints are considered infeasible
and assigned zero fitness during optimization.


## 🧠 Optimization Algorithms Evaluated

The following techniques are implemented and compared:

- **Exhaustive Search** (baseline reference)
- **Particle Swarm Optimization (PSO)**
- **Genetic Algorithm (GA)**
- **Firefly Algorithm**
- **Artificial Bee Colony (ABC)**
- **Bat Algorithm**

Each algorithm is evaluated using the same objective function, constraints, and simulation conditions to ensure a fair comparison.


## 🔄 Optimization Algorithm Flow Diagrams

<p align="center">
  The following diagrams summarize the internal logic and iteration flow of each
  metaheuristic optimization algorithm implemented in this study.
</p>


<table align="center">
  <tr>
    <td align="center">
      <b>Particle Swarm Optimization (PSO)</b><br><br>
      <img src="https://github.com/user-attachments/assets/4c63abac-14c5-42d6-b7da-b5f46ba336ac" width="320">
    </td>
    <td align="center">
      <b>Genetic Algorithm (GA)</b><br><br>
      <img src="https://github.com/user-attachments/assets/f0e16f80-8848-48f3-b84b-67c970a4d454" width="320">
    </td>
  </tr>
  <tr>
    <td align="center">
      <b>Firefly Algorithm</b><br><br>
      <img src="https://github.com/user-attachments/assets/91c768c4-918f-493c-80e9-f2c2282f68d0" width="320">
    </td>
    <td align="center">
      <b>Artificial Bee Colony (ABC)</b><br><br>
      <img src="https://github.com/user-attachments/assets/c4cac0f8-5a6b-4831-b33b-e01cf4e54a14" width="240">
    </td>
  </tr>
</table>


> These diagrams are provided for clarity and documentation purposes.
> They do not alter the numerical results but illustrate the algorithmic flow.

## 🚀 How to Run

Each optimization algorithm is executed independently.

Each runner:
- executes the selected optimizer
- generates method-specific plots
- stores convergence history as global_fitness in /results/*.mat

## 📈 Results & Analysis

### Fitness Evolution and Convergence Behavior

> **Important note (Optimality vs. Best Fitness):**  
> In this study, the **Exhaustive Search** is used as the **reference optimum** within the evaluated parameter grid and bounds.  
> For the metaheuristic methods (PSO, GA, Firefly, ABC, Bat), the reported curves correspond to the **best-so-far fitness found during the search**, which **does not necessarily imply global optimality**.  
>  
> Convergence performance is therefore evaluated based on:
> - **Proximity to the reference optimum**, and  
> - **How efficiently each algorithm reaches that region of the search space**.

<p align="center">
  <img alt="result" src="https://github.com/user-attachments/assets/f12908db-7383-4404-9525-13751e2158fc" width="700">
</p>

> **Relative optimality gap:**  
> The vertical axis represents the relative gap with respect to the exhaustive-search
> reference optimum, defined as
>
> $$
> \text{Gap} = \frac{f^\* - f}{f^\*}
> $$
>
> where $$f^\*$$ is the best fitness obtained by exhaustive search and $$f$$ is the
> best-so-far fitness achieved by the metaheuristic at a given iteration.
> Lower values indicate closer proximity to the reference optimum.
>
> **Interpretation:**  
> A gap equal to zero indicates convergence to the reference optimum, while nonzero
> values reflect suboptimal or locally optimal solutions under the given iteration budget.


All metaheuristic algorithms were executed using a **fixed iteration budget of 100 iterations** under identical simulation conditions.  
The exhaustive search result serves exclusively as a **benchmark reference**, not as a competitor in convergence speed.


## 🧾 Convergence Metrics (Best-So-Far Fitness)

To provide a quantitative assessment of convergence behavior, the stored `global_fitness` histories were analyzed using the following metrics:

- **MaxBestFitness:** Maximum best-so-far fitness reached during the run  
- **IterAtMax:** First iteration at which the maximum best-so-far fitness is achieved  
- **IterToRef:** First iteration at which the algorithm reaches the *reference optimum region* (within tolerance)
- **TimeToRef:** Represents the estimated real execution time required to reach the reference optimum region, computed assuming a fixed iteration budget of 100 iterations.
- **ExecTime (s):** Total execution time for the run  
- **Score:** Time-weighted performance index (higher is better), combining fitness quality and execution time penalty  

> **Note:** Since all metaheuristics were executed with a fixed iteration budget of **100 iterations**, the reported values represent the **best solution found within that budget**, which may correspond to either a global or a local optimum.

| Technique | MaxBestFitness | IterAtMax | IterToRef | TimeToRef (s) | ExecTime (s) | Score |
|----------|----------------:|----------:|----------:|--------------:|-------------:|------:|
| GA       | 0.22916         | 7         | 7         | 2.31          | 33           | 0.17230 |
| Firefly  | 0.25134         | 79        | 7         | 7.56          | 108          | 0.12084 |
| PSO      | 0.22921         | 17        | 10        | 10.70         | 107          | 0.11073 |
| ABC      | 0.22921         | 82        | 82        | 297.66        | 363          | 0.04950 |

>Including the time-to-reference metric allows distinguishing between algorithms that converge in few iterations but require high computational effort per iteration,
and those that reach the reference region earlier in real execution time.

### Interpretation

- **GA** reaches the reference optimum region fastest (**IterToRef = 7**) and exhibits the best time-weighted score due to its low execution time.
- **PSO** converges reliably toward the reference region (**IterToRef = 10**) with stable behavior, albeit at a higher computational cost than GA.
- **ABC** eventually reaches the reference region but requires significantly more iterations and computation time.
- **Firefly** achieves the highest maximum best-so-far fitness; however, this occurs late in the run (**IterAtMax = 79**), indicating convergence toward a **different feasible region** of the search space rather than superiority with respect to the reference optimum.

This highlights the **exploratory nature** of Firefly-type algorithms under the current objective function and constraints.


## 📊 Comparative Summary

The following qualitative comparison complements the quantitative metrics above, summarizing each algorithm’s behavior in terms of convergence quality, computational effort, and practical usability.

| Algorithm              | Fitness Level        | Computation Time | Notes                                                        |
|------------------------|----------------------|------------------|--------------------------------------------------------------|
| Exhaustive Search      | Reference optimum    | Medium           | Guarantees optimality within the evaluated grid              |
| PSO                    | Near-reference       | Medium           | Stable convergence toward the reference solution             |
| Genetic Algorithm (GA) | Reference-equivalent | Low              | Fast convergence in few generations                          |
| Firefly Algorithm      | Higher fitness value | Medium           | Converges to a different (local) optimum region              |
| ABC                    | Reference-equivalent | Very High        | Achieves reference solution with high computational cost     |

> Fitness values are not directly comparable across different local optima when constraints and objective scaling differ; therefore, **convergence behavior and computational cost are equally relevant evaluation criteria**.


## 📊 Comparative Performance Summary (Quantitative Results)

The table below reports the final controller parameters and execution times obtained for each method.

All metaheuristic algorithms were executed with **100 iterations**, allowing a direct comparison of
**how efficiently each method approaches the reference optimum region** under identical computational constraints.

### Computing Platform

All simulations were executed on the following hardware:

- **Processor:** AMD Ryzen 7 5800X (8-Core, 3.80 GHz)  
- **Installed RAM:** 32.0 GB  

### Performance Comparison

| Technique                  | Fitness | Kp   | Ti    | Execution Time (s) |
|---------------------------|---------|------|-------|--------------------|
| Exhaustive Search         | 0.2291  | 0.60 | 15.00 | 82                 |
| PSO                       | 0.2292  | 0.60 | 14.90 | 107                |
| Firefly                   | 0.2513  | 0.69 | 19.78 | 108                |
| Genetic Algorithm (GA)    | 0.2291  | 0.60 | 15.00 | 33                 |
| Artificial Bee Colony     | 0.2291  | 0.60 | 15.20 | 363                |

> **Note:**  
> The exhaustive search result is used exclusively as a **reference optimum** within the evaluated parameter grid.  
> For metaheuristic methods, the reported fitness corresponds to the **best-so-far solution found within the fixed iteration budget**.


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

## ⚠️ Disclaimer

This repository is intended for **educational and research purposes only**.

The control strategies, optimization algorithms, and parameter values presented
here are **not directly validated for industrial deployment**.
They must be independently verified, tested, and adapted
before being applied to real industrial systems.

The author assumes no responsibility for misuse of the provided material.



## 🤝 Support Projects

Support my work on Patreon:  
https://www.patreon.com/c/CrissCCL


## 📜 License

MIT License


