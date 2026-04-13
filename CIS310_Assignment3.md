# Assignment 3 – Building an 8-bit CPU in **Digital**

## Overview

In this assignment you will combine everything you built in **Assignment 1** (PC, Instruction Memory, IR) and **Assignment 2** (Register File, ALU) into a working **8-bit CPU** in the **Digital** simulator by H. Neemann.

Your CPU will:

- Fetch **8-bit instructions** from an 8-bit-wide instruction memory (one word per instruction).
- Use a single **8-bit Instruction Register (IR)** to hold the current instruction.
- Execute instructions using your **Register File (R0–R3)** and **8-bit ALU**.
- Be controlled by a **4-state finite state machine (FSM)** implementing a simple pipeline:
  - FETCH → DECODE → EXECUTE → WRITEBACK → FETCH → …

The reference processor layout is shown below (your implementation should follow this structure):

![8-bit Processor Reference](8bit_processor_reference.png)

The processor has three clearly labeled stages:
1. **Instruction Fetch** — Program Counter, Instruction Memory (8B-Memory), Instruction Register (8-bit IR)
2. **Instruction Decode** — Splitters extract opcode, op1, op2, type fields; muxes route control signals
3. **Instruction Execution (Exec)** — Register File and 8-bit ALU compute and write back results

---

## Instruction Set

Your CPU supports **all 8 ALU operations** in both R-type and I-type format:

### R-type Instructions (type bit = 0)

In R-type, the ALU operates on register values. `op1` selects both the destination and the first operand (ALU input A = R[op1]). `op2` selects the second operand (ALU input B = R[op2]).

| Opcode (3 bits) | Instruction      | Meaning                          | ALU Control {S1,S0,Cin} |
|:----------------:|------------------|----------------------------------|:------------------------:|
| 000              | ADD Rd, Rs       | R[d] ← R[d] + R[s]              | 0 0 0                   |
| 001              | ADDC Rd, Rs      | R[d] ← R[d] + R[s] + 1          | 0 0 1                   |
| 010              | SUBB Rd, Rs      | R[d] ← R[d] + ~R[s] (sub borrow)| 0 1 0                   |
| 011              | SUB Rd, Rs       | R[d] ← R[d] − R[s]              | 0 1 1                   |
| 100              | PASS Rd          | R[d] ← R[d] (transfer A)        | 1 0 0                   |
| 101              | INC Rd           | R[d] ← R[d] + 1                 | 1 0 1                   |
| 110              | DEC Rd           | R[d] ← R[d] − 1                 | 1 1 0                   |
| 111              | PASS Rd          | R[d] ← R[d] (transfer A)        | 1 1 1                   |

### I-type Instructions (type bit = 1)

In I-type, the **op2 field serves as a 2-bit immediate value** (0–3). The immediate is zero-extended to 8 bits and fed to ALU input A instead of R[op1]. The most useful I-type instruction is **LDI** (Load Immediate):

| Opcode | Instruction       | Meaning                                | ALU Control {S1,S0,Cin} |
|:------:|--------------------|----------------------------------------|:------------------------:|
| 100    | LDI Rd, #imm2     | R[d] ← imm2 (zero-extended to 8 bits) | 1 0 0                   |

> **How LDI works:** The type bit = 1 routes the immediate (from op2) to ALU input A. Opcode 100 is "Transfer A" (Output = A + 0 + 0 = A). So the ALU simply passes the immediate through, and it gets written to R[d] during WRITEBACK.

> **Note:** Other I-type opcode combinations are technically valid (e.g., I-type ADD would compute `imm + R[imm_as_reg_index]`), but **LDI is the primary I-type instruction** you need to use.

---

## 1. Prerequisites (from Assignments 1 & 2)

You should already have the following subcircuits from previous assignments:

### From Assignment 1

