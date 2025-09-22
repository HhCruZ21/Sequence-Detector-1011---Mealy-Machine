# VHDL Sequence Detector with Assertions

## 📖 Project Overview
This project implements a **Mealy finite state machine (FSM)** to detect the sequence **"1011"** in a serial input stream with **overlap support**.  
The FSM is verified with a **self-checking testbench** that includes timing and functional assertions.  

Key features:
- Overlap-aware sequence detection
- Asynchronous reset and start
- Behavioral simulation with assertions for robust verification

---

## 🗂 Project Structure

/detector_project
├── src/                 # VHDL source files
│   └── det_cmp.vhd      # FSM sequence detector
├── tb/                  # Testbench files
│   └── det_cmp_tb.vhd   # Testbench with assertions
├── sim/                 # Optional simulation scripts
│   ├── run_vivado.tcl
│   └── run_models.pl
├── docs/                # Documentation
│   ├── assertions.md
│   └── timing_diagram.png
├── .gitignore           # Git ignore file for Vivado/ModelSim
└── README.md            # This file


---

## 🛠 Files Description

- **`src/det_cmp.vhd`**  
  Mealy FSM that detects the sequence `1011`. Outputs `seq_det` when the sequence is matched.  

- **`tb/det_cmp_tb.vhd`**  
  Testbench driving the FSM with a serial input stream.  
  Includes:
  - Clock generation
  - Reset and start signal
  - Input stimulus
  - Assertions (clock period, reset pulse width, input timing, functional correctness)

- **`sim/`**  
  Optional directory to store your simulation scripts (Tcl for Vivado, do-files for ModelSim).  

- **`docs/`**  
  Contains detailed explanation of assertions and timing diagrams.  

---

## ✅ Assertions Overview

1. **Clock Period Check**  
   Ensures clock period is not faster than `min_clk_period` (e.g., 20 ns).  
   Protects against invalid simulation conditions.

2. **Reset Pulse Width Check**  
   Ensures asynchronous reset is asserted long enough for reliable initialization.  

3. **Setup/Hold Timing Check for `din`**  
   Validates input signal timing relative to clock to prevent metastability in real hardware.  

4. **Functional Sequence Check**  
   Confirms FSM asserts `seq_det` only when the input sequence `1011` is detected.  
   Prevents false positives or missed detections.

---

## ▶️ How to Run Simulation

### Vivado
```tcl
# Open project
open_project detector_project.xpr

# Launch simulation
launch_sim

# Run simulation for specified time
run 500 ns
