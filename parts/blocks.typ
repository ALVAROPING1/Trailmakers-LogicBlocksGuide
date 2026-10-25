// LTeX: enabled=false

#import "/utils/common.typ": *
#import "/utils/diagrams.typ": annotated-img, annotation

#let curr-block-name() = query(selector(heading).before(here())).last().body
#let curr-block-id() = lower(curr-block-name().text).replace(" ", "_")

#let settings-annotation(name: auto, ..args) = context [
  #let name = if name == auto { curr-block-name() } else { name }
  #let id = curr-block-id()
  #figure(
    annotated-img("/img/" + id + ".png", ..args),
    caption: [#name settings]
  ) #label("fig:" + id)
]

#let settings-intro(prefix: [Its]) = context noindent[
  #prefix settings are shown in #ref(label("fig:" + curr-block-id())) and are as follows:
]

= Logic Blocks

Logic blocks are a group of blocks that allow to obtain and process information, which in turn can be used to automate
tasks or create more complex control schemes for creations, and more generally, perform any finite sequence of steps
(known as executing an algorithm).

Most logic blocks have a display with an arrow pointing away from the center of the block representing the value of
their output signal. This arrow is empty when there is no output ($0$ value), and green/red when the output is
positive/negative. On gravity/altitude/position sensors, this arrow is replaced with an icon (weight for gravity
sensors, and an arrow pointing in the measured direction for altitude/position sensors), which has the same
functionality (although it is white when there is no output). Blocks which can take other signals as inputs
(#logic-gates and #math-blocks), with the exception of number displays, additionally have a second
arrow pointing to the center of the block representing the input signals, which works like the output arrow but using
the value of the sum of the input signals.

Note: all settings which accept numbers are rounded after being confirmed. The value used is always the value displayed
after rounding

== Sensors

Sensors are a group of blocks that measure a physical property, like speed or angle, and create either a boolean or real output based on it.

=== Distance Sensor

Distance sensors check for objects within a straight line in front of them and a predefined distance. Objects are detected with a raycast from a point in the detecting face, indicated by a red dot. The detecting face glows white when the sensor creates an output, and stays off otherwise.

#settings-intro()

- Keybinds: see @keybinds
- Toggle: see @toggle
- Timers: see @timers
- Logic output channel: tag added to the output signal, see @signals
- Range: maximum distance between an object and the sensor for it to be detected, in meters ($1 "block" = 0.25 "m"$)
  - Distance is measured from the surface of the detecting face, although the raycast used starts at the center of the block. This allows it to measure negative distances in the range $[-0.125, 0]$ m, which correspond with the distance between the center of the block and the surface of the detecting face
- Output scale: multiplier of the output signal created by the block
- Sensor offset: horizontal position from which the detecting face sends the raycast to detect objects
- Output mode: type of output created by the sensor when it is activated (the output is always $0$ otherwise)
  - Trigger: output 1
  - Measurement: output the distance to the detected object in meters
    - Same as "Trigger" when inverted trigger is used
  - Normalized: output $"measurement"/"range"$ if $"distance" != 0$ ($0$ otherwise)
- Trigger: condition used to determine when to send an output
  - Normal: sends an output when it detects an object
  - Inverted: sends an output when it doesn't detect an object
- Mute on input: determines whether inputs enable or disable the output
  - Inputs disable the output when enabled, and enable the output otherwise
- Blocks only: whether to trigger only when blocks are detected
  - If enabled, raycast stops at the first obstacle regardless of what it is, but if it's not a block the output will be the same as no detection

#settings-annotation({
  annotation([Output (off)],     "right", 4.35, (0,))
  annotation([Output (on)],      "right", 5.35, (0,))
  annotation([Keybinds/toggles], "left",  2.2,  (0,))
  annotation([Range],            "left",  3.8,  (0,))
  annotation([Output scale],     "left",  4.65, (0,))
  annotation([Sensor offset],    "left",  5.55, (0,))
  annotation([Timers],           "left",  6.7,  (0, -0.4, 0.4))
  annotation([Output mode],      "left",  8.05, (0,))
  annotation([Output channel],   "mid",   8.75, (0,))
  annotation([Invert trigger],   "left",  9.15, (0,))
  annotation([Blocks only],      "mid",   9.55, ((-1.4, 0),))
  annotation([Mute on input],    "left",  9.9,  (0,))
})

=== Altitude Sensor

Altitude sensors measure the altitude of the block relative to a predefined frame of reference. They have a display which shows the currently measured altitude rounded to the nearest integer.

