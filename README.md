# Synchronous Up/Down Counter (4-bit) in Verilog

## Overview

This project implements a **4-bit synchronous up/down counter** using T flip-flops.
The counter supports both increment and decrement operations based on a control signal.

Unlike ripple counters, all flip-flops in this design are driven by a **common clock**, ensuring simultaneous state transitions.

---

## Module Description

### `sCounter`

A synchronous 4-bit counter with:

* Up/Down counting capability
* Common clock input for all flip-flops
* Synchronous operation
* Asynchronous reset via flip-flops

---

## Inputs and Outputs

### Inputs

| Signal   | Description                    |
| -------- | ------------------------------ |
| `clk_i`  | Clock input                    |
| `rst_i`  | Reset (active HIGH)            |
| `mode_i` | Mode select (0 = UP, 1 = DOWN) |

### Output

| Signal        | Description         |
| ------------- | ------------------- |
| `dout_o[3:0]` | 4-bit counter value |

---

## Functional Behavior

### Reset

* When `rst_i = 1`, all flip-flops are reset to `0000`

### Counting Modes

#### Up Counter (`mode_i = 0`)

* Counter increments on each rising edge of the clock:

```
0000 → 0001 → 0010 → ... → 1111 → 0000
```

#### Down Counter (`mode_i = 1`)

* Counter decrements on each rising edge of the clock:

```
0000 → 1111 → 1110 → ... → 0001 → 0000
```

---

## Design Logic

The counter is implemented using **T flip-flops**, where each stage toggles based on lower-bit conditions.

### Toggle Conditions

| Flip-Flop | Toggle Condition (T input) |
| --------- | -------------------------- |
| T0 (LSB)  | Always 1                   |
| T1        | Depends on Q0              |
| T2        | Depends on Q1, Q0          |
| T3 (MSB)  | Depends on Q2, Q1, Q0      |

The logic adapts dynamically for up/down counting using `mode_i`.

---

## Code Snippet

```verilog id="k29sd1"
assign Ta = (mode_i & QbBar & QcBar & QdBar) | ((~mode_i) & Qb & Qc & Qd);
assign Tb = (mode_i & QcBar & QdBar) | ((~mode_i) & Qc & Qd);
assign Tc = (mode_i & QdBar) | ((~mode_i) & Qd);
assign Td = 1'b1;
```

---

## Design Characteristics

* **Fully synchronous**: All flip-flops share the same clock
* **Deterministic behavior**: No ripple delay between stages
* **Bidirectional counting**: Controlled by a single signal
* **Mod-16 operation**: Counts through all 16 states (0–15)

---

## Simulation

The testbench validates:

* Up counting sequence
* Down counting sequence
* Reset behavior
* Mode switching during operation

Waveforms are generated in `.vcd` format for analysis.

---

## File Structure

```
.
├── sCounter.v        # Design module
├── Tff.v             # T flip-flop module
├── tb_sCounter.v     # Testbench
├── sCounter.vcd      # Waveform output
```

---

## Notes

* The design ensures all outputs update simultaneously on the clock edge.
* Toggle logic is derived from binary counting principles.
* Mode switching during operation is supported and reflected in the next clock cycle.

---

## Conclusion

This implementation demonstrates a reliable **synchronous up/down counter** using T flip-flops, suitable for digital systems requiring predictable timing and bidirectional counting functionality.
