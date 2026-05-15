EXP7 – LightChaser
Aim
To design and verify a LightChaser module that performs circular left rotation of LEDs at fixed clock intervals.

Objective
Rotate LED output left after a fixed number of clock cycles.
Hold LED state when enable is LOW.
Resume rotation when enable becomes HIGH.
Initialize LED output to 00000001 during reset.
Design Description
The LightChaser module is a rotating LED controller implemented using sequential logic.

Features:

Circular left shift operation.
Parameterized LED width.
Parameterized delay between rotations using TICKS_PER_STEP.
Active-low asynchronous reset.
Pause and resume support using enable signal.
The design uses:

A tick counter to count clock cycles.
A rotation function for circular shifting.
Sequential always_ff block for synchronous operation.
Inputs and Outputs
Signal	Direction	Description
clk	Input	System clock
rst_n	Input	Active-low reset
enable	Input	Enables LED rotation
led_out	Output	Rotating LED pattern
Working Principle
During reset, LED output becomes 00000001.
When enable is HIGH:
Counter increments every clock cycle.
After TICKS_PER_STEP cycles, LED rotates left.
When enable is LOW:
Counter pauses.
LED output remains unchanged.
Rotation wraps around circularly.
Example: 00000001 → 00000010 → 00000100 → ... → 10000000 → 00000001

Test Cases Performed
Reset verification
Basic LED rotation
Pause and resume operation
Wrap-around rotation
Enable toggling
Continuous rotation check
Simulation Result
The LightChaser module successfully rotated the LED pattern according to the configured timing and passed all test cases.

Result
The LightChaser module was designed and verified successfully using SystemVerilog.