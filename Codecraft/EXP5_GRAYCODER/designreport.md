**GrayCoder Design Report**
**Aim**
To design and verify a GrayCoder module that converts 4-bit binary input into Gray code.

**Design Description**
The GrayCoder module converts binary input to Gray code using XOR operation between the binary number and its right-shifted version.

Gray Code Formula: Gray = Binary ^ (Binary >> 1)

**Files**
Design/graycoder.v
TB/tb_graycoder.v

**Simulation**
Simulation was performed using EDA Playground with Icarus Verilog.

**Results**
The module successfully converted all binary inputs into correct Gray code outputs.

**Conclusion**
The GrayCoder module correctly performs binary-to-Gray code conversion.