#settings-intro()

- Keybinds: see @keybinds
- Toggle: see @toggle
- Timers: see @timers
- Logic output channel: tag added to the output signal, see @signals
- Altitude: altitude threshold to trigger, in meters above the frame of reference ($1 "block" = 0.25 "m"$)
- Output scale: multiplier of the output signal created by the block
- Output mode: type of output created by the sensor when it is activated (the output is always $0$ otherwise)
  - Trigger: output 1
  - Measurement: output the current altitude in meters
  - Normalized: output $"measurement"/"altitude"$ if $"altitude" != 0$ (same as measurement otherwise)
- Frame of reference: position of the $0$ altitude point
  - Ignore waves: fixed at the average sea level
  - Relative to waves: at the position of the water surface at the horizontal coordinates of the sensor
  - Outside of high seas and when the wave setting is set to disabled, both options are equivalent
  - On space sector, it's a "MAX" value (equivalent to $2001$ m) while outside an atmosphere and the distance to a point close to the center of the planet while inside of one
- Trigger: condition used to determine when to send an output
  - Normal: sends an output when the altitude is above the configured value
  - Below: sends an output when the altitude is below the configured value
- Mute on input: determines whether inputs enable or disable the output
  - Inputs disable the output when enabled, and enable the output otherwise

#settings-annotation({
  annotation([Output (off)],       "right", 4.35, (0,))
  annotation([Output (on)],        "right", 5.35, (0,))
  annotation([Keybinds/toggles],   "left",  2.2,  (0,))
  annotation([Altitude],           "left",  3.8,  (0,))
  annotation([Output scale],       "left",  4.65, (0,))
  annotation([Timers],             "left",  5.8,  (0, -0.4, 0.4))
  annotation([Output mode],        "left",  7.15, (0,))
  annotation([Output channel],     "mid",   7.9,  (0,))
  annotation([Trigger below],      "left",  8.3,  (0,))
  annotation([Frame of reference], "mid",   8.7,  ((-1.5, 0),))
  annotation([Mute on input],      "left",  9.0,  (0,))
})

=== Position Sensor

Position sensors measure the horizontal position of the block on a chosen axis. They have a display which shows the currently measured position rounded to the nearest integer.

#settings-intro()

- Keybinds: see @keybinds
- Toggle: see @toggle
- Timers: see @timers
- Logic output channel: tag added to the output signal, see @signals
- Threshold: position threshold to trigger, in meters ($1 "block" = 0.25 "m"$)
- Output scale: multiplier of the output signal created by the block
- Output mode: type of output created by the sensor when it is activated (the output is always $0$ otherwise)
  - Trigger: output 1
  - Measurement: output the current position in meters
  - Normalized: output $"measurement"/"threshold"$ if $"threshold" != 0$ (same as measurement otherwise)
- Mode: horizontal axis in which to measure the position, either latitude or longitude
- Trigger: condition used to determine when to send an output
  - Normal: sends an output when the altitude is above the configured value
  - Below: sends an output when the altitude is below the configured value
- Mute on input: determines whether inputs enable or disable the output
  - Inputs disable the output when enabled, and enable the output otherwise
- Relative: determines whether the position measured is absolute or relative to the initial position of the sensor when it was spawned

#settings-annotation({
  annotation([Output (off)],     "right", 4.35, (0,))
  annotation([Output (on)],      "right", 5.35, (0,))
  annotation([Keybinds/toggles], "left",  2.2,  (0,))
  annotation([Threshold],        "left",  3.8,  (0,))
  annotation([Output scale],     "left",  4.65, (0,))
  annotation([Timers],           "left",  5.8,  (0, -0.4, 0.4))
  annotation([Output mode],      "left",  7.15, (0,))
  annotation([Mode],             "mid",   7.9,  (0,))
  annotation([Output channel],   "left",  8.6,  (0,))
  annotation([Trigger below],    "mid",   9.05, ((-1.9, 0),))
  annotation([Mute on input],    "left",  9.35, (0,))
  annotation([Relative],         "mid",   9.75, ((-2.5, 0),))
})

=== Speed Sensor

Speed sensors measure the speed of the block in a given direction indicated by the arrow on the block. They have a display which shows the currently measured speed as a bar indicator, which is full when the speed is higher than or equal to the trigger speed and empty when the speed is negative or $0$.

#settings-intro()

