# PulseTracer Design Report

## Aim
To design and verify a PulseTracer module that filters noisy input signals and generates a single pulse for a stable valid signal.

## Design Description
The PulseTracer module uses a debounce filter implemented using a shift register. The noisy input signal is sampled for multiple clock cycles. If the signal remains stable for FILTER_LEN cycles, it is considered valid.

A pulse is generated only during the rising edge of the debounced signal.

## Files
- Design/PulseTracer.v
- TB/tb_PulseTracer.v

## Simulation
Simulation was performed using EDA Playground with Icarus Verilog.

## Results
The module successfully:
- Rejected short glitches
- Generated single pulses for stable inputs
- Avoided multiple pulses during long high signals

## Conclusion
The PulseTracer design correctly filters noise and generates reliable pulse outputs.