- **Program Counter (PC)**
  - 8-bit register with 2-bit CTRL input:
    - `00` → Hold (load from self — no change)
    - `01` → Increment (PC ← PC + 1)
    - `10` → Clear (PC ← 0)
    - `11` → Set all bits (PC ← 0xFF)
  - Only **bits [2:0]** of the PC are used as the memory address (8 instruction slots).

- **Instruction Memory (8B-Memory)**
  - 8-bit data width, 8 addresses (0–7).
  - Address input: 3 bits (from PC[2:0]).
  - Data input: 8 bits (for programming instructions externally).
  - CTRL input: 2 bits (`00` = hold, `01` = store from external input).
  - Data output: 8 bits (instruction word).

- **Instruction Register (8-bit IR)**
  - 8-bit register with 2-bit CTRL:
    - `00` → Hold
    - `01` → Store (capture input from memory)
    - `10` → Clear
    - `11` → Set all bits
  - Receives input from instruction memory data output.

### From Assignment 2

- **Register File**
  - Four 8-bit registers: **R0, R1, R2, R3**.
  - Two read ports, one write port.
  - Inputs:
    - `Read_Register1[1:0]` – selects R0–R3 for output `Read_Data1`.
    - `Read_Register2[1:0]` – selects R0–R3 for output `Read_Data2`.
    - `Write_Register[1:0]` – selects destination register.
    - `Write_data[7:0]` – 8-bit data to be written (from ALU output).
    - `ctrl[7:0]` – 8-bit control bus (2 bits per register, see Section 5).
  - Outputs:
    - `Read_Data1[7:0]`, `Read_Data2[7:0]`.

- **ALU (8-bit)**
  - Inputs:
    - `A[7:0]`, `B[7:0]`
    - Control bits `{S1,S0,Cin}` (3 bits) — comes directly from the **opcode** field.
  - Output:
    - `Output[7:0]` – result.
    - `Status` – carry out flag.
  - Internally uses a 4-to-1 mux to select the ALU's Y input:
    - `{S1,S0} = 00` → Y = B
    - `{S1,S0} = 01` → Y = ~B (bitwise complement)
    - `{S1,S0} = 10` → Y = 0x00
    - `{S1,S0} = 11` → Y = 0xFF
  - Then computes: `Output = A + Y + Cin`

---

## 2. Instruction Format

Each instruction is a single **8-bit word** stored at one memory address:

```
  Bit:   7   6   5   4   3   2   1   0
       [  opcode  ] [ op1 ] [ op2 ] [type]
       [S1  S0 Cin] [ d d ] [ s s ] [ T ]
```

| Field   | Bits    | Width | Description                                      |
|---------|---------|:-----:|--------------------------------------------------|
| opcode  | [7:5]   | 3     | ALU control = {S1, S0, Cin}                      |
| op1     | [4:3]   | 2     | Destination register (also Read_Register1, Write_Register) |
| op2     | [2:1]   | 2     | Source register (R-type) or 2-bit immediate (I-type) |
| type    | [0]     | 1     | 0 = R-type, 1 = I-type                          |

**Key design insight:** The opcode bits map **directly** to the ALU control signals `{S1, S0, Cin}`. No separate decode logic is needed for ALU control — just wire the opcode field straight to the ALU!

---

## 3. Pipeline Stages (4-State FSM)

### 3.1 Control Unit FSM

Implement a **4-state one-hot FSM** using four D flip-flops in a ring:

```
  FETCH → DECODE → EXECUTE → WRITEBACK → FETCH → …
```

One flip-flop is initialized to 1 (the FETCH flip-flop), all others to 0. On each clock edge, the active state shifts to the next:

| State      | Active Signal | What Happens                                    |
|------------|:------------:|-------------------------------------------------|
| FETCH      | `Inst_Fetch` | IR captures instruction from memory at PC address |
| DECODE     | `Inst_Decode`| Instruction fields decoded, register file read ports provide operands |
| EXECUTE    | `Inst_Exec`  | ALU computes result (combinational — output is stable) |
| WRITEBACK  | `Write_Back` | Register file writes ALU result to R[op1]; PC increments by 1 |