- Keybinds: see @keybinds
- Toggle: see @toggle
- Timers: see @timers
- Logic output channel: tag added to the output signal, see @signals
- Speed: speed threshold to trigger, in km/h or mph depending on the speed unit settings
- Output scale: value of the output signal created by the block
- Output mode: type of output created by the sensor when it is activated (the output is always $0$ otherwise)
  - Trigger: output 1
  - Measurement: output the current speed in m/s
  - Normalized: output $"measurement"/"speed (in m/s)"$ if $"speed" != 0$ (same as measurement otherwise)
- Trigger: condition used to determine when to send an output
  - Normal: sends an output when the speed is above the configured value
  - Below: sends an output when the speed is below the configured value
- Mute on input: determines whether inputs enable or disable the output
  - Inputs disable the output when enabled, and enable the output otherwise

#settings-annotation({
  annotation([Output (off)],     "right", 4.35, (0,))
  annotation([Output (on)],      "right", 5.35, (0,))
  annotation([Keybinds/toggles], "left",  2.2,  (0,))
  annotation([Speed],            "left",  3.8,  (0,))
  annotation([Output scale],     "left",  4.65, (0,))
  annotation([Timers],           "left",  5.8,  (0, -0.4, 0.4))
  annotation([Output mode],      "left",  7.15, (0,))
  annotation([Output channel],   "mid",   7.9,  (0,))
  annotation([Trigger below],    "left",  8.5,  (0,))
  annotation([Mute on input],    "mid",   8.85, ((-1.8, 0),))
})

=== Gravity Sensor

Gravity sensors measure the gravity strength at the position of the block. They have a display which shows the currently measured gravity as a bar indicator, which is full when the gravity is higher than or equal to the trigger gravity and empty when the gravity is $0$.

#settings-intro()

- Keybinds: see @keybinds
- Toggle: see @toggle
- Timers: see @timers
- Logic output channel: tag added to the output signal, see @signals
- Threshold: gravity strength threshold to trigger, relative to the normal gravity ($14 hfrac("m", "s"^2)$)
- Output scale: multiplier of the output signal created by the block
- Output mode: type of output created by the sensor when it is activated (the output is always $0$ otherwise)
  - Trigger: output 1
  - Measurement: output the current gravity relative to the normal gravity
  - Normalized: output $"measurement"/"threshold"$ if $"threshold" != 0$ (same as measurement otherwise)
- Trigger: condition used to determine when to send an output
  - Normal: sends an output when the gravity strength is above the configured value
  - Below: sends an output when the gravity strength is below the configured value
- Mute on input: determines whether inputs enable or disable the output
  - Inputs disable the output when enabled, and enable the output otherwise

#settings-annotation({
  annotation([Output (off)],     "right", 4.35, (0,))
  annotation([Output (on)],      "right", 5.35, (0,))
  annotation([Keybinds/toggles], "left",  2.2,  (0,))
  annotation([Threshold],        "left",  3.8,  (0,))
  annotation([Output scale],     "left",  4.65, (0,))
  annotation([Timers],           "left",  5.8,  (0, -0.4, 0.4))
  annotation([Output mode],      "left",  7.15, (0,))
  annotation([Output channel],   "mid",   7.9,  (0,))
  annotation([Trigger below],    "left",  8.5,  (0,))
  annotation([Mute on input],    "mid",   8.85, ((-1.8, 0),))
})

=== Angle Sensor

Angle sensors measure the angle of the block relative to the closest direction to the up direction in the plane defined by the square faces of the block. This is done by projecting the up direction vector onto the plane (resulting in the direction of highest slope), and comparing a vector fixed to the block against that projection. They have a display which shows the currently measured angle, with a blue section representing the activation threshold and an output arrow representing the projected direction.

#settings-intro()

- Keybinds: see @keybinds
- Toggle: see @toggle
- Timers: see @timers
- Logic output channel: tag added to the output signal, see @signals
- Direction: position of the middle point of the activation threshold, in degrees
- Width: size of the activation threshold, in degrees
- Output scale: multiplier of the output signal created by the block
- Output mode: type of output created by the sensor when it is activated (the output is always $0$ otherwise)
  - Trigger: output 1
  - Measurement: output the current signed angle (positive for counterclockwise) from either the center (normal trigger) or the closest edge (trigger outside) of the activation threshold to the output arrow in degrees
  - Normalized: output $"measurement"/hfrac("width", 2)$ if $"width" != 0$ ($0$ otherwise)
    - Note: if using trigger outside, the width used is that of the outside area, i.e. $360 - "width"$
- Trigger: condition used to determine when to send an output
  - Normal: sends an output when the angle is inside of the activation threshold
  - Outside: sends an output when the angle is outside the activation threshold
