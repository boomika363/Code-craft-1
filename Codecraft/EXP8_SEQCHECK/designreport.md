# EXP8 – SeqCheck

## Aim
To design and verify a SeqCheck module that detects a specified number of rising edges within a sliding window of clock cycles.

---

## Objective
- Detect rising edges in the input signal.
- Count rising edges occurring within a window of W clock cycles.
- Generate a one-cycle pulse when the count reaches threshold K.
- Synchronize asynchronous input signals using a 2-stage synchronizer.

---

## Design Description
The SeqCheck module monitors an input signal and detects rising edges.  
A ring buffer stores recent edge detections within a sliding window.

Features:
- 2-stage synchronizer for stable input sampling.
- Rising edge detection logic.
- Sliding window edge counter.
- One-cycle hit pulse generation.
- Active-low asynchronous reset.

The design uses:
- Shift-register style ring buffer.
- Running edge count.
- Circular indexing logic.

---

## Inputs and Outputs

| Signal | Direction | Description |
|---|---|---|
| clk | Input | System clock |
| rst_n | Input | Active-low reset |
| in_sig | Input | Input signal |
| hit | Output | Pulse output when threshold is reached |

---

## Working Principle
1. Input signal is synchronized using two flip-flops.
2. Rising edges are detected using present and previous signal values.
3. Rising edges are stored in a sliding window buffer.
4. Edge count is continuously updated.
5. When the number of rising edges within the window becomes greater than or equal to K, the module generates a one-cycle pulse on `hit`.

Example:
- W = 5 cycles
- K = 3 rises

If 3 rising edges occur within any 5-cycle window, `hit` becomes HIGH for one clock cycle.

---

## Test Cases Performed
- Rising edges within window
- Rising edges outside window
- Dense edge patterns
- Reset verification
- Long HIGH signal check
- Alternating input pattern
- No-edge condition

---

## Simulation Result
The SeqCheck module successfully detected rising edge sequences within the specified window and generated correct hit pulses for all test cases.

---

## Result
The SeqCheck module was designed and verified successfully using SystemVerilog.