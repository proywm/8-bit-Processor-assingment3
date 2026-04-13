# CIS 310 — Assignment 3: Building an 8-bit CPU

## Overview

In this assignment you will build a working **8-bit processor** in the **Digital** simulator (by H. Neemann) by integrating the components you created in Assignments 1 and 2:

- **Assignment 1:** Program Counter, Instruction Memory (SRAM), Instruction Register
- **Assignment 2:** Register File (R0–R3), 8-bit ALU

Your processor will fetch, decode, execute, and write back 8-bit instructions using a **4-state pipeline FSM**:

```
FETCH → DECODE → EXECUTE → WRITEBACK → (repeat)
```

## Repository Contents

| File | Description |
|------|-------------|
| `CIS310_Assignment3.md` | **Full assignment specification** — read this first |
| `test_8bit_processor.txt` | Test script for the Digital simulator |
| `README.md` | This file |

## Quick Start

1. Read **`CIS310_Assignment3.md`** for the complete assignment details, instruction set, datapath wiring, and FSM design.
2. Open the **Digital** simulator and build your processor following the block diagram in the assignment.
3. Use **`test_8bit_processor.txt`** to test your implementation (Analysis → Test in Digital).

## Instruction Format

Each instruction is a single 8-bit word:

```
  Bit:  [7  6  5] [4  3] [2  1] [0]
        [opcode ] [op1 ] [op2 ] [type]
        [S1 S0 Cin] [dd ] [ss  ] [ T ]
```

- **opcode** (3 bits) — maps directly to ALU control `{S1, S0, Cin}`
- **op1** (2 bits) — destination register index (R0–R3)
- **op2** (2 bits) — source register (R-type) or 2-bit immediate (I-type)
- **type** (1 bit) — `0` = R-type, `1` = I-type

## Supported Instructions

| Opcode | R-type (T=0) | Effect |
|:------:|--------------|--------|
| 000 | ADD Rd, Rs | R[d] ← R[d] + R[s] |
| 001 | ADDC Rd, Rs | R[d] ← R[d] + R[s] + 1 |
| 010 | SUBB Rd, Rs | R[d] ← R[d] + ~R[s] |
| 011 | SUB Rd, Rs | R[d] ← R[d] − R[s] |
| 100 | PASS Rd | R[d] ← R[d] |
| 101 | INC Rd | R[d] ← R[d] + 1 |
| 110 | DEC Rd | R[d] ← R[d] − 1 |

| Opcode | I-type (T=1) | Effect |
|:------:|--------------|--------|
| 100 | LDI Rd, #imm | R[d] ← imm (0–3) |

## Test Program

The provided test script programs and executes 8 instructions:

| Addr | Instruction | Decimal | Expected |
|:----:|-------------|:-------:|----------|
| 0 | LDI R1, #3 | 143 | R1 = 3 |
| 1 | LDI R2, #1 | 147 | R2 = 1 |
| 2 | ADD R1, R2 | 12 | R1 = 4 |
| 3 | SUB R1, R2 | 108 | R1 = 3 |
| 4 | INC R1 | 168 | R1 = 4 |
| 5 | DEC R1 | 200 | R1 = 3 |
| 6 | ADDC R1, R2 | 44 | R1 = 5 |
| 7 | PASS R1 | 136 | R1 = 5 |

## Submission Requirements

1. **Digital project files** — top-level `8BitProcessor` circuit and all subcircuits
2. **Test results** — use the provided test script or create your own
3. **Short report (~2 pages)** — block diagram, FSM explanation, execution walkthrough, screenshots
4. Groups of up to **3 members** allowed; each member submits an individual report

See `CIS310_Assignment3.md` for complete details.