- Mute on input: determines whether inputs enable or disable the output
  - Inputs disable the output when enabled, and enable the output otherwise

#let angle-sensor-annotations = {
  annotation([Output (off)],     "right", 4.35, (0,))
  annotation([Output (on)],      "right", 5.35, (0,))
  annotation([Keybinds/toggles], "left",  2.2,  (0,))
  annotation([Direction],        "left",  3.8,  (0,))
  annotation([Width],            "left",  4.7,  (0,))
  annotation([Output scale],     "left",  5.55, (0,))
  annotation([Timers],           "left",  6.7,  (0, -0.4, 0.4))
  annotation([Output mode],      "left",  8.05, (0,))
  annotation([Output channel],   "mid",   8.75, (0,))
  annotation([Trigger outside],  "left",  9.15, (0,))
  annotation([Mute on input],    "mid",   9.55, ((-1.8, 0),))
}
#settings-annotation(angle-sensor-annotations)

=== Compass

Compasses measure the angle of the block relative to the closest direction to the north in the plane defined by the square faces of the block. This is done by projecting the north vector onto the plane, and comparing a vector fixed to the block against that projection. They have a display which shows the currently measured angle, with a red section representing the activation threshold, and an output arrow and cardinal direction letters representing the projected direction.

#settings-intro()

- Direction: position of the middle point of the activation threshold, in degrees
- Width: size of the activation threshold, in degrees
- Output scale: multiplier of the output signal created by the block
- Output mode: type of output created by the sensor when it is activated (the output is always $0$ otherwise)
  - Trigger: output 1
  - Measurement: output the current signed angle (positive for counterclockwise) from either the center (normal trigger) or the closest edge (trigger outside) of the activation threshold to the output arrow in degrees
  - Normalized: output $"measurement"/hfrac("width", 2)$ if $"width" != 0$ ($0$ otherwise)
    - Note: if using trigger outside, the width used is that of the outside area, i.e. $360 - "width"$
- Trigger: condition used to determine when to send an output
  - Normal: sends an output when the angle is inside of the activation threshold
  - Outside: sends an output when the angle is outside the activation threshold
- Mute on input: determines whether inputs enable or disable the output
  - Inputs disable the output when enabled, and enable the output otherwise

#settings-annotation(angle-sensor-annotations)

=== Aiming Sensor

Aiming sensors measure the angle of the block relative to the closest direction to camera direction in the plane defined by the square faces of the block. This is done by projecting the camera direction vector onto the plane, and comparing a vector fixed to the block against that projection. The camera direction used is always that of the player who owns (spawned) the creation, although with an upwards pitch offset explained in @AimingSensorPitch. They have a display which shows the currently measured angle, with a light blue section representing the activation threshold and an output arrow representing the projected direction.

#settings-intro()

- Keybinds: see @keybinds
- Toggle: see @toggle
- Timers: see @timers
- Logic output channel: tag added to the output signal, see @signals
- Direction: position of the middle point of the activation threshold, in degrees
- Width: size of the activation threshold, in degrees
- Output scale: multiplier of the output signal created by the block
- Output mode: type of output created by the sensor when it is activated (the output is always $0$ otherwise)
  - Trigger: output 1
  - Measurement: output the current signed angle (positive for counterclockwise) from either the center (normal trigger) or the closest edge (trigger outside) of the activation threshold to the output arrow in degrees
  - Normalized: output $"measurement"/hfrac("width", 2)$ if $"width" != 0$ ($0$ otherwise)
    - Note: if using trigger outside, the width used is that of the outside area, i.e. $360 - "width"$
- Trigger: condition used to determine when to send an output
  - Normal: sends an output when the angle is inside of the activation threshold
  - Outside: sends an output when the angle is outside the activation threshold
- Mute on input: determines whether inputs enable or disable the output
  - Inputs disable the output when enabled, and enable the output otherwise

#settings-annotation({
  let l(y) = (0.55, y)
  annotation([Output (off)],     "right", 4.25,  ((-1.7, 0),))
  annotation([Output (on)],      "right", 5.1,   ((-1.7, 0),))
  annotation([Keybinds/toggles], "left",  2.3,   (l(0),))
  annotation([Direction],        "left",  3.95,  (l(0),))
  annotation([Width],            "left",  4.95,  (l(0),))
  annotation([Output scale],     "left",  5.95,  (l(0),))
  annotation([Timers],           "left",  7.6,   (l(0), l(-0.4), l(0.4)))
  annotation([Output mode],      "left",  9.3,   (l(0),))
  annotation([Output channel],   "mid",   10.05, ((-0.8, 0),))
  annotation([Trigger outside],  "left",  10.55, (l(0),))
  annotation([Mute on input],    "mid",   10.9,  ((-2, 0),))
})