### 3.2 Control Signal Generation

| Control Signal    | When Active            | Purpose                                      |
|-------------------|------------------------|----------------------------------------------|
| `IR_ctrl = 01`    | FETCH state (and not programming) | IR captures instruction from memory |
| `IR_ctrl = 00`    | All other states       | IR holds its current value                   |
| `PC CTRL = 01`    | WRITEBACK state        | PC increments to next instruction address    |
| `PC CTRL = 00`    | All other states       | PC holds current value (stable for fetch)    |
| `RegFile_ctrl`    | WRITEBACK state        | Selected register gets CTRL=01 (store); all others get 00 (hold) |
| `RegFile_ctrl = 0`| All other states       | All registers hold (no writes)               |

### 3.3 Programming Mode vs Run Mode

The processor supports an external programming interface:

- **Programming mode** (`InstrMem_ctrl = 01`): External data is written to instruction memory at the current PC address. The IR is **prevented** from loading (a mux forces `IR_ctrl = 00`) so the instruction register ignores memory output during programming.
- **Run mode** (`InstrMem_ctrl = 00`): Normal execution. IR loads from memory during FETCH.

---

## 4. Top-Level Datapath (`8BitProcessor`)

Create a new top-level circuit and instantiate the following subcircuits:

- `8bit_PC` — Program Counter
- `8B_Memory` — Instruction Memory (8 locations × 8 bits)
- `8_bit_IR` — Instruction Register
- `RegisterFile` — Register File (R0–R3, 8 bits each)
- `8bitALU` — Arithmetic Logic Unit
- `ControlUnit` — 4-state FSM

### 4.1 External Inputs and Outputs

**Inputs:**

| Signal             | Width | Description                              |
|--------------------|:-----:|------------------------------------------|
| `clk`              | 1     | System clock                             |
| `InstrMem_input`   | 8     | Data to write into instruction memory    |
| `InstrMem_ctrl`    | 2     | Instruction memory control (01 = store)  |

**Outputs (expose these as probes for debugging):**

| Signal             | Width | Description                              |
|--------------------|:-----:|------------------------------------------|
| `Program_Counter`  | 3     | Current PC value (bits [2:0])            |
| `IR_output`        | 8     | Current instruction in the IR            |
| `IR_ctrl`          | 2     | IR control signal                        |
| `Inst_Fetch`       | 1     | Fetch state indicator                    |
| `Inst_Decode`      | 1     | Decode state indicator                   |
| `Inst_Exec`        | 1     | Execute state indicator                  |
| `Write_Back`       | 1     | Writeback state indicator                |
| `RegFile_ctrl`     | 8     | Register file control bus                |
| `ALU_output`       | 8     | ALU result                               |

### 4.2 Datapath Connections

#### Stage 1: Instruction Fetch

```
PC[2:0]  ──→  8B_Memory.Address_pin
8B_Memory.Data_output  ──→  8_bit_IR.Input
IR_ctrl  ──→  8_bit_IR.CTRL
```

- When `InstrMem_ctrl[0] = 0` (run mode): `IR_ctrl[0] = Inst_Fetch` — IR loads during FETCH.
- When `InstrMem_ctrl[0] = 1` (programming): `IR_ctrl[0] = 0` — IR does NOT load.
- `IR_ctrl[1]` is always 0.

Use a **2-to-1 mux** to select:
- `sel = InstrMem_ctrl[0]`
- `in_0 = Inst_Fetch` (normal run mode)
- `in_1 = 0` (programming mode)
- `out → IR_ctrl[0]`

#### Stage 2: Instruction Decode

Split the IR output into instruction fields using splitters:

```
IR_output[7:5]  ──→  opcode (3 bits) ──→  ALU.S_1_S_0_Carry_in
IR_output[4:3]  ──→  op1 (2 bits)    ──→  RegFile.Read_Register1, RegFile.Write_Register
IR_output[2:1]  ──→  op2 (2 bits)    ──→  RegFile.Read_Register2
IR_output[0]    ──→  type (1 bit)    ──→  ALU input A mux select
```

