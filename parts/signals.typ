// LTeX: language=en

#import "/conf.typ": booktab-table
#import "/utils/common.typ": *

#let maxFloat = $(2 - 2^(-23)) dot 2^127$
#let maxFloatApprox = scientific(eval-math(maxFloat))

= Signals <signals>

Signals are the method used to communicate different logic blocks between
eachother and other blocks. All block inputs, both from logic blocks and
keybinds, are represented with signals. Signals are made up of 3 important
properties:

- Input/output value: value attached to each signal, usually in the range
  $[-1, 1]$.
  - #math-blocks are the only blocks which don't clamp the sum of their inputs
    to the $[-1, 1]$ range, instead they use the range
    $[-#maxFloat, #maxFloat] approx [-#maxFloatApprox, #maxFloatApprox]$
  - They are represented with a standard #link(
      "https://en.wikipedia.org/wiki/Single-precision_floating-point_format",
    )[IEEE 754 single-precision floating-point number]
- Truthness value: value that determines if a signal is on or off
  - A signal is on if its associated value is not $0$. Additionally, for blocks
    with multiple inputs, the sum of their inputs must also be non-$0$ in order
    for them to be activated
- Logic channel: tag added to signals to be able to group them. Its exact value
  is meaningless, as it's only ever used to determine how to group signals
  received by a single block. The value of each group is the sum of the signals
  within that group received. Most blocks ignore it, but some blocks can treat
  each group differently.
  - Keybinds always use the C0 channel
  - Toggle/timers state is shared by all channels

When a block receives a set of inputs, it determines how it is activated based
on the value of their sum. Blocks with a single configurable keybind, except the
gyro stabilizer and hue light panels, additionally use the absolute value before
interpreting it, which makes both signs equivalent. The resulting value
represents the percentage of power that whatever it activates will use, applied
to the value set in its settings as a multiplier (if applicable). Values
modified for each block are in @table:InputValueBlocks. Some important notes:

- For hinges/wings the rotation speed depends on the max angle set in their
  settings and not on the angle achieved with the input value, resulting in
  faster speeds with fractional input values for the same final angle
- By default, the response of hinges/wings to fractional inputs is not linear,
  resulting in smaller angles. See @InputValueMultiplier for more information
- Due to a bug, close to 0 inputs in servos with hold position also result in
  lower speeds as well. See @InputValueSpeed for more information
- For rotating servos, an angle of "infinity" actually represents $360 degree$
- For the gyro stabilizer, it only works with disabled by default, and negative
  values make it stabilize in the opposite direction

#figure(
  // @typstyle off
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
  caption: [Value modified by the input value for each block],
) <table:InputValueBlocks>

== Update order

#let double-buffer = "https://en.wikipedia.org/wiki/Multiple_buffering"
#let dfs = "https://en.wikipedia.org/wiki/Depth-first_search"

In most cases, it can be assumed that blocks are updated independently of
eachother, and the resulting signals are updated after all of them have
finished, using a #link(double-buffer)[double buffer]. However, that's not
exactly how the game works, and as a result the update order can make a
difference in some cases, particularly in blocks that need to access raw inputs
instead of their aggregated sum. In practice, this makes the biggest difference
when multiple inputs of an aggregate logic block in non-sum mode change in the
same tick, since the aggregate block might temporarilly see partially updated
inputs and thus produce a wrong output value. It can also have a smaller effect
with a single input change, where the aggregate block can have a transmission
delay of either 0 or 1 ticks depending on the update order.

Although the update order can generally be predicted, doing so requires very
careful planning and building, is very brittle against changes in the build, and
can change chaotically. Additionally, it's not guaranteed to never change in an
update. As a result, circuits that rely on a particular update order, specially
on seeing partially updated inputs or no transmission delay, should be
considered undefined behavior and avoided where possible.

Instead of using a double buffer of signals, the game stores the value of all
inputs and the sum of inputs of each block. On each update tick, the update of
blocks is divided in 2 main steps:
+ Each block calculates its current sum of inputs from the raw inputs table
  - Order is irrelevant as the raw inputs table isn't modified during this step
  - The sign of this sum is used for the display of the input arrows in all
    #logic-gates and #math-blocks
  - Blocks that make use of logic channels also calculate the sum of inputs for
    each channel
+ Each block in spawn order calculates its new output, updating its value in the
  inputs table
  - Block spawn order is the order in which the blocks were created in the
    build, from oldest to newest, and is preserved across blueprint save/loads
  - Whenever the output of a block changes, its connected output blocks are
    processed recursively as well, resulting in a #link(dfs)[depth-first search]
    (updating neighbors of the block in cration order as well)
    - This causes the update order to potentially change based on the exact
      values of the signals going through the circuit and the state of all
      blocks at the end of the previous tick
  - Blocks are processed exactly once per tick, i.e. only the first time they
    are encountered during this process. Subsequent update attempts within the
    same tick are skipped
  - Since only the inputs table is updated during this step, blocks whose output
    only depends on the aggregated sum of inputs always produce the correct
    output with 1 tick of transmission delay (as that sum was calculated using
    the outputs from the previous tick), although their update order can still
    have an impact on the update order of other blocks
  - Since the raw inputs table is modified during this step, blocks that depend
    on it can see a partially updated table with up to 1 of their inputs updated
    (the one that triggered the update of the block through the recursive step,
    which corresponds with the first updated block that changed its output)
    - The only way to guarantee consistent update order and correct output in
      this case is for the block to be updated before any of its inputs, i.e.
      appear earlier in the spawn order
      - Theoretically this applies to any input ancestor block, although in
        practice it's usually enough to consider only up until the first or
        second one that doesn't depend on the raw inputs table