== Logic gates <logic-gates>

Logic gates are a group of blocks that take a set of boolean inputs, and create a boolean output based on their values. The conditions used are as follows, inputs will be discussed on @signals:

- AND gate: all inputs are on
- OR gate: at least one input is on
- XOR gate: only one input is on
- NOR gate: sum of inputs is $0$

#settings-intro(prefix: [Their])

- Keybinds: see @keybinds
- Toggle: see @toggle
- Timers: see @timers
- Logic output channel: tag added to the output signal, see @signals
- Output scale: multiplier of the output signal created by the block, explained in @output-value-calculation

#settings-annotation(name: "Logic Gate", {
  annotation([Output (off)],     "right", 4.35, (0,))
  annotation([Output (on)],      "right", 5.35, (0,))
  annotation([Keybinds/toggles], "left",  2.2,  (0,))
  annotation([Output scale],     "left",  3.8,  (0,))
  annotation([Timers],           "left",  4.9,  (0, -0.4, 0.4))
  annotation([Output channel],   "left",  6.3,  (0,))
})

=== Output value calculation <output-value-calculation>

These are the steps used by the game to determine the value attached to the output signal created by logic gates. For more information about signals, see @signals.

+ The gate checks if its conditions are met. If they aren't, the gate doesn't create an output
+ The gate adds up the values of all of its inputs and clamps the result to the $[-1, 1]$ range
  - Values smaller than $-1$ are replaced with $-1$, and values bigger than $1$ with $1$
+ The gate multiplies the result by its Output scale setting. For NOR gates, their setting replaces the result (which would otherwise always be $0$)
+ The gate sends the result as its output value

This process can be described with the following formula:
$ "output" = "output_value" dot op("boolean_operation")("inputs") dot op("clamp")(sum "inputs") $

#figure(
  image("/img/output_value_diagram.png", width: 100%),
  caption: [Output value calculation diagram made by Zoomah]
) <fig:OutputValueDiagram>

==== Example

An AND gate with an output value of $0.5$ has 2 inputs, one of them has an output value of $0.8$ and the other of $0.5$. When at least one of them is off, it doesn't send an output. When both of them are on at the same time, the AND gate is able to send an output. On that case, the output values of the inputs are first added up: $0.8 + 0.5 = 1.3$. Because the sum, $1.3$, is bigger than $1$, the gate replaces it with $1$. Then that value is multiplied by the output value of the gate: $1 dot 0.5 = 0.5$. Finally, the AND gate sends an output with the value of that multiplication, $0.5$. On the steam version, if the sum of the inputs or the output value of the gate had been $0$, the resultant value of the multiplication would have also been $0$, in which case the gate wouldn't have sent an output.

== Math blocks <math-blocks>

Math blocks are a group of blocks that take a set of numeric inputs and perform some operation to get an output based on their values, either numeric or boolean. They are the only blocks which don't clamp the sum of their inputs to the $[-1, 1]$ range before interpreting it.

=== Comparison Logic Gate

Comparison logic gates calculate the boolean value of a predefined comparison and return it as their output, where the left hand side is the sum of all their inputs and the right hand side is a constant. They have a display which shows the currently selected comparison mode. They are also sometimes referred to as comparators.

#settings-intro()

- Keybinds: see @keybinds
- Toggle: see @toggle
- Timers: see @timers
- Logic output channel: tag added to the output signal, see @signals
- Threshold: value used for the right hand side of the comparison
- Output value: value of the output signal created by the block, explained in @signals
- Comparison mode: comparison operation to perform. Possible values are "less than", "less equals", "greater than", "greater equals", "equal", and "not equal"
  - When the mode is set to "less equals", the total input is rounded to 3 decimal places before performing the comparison, using the nearest mode and rounding numbers ending in $5$ up
  - For the "equal" and "not equal" modes, numbers are compared with a tolerance of $epsilon = 0.0005$ (the numbers are equal if their difference is $< epsilon$)
- Clamp input: whether the result of the sum of the inputs should be clamped to the $[-1, 1]$ range or not

