# JoltPhysics3DJoint RobotArm

![Godot Engine 4.6](https://img.shields.io/badge/Godot-4.6+-478CBF?logo=godot-engine&logoColor=white)
![Jolt Physics](https://img.shields.io/badge/Physics-Jolt-red)

A high-performance robotics simulation project for **Godot 4.6**, utilizing the **native Jolt Physics** engine. This project implements industrial-grade joint control by transitioning from basic hinges to a sophisticated **6-DOF Servo Control** model, providing a robust foundation for researchers and hobbyists interested in realistic 3D kinematics.

---

## 📖 Introduction
This project features a 5-axis robotic arm fully simulated within Godot 4.6. By leveraging the advanced capabilities of **Jolt Physics**, it achieves high-fidelity motion that eliminates common simulation artifacts like "joint jitter" or "spongy constraints."

This work is a modern refactor and upgrade of the [Enhanced HingeJoint3D](https://github.com/jdarc/Godot-Enhanced-HingeJoint3D) project by **jdarc**, specifically optimized for the 2026 high-performance simulation standards.

---

## ✨ Features
* **5-Axis Independent Control**: Precision management of Base, Arm, Wrist, and dual Claw components.
* **High-Fidelity Joint Simulation**: Uses `Generic6DOFJoint3D` to ensure rigid mechanical connections and prevent stretching under load.
* **Real-time Visual Feedback**: A clean UI dashboard with interactive progress bars for live angle monitoring.
* **Safety Constraints**: Integrated soft and hard limits (-90° to 90°) to prevent mechanical self-intersection.
* **Advanced Servo Logic**: Combines spring stiffness with motor velocity for smooth, weighted movements.

---

## 🛠 Core Methodology & Optimizations

### 1. From Hinge to 6-DOF
Unlike standard hinge joints, this project utilizes **Generic 6-Degrees-of-Freedom (6-DOF) joints**. This configuration allows for the absolute locking of all three linear translation axes, ensuring that arm segments remain perfectly attached even during high-speed rotations.



### 2. Spring-Position Servo Control
The project moves away from simple velocity motors in favor of a **Position Servo Model**:
* **Targeting**: The `Equilibrium Point` of the angular spring serves as the "Target Angle."
* **Damping**: High damping values are applied to absorb high-frequency oscillations (eliminating the "jelly effect").
* **Force Limiting**: Motors provide the necessary torque to overcome gravity, while the spring ensures precise alignment.

### 3. Local Coordinate Angle Extraction
A common issue in robotics simulation is "Linkage Contamination," where moving a parent joint affects the reading of a child joint. This project solves this using **Affine Inverse Transformation**.
* **Method**: By calculating the transform of the child body relative to the joint's own basis, the system extracts a pure local angle.
* **Result**: Every UI reading is 100% accurate relative to its specific pivot, regardless of the arm's global posture.

### 4. Jolt Physics Tuning
* **Solver Iterations**: Optimized to **64** for stable mechanical constraints.
* **ERP Optimization**: Native Jolt property mapping is used to bypass legacy Godot Physics parameter warnings.

---

## 🚀 Usage Guide

### 1. Setup
Download the repository files to your local directory and open the project using **Godot 4.6** or later. Ensure the **Godot Jolt** extension is enabled in your Project Settings.

### 2. Running the Scene
Open the file `example.tscn` and press F5 to run.

### 3. Key Mappings
| Action | Keys |
| :--- | :--- |
| **Camera Movement** | W, A, S, D |
| **Camera Height** | Q (Down), E (Up) |
| **Base Rotation** | U (-), I (+) |
| **Arm Pivot** | H (-), J (+) |
| **Wrist Rotation** | O (-), P (+) |
| **Claw 1 (Left)** | K (-), L (+) |
| **Claw 2 (Right)** | N (-), M (+) |
| **Reset Pose** | R |

### 4. UI Dashboard
* **Progress Bars**: Represent the current rotation relative to the full mechanical range (-180° to 180°).
* **Degree Labels**: Display the specific physical angle extracted from the Jolt engine, accurate to 0.1°.

---

## 🔗 Credits & References
* **Original Project**: [Enhanced HingeJoint3D](https://github.com/jdarc/Godot-Enhanced-HingeJoint3D) by **jdarc**.
* **Physics Engine**: [Godot Jolt](https://github.com/godot-jolt/godot-jolt).

---

## 📄 License
This project is released as open-source. When using this for secondary development, please provide credit to the original contributors.
