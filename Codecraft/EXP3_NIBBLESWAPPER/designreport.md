NibbleSwapper Design Report Aim To design and verify a NibbleSwapper module that swaps upper and lower 4-bit nibbles of an 8-bit input when swap_en is enabled.

Design Description The module swaps the upper and lower nibbles of the input data using concatenation operation. The swapping operation occurs only when swap_en is high. When swap_en is low, the previous output value is retained.

Files Design/nibbleswapper.v TB/tb_nibbleswapper.v Simulation Simulation was performed using EDA Playground with Icarus Verilog.

Results The module successfully:

Swapped upper and lower nibbles Held output when swap_en was low Passed reset and edge test cases

Conclusion The NibbleSwapper module correctly performs conditional nibble swapping operation.