#### I-type Immediate Path

For I-type instructions, the `op2` field is used as a 2-bit immediate:

```
op2[1:0]  ──→  zero-extend to 8 bits: {6'b000000, op2[1:0]}
```

Use a **2-to-1 mux** to select ALU input A:
- `sel = type bit` (IR[0])
- `in_0 = Read_Data1` (R-type: A = R[op1])
- `in_1 = {6'b0, op2}` (I-type: A = zero-extended immediate)
- `out → ALU.A`

ALU input B is always `Read_Data2` (R[op2]) regardless of type.

#### Stage 3: Execution and Writeback

```
ALU.A  ←  (selected by type mux above)
ALU.B  ←  RegFile.Read_Data2
ALU.S_1_S_0_Carry_in  ←  opcode (IR[7:5])
ALU.Output  ──→  RegFile.Write_data
```

---

## 5. Register File Write Control

The register file uses an **8-bit control bus** (`ctrl[7:0]`) where each register gets 2 bits:

| Register | Control Bits | CTRL=01 Means |
|----------|:------------:|---------------|
| R0       | `ctrl[1:0]`  | Store (write) |
| R1       | `ctrl[3:2]`  | Store (write) |
| R2       | `ctrl[5:4]`  | Store (write) |
| R3       | `ctrl[7:6]`  | Store (write) |

To write to only one register during WRITEBACK, use a **4-to-1 mux** selected by `op1`:

| op1 (Write_Register) | RegFile_ctrl value | Binary       | Decimal |
|:---------------------:|:------------------:|:------------:|:-------:|
| 00 (R0)               | `0b00000001`       | `00000001`   | 1       |
| 01 (R1)               | `0b00000100`       | `00000100`   | 4       |
| 10 (R2)               | `0b00010000`       | `00010000`   | 16      |
| 11 (R3)               | `0b01000000`       | `01000000`   | 64      |

Then gate this with a **2-to-1 mux** controlled by `Write_Back`:

```
sel = Write_Back
in_0 = 0b00000000   (not writeback → all registers hold)
in_1 = (mux output above)   (writeback → selected register stores)
out → RegFile.ctrl
```

This ensures registers are only written during the WRITEBACK state.

---

## 6. PC Increment Logic

The Program Counter should:
- **Hold** during FETCH, DECODE, and EXECUTE (CTRL = `00`).
- **Increment by 1** during WRITEBACK (CTRL = `01`).

Wire:
```
PC.CTRL[0] = Write_Back
PC.CTRL[1] = 0
PC.Inc_by  = 8'b00000001 (constant 1)
```

This means `PC.CTRL = 01` only when `Write_Back = 1`, causing the PC to advance after each instruction completes.

---

## 7. Testing Your CPU in Digital

### 7.1 Programming Phase

To load a program, use the external `InstrMem_input` and `InstrMem_ctrl` signals:

1. Set `InstrMem_ctrl = 01` (store mode) and `InstrMem_input` to the instruction byte.
2. Pulse the clock — the instruction is stored at `memory[PC]`.
3. Set `InstrMem_ctrl = 00` and pulse the clock 3 more times — the FSM completes its cycle, and on WRITEBACK the PC increments.
4. Repeat for each instruction.

After programming all 8 instructions, the PC wraps around to 0 (since only bits [2:0] are used). Set `InstrMem_ctrl = 00` to enter run mode.

### 7.2 Example Test Program

The following program tests **all major operations**:

