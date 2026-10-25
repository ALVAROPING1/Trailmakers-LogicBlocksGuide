// LTeX: language=en

#import "/conf.typ": booktab-table
#import "/utils/common.typ": *

#let maxFloat = $(2 - 2^(-23)) dot 2^127$
#let maxFloatApprox = scientific(eval-math(maxFloat))

= Signals <signals>

Signals are the method used to communicate different logic blocks between eachother and other blocks. All block inputs, both from logic blocks and keybinds, are represented with signals. Signals are made up of 3 important properties:

- Input/output value: value attached to each signal, usually in the range $[-1, 1]$.
  - #math-blocks are the only blocks which don't clamp the sum of their inputs to the $[-1, 1]$ range, instead they use the range $[-#maxFloat, #maxFloat] approx [-#maxFloatApprox, #maxFloatApprox]$
  - They are represented with a standard #link("https://en.wikipedia.org/wiki/Single-precision_floating-point_format")[IEEE 754 single-precision floating-point number]
- Truthness value: value that determines if a signal is on or off
  - A signal is on if its associated value is not $0$. Additionally, for blocks with multiple inputs, the sum of their inputs must also be non-$0$ in order for them to be activated
- Logic channel: tag added to signals to be able to group them. Its exact value is meaningless, as it's only ever used to determine how to group signals received by a single block. The value of each group is the sum of the signals within that group received. Most blocks ignore it, but some blocks can treat each group differently.
  - Keybinds always use the C0 channel
  - Toggle/timers state is shared by all channels

When a block receives a set of inputs, it determines how it is activated based on the value of their sum. Blocks with a single configurable keybind, except the gyro stabilizer and hue light panels, additionally use the absolute value before interpreting it, which makes both signs equivalent. The resulting value represents the percentage of power that whatever it activates will use, applied to the value set in its settings as a multiplier (if applicable). Values modified for each block are in @table:InputValueBlocks. Some important notes:

- For hinges/wings the rotation speed depends on the max angle set in their settings and not on the angle achieved with the input value, resulting in faster speeds with fractional input values for the same final angle
- By default, the response of hinges/wings to fractional inputs is not linear, resulting in smaller angles. See @InputValueMultiplier for more information
- Due to a bug, close to 0 inputs in servos with hold position also result in lower speeds as well. See @InputValueSpeed for more information
- For rotating servos, an angle of "infinity" actually represents $360 degree$
- For the gyro stabilizer, it only works with disabled by default, and negative values make it stabilize in the opposite direction

#figure(
  booktab-table(
    columns: (6.5cm, auto),
    align: left,
    table.header([Block], [Value modified]),
    [Engines], [Max speed and acceleration (torque)],
    [Thrusters, gimbals, propellers, boat engines, and quantum rudders], [Power (thrust)],
    [Rotating servos, hinges, and wings with control surfaces (without hold position)], [Angle],
    [Spinning servos, helicopter engines, pistons, gyros, and gyro stabilizers], [Speed],
    [Tone generators], [Volume],
    [Logic gates and math blocks], [Output value (see #logic-gates and #math-blocks)],
    [Hue light panels], [Color (see #block-ref(<hue-light-panel>))],
    [Other], [None],
  ),
  caption: [Value modified by the input value for each block]
) <table:InputValueBlocks>
