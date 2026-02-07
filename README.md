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


<table align="center">
  <tr>
    <td align="center">
      <img alt="Loop diagram"
           src="https://github.com/user-attachments/assets/63206eb0-f6d7-4aab-8958-d43ca0dbf8d9"
           width="450">
    </td>
    <td align="center">
      <img alt="Tank system"
           src="https://github.com/user-attachments/assets/cb2c5ea4-0884-4866-a1bc-5da1a3cd7daa"
           width="200">
    </td>
  </tr>
</table>


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
### Fitness Evolution Comparison
> **Important note (Optimality vs. Best Fitness):**  
> In this study, the **Exhaustive Search** is used as the **reference optimum** within the evaluated parameter grid/bounds.  
> For the metaheuristic methods (PSO, GA, Firefly, ABC, Bat), the reported curves correspond to the **best-so-far fitness found during the search**,which **does not necessarily imply global optimality**.  
> Convergence is therefore evaluated based on **proximity to the reference optimum** and **how efficiently each algorithm reaches that region of the search space**.


<p align="center">
  <img alt="result" src="https://github.com/user-attachments/assets/f12908db-7383-4404-9525-13751e2158fc" width="700">
</p>

## 🧾 Convergence Metrics (Best-So-Far Fitness)

The following table summarizes convergence behavior using the stored `global_fitness` histories:

- **MaxBestFitness:** maximum best-so-far fitness reached during the run  
- **IterAtMax:** first iteration where the maximum best-so-far fitness is reached  
- **IterToRef:** first iteration where the method reaches the *reference optimum region* (exhaustive baseline, within tolerance)  
- **ExecTime_s:** total execution time for the run  
- **Score:** time-weighted score (higher is better), combining best fitness and runtime penalty

> **Note:** Metaheuristics were executed with a limited iteration budget, so values represent the *best solution found within that budget*.

| Technique | MaxBestFitness | IterAtMax | IterToRef | ExecTime (s) | Score |
|----------|----------------:|----------:|----------:|-------------:|------:|
| GA       | 0.22916         | 7         | 7         | 33           | 0.17230 |
| Firefly  | 0.25134         | 79        | 7         | 108          | 0.12084 |
| PSO      | 0.22921         | 17        | 10        | 107          | 0.11073 |
| ABC      | 0.22921         | 82        | 82        | 363          | 0.04950 |

### Key Observations
- **GA** reaches the reference region fastest (**IterToRef = 7**) and has the best time-weighted score due to the shortest runtime.
- **PSO** reaches the reference region within the budget (**IterToRef = 10**) with stable convergence, but with higher runtime than GA.
- **ABC** reaches the reference region, but much later (**IterToRef = 82**) and with the highest runtime, resulting in the lowest score.
- **Firefly** achieves the highest maximum best-so-far fitness, but does so late (**IterAtMax = 79**). This indicates convergence toward a different optimum region under the current objective/constraints and algorithm settings.

## ✅ Advantages, Limitations, and Opportunities

### Genetic Algorithm (GA)
**Advantages**
- Fast convergence to the reference region (low **IterToRef**)
- Lowest execution time among tested metaheuristics

**Limitations**
- Performance is sensitive to selection/crossover/mutation settings
- Can converge prematurely depending on diversity control

**Opportunities**
- Add elitism + adaptive mutation to improve robustness
- Increase population diversity metrics (avoid premature convergence)

### Particle Swarm Optimization (PSO)
**Advantages**
- Stable convergence behavior and competitive fitness
- Simple parameterization and good baseline metaheuristic for PI tuning

**Limitations**
- Runtime higher than GA in this implementation
- Can stagnate without inertia/acceleration tuning

**Opportunities**
- Use adaptive inertia / acceleration schedules
- Add velocity clamping or constriction factor to reduce stagnation

### Firefly Algorithm
**Advantages**
- Capable of exploring alternative optima (highest **MaxBestFitness** observed)
- Strong exploration behavior under stochastic movement

**Limitations**
- Requires more iterations to stabilize (high **IterAtMax**)
- Sensitive to tuning (α, β, γ) and scale of the search space

**Opportunities**
- Tune α decay across iterations (exploration → exploitation)
- Normalize parameter scales and use bounded random steps

### Artificial Bee Colony (ABC)
**Advantages**
- Reaches the reference region under constraints (eventually)
- Robust exploration through scout/employee behavior

**Limitations**
- High computational cost in this implementation (largest runtime)
- Slow convergence under limited-iteration budgets (high **IterToRef**)

**Opportunities**
- Reduce redundant evaluations (cache fitness for repeated candidates)
- Tune limits/scout rate and step generation to accelerate exploitation


## 📊 Comparative Summary

The table below provides a qualitative comparison of the evaluated optimization techniques
based on **fitness level**, **computational cost**, and **convergence behavior**.
The exhaustive search is used as a **reference solution** within the evaluated parameter grid.

Metaheuristic algorithms were executed with a **limited number of iterations (10)**;
therefore, the reported results correspond to the **best-so-far solution found within that budget**,
which may represent either a global or a local optimum.

| Algorithm              | Fitness Level        | Computation Time | Notes                                                        |
|------------------------|----------------------|------------------|--------------------------------------------------------------|
| Exhaustive Search      | Reference optimum    | Medium           | Guarantees optimality within the grid                        |
| PSO                    | Near-reference       | Medium           | Stable convergence toward reference solution                 |
| Genetic Algorithm (GA) | Reference-equivalent | Low              | Fast convergence in few generations                          |
| Firefly Algorithm      | Higher fitness value | Medium           | Converges to a different (local) optimum                     |
| ABC                    | Reference-equivalent | Very High        | Achieves reference solution with high computational cost     |

> Fitness values are not directly comparable across different local optima when constraints
> and objective scaling differ; convergence behavior and computational cost are therefore
> equally relevant evaluation criteria.



## 📊 Comparative Performance Summary (Quantitative Results)


The table below summarizes the updated performance results obtained for each optimization technique.
For the metaheuristic algorithms, **10 iterations** were used, as shown in the fitness evolution plots,
which allow identifying **which method reaches the global or local optimum first**.

Metaheuristic optimization methods are employed to **accelerate the search for optimal controller parameters**
by avoiding the exhaustive evaluation of all possible parameter combinations, as performed by exhaustive search.
While exhaustive search guarantees finding the reference optimum within the evaluated grid,
it can become **computationally expensive** for large search spaces.

In contrast, metaheuristic methods provide a **computationally efficient alternative**,
trading guaranteed optimality for faster convergence toward near-optimal or optimal solutions.

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
> The exhaustive search result is used as a **reference optimum within the evaluated parameter grid**.
> For metaheuristic methods, the reported fitness corresponds to the **best-so-far solution**
> found within the limited number of iterations.


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


