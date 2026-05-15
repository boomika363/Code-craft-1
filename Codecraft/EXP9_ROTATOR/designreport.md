# EXP9 – RotatorUnit

## Aim
To design and verify a RotatorUnit module that performs left and right circular rotation operations on a register.

---

## Objective
- Perform circular left rotation.
- Perform circular right rotation.
- Support synchronous data loading.
- Hold state when enable is LOW.
- Clear output during reset.

---

## Design Description
The RotatorUnit is a parameterized sequential circuit used for rotating binary data.

Features:
- Circular left and right rotation.
- Synchronous data loading.
- Enable-controlled operation.
- Active-low asynchronous reset.
- Parameterized data width.

The module rotates stored data by one bit position every clock cycle when enabled.

---

## Inputs and Outputs

| Signal | Direction | Description |
|---|---|---|
| clk | Input | System clock |
| rst_n | Input | Active-low reset |
| enable | Input | Enables rotation/load |
| load | Input | Loads input data |
| dir | Input | Rotation direction |
| data_in | Input | Input data |
| data_out | Output | Rotated output data |

---

## Working Principle
1. During reset, output becomes zero.
2. When enable is HIGH:
   - If load is HIGH, input data is loaded.
   - If load is LOW:
     - dir = 0 → rotate left
     - dir = 1 → rotate right
3. When enable is LOW:
   - Output remains unchanged.

Example:
- Left Rotation:
  00010010 → 00100100

- Right Rotation:
  00010010 → 00001001

---

## Test Cases Performed
- Reset verification
- Left rotation
- Right rotation
- Pause/hold operation
- Direction toggling
- Mid-run data loading
- Wrap-around verification
- All-zero rotation
- All-one rotation

---

## Simulation Result
The RotatorUnit module successfully performed left and right circular rotations and passed all test cases.

---

## Result
The RotatorUnit module was designed and verified successfully using SystemVerilog.