| Addr | Instruction     | Encoding (binary)   | Decimal | Expected Result        |
|:----:|-----------------|:-------------------:|:-------:|------------------------|
| 0    | LDI R1, #3      | `100 01 11 1`       | 143     | R1 = 3                 |
| 1    | LDI R2, #1      | `100 10 01 1`       | 147     | R2 = 1                 |
| 2    | ADD R1, R2      | `000 01 10 0`       | 12      | R1 = 3 + 1 = 4        |
| 3    | SUB R1, R2      | `011 01 10 0`       | 108     | R1 = 4 − 1 = 3        |
| 4    | INC R1          | `101 01 00 0`       | 168     | R1 = 3 + 1 = 4        |
| 5    | DEC R1          | `110 01 00 0`       | 200     | R1 = 4 − 1 = 3        |
| 6    | ADDC R1, R2     | `001 01 10 0`       | 44      | R1 = 3 + 1 + 1 = 5    |
| 7    | PASS R1         | `100 01 00 0`       | 136     | R1 = 5 (no change)    |

**Register trace after each instruction:**

```
Initial:  R0=0  R1=0  R2=0  R3=0
After 0:  R0=0  R1=3  R2=0  R3=0   ← LDI R1, #3
After 1:  R0=0  R1=3  R2=1  R3=0   ← LDI R2, #1
After 2:  R0=0  R1=4  R2=1  R3=0   ← ADD R1, R2
After 3:  R0=0  R1=3  R2=1  R3=0   ← SUB R1, R2
After 4:  R0=0  R1=4  R2=1  R3=0   ← INC R1
After 5:  R0=0  R1=3  R2=1  R3=0   ← DEC R1
After 6:  R0=0  R1=5  R2=1  R3=0   ← ADDC R1, R2
After 7:  R0=0  R1=5  R2=1  R3=0   ← PASS R1 (unchanged)
```

### 7.3 Hand-Encoding Instructions

To encode an instruction by hand:

1. Look up the **opcode** (3 bits) from the ALU operation table.
2. Determine **op1** (2 bits) — the destination register index.
3. Determine **op2** (2 bits) — the source register index (R-type) or immediate value (I-type).
4. Set **type** (1 bit) — 0 for R-type, 1 for I-type.
5. Concatenate: `opcode | op1 | op2 | type`
6. Convert the 8-bit binary to decimal for the test file.

**Example: SUB R1, R2**
- Opcode = `011` (SUB: A + ~B + 1)
- op1 = `01` (R1)
- op2 = `10` (R2)
- type = `0` (R-type)
- Binary: `011 01 10 0` = `01101100₂` = **108**

**Example: LDI R1, #3**
- Opcode = `100` (Transfer A)
- op1 = `01` (R1)
- op2 = `11` (immediate = 3)
- type = `1` (I-type)
- Binary: `100 01 11 1` = `10001111₂` = **143**

### 7.4 Signals to Probe

Add output pins for easier debugging:

- `Program_Counter[2:0]` — current instruction address
- `IR_output[7:0]` — current instruction
- `IR_ctrl[1:0]` — IR control (01 during fetch, 00 otherwise)
- `Inst_Fetch`, `Inst_Decode`, `Inst_Exec`, `Write_Back` — FSM state indicators
- `RegFile_ctrl[7:0]` — register write enable bus
- `ALU_output[7:0]` — ALU computation result

When you run the simulation, you should observe:

- **FETCH:** `IR_ctrl = 01`, IR captures instruction from memory.
- **DECODE/EXECUTE:** `IR_ctrl = 00`, IR holds. ALU output shows the computed value.
- **WRITEBACK:** `RegFile_ctrl` selects the destination register. `Program_Counter` increments.
- After WRITEBACK of `ADD R1,R2` → `ALU_output = 4`.
- After WRITEBACK of `SUB R1,R2` → `ALU_output = 3`.

### 7.5 Using the Test Script

A test script `test_8bit_processor.txt` is provided. Load it in Digital:

1. Open your top-level processor circuit.
2. Go to **Analysis → Test** or press the **Test** button.
3. Load `test_8bit_processor.txt`.
4. Run the test.

The test will:
1. Program all 8 instructions into memory.
2. Execute each instruction and verify ALU outputs and register behavior.

---

## 8. What to Submit

