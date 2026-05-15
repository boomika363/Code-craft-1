**DebouncerLite Design Report**
**Aim**
To design and verify a DebouncerLite module that filters noisy input signals and produces stable debounced output.

**Design Description**
The DebouncerLite module uses:

**Two flip-flop synchronizers**
Counter-based debounce filtering
The output changes only after the input remains stable for N consecutive clock cycles.

**Files**
Design/debouncerlite.v
TB/tb_debouncerlite.v

**Simulation**
Simulation was performed using EDA Playground using SystemVerilog and Icarus Verilog.

**Results**
The module successfully:

Filtered short glitches
Handled bouncing inputs
Detected stable presses/releases
Passed reset and stress test cases

**Conclusion**
The DebouncerLite module correctly removes noise and stabilizes digital input signals.