#settings-annotation({
  annotation([Output (off)],     "right", 4.35, (0,))
  annotation([Output (on)],      "right", 5.35, (0,))
  annotation([Keybinds/toggles], "left",  2.2,  (0,))
  annotation([Threshold],        "left",  3.8,  (0,))
  annotation([Output scale],     "left",  4.65, (0,))
  annotation([Timers],           "left",  5.8,  (0, -0.4, 0.4))
  annotation([Comparison mode],  "left",  7.15, (0,))
  annotation([Output channel],   "mid",   7.9,  (0,))
  annotation([Clamp input],      "left",  8.85, (0,))
})

=== Accumulator

Accumulators store and output a numeric value, and allow to increment/decrement it between some bounds. They are always initialized to the value closest to $0$ within the defined bounds. They have a display which shows the currently stored value as a bar indicator, which is full when the value is the maximum and empty when it is the minimum. Additionally, the bar indicator is white when the value is 0, and green/red when it is positive/negative.

#settings-intro()

#let min-max-range = $[min("minimum", "maximum"), space.en max("minimum", "maximum")]$

- Keybinds: see @keybinds
- Toggle: see @toggle
- Timers: see @timers
- Logic output channel: tag added to the output signal, see @signals
- Value bounds: minimum/maximum value that can be stored, the stored value will be clamped to the range #min-max-range
- Scale: rate of change of the stored value, used to scale the value of the input
- Use steps: whether to change the stored value continuously (in which case the scale is change per second, achieved by using $hfrac(1, 60)$th the scale on each frame) or only once per input activation (on the rising edge of the signal)

#settings-annotation({
  annotation([Output (off)],     "right", 4.35, (0,))
  annotation([Output (on)],      "right", 5.35, (0,))
  annotation([Keybinds/toggles], "left",  2.2,  (0,))
  annotation([Value bounds],     "left",  4.15, (-0.4, 0.4))
  annotation([Scale],            "left",  5.55, (0,))
  annotation([Timers],           "left",  6.7,  (0, -0.4, 0.4))
  annotation([Output channel],   "left",  8.05, (0,))
  annotation([Use steps],        "mid",   8.45, ((-2.2, 0),))
})

=== Randomizer

Randomizers generate and output random values.

#settings-intro()

- Keybinds: see @keybinds
- Toggle: see @toggle
- Timers: see @timers
- Logic output channel: tag added to the output signal, see @signals
- Value bounds: minimum/maximum value that can be generated, the generated
  values will be in the range #min-max-range
- Random mode: mode in which the values are generated
  - Output on input: outputs a random value generated on each frame when it is activated, and $0$ otherwise
  - Change on input: outputs a random value generated on each frame when it is activated, and the last generated value (initialized to $0$) otherwise
  - Input defines range: outputs a random value generated on each frame in the intersection between the value bounds and the range $[min("inputs"), max("inputs")]$ when the block is activated, and the last generated value (initialized to a random value within the value bounds) otherwise
    - If the intersection is empty, the value bounds range is used instead if any of the inputs isn't 0, otherwise the output is always 0
  - -Change, +Output: generates and stores a random value on each frame when the block is activated with a negative input, and outputs the last generated value (initialized to a random value within the value bounds) when it is activated with a positive input

#settings-annotation({
  annotation([Output (off)],     "right", 4.35, (0,))
  annotation([Output (on)],      "right", 5.35, (0,))
  annotation([Keybinds/toggles], "left",  2.2,  (0,))
  annotation([Value bounds],     "left",  4.15, (-0.4, 0.4))
  annotation([Timers],           "left",  5.8,  (0, -0.4, 0.4))
  annotation([Random mode],      "left",  7.15, (0,))
  annotation([Output channel],   "mid",   7.9, (0,))
})

=== Number Display

Number displays output the sum of their inputs, similar to how OR logic gates work (although without clamping the sum to the $[-1, 1]$ range), and display it with an optional rounding. They display "N/A" in build mode.

#settings-intro()

- Keybinds: see @keybinds
- Toggle: see @toggle
- Timers: see @timers
- Logic output channel: tag added to the output signal, see @signals
- Rounding: rounding mode applied to the sum of the inputs, always done to an integer when enabled. Possible values are "disabled", "nearest", "floor" (closest smaller integer), and "ceil" (closest bigger integer)
  - When rounding is disabled, numbers are rounded to $2$ decimals using the nearest mode, rounding numbers ending in $0.005$ away from $0$
  - For the "nearest" mode, numbers with a fractional part of $0.5$ are rounded to the closest even integer
  - If the number is outside of the $[-1000, 1000]$ range, it's always displayed in scientific notation with $1$ decimal of precision

