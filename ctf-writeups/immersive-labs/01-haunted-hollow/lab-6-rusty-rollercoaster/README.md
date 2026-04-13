# Lab 6 - Rusty Rollercoaster

## Table of Contents
- [Lab 6 - Rusty Rollercoaster](#lab-6---rusty-rollercoaster)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Analysis](#analysis)
  - [Solution](#solution)

## Overview

This lab provides a Rust application that needs to be exploited with a buffer overflow attack to extract hidden information.

## Analysis

The `ControlPanel` structure has both the speed array and the shutdown flag:
```rust
struct ControlPanel {
    speed_array: [i32; 8],
    can_shutdown: bool,
}
```
- `speed_array` is a fixed-size array of 8 signed 32-bit integers.
- `can_shutdown` is a flag hard-coded to `false` after initializing the control panel values.

The solution is to figure out a way to override the shutdown flag to `true` (1).

The `speed_adjustment` function allows you to directly update values in the speed_array using an `unsafe` block:
```rust
unsafe {
    *buffer.get_unchecked_mut(selection as usize - 1) = value;
}
```

A few important things to consider from that code block:
- `unsafe { ... }` allows operations that bypass some of Rust’s safety guarantees.
- `get_unchecked_mut()` is a Rust slice/array method that skips bounds checking.
- `as usize` is a Rust type cast (often used for array indexing).
- the `*` in `*buffer.get_unchecked_mut(...)` dereferences a pointer or mutable reference.

The `unsafe` code is doing the following:
1. Converts `selection` to `usize`.
2. Subtracts 1 (likely converting from 1-based input to 0-based indexing).
3. Gets a mutable element **without bounds checking**.
4. Writes value into that position.

Equivalent safe Rust would look like:
```rust
buffer[selection as usize - 1] = value;
```
but the unsafe version removes the bounds check for performance (or low-level control). ⚠️

The trick here is to perform out-of-bounds memory write operations by playing with Speed adjustments.

## Solution

There are only 8 values in the `speed_array`. By setting a speed adjustment for entry 9 with the value 1 will set the value of the next entry in the control panel structure. In this case, it would set the `can_shutdown` flag to `true`.

After setting the value, you can select the Emergency Stop option from the menu.

```log
[!] Emergency stop activated! Ride is shutting down.
[*] Token: 878312
[*] Code: tr0ubl3s0m3tr4cks
```