**EvenOddFSM Design Report**
**Aim**
To design and verify an FSM-based module that identifies whether the input number is even or odd.

**Design Description**
The EvenOddFSM module checks the least significant bit (LSB) of the input number. If the LSB is 0, the number is even; otherwise, it is odd.

The outputs are updated only when in_valid is high. If in_valid is low, the previous state is retained.

**Files**
Design/evenoddfsm.v
TB/tb_evenoddfsm.v
Simulation
Simulation was performed using EDA Playground with Icarus Verilog.

**Results**
The module successfully:

Identified even numbers
Identified odd numbers
Held state when in_valid was low
Passed reset and edge test cases
**Conclusion**
The EvenOddFSM module correctly classifies numbers as even or odd.