#settings-annotation({
  annotation([Output (off)],     "right", 4.35, (0,))
  annotation([Output (on)],      "right", 5.35, (0,))
  annotation([Keybinds/toggles], "left",  2.2,  (0,))
  annotation([Timers],           "left",  3.6,  (0, -0.4, 0.4))
  annotation([Rounding],         "left",  5.0,  (0,))
  annotation([Output channel],   "below", 6.45,  (0,))
})

=== Arithmetics Logic Block

Arithmetics logic blocks perform an arithmetic binary operation with a constant and the sum of their inputs, and output the result. The constant is the first operand while the sum of the inputs is the second one. They have a display which shows the currently selected operation.

#settings-intro()

- Keybinds: see @keybinds
- Toggle: see @toggle
- Timers: see @timers
- Logic output channel: tag added to the output signal, see @signals
- Constant: constant value to use as the first operand
- Operation: binary operation to perform. Possible values are addition, subtraction, multiplication, division, modulo, power ($x^"constant"$), exponentiation ($"constant"^x$), and variable division
  - Attempting to perform a division by $0$ or $a^b$ with $a < 0$ and $b in.not ZZ$ results in an output of $0$
  - Attempting to perform $0^0$ results in $1$ when the operation is power and $0$ when the operation is exponentiation
  - When there are no inputs, the operation is performed using an input of $0$
  - Variable division uses the logic channel 0 for its first input (numerator) and logic channel 1 for its second input (denominator)

#settings-annotation({
  annotation([Output (off)],     "right", 4.35, (0,))
  annotation([Output (on)],      "right", 5.35, (0,))
  annotation([Keybinds/toggles], "left",  2.2,  (0,))
  annotation([Constant],         "left",  3.8,  (0,))
  annotation([Timers],           "left",  4.9,  (0, -0.4, 0.4))
  annotation([Operation],        "left",  6.3,  (0,))
  annotation([Output channel],   "mid",   7.0,  (0,))
})

=== Functions Logic Block

Functions logic blocks perform a unary operation with the sum of their inputs and output the result. They have a display which shows the currently selected operation.

#settings-intro()

- Keybinds: see @keybinds
- Toggle: see @toggle
- Timers: see @timers
- Logic output channel: tag added to the output signal, see @signals
- Function: unary operation to perform. Possible values are absolute value, sign, square root, sine, cosine, tangent, arcsine, arccosine, arctangent, floor, ceiling, rounding, arctan2, $log_2$, $log_e$, and $log_10$
  - Attempting to perform an undefined operation (square root of a negative number, arcsine/arccosine of a number outside of the $[-1, 1]$ range, or logarithm of a negative value) results in an output of $0$
  - Trigonometric functions use degrees as the angle unit
  - Inverse trigonometric functions output the value in their #link("https://en.wikipedia.org/wiki/Principal_branch")[principal branch]
    - For arcsine: $-90 degree <= arcsin(x) <= 90 degree$
    - For arccosine: $0 degree <= arccos(x) <= 180 degree$
    - For arctangent: $-90 degree < arctan(x) < 90 degree$
  - For the rounding function, numbers with a fractional part of $0.5$ are rounded to the closest even integer
  - Arctan2 uses the logic channel 0 for its first input ($y$) and logic channel 1 for its second input ($x$)

#settings-annotation({
  annotation([Output (off)],     "right", 4.35, (0,))
  annotation([Output (on)],      "right", 5.35, (0,))
  annotation([Keybinds/toggles], "left",  2.2,  (0,))
  annotation([Timers],           "left",  4.0,  (0, -0.4, 0.4))
  annotation([Function],         "left",  5.4,  (0,))
  annotation([Output channel],   "below", 6.9, (0,))
})

=== Aggregate Logic Block

Aggregate logic blocks perform a (variadic) aggregation operation with their inputs and output the result. They have a display which shows the currently selected operation. Note: due to a bug, when the function isn't sum, the output can sometimes be updated instantly without the normal signal propagation delay.

#settings-intro()

- Keybinds: see @keybinds
- Toggle: see @toggle
- Timers: see @timers
- Logic output channel: tag added to the output signal, see @signals
- Aggregate function: aggregate operation to perform. Possible values are sum, product, minimum, and maximum

#settings-annotation({
  annotation([Output (off)],       "right", 4.35, (0,))
  annotation([Output (on)],        "right", 5.35, (0,))
  annotation([Keybinds/toggles],   "left",  2.2,  (0,))
  annotation([Timers],             "left",  4.0,  (0, -0.4, 0.4))
  annotation([Aggregate function], "left",  5.4,  (0,))
  annotation([Output channel],     "below", 6.9,  (0,))
})

