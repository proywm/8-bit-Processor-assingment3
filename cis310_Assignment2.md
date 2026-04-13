# Assignment 2: Implementing a Register File and ALU

Building on your foundational work with registers and memory in the first assignment, this assignment focuses on designing and implementing a **Register File** and an **Arithmetic Logic Unit (ALU)** in the **Digital** simulator. You will integrate the register file (with two simultaneous read ports and one write port) and an ALU that performs specific arithmetic operations (as shown in the provided table).

---

## Objective

By the end of this assignment, you will:
- Design a **Register File** with four 8-bit General Purpose Registers (R0, R1, R2, R3).
- Provide two read ports and one write port for the register file.
- Implement an **ALU** capable of performing the listed arithmetic and transfer operations.
- Integrate the register file and ALU to demonstrate data flow and operations on register data.

---

## 1. Setting Up the Digital Simulator

1. **Create a New Project**  
   - Open **Digital** (by H. Neemann) and start a new project.  
   - Save the project as `RegisterFile_ALU`.

2. **Organize Your Workspace**  
   - Use separate subcircuits or neatly labeled sections for each component:
     - **Register File** subcircuit
     - **ALU** subcircuit
   - Clearly label all inputs, outputs, and control signals.

---

## 2. Designing the Register File

### 2.1 Overview

You will create four 8-bit registers: **R0**, **R1**, **R2**, **R3**. The register file must allow:
- **Two simultaneous reads** (using two 4-to-1 multiplexers internally).
- **One write** to a selected register.
- External signals to specify which registers to read from and write to.

### 2.2 Inputs and Outputs

1. **Read Register 1 (2 bits)**  
   - Selects which register (R0–R3) is connected to **Read Data 1**.

2. **Read Register 2 (2 bits)**  
   - Selects which register (R0–R3) is connected to **Read Data 2**.

3. **Write Register (2 bits)**  
   - Selects which register (R0–R3) will be written to (when the write enable signal is active).

4. **Ctrl Registers (8 bit)**  
   - Selects operations on the registers. We split 8 bit into 4 chunks. Each chunk represents corresponding register's operations.

5. **Write Data (8 bits)**  
   - The 8-bit input value to be written into the selected register (if Write Enable is active).

6. **Read Data 1 (4 bits)** and **Read Data 2 (4 bits)**  
   - The outputs of the two selected registers.

### 2.3 Implementation Steps

1. **Create Four 8-bit Registers**  
   - Label them **R0**, **R1**, **R2**, **R3**.
   - Each register should have an enable/clock input to control writing.

2. **Reading from Registers**  
   - Use two **4-to-1 multiplexers** to select the register output for **Read Data 1** and **Read Data 2**.
   - The select lines of each multiplexer connect to **Read Register 1** and **Read Register 2** respectively.

3. **Writing to a Register**  
   - Decode the 2-bit **Write Register** input to generate four enable signals (one per register).  
   - Combine each decoded enable signal with the **Ctrl Registers** line to determine if a particular register should latch the **Write Data**.

4. **Testing the Register File**  
   - Drive **Read Register 1** and **Read Register 2** with test values (00, 01, 10, 11).
   - Enable writes to each register in turn and verify that the correct data appears on **Read Data 1** and **Read Data 2**.

---

## 3. Implementing the ALU

### 3.1 ALU Functionality

Your ALU should implement the following operations based on the 3-bit control signals \(\{S_1, S_0, C_{in}\}\):

| S<sub>1</sub> | S<sub>0</sub> | C<sub>in</sub> | Input to ALU | Output (D)        | Micro Operation         |
|:-------------:|:-------------:|:--------------:|:------------:|:------------------:|:------------------------:|
| 0             | 0             | 0              | B            | A + B              | Add                     |
| 0             | 0             | 1              | B            | A + B + 1          | Add with Carry          |
| 0             | 1             | 0              | B̅           | A + B̅           | Subtract with Borrow    |
| 0             | 1             | 1              | B̅           | A + B̅ + 1              | Subtract                |
| 1             | 0             | 0              | 0          | A                  | Transfer A              |
| 1             | 0             | 1              | 0           | A + 1              | Increment A             |
| 1             | 1             | 0              | 1           | A - 1              | Decrement A             |
| 1             | 1             | 1              | 1           | A                  | Transfer A              |

**Notes:**
- **B̅** denotes the bitwise complement of B.
- The ALU has two 8-bit inputs: **A** and **B**.
- The ALU has a 8-bit output: **D**.
- \(\{S_1, S_0, C_{in}\}\) determine which operation is performed.

### 3.2 Implementation Steps

1. **Input Lines**  
   - Two 8-bit inputs: **A** and **B**.
   - Three control bits: **S1**, **S0**, and **Cin**.

2. **Output Line**  
   - One 8-bit output: **D** (the result).

3. **Internal Design**  
   - Use a **8-bit adder** that can also handle subtraction.  
     - For subtraction, invert B and add 1 when necessary.  
     - For increment/decrement, feed A into the adder with constant inputs for B (e.g., `0001` for increment, `1111` for decrement).
   - Use multiplexers and/or logic gates to select whether to pass `B`, `B̅`, or a constant (for increment/decrement).
   - Use additional logic to pass **A** directly (Transfer A).

4. **Testing the ALU**  
   - Apply test vectors to **A** and **B** and vary \(\{S_1, S_0, C_{in}\}\) to check each operation:
     - **Add** (A + B)
     - **Add with Carry** (A + B + 1)
     - **Subtract** (A - B) and **Subtract with Borrow** (if needed)
     - **Transfer A**
     - **Increment A**
     - **Decrement A**

---



## 5. Submission Requirements

1. **Project File**  
   - Submit the `RegisterFile_ALU` circuit files in a Github repository (or another specified submission platform).

2. **Documentation**  
   - A brief report explaining:
     - **Register File Design**: How you created two read ports and one write port.  
     - **ALU Implementation**: How you handled add, subtract, increment, decrement, and transfer operations.  
     - **Testing**: Show input/output waveforms or screenshots demonstrating each operation.

4. **Group Submission**  
   - You may work in groups of up to **three members**. Each member should submit an individual report, clearly indicating their contributions.

---

## Conclusion

By completing this assignment, you will deepen your understanding of **register file** architecture—where multiple registers can be read from and written to in the same cycle—and of the **ALU** that manipulates register data according to control signals. Mastery of these concepts is essential for designing more advanced CPU components, including control units, pipelines, and complex instruction sets in future projects.

