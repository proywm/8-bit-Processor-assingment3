# Assignment 1: Implementing Registers and SRAM in Digital Simulator

Now that you are beginning your journey into computer architecture, this assignment will focus on designing and implementing essential components of a CPU: **Registers** and **Static RAM (SRAM)** using the **Digital** simulator by H. Neemann.

## Objective
By the end of this assignment, you will:
- Implement various types of **registers** (General Purpose Registers, Program Counter, Instruction Register).
- Design and integrate a **SRAM module** for memory storage.
- Simulate data transfer between registers and memory.
- Gain a fundamental understanding of data storage and retrieval within a CPU architecture.

---

## Step-by-Step Guide

### 1. Setting Up the Digital Simulator

1. **Create a New Project:**
   - Open **Digital** and start a new project.
   - Save the project as `Registers_SRAM`.
   
2. **Organize Your Workspace:**
   - Use separate subcircuits for different components.
   - Label each component appropriately (e.g., `PC`, `GPR`, `SRAM`).
   
---

### 2. Implementing Registers

#### a. General Purpose Registers (GPR)

1. **Purpose:**
   - Temporary storage for operands and computation results.
   
2. **Implementation:**
   - Create **four 8-bit registers** (`R0`, `R1`, `R2`, `R3`).
   - Add control signals for **Load (LD)**, **Store (ST)**, and **Clear (CLR)**.
   - Use a **multiplexer (MUX)** to select between different data sources when loading values into registers.
   - Ensure that each register can be written to and read from independently.

3. **Testing:**
   - Load values into each register and verify their content using output pins.

#### b. Program Counter (PC)

1. **Purpose:**
   - Keeps track of the next instruction to execute.
   
2. **Implementation:**
   - Use a **8-bit register** to store the current instruction address.
   - Connect an **Increment (INC) control signal** to update the PC value.
   - Use a **8-bit adder circuit** to implement the increment function:
     - Input A: Current PC value (stored in the register)
     - Input B: Constant `0001` (binary `1`)
     - Sum Output: New PC value (`PC + 1`)
     - Multiplexer (MUX) selects between the incremented value or a manually loaded value (for jumps).
   - Include control signals:
     - **Increment (INC)** → Selects `PC + 1` when `INC = 1`
     - **Load (LD)** → Loads a new address for jump operations when `LD = 1`
     - **Reset (RST)** → Clears PC to `0000` when `RST = 1`

3. **Testing:**
   - Verify that PC increments correctly when `INC = 1`.
   - Load a custom address into PC using `LD = 1` and check if the jump works.
   - Reset PC to `0000` using `RST = 1`.

#### c. Instruction Register (IR)

1. **Purpose:**
   - Stores the currently fetched instruction before execution.
   
2. **Implementation:**
   - Use a **8-bit register** for instruction storage.
   - Add control signals for **Load (LD)**.
   - Use a **multiplexer (MUX)** to select between different input sources when loading data into the instruction register.
   - Ensure that it can receive input from SRAM.

3. **Testing:**
   - Load different instruction values and verify the output.

---

### 3. Implementing SRAM Module

#### a. Memory Design

1. **Purpose:**
   - Provides data storage for instructions and operands.
   
2. **Implementation:**
   - Use a **8-bit wide, 16-address SRAM** component.
   - Design input pins for **Address**, **Data**, **Load/Store/Clear/Set FF**.

3. **Testing:**
   - Write values to specific addresses and read them back.
---

### 4. Submission Requirements

1. **Project File:** Submit the circuit files of your completed design using a Github repository.
2. **Documentation:** A brief report explaining:
   - Design choices for registers and SRAM.
   - Control signals used.
   - Test results with screenshots.
4. **Group Submission:** Assignments can be completed in groups of up to **two members**. Each member must submit an individual report specifying their contributions.

---

### Conclusion
By completing this assignment, you will develop a strong foundation in CPU design, specifically understanding how registers interact with memory. This will prepare you for more complex topics such as **ALU integration and control unit design** in future assignments.
