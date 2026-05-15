Aim To design and verify a BitBalancer module that checks whether the number of 1’s and 0’s in the input data are equal.

**Design Description **The BitBalancer module analyzes an 8-bit input signal and counts the number of 1’s and 0’s present in the data. The input is processed using a loop that iterates through each bit and updates two counters.

If the number of 1’s is equal to the number of 0’s, the output signal is set HIGH. Otherwise, the output remains LOW. The design operates synchronously with the clock and includes an active-low reset for proper initialization.

Files Design/bitbalancer.v TB/tb_bitbalancer.v

Simulation Simulation was performed using EDA Playground with Icarus Verilog.

Results The module successfully:

Counted the number of 1’s and 0’s correctly Detected balanced and unbalanced input patterns Produced correct output for all test cases

Conclusion The BitBalancer design correctly identifies whether the input data is balanced and functions as expected.