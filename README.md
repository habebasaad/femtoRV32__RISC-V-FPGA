# femtoRV32 – RISC-V FPGA Implementation

> **CSCE 3301 – Computer Architecture**  
> **Project 1 | Milestone 3 Submission**

---

## Team

| Name | ID |
|------|------|
| Habeba Saad | 900232157 |
| Doha Nour El-Din | 900232246 |

---

# Overview

This project implements a **5-stage pipelined RISC-V processor** based on the **femtoRV32** architecture using **Verilog HDL**.

The processor supports the complete **RV32I instruction set** together with the **RV32IM multiplication and division extensions** as bonus features. The design was successfully implemented and verified on the **Digilent Nexys A7 FPGA board**.

Additionally, the project includes an **automated test generator** capable of generating assembly, binary, hexadecimal, and Verilog memory files for comprehensive processor testing.

---

# Features

## RV32I Instruction Support

✔ Arithmetic Instructions

- ADD
- SUB
- AND
- OR
- XOR
- SLT
- SLTU

✔ Shift Instructions

- SLL
- SRL
- SRA

✔ Load & Store Instructions

- LW
- SW
- LH
- LHU
- LB
- LBU
- SH
- SB

✔ Branch Instructions

- BEQ
- BNE
- BLT
- BGE
- BLTU
- BGEU

✔ Jump Instructions

- JAL
- JALR

✔ Upper Immediate Instructions

- LUI
- AUIPC

✔ System Instructions

The following instructions are recognized and implemented as **HALT** operations according to the project specifications.

- ECALL
- EBREAK
- PAUSE
- FENCE
- FENCE.TSO

---

# Bonus Features (RV32IM)

The processor also supports the complete multiplication and division extension.

### Multiplication

- MUL
- MULH
- MULHSU
- MULHU

### Division

- DIV
- DIVU
- REM
- REMU

Additional bonus features include:

- Automated test generator
- FPGA deployment on Nexys A7

---

# Processor Architecture

The processor implements a classic **5-stage pipeline**:

1. Instruction Fetch (IF)
2. Instruction Decode (ID)
3. Execute (EX)
4. Memory Access (MEM)
5. Write Back (WB)

### Pipeline Features

- Complete forwarding unit
- Pipeline flushing
- Structural hazard handling
- Data hazard forwarding
- Control hazard resolution
- Unified single-ported memory
- 2-cycle CPI due to shared instruction/data memory

---

# Datapath Components

The implementation includes:

- Program Counter (PC)
- Register File (32 Registers)
- Arithmetic Logic Unit (ALU)
- Immediate Generator
- Unified Memory (Instruction + Data)
- Control Unit
- ALU Control Unit
- Forwarding Unit
- Pipeline Flush Logic
- Data Memory Interface

---

# Verified Functionality

The following functionality has been completely verified:

- Instruction fetch
- Instruction decode
- Register read/write
- ALU execution
- Memory operations
- Branch execution
- Jump execution
- Pipeline forwarding
- Pipeline flushing
- Data hazard handling
- Control hazard handling
- Structural hazard handling
- Multiplication operations
- Division operations
- FPGA execution on Nexys A7

---

# Automated Test Generator

The project includes a test generator capable of automatically producing test programs.

Generated files include:

```
Test_instructions.txt
Test_asm.txt
Test_binary.v
Test_hex.txt
```

The generator allows users to specify the desired test name and automatically creates all required files in one folder.

---

# Assumptions

- Unified single-ported memory is shared between instructions and data.
- Memory is byte-addressable.
- Register x0 is permanently hardwired to zero.
- Pipeline operates with a 2-cycle CPI because of structural hazards.
- Branch prediction uses an **Always Not Taken** strategy.
- Reset initializes all registers and control signals.
- Multiplication and division complete in a single cycle.

---

# Release Notes

No issues remain in the final milestone.

The processor successfully supports:

- ✔ Complete RV32I instruction set
- ✔ 8 RV32IM bonus instructions
- ✔ Automated test generator
- ✔ Hazard handling
- ✔ FPGA implementation
- ✔ Comprehensive verification

All required functionality has been tested successfully.

---

# Final Results

✅ Complete RV32I processor

✅ Complete RV32IM bonus extension

✅ Full forwarding implementation

✅ Hazard detection and resolution

✅ Pipeline flushing

✅ Automated test generator

✅ FPGA implementation on Nexys A7

✅ Comprehensive testing of all **50 supported instructions**

---

## Repository Structure

```
.
├── src/
├── test_generator/
├── testcases/
├── simulation/
├── constraints/
├── documentation/
└── README.md
```

---

## Technologies

- Verilog HDL
- Vivado
- Nexys A7 FPGA
- RISC-V ISA (RV32I + RV32IM)

---

## Course Information

**Course:** CSCE 3301 – Computer Architecture

**Project:** femtoRV32 – RISC-V FPGA Implementation

**Milestone:** 3
