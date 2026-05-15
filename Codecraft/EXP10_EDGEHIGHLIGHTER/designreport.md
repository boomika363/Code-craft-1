# EXP10 – EdgeHighlighter

## Aim
To detect rising and falling edges of an input signal and generate one-clock-cycle pulses.

---

## Description
The EdgeHighlighter module detects transitions in the input signal.

- Rising edge → rise_pulse becomes HIGH for 1 clock cycle
- Falling edge → fall_pulse becomes HIGH for 1 clock cycle

The design optionally uses a 2-stage synchronizer for stable signal synchronization.

---

## Inputs
- clk
- rst_n
- in_sig

## Outputs
- rise_pulse
- fall_pulse

---

## Working
1. Input signal passes through optional synchronizer.
2. Current signal is compared with previous signal.
3. Rising edge:
   - current = 1
   - previous = 0
4. Falling edge:
   - current = 0
   - previous = 1
5. Corresponding pulse is generated for one clock cycle.

---

## Result
The EdgeHighlighter module was successfully simulated and verified using waveform analysis.