1. **Digital Project File(s)**
   - Top-level CPU circuit (`8BitProcessor`).
   - Subcircuits for: `8bit_PC`, `8B_Memory`, `8_bit_IR`, `RegisterFile`, `8bitALU`, `ControlUnit`.

2. **Test Program**
   - Use the provided `test_8bit_processor.txt` or create your own.
   - Demonstrate at least: LDI, ADD, SUB, INC, DEC.

3. **Short Report (≈2 pages)**
   - Block diagram of your CPU datapath (can be a screenshot from Digital).
   - Explanation of your 4-state FSM and how each state drives control signals.
   - Description of how an instruction flows through FETCH → DECODE → EXECUTE → WRITEBACK.
   - Screenshots or waveforms showing correct execution of the test program.

4. **Group Submission**
   - You may work in groups of up to **three members**. Each member should submit an individual report indicating their contributions.

---

## 9. ISA Quick Reference

### Registers

- 4 general-purpose registers: **R0, R1, R2, R3** (8 bits each).
- Register indices (2 bits): `00` = R0, `01` = R1, `10` = R2, `11` = R3.
- All registers initialize to 0.

### 8-bit Instruction Format

```
  [7:5]    [4:3]   [2:1]   [0]
  opcode    op1     op2    type
  (3 bit)  (2 bit) (2 bit) (1 bit)
```

### Complete Instruction Encoding Table

| Opcode | op1 | op2 | Type | Instruction      | Effect                     | Decimal Formula                  |
|:------:|:---:|:---:|:----:|------------------|----------------------------|----------------------------------|
| 000    | dd  | ss  | 0    | ADD Rd, Rs       | R[d] ← R[d] + R[s]        | `0*32 + dd*8 + ss*2 + 0`        |
| 001    | dd  | ss  | 0    | ADDC Rd, Rs      | R[d] ← R[d] + R[s] + 1    | `1*32 + dd*8 + ss*2 + 0`        |
| 010    | dd  | ss  | 0    | SUBB Rd, Rs      | R[d] ← R[d] + ~R[s]       | `2*32 + dd*8 + ss*2 + 0`        |
| 011    | dd  | ss  | 0    | SUB Rd, Rs       | R[d] ← R[d] − R[s]        | `3*32 + dd*8 + ss*2 + 0`        |
| 100    | dd  | xx  | 0    | PASS Rd          | R[d] ← R[d]               | `4*32 + dd*8 + 0`               |
| 101    | dd  | xx  | 0    | INC Rd           | R[d] ← R[d] + 1           | `5*32 + dd*8 + 0`               |
| 110    | dd  | xx  | 0    | DEC Rd           | R[d] ← R[d] − 1           | `6*32 + dd*8 + 0`               |
| 100    | dd  | imm | 1    | LDI Rd, #imm     | R[d] ← imm (0–3)          | `4*32 + dd*8 + imm*2 + 1`       |

> `dd` = destination register index (00–11), `ss` = source register index (00–11), `imm` = 2-bit immediate (00–11), `xx` = don't care (use 00).

### Quick Encoding Examples

| Instruction   | opcode | op1 | op2 | type | Binary     | Decimal |
|---------------|:------:|:---:|:---:|:----:|:----------:|:-------:|
| LDI R1, #3    | 100    | 01  | 11  | 1    | 10001111   | 143     |
| LDI R2, #2    | 100    | 10  | 10  | 1    | 10010101   | 149     |
| ADD R1, R2    | 000    | 01  | 10  | 0    | 00001100   | 12      |
| SUB R1, R2    | 011    | 01  | 10  | 0    | 01101100   | 108     |
| INC R1        | 101    | 01  | 00  | 0    | 10101000   | 168     |
| DEC R2        | 110    | 10  | 00  | 0    | 11010000   | 208     |
| ADDC R1, R2   | 001    | 01  | 10  | 0    | 00101100   | 44      |
| PASS R1       | 100    | 01  | 00  | 0    | 10001000   | 136     |

With this reference, you can hand-assemble programs and load them into instruction memory using the test script format.