=== Hue Light Panel <hue-light-panel>

Hue light panels are lights with configurable color determined from their input value.

#settings-intro()

- Keybinds: see @keybinds
- Toggle: see @toggle
- Timers: see @timers
- Saturation: saturation of the color of the light. Ignored when the input value is negative
- Brightness: brightness of the color of the light

#settings-annotation({
  annotation([Keybinds/toggles], "left",  2.2,  (0,))
  annotation([Saturation],       "left",  3.8,  (0,))
  annotation([Brightness],       "left",  4.65, (0,))
  annotation([Timers],           "left",  5.8,  (0, -0.4, 0.4))
})

==== Color Calculation

The color displayed as a function of their input value can be determined with the following formula, where $S$ and $B$ are the saturation and brightness settings respectively. Figure @fig:HueLightPanelColor shows an example of the resulting colors for inputs in the range $[-1, 1]$ with $"saturation" = "brightness" = 1$. Inputs smaller than $-1$ result in the $[-1, 0]$ range being repeated, while inputs greater than $1$ result in the $[0, 1]$ range being repeated.

$ op("color")(x) = cases(
    op("HSV")(360(x "mod" 1), S, B)          space.quad & (x > 0),
    "Off (Black)"                            space.quad & (x = 0),
    op("greyscale")((1 - (x "mod" 1)) dot B) space.quad & (x < 0),
) $

#figure(
  {
    let gradient-line((min, max), colors) = lq.line(
      (min, 0), (max, 0),
      stroke: 1cm + gradient.linear(..colors, space: color.hsv),
    )

    show: lq.set-tick(inset: 6pt, outset: 6pt, stroke: luma(50%))
    lq.diagram(
      height: 1cm,
      width: 95%,
      xlabel: [Input value],
      xaxis: (
        ticks: range(-6, 7).map(i => i/6),
        format-ticks: (ticks, ..args) => {
          let tick-info = (..args.tick-info, significant-digits: 2)
          lq.tick-format.linear(ticks, ..args, tick-info: tick-info)
        }
      ),
      yaxis: none,
      grid: none,
      gradient-line((-1, 0), (white, black)),
      gradient-line((0, 1), range(4).map(i => color.hsv(i * 120deg, 100%, 100%))),
    )
  },
  caption: [Hue light panel color with $"saturation" = "brightness" = 1$ for inputs in the range $[-1, 1]$]
) <fig:HueLightPanelColor>

=== RC Blocks

RC blocks are a pair of blocks that allow to send and receive logic signals between different creations.

==== Radio Sender

Radio senders transmit their input value to other radio receivers on the same channel and isolation level. The logic output of radio senders is always 0.

#settings-intro()

- Keybinds: see @keybinds
- Toggle: see @toggle
- Timers: see @timers
- Channel: RC channel in which to emit the signal
- Channel isolation: visibility type of the channel
  - None: channel is shared by all players
  - Team: channel is shared by all players of the same team. Different teams won't see each other's signals
  - Player: channel is different for each player. Different players won't see each other's signals
  - The player/team of the RC block is determined by the player who owns (spawned) the creation

#settings-annotation({
  annotation([Keybinds/toggles],  "left",  2.2,  (0,))
  annotation([Channel],           "left",  3.8,  (0,))
  annotation([Timers],            "left",  4.9,  (0, -0.4, 0.4))
  annotation([Channel isolation], "left",  6.3,  (0,))
})

==== Radio Receiver

Radio receivers gather signals from radio senders on the same channel and isolation level, and output their sum. The logic channel of the output is always 0. Logic inputs to the radio receiver are ignored, only radio senders are taken into account.

#settings-intro()

- Keybinds: see @keybinds
- Toggle: see @toggle
- Timers: see @timers
- Channel: RC channel in which to receive the signals
- Channel isolation: visibility type of the channel
  - None: channel is shared by all players
  - Team: channel is shared by all players of the same team. Different teams won't see each other's signals
  - Player: channel is different for each player. Different players won't see each other's signals
  - The player/team of the RC block is determined by the player who owns (spawned) the creation

#settings-annotation({
  annotation([Output (off)],      "right", 4.35, (0,))
  annotation([Output (on)],       "right", 5.35, (0,))
  annotation([Keybinds/toggles],  "left",  2.2,  (0,))
  annotation([Channel],           "left",  3.8,  (0,))
  annotation([Timers],            "left",  4.9,  (0, -0.4, 0.4))
  annotation([Channel isolation], "left",  6.3,  (0,))
})
