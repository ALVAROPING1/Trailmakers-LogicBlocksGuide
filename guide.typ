// LTeX: enabled=false

#import "/conf.typ": conf, newpage, table-stroke, booktab-table

#show: conf.with(
  title: "Logic Blocks Guide",
  author: "ALVAROPING1",
  date: datetime.today(),
)

#import "/deps.typ": *

/// LaTeX's `\noindent`, removes the first-line indentation of the paragraph
#let noindent(body) = par(body, first-line-indent: 0pt)

#let scientific(x, ..args) = num(x, exponent: "sci", round: (precision: 3), product: sym.dot, ..args)
#let eval-math(expr, values: ()) = symbolica.evaluate(symbolica.math(expr), values: values).re

#let maxFloat = $(2 - 2^(-23)) dot 2^127$
#let maxFloatApprox = scientific(eval-math(maxFloat))

#let hfrac(x, y) = $frac(#x, #y, style: "horizontal")$
#let tick = $hfrac(1, 60) "s"$

#let steam(id, body) = link("https://steamcommunity.com/sharedfiles/filedetails/?id=" + id, body)

#let block-ref(id) = link(id, {
  let name = str(id).replace("-", " ")
  upper(name.at(0)) + name.slice(1)
})
#let math-blocks = block-ref(<math-blocks>)
#let logic-gates = block-ref(<logic-gates>)

// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║                                 Document                                  ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

= Introduction

#let trailmakers = link("https://store.steampowered.com/app/585420/Trailmakers/")[Trailmakers]

The goal of this document is to explain the logic system in the game #trailmakers. It also aims to act as a
comprehensive technical reference manual for all related mechanics and behaviours. This document also contains a section
about commonly used logic circuits and how to make them, to aid in the design and understanding of more complex logic
circuits.

= Logic Blocks

// chapter on new page
#show heading.where(level: 1): it => {
  newpage()
  it
}

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

#let curr-block-name() = query(selector(heading).before(here())).last().body
#let curr-block-id() = lower(curr-block-name().text).replace(" ", "_")

#let settings-intro(prefix: [Its]) = context noindent[
  #prefix settings are shown in #ref(label("fig:" + curr-block-id())) and are as follows:
]

#import "/utils/diagrams.typ": annotated-img, annotation

#let settings-annotation(name: auto, ..args) = context [
  #let name = if name == auto { curr-block-name() } else { name }
  #let id = curr-block-id()
  #figure(
    annotated-img("/img/" + id + ".png", ..args),
    caption: [#name settings]
  ) #label("fig:" + id)
]

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

Aiming sensors measure the angle of the block relative to the closest direction to camera direction in the plane defined by the square faces of the block. This is done by projecting the camera direction vector onto the plane, and comparing a vector fixed to the block against that projection. The camera direction used is always that of the player who owns (spawned) the creation, although with an upwards pitch offset explained in @AimingServoPitch. They have a display which shows the currently measured angle, with a light blue section representing the activation threshold and an output arrow representing the projected direction.

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
  image("img/output_value_diagram.png", width: 100%),
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
        subticks: 1,
        ticks: range(-6, 7).map(i => i/6),
        format-ticks: (ticks, ..args) => {
          let tick-info = (..args.tick-info, significant-digits: 2)
          lq.tick-format.linear(ticks, ..args, tick-info: tick-info)
        }
      ),
      yaxis: none,
      grid: none,
      margin: 0%,
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

= Common block settings

These are settings shared by all blocks in the game that can be activated with input signals.

== Keybinds <keybinds>

Keybinds are the most common input to activate a block, and all blocks that can be activated have either a single keybind (green) or two keybinds (green and red).

- All keybinds on a single block act as a single input for each seat
  - An AND gate with a green and a red keybind configured will send an output when just pressing one of the 2 keybinds, but will require someone in each seat that has control over it pressing the keybind to send an output
  - If no keybinds are configured, the input isn't taken into account. This only makes a difference in AND gates, which would otherwise be impossible to trigger without keybinds
- The green keybind has a positive value while the red keybind has a negative one. For more information about input values, see @signals
  - For input methods that don't support analog inputs (keyboards and normal buttons on controllers), the value is always $1$
  - For input methods that support analog inputs (controller joysticks and triggers), the value is the one given by the input method normalized to the range $[0, 1]$

== Toggle <toggle>

Toggle allows to make inputs alternate the activation state of a block between on and off without requiring a continuous input signal to remain active.

- There is a toggle setting associated with positive inputs (below the green keybind) and another with negative ones (below the red keybind)
- Toggles *inputs*
  - When the sum of the inputs goes from $0$ to a different value, multiple things happen depending on the new value:
    + If the opposite sign of the input is toggled on, it is toggled off instantly
    + If the sign of the input has toggle enabled, it is toggled: if it was off it turns on, and if it was on it turns off (which will happen on the falling edge of the input). Otherwise, the gate is enabled normally
  - Toggle retains the value of the last non-$0$ sum of inputs while active
  - To toggle the output instead of the inputs, make the signal go through another gate with the toggle

== Timers <timers>

Timers are a group of settings that allow to automate the activation/deactivation of a block after a set amount of time.

#let textarrow = sym.arrow

- Timers apply to the inputs of the block and are shared by all of them, and start as soon as the block receives a *single input*. For logic blocks, this still applies even if the block doesn't meet its conditions to send an output
- The number will be rounded to have only 2 decimal places when shown on the menu, but the number which will be used is the one written rounded to 8 decimal places. Due to a bug, only up to 5 characters can be written, so depending on the exact value the number of decimals which can be used will vary
- All values are specified in seconds
- Delay: amount of time between the block receives an input and the block activates
  - Note: each logic gate has an extra delay of #tick due to the state of all the logic gates being updated once per physics' frame at the same time
- Duration (previously active time): amount of time before the block automatically deactivates after it has been activated
  - A value of $0$ indicates that it will never deactivate automatically
  - Shortest pulse length is $1$ frame (#tick), values smaller than this won't activate the block
- Pause (previously inactive time): amount of time before the block reactivates and the duration timer is restarted, after the duration timer expires
  - A value of $0$ indicates that the block will never reactivate automatically
  - It's ignored if the duration timer is $0$
- During the delay/pause timers, the block is deactivated by overriding the input value with $0$
- The order of the timers is as follows: delay #textarrow duration #textarrow pause #textarrow back to duration (if pause is $0$ it ends after the duration ends)
- In the case of the delay and duration timers, even though their values are expressed in seconds, the game handles them as a number of frames, which can be calculated with $"seconds" dot 60$
  - If this number is not an integer, it will be rounded down to the nearest integer
  - If this number is an integer, it will randomly either be kept as it is or be subtracted one frame depending on the exact value used, so it's recommended to add $0.01$ to the original number to make sure it always stays in the correct number of frames
  - Pause timers aren't subject to this, and the exact time in seconds is used for them

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

= Useful Circuits <useful-circuits>

This section contains commonly used logic circuits and how to make them, to aid in the design and understanding of more complex logic circuits.

== Pulse generator/Rising edge detector

- Sends a pulse of a specific length (usually a single frame which is #tick) when the input goes from off to on
- Made by setting the duration to the length of the pulse on an OR gate

== Falling edge detector

- Sends a pulse of a specific length when the input goes from on to off
- Made by connecting a NOT gate to a pulse generator

== Latch (T-FlipFlop)

- Stores a single bit of information
- Made by activating toggle on an OR gate, requires the input to be a pulse to be easily controlled by other gates (use a pulse generator for this)

== Counter

#let example-bps(id1, id1c, id2, id2c) = [
  Example blueprints: #steam(id1)[1-way], #steam(id1c)[1-way+cycle], #steam(id2)[2-way] and #steam(id2c)[2-way+cycle]
]

- Stores the value of a variable with $n$ possible (discrete) values
- Depending on how it's made, it can be 1 or 2 way and have cycle or not
  - 1-way: the value can only be increased
  - 2-way: the value can be both increased and decreased
  - Cycle: determines if trying to increase/decrease the value past its maximum/minimum will result in it cycling back to the smallest/biggest value or staying at the maximum/minimum value
  - Base designs described are 1-way without cycle, with the modifications needed to implement 2-way or cycle being explained afterwards
- The complexity of a design is the amount of logic gates used by it without counting the ones used to create a startup pulse or always on sensors (those can be reused)
- There are 3 ways of doing it: general circuit (base $N$), decimal (base $10$) and binary (base $2$). Which one is least complex depends on the situation
  - The general circuit and decimal methods can be implemented using logic gates or accumulators. Generally accumulator-based counters are less complex, but logic gate based designs will still be described as they can be less complex under some circumstances (like needing a counter which only changes its value when a function of its current value is true)

=== General Circuit (Base $N$)

==== Logic Gates Implementation

- $n = "amount of cells"$
- The output is encoded as the position of the active gate in the row of output gates (with the one from the first cell being the minimum value and the one from the last cell being the maximum value)
- Diagram of the circuit:

#figure(
  cetz.canvas({
    import "/utils/diagrams.typ": *
    // Nodes
    let cells = (
      (name: $1$),
      (name: "h1", hidden: true),
      (name: $k$),
      (name: $k+1$),
      (name: "h2", hidden: true),
      (name: $n$),
    )
    cell-group(cells, (
      (body: [Toggled OR gate with 1 frame delay (output)]),
      (body: [AND gate], arrows: "both", hide-last: true),
    ))
    node(name: "input-gate", (rel: (0, -1.5), to: "cells.south"), [1 frame pulse generator (input)])

    // Arrows
    // Between cells
    for curr in range(1, cells.len()) {
      arrow(cell-anchor(curr - 1, "1.east"), "-|-", cell-anchor(curr, "0.west"))
    }
    // Input connections
    let input = (rel: (0, 0.5), to: "input-gate.north")
    arrow(pos: "symbol", "cells.c0.body.south", "|-", input, "-|", "cells.c4.body.south")
    line(input, "input-gate")
    for target in range(1, cells.len() - 2) {
      arrow(cell-anchor(target, "south"), ((), "|-", input), pos: "start")
    }
  }),
  caption: [Diagram of the general method counter (logic gates implementation)]
) <fig:CounterGeneral>

- To add cycle, add an AND gate to the last cell configured in the same way as the others and using the first cell as its next cell
- To make it 2-way, add a new AND gate to each cell configured in the same way as the other one but going in the opposite direction and using a different pulse generator as input
- Requires a startup pulse to one of the toggled OR gates to work (achieved with a 1 frame pulse generator)
- Complexity
  - 1-way: $2n$
  - 1-way+cycle: $2n + 1$
  - 2-way: $3n$
  - 2-way+cycle: $3n + 1$
- Takes 3 frames to update
- #example-bps("2134486907", "2134487841", "2075055361", "2134489564")

==== Accumulators Implementation

- $n = "amount of comparators"$
- The output is encoded as the active comparator
- Made by choosing $n$ equally spaced numbers, configuring an accumulator to use steps and setting its minimum, maximum, and scale settings to go through those numbers as the value is changed, and connecting the accumulator to $n$ comparators set to equality with each of the chosen numbers
  - The minimum/maximum must be the minimum/maximum chosen numbers, and the scale their spacing. Additionally, in order for the comparators to work, $"spacing" >= 0.001$ must hold
  - If $"minimum" <= 0 <= "maximum"$, $0$ should be within the chosen numbers. Otherwise, the counter needs to be pushed to its minimum/maximum value to initialize it
  - For simplicity, the integers from $0$ to $n-1$ are usually used by setting the minimum/maximum values to $0$/$n-1$ respectively and the scale to $1$, but other configurations can be useful in certain circumstances
    - Using a negative minimum value allows the initial value to not be the lowest value, which might be useful for 2-way counters
    - Using (positive) scale values closer to $0$ allows to increase the amount of stored values beyond $101$
    - Using different minimum/maximum values might reduce the complexity if analog value outputs are wanted by avoiding having to perform transformation of the value ranges
  - The value can be increased/decreased by sending a $plus.minus 1$ input to the accumulator (the circuit is the same for 1 and 2-way)
  - In some cases, it might be useful to not enable use steps and set the scale to $60 dot "spacing"$. This allows to change the stored value on each frame, but requires the input to come from a  1 frame pulse generator to get the normal input behaviour
- To add cycle, connect the comparator with the biggest threshold to an AND gate with the positive accumulator input as its second input. Connect that AND gate to an arithmetic logic block set to multiplication with a $-1000$ constant and $0.02$ duration, and that arithmetic logic block to the accumulator
  - The normal input to the accumulator must come from a 1 frame pulse generator
  - If using the circuit as 2-way, repeat the process with the comparator with the smallest threshold and the negative input of the accumulator. The AND gate should have an additional $-2$ always on input (which can be achieved with an arithmetic logic block set to addition with a $-1000$ constant). The arithmetic logic block and input pulse generator can be reused, using negative inputs to reduce the value
- Complexity
  - 1-way: $n+1$
  - 1-way+cycle: $n+4$
  - 2-way: $n+1$
  - 2-way+cycle: $n+5$
- Takes 2 frames to update without cycle, and 3 frames otherwise
- #example-bps("3309036414", "3309036347", "3309036504", "3309036241")

=== Decimal (Base $10$)

==== Logic Gates Implementation

- Works best when $n$ is of the form $c dot 10^k$ where $c$ is an integer in the range $[1, 9]$ and $k$ is any positive integer. If it isn't, more gates are needed to cap the value at $n$
- $n = 10^"amount of cells"$; $"amount of cells" = ceil(log_10 n)$
- Each cell is the general circuit for $n=10$ with cycle and no input gate, except for the last cell which can have any value $2 <= n <= 10$ and doesn't need to have cycle
- The output is encoded as a decimal number with a digit stored in each cell (with the first cell being the least significant digit and the last cell being the most significant digit)
- Diagram of the circuit:

#figure(
  cetz.canvas({
    import "/utils/diagrams.typ": *
    // Nodes
    let cells = (
      (name: $1$),
      (name: "h1", hidden: true),
      (name: $k$),
      (name: $k+1$),
      (name: "h2", hidden: true),
      (name: $ceil(log_10 n)$),
    )
    cell-group(cells, (
      (body: [All OR gates except the last]),
      (body: [Last OR gate], hide-last: true),
      (body: [All AND gates]),
    ))
    input-circuit(2cm, [1 frame pulse generator (input)], [OR gate])

    // Arrows
    let input-dist = (rel: (0, -5mm), to: "cells.c0.south")
    let input = (rel: (0, -5mm), to: input-dist)
    let step = ((rel: (0, 5mm), to: "cells.c0.north"), "-|", (rel: (5mm, 0), to: "cells.c5.body.east"))

    arrow("input.body.right.north", "|-", input, "cells.c0.body.south")
    line("input.body.left.north", ((), "|-", input))

    let end = "cells.c4.body.1.east"
    line-spec(input-dist, "-|", (end, "-|", gap(4)), end)
    arrow("cells.c0.body.0.east", ((), "-|", gap(0)), "|-", step, "|-", "input.body.right.east")

    for i in range(4) {
      line-spec(cell-anchor(i, "1.east"), "-|", (input-dist, "-|", gap(i)))
      line-spec(cell-anchor(i+1, "0.east"), "-|", (step, "-|", gap(i+1)))
      let v = (gap(i), 50%, gap(i+1))
      mark((v, "|-", input-dist), (rel: (1, 0)), ..arrow-mark("symbol"))
      mark((v, "|-", step), (rel: (1, 0)), ..arrow-mark("symbol"))
    }
    mark((input-dist, "-|", (input-dist, 50%, gap(0))), (rel: (1, 0)), ..arrow-mark("symbol"))
    mark((step, "-|", (step, 50%, gap(4))), (rel: (1, 0)), ..arrow-mark("symbol"))

    for i in range(5) {
      arrow(cell-anchor(i+1, "2.west"), ((), "-|", gap(i)), pos: "start")
    }
    line("cells.c5.body.0.east", ((), "-|", step))
  }),
  caption: [Diagram of the decimal method counter (logic gates implementation)]
) <fig:CounterDecimal>

- To add cycle, add cycle to the last cell and remove the OR gate from the input circuit
- To make it 2-way, duplicate the input circuit but connect all OR gates except the first from each cell to the OR gate. Then, make each cell 2-way, connect the cells in the same direction using the first OR gate of each cell rather than the last, and connect the new input circuit to all AND gates for the second direction
- Might require a decoder (unless you want to show numbers on a screen)
  - To create it, take $n$ AND gates and assign a different combination of 1 output gate from each cell to each of them (if you only need to use it combined with other circuits, you can combine all of their decoders into a single one to use less gates)
  - Has a complexity of $n$ gates
- Requires a startup pulse to one of the toggled OR gates on each cell to work (achieved with a 1 frame pulse generator)
- Complexity
  #let complexity(a, b, c) = $#a ceil(n/10^(ceil(log_10 n) - 1)) + #b ceil(log_10 n) - #c$
  - 1-way:       #complexity(2, 20, 19)

  - 1-way+cycle: #complexity(2, 20, 19)

  - 2-way:       #complexity(3, 30, 28)

  - 2-way+cycle: #complexity(3, 30, 28)
- Takes 3 frames to update with cycle and 4 frames otherwise
- #example-bps("2134491881", "2134492935", "2134494676", "2134496082")

==== Accumulator Implementation

- Works best when $n$ is of the form $c dot 10^k$ where $c$ is an integer in the range $[1, 9]$ and $k$ is any positive integer. If it isn't, more gates are needed to cap the value at $n$
- $n = 10^"amount of cells"$; $"amount of cells" = ceil(log_10 n)$
- Each cell is the general circuit implemented with accumulators for $n=10$ with cycle and without use steps, except for the last cell which can have any value $2 <= n <= 10$ and doesn't need to have cycle
- The output is encoded as a decimal number with a digit stored in each cell (with the first cell being the least significant digit and the last cell being the most significant digit)
- Made by connecting the last comparator of each cell to the AND gate from the cycle circuit of all following cells, and the AND gate from the cycle circuit of each cell to the accumulator of the next cell.
  - Requires a different input circuit: the positive input should be in a 1 frame pulse generator connected to an AND gate connected to the accumulator of the first cell and the AND gate from the cycle circuit of all cells. All comparators except the last on each cell should be connected to an OR gate connected to the AND gate from the input circuit
- To add cycle, add cycle to the last cell and remove all the gates in the input circuit except the pulse generator, which should be connected to the accumulator of the first cell and the AND gate from the cycle circuit of all cells
- To make it 2-way, duplicate the input circuit but connect all comparators except the first from each cell to the OR gate. Then, make each cell 2-way, connect the cells in the same direction using the first comparator of each cell rather than the last, and connect the new input circuit to all AND gates for the second direction
  - The AND gate from the second input circuit should have a $-1$ output scale
- Might require a decoder (unless you want to show numbers on a screen)
  - To create it, take $n$ AND gates and assign a different combination of 1 comparator from each cell to each of them (if you only need to use it combined with other circuits, you can combine all of their decoders into a single one to use less gates)
  - Has a complexity of $n$ gates
- Complexity
  #let complexity(b, c) = $ceil(n/10^(ceil(log_10 n) - 1)) + #b ceil(log_10 n) - #c$
  - 1-way:       #complexity(13, 9)

  - 1-way+cycle: #complexity(13, 9)

  - 2-way:       #complexity(14, 7)

  - 2-way+cycle: #complexity(14, 8)
- Takes 3 frames to update
- #example-bps("3309037356", "3309037285", "3309037105", "3309037186")

=== Binary (Base $2$)

- Works best when $n$ is a power of $2$. If it isn't, more gates are needed to cap the value at $n$
- $n = 2^"amount of cells"$; $"amount of cells" = ceil(log_2 n)$
- The output is encoded as a binary number with a bit stored in each cell (with the first cell being the least significant digit and the last cell being the most significant digit)
- Diagram of the circuit:

#figure(
  cetz.canvas({
    import "/utils/diagrams.typ": *
    // Nodes
    let cells = (
      (name: $1$),
      (name: "h1", hidden: true),
      (name: $k$),
      (name: $k+1$),
      (name: "h2", hidden: true),
      (name: $ceil(log_2 n)$),
    )
    cell-group(cells, (
      (body: [Toggled OR gate (output)]),
      (body: [AND gate], arrows: "up"),
    ))
    input-circuit(1.5cm, [1 frame pulse generator (input)], [NAND gate])

    // Arrows
    // Between cells
    for i in range(5) {
      arrow(cell-anchor(i, "0.east"), "-|-", cell-anchor(i + 1, "1.west"))
    }

    // Input
    let input = ("cells.south", 50%, "input.north")
    let top-line = ((rel: (0, 5mm), to: "cells.c0.north"), "-|", (rel: (5mm, 0), to: "cells.c5.body.east"))

    arrow(pos: "symbol", "cells.c0.body.south", "|-", input, "-|", "cells.c5.body.south")
    for i in ("left", "right") {
      line("input.body." + i + ".north", ((), "|-", input))
    }
    for i in range(1, cells.len() - 1) {
      arrow(cell-anchor(i, "south"), ((), "|-", input), pos: "start")
      line((cell-anchor(i, "0.east"), "-|", gap(i)), ((), "|-", top-line))
    }

    arrow(("cells.c0.body.0.east", "-|", gap(0)), "|-", top-line, "|-", "input.body.right.east")
    line("cells.c5.body.0.east", ((), "-|", top-line))

    for i in range(4) {
      let v = (gap(i), 50%, gap(i+1))
      mark((v, "|-", top-line), (rel: (1, 0)), ..arrow-mark("symbol"))
    }
    mark(((gap(4), "|-", top-line), 50%, top-line), (rel: (1, 0)), ..arrow-mark("symbol"))
  }),
  caption: [Diagram of the binary method counter]
) <fig:CounterBinary>

- To add cycle, remove the NAND gate from the input circuit and the AND gate on the first cell, and connect the 1 frame pulse generator directly to the OR gate in the first cell
- To make it 2-way, add a NOT gate to each cell with its OR gate as input and a new AND gate connected in the same way as the old AND gate, but using the NOT gate of all previous cells as input instead of the OR gates. Then replace the NAND gate on the input circuit with an OR gate and duplicate it (with the copy being connected to the new AND gates on each cell rather than the old ones). Connect the NOT gate of all the cells to the OR gate of the first input circuit, and the OR gate of all the cells to the OR gate of the second input circuit
- Might require a decoder
  - To create it, add a NOT gate to each cell and replace the NAND gate of the input circuit with an OR gate like in the 2-way version (if using the 1-way versions). Then, take $n$ AND gates and assign each of them a different combination of either the OR or NOT from each cell (if you only need to use it combined with other circuits you can combine all of their decoders into a single one to use less gates)
  - Has a complexity of $ceil(log_2 n) + n - 1$ for the 1-way version, $ceil(log_2 n) + n$ for the 1-way+cycle version and $n$ for the 2-way versions
- Complexity
  #let complexity(a, b) = $#a ceil(log_2 n) #if b != 0 { $+ #b$ } else {}$
  - 1-way:       #complexity(2, 3)
  - 1-way+cycle: #complexity(2, 0)
  - 2-way:       #complexity(4, 4)
  - 2-way+cycle: #complexity(4, 0)
- Takes 3 frames to update for 1-way+cycle and 4 frames otherwise
- #example-bps("2134497489", "2134498845", "2134500019", "2134500705")

=== When to use each method

#figure(
  table(
    columns: (auto, 20em, 20em),
    align: (x, y) => if x == 0 or y == 0 {center+horizon} else {left},
    stroke: (x, y) => if x != 0 or y != 0 { table-stroke.thick },
    "", [*1-way*], [*2-way*],
    rotate(-90deg, reflow: true)[*Without cycle*],
    [
      Doesn't require an individual decoder:
      - For $n <= 10$ use the general circuit
      - For $n > 10$ use the binary circuit
      \
      Show values directly on a screen (only numbers for $n > 18$):
      - For $n <= 18$ use the general circuit
      - For $n > 18$ use the decimal circuit
    ],
    [
      Doesn't require an individual decoder:
      - For $n <= 23$ use the general circuit
      - For $n > 23$ use either the binary or decimal circuit
      Show values directly on a screen (only numbers for $n > 23$):
      - For $n <= 23$ use the general circuit
      - For $n > 23$ use the decimal circuit
    ],
    rotate(-90deg, reflow: true)[*With cycle*],
    [
      Doesn't require an individual decoder:
      - Use the binary circuit
      \
      \
      \
      \
      \
      Show values directly on a screen (only numbers for $n > 15$):
      - For $n <= 15$ use the general circuit
      - For $n > 15$ use the decimal circuit
    ],
    [
      Doesn't require an individual decoder:
      - For $n = 4$, $n = 8$, or $11 < n <= 32$ use the binary circuit
      - For $4 < n <= 7$ or $8 < n <= 11$ use the general circuit
      - For $n > 32$ use either the binary or decimal circuit
      Show values directly on a screen (only numbers for $n > 17$):
      - For $n <= 17$ use the general circuit
      - For $n > 17$ use the decimal circuit
    ],
  ),
  caption: [Comparison of the different counter methods]
) <table:CounterComparison>

Notes:

- Calculated for $n >= 3$, for $n = 2$ a latch is always best
- All mentions of the general and decimal circuits refer to the accumulator-based implementations
- If an individual decoder is needed, the general circuit is always best
- For 2-way without an individual decoder, decimal and binary circuits are very close in terms of complexity. Use their complexity formulas to figure out which is best for your use case. If they have the same complexity, decimal is better due to being faster
- This is just based on the amount of logic gates each circuit uses (unless there is a tie, in which case update speed is used). However, the amount of time it takes for the system to update might also matter depending on the situation. In that case, refer to the circuits' descriptions to compare the speed for the needed use case

== No-Delay Signal Toggle

- Allows to enable/disable an analog signal without increasing the signal delay like normal AND/XOR gate methods do
- Doesn't work when the output block is an AND/XOR gate
- Commonly used to enable/disable angle sensor stabilization (with the input being angle sensors and the output helicopter engines)

#figure(
  cetz.canvas({
    import "/utils/diagrams.typ": *
    // Nodes
    node((),                                  [Input Signals (can be multiple blocks)], name: "input")
    node(..pos(5cm, "input").r, [Output Blocks], name: "output")
    node(..pos(1.5cm, "input").u, [OR Gate with toggle keybind], name: "toggle1")
    node(..pos(5cm, "toggle1").r, [OR Gate with toggle keybind], name: "toggle2")
    let toggles = ("toggle1", 50%, "toggle2")
    let middle = ("input.north", 50%, "toggle1.south")
    node((toggles, "|-", middle), [XOR gate with -1 output scale], name: "XOR")

    // Arrows
    arrow("input", "output")
    arrow("input", "|-", "XOR")
    arrow("XOR", "-|", "output")
    line("toggle1", "toggle2")
    arrow(toggles, "XOR")
    mark(("toggle1.east", 50%, toggles), toggles, ..arrow-mark("symbol"))
    mark(("toggle2.west", 50%, toggles), toggles, ..arrow-mark("symbol"))
  }),
  caption: [Diagram of the no-delay signal toggle]
) <fig:NoDelaySignalToggle>

- #steam("3054610284")[Example blueprint]

= Historical Circuits

This section contains old circuits that were previously in @useful-circuits, but have since been superseded by new blocks. They are kept here for historical reasons and in case they are seen in older circuits.

== NOR/NOT Gate

- Superseded by the NOR gate block
- Inverts the state of the input
- Made by connecting an always on input (a sensor that is always on, all sensors can be configured to work like this but the most commonly used one is a distance sensor with 0 range and invert trigger) to a XOR gate
- If it only has a single input that isn't the always on input it will act as a NOT gate, if it has multiple it will act as a NOR gate
- You can make a NAND/XNOR gate by making an AND/XOR gate output to a NOT gate and taking the output from the NOT gate

== Feedback Loop

- Superseded by accumulators
- Allows to store an analog value in the range $[-1, 1]$
- Made by connecting 2 OR gates to each other, connecting the input to both of them, and taking the output from one of them
- Each frame the input is active, the stored value increases by the value of the input
  - With a close to 0 input value, the circuit can be used to generate an analog output value
- One of the OR gates can be replaced with an XOR to add a reset input. In this case, the normal input should go to the OR gate only and the reset input must be 2 different signals connected to the XOR gate
  - Be aware that this method adds a 1 frame jitter to the stored signal

=== Clamped Feedback Loop

- Allows limiting the output signal of a feedback loop to the range $[0, 1]$
- Diagram of the circuit:

#figure(
  cetz.canvas({
    import "/utils/diagrams.typ": *
    // Nodes
    cell(0, [Feedback Loop], (
      (body: [OR Gate]),
      (body: [OR Gate], arrows: "both"),
    ))
    node(..pos(1cm, "c0.body").l, [Input Signal], name: "input")

    node(..pos(1cm, "c0.body.1").r, [Always on sensor], name: "c+1")
    node(..pos(5mm, "c+1").u, [OR gate with -1 output scale], name: "c-1")

    node(..pos(1cm, "c-1").r, [OR gate with -1 output scale (output)], name: "output")

    // Arrows
    let input-split = (rel: (5mm, 0), to: "input.east")
    line("input", input-split)
    arrow("c0.body.0.west", "-|", input-split, "|-", "c0.body.1.west", pos: "symbol")
    arrow("c+1", "c0.body.1.east")
    arrow("c+1", "c-1")
    arrow("c-1", "output")
    arrow("c0.body.0.east", ((), "-|", "c-1.west"), pos: "start")
    arrow("c0.body.south", (rel: (0, -5mm), to: "c0.body.south"), "-|", "output")
  }),
  caption: [Diagram of the clamped feedback loop]
) <fig:ClampedFeedbackLoop>

- Note: the input signal is reversed. This means that a negative value increases the stored value while a positive value decreases it
- Keybinds can be added to one of the OR gates in the feedback loop to go to the max/min value. The green keybind sets the min value while the red keybind sets the max value
- #steam("2911246646")[Example blueprint]
- Python script to simulate the behaviour (input value is automatically reversed):
  ```python
  def clamp(x: float) -> float:
      return min(max(x, -1), 1)

  def update(
      feedback_top: float, feedback_bottom: float, user_input: float
  ) -> tuple[float, float]:
      return (
          clamp(feedback_bottom - user_input + 1),
          clamp(feedback_top    - user_input - 1)
      )

  def print_state(feedback_top: float, feedback_bottom: float):
      print("State:")
      print("\tFeedback Top: ", round(feedback_top, 3))
      print("\tFeedback Bottom: ", round(feedback_bottom, 3))
      print("Output: ", round(clamp(-(feedback_top - 1)), 3))

  feedback_top, feedback_bottom = 1, 0
  print_state(feedback_top, feedback_bottom)
  while True:
      user_input = input("Enter input (between -1 and 1, Q to quit): ")
      if user_input.lower() == "q":
          break
      try:
          user_input = float(user_input)
      except ValueError:
          print("Invalid input. Try again")
          continue
      feedback_top, feedback_bottom = update(feedback_top, feedback_bottom, user_input)
      print_state(feedback_top, feedback_bottom)
  ```
- Credits to Precache for figuring out this circuit

#show heading.where(level: 1): set heading(
  // configure supplement
  supplement: "Appendix",
  // show just appendixes titles in outline
  outlined: true,
  numbering: "A ",
)
#counter(heading).update(0)

= Input value to multiplier for hinges/wings with control surfaces <InputValueMultiplier>


By default, the angle by which hinges/wings/other blocks with the "steering help" setting rotate doesn't scale linearly with the input value. The angle is smaller than what a linear relationship would result in, to improve steering on controller. In hinges, this can be adjusted with the steering mode setting, where a "linear" value results in a linear relationship while any other value results in the non-linear relationship. This section contains the multipliers used for many input values in the non-linear relationship, found experimentally. Some notes about this process:

- Final angle is the resulting angle of the hinge measured with a max angle of $90 degree$ and an error of $plus.minus 0.005 degree$
- The multiplier was calculated with $"multiplier" = "final angle"/90$
- A calculator using this data made by confusionextended can be found #link("https://www.desmos.com/calculator/i70yadxqyy")[here]

#let load-data(path) = {
  let data = read(path).split("\n").slice(1).map(l => l.split(" "))
  data
}

#let zip((first, ..rest)) = first.zip(..rest)

#let transpose(data, cols) = {
  let col-size = calc.ceil(data.len()/cols)
  let default = ("",) * data.at(0).len()
  let fill = col-size * cols - data.len()
  zip((data + (default,) * fill).chunks(col-size))
}

#let data-table(header, cols, data, caption, label: none) = [
  #show figure: set block(breakable: true)
  #figure(
    booktab-table(
      columns: header.len() * cols,
      align: center + horizon,
      row-gutter: 0pt,
      ..range(1, cols).map(i =>
        table.vline(stroke: table-stroke.thick, x: i * header.len())
      ),

      table.header(..(header.map(h => [*#h*])) * cols),
      ..transpose(data, cols).flatten(),
    ),
    caption: caption
  )
  #if label != none {
    assert(
      type(label) == std.label,
      message: "You must provide a label, e.g. `<table:id>`",
    )
    label
  }
]

#let get-cols(data, ..cols) = cols.map(c => data.map(row => float(row.at(c))))

#let process-row(row) = {
  row.insert(1, strfmt("{:.3}", float(row.at(1)) * 90))
  row
}

#let data = load-data("data/Input_Value_Multiplier.dat").map(process-row)

#data-table(
  ([Input\ Value], [Final\ Angle], [Multiplier]),
  3,
  data,
  [Raw data of the input value multiplier for hinges],
  label: <table:InputValueMultiplierData>
)

#show: lq.set-tick(inset: 4pt)
#show: lq.set-diagram(
  height: 27.5em,
  width: 42em,
  margin: 0%,
  xaxis: (subticks: 1),
  yaxis: (subticks: 1),
  legend: (position: top+left),
)

#let plot-fn(range, expr, label: auto, ..args) = lq.plot(
  range,
  x => eval-math(expr, values: ((symbolica.symbol("x"), x),)),
  label: if label == auto {$y = #expr$} else { label },
  color: black,
  stroke: 1.2pt,
  mark: none,
  ..args
)

#let plot-data(xs, ys, label: auto, ..args) = lq.plot(
  xs, ys,
  label: if label == auto {$f(x)$} else { label },
  mark: "o",
  ..args
)

#figure(
  lq.diagram(
    title: [Multiplier as a function of the input value],
    xlabel: [Input value],
    ylabel: [Multiplier],
    plot-data(..get-cols(data, 0, 2), clip: false),
    plot-fn((0, 1), $x$)
  ),
  caption: [Graph of the multiplier for hinges as a function of the input value]
) <fig:InputValueMultiplierGraph>

= Input value to speed for servos with hold position <InputValueSpeed>

Due to a bug, the speed at which rotating servos with hold position rotate changes with the input value when small values are used. This section contains the speed multipliers used for many input values, found experimentally. Some notes about this process:

- Speed is the speed required on a servo with an input value of $1$ to match the speed of a servo with a speed being tested and the given input value, with an error of $plus.minus 0.00005$ speed units for speeds lower than $1$ and an error of $plus.minus 0.0005$ otherwise
  - To compare the speeds of the servos, they were run continuously for some time and the final angle was compared
    - For servos with $360$ angle, they were run for $3$ min
    - For servos with less than $360$ angle, they were run for slightly less than the time required to reach the maximum angle
  - Servos with a configured speed of $1$ and $2$ as well as $360$ and $180$ angle were tested, with other speeds/angles being checked to verify the results
- $f_(s, a)(x)$ represents the resulting speed of a servo with $s$ speed, $a$ angle, and $x$ input value
- The resulting speed can be approximated by $hat(f)_(s, a)(x) = min(x/0.0611 dot a/90, s)$

#let path = "data/Input_Value_Speed{}_{}.dat"
#let load-file(angle, speed) = load-data(strfmt(path, speed, angle)).slice(0, -1)
#let data-cases = (180, 360).map(a => (1, 2).map(s => (a, s))).join()
#let data = data-cases.map(conf => (conf, load-file(..conf)))
#let xlim = (0, 0.0625)
#let fhat(angle) = $x/0.0611 dot #angle/90$

#figure(
  lq.diagram(
    title: [Speed as a function of the input value],
    xlabel: [Input value],
    ylabel: [Speed],
    xlim: xlim,
    ylim: (0, 2),
    yaxis: (tick-distance: 0.2),
    cycle: (green, blue, rgb("#0000ff"), rgb("#ff0000")),
    ..data.enumerate().map(((i, ((a, s), d))) => plot-data(
      ..get-cols(d, 0, 1),
      label: $f_(#s, #a)(x)$,
      z-index: if i < 2 {2.1} else {2},
    )),
    ..((180, 35%, right), (360, 75%, left)).map(((a, pos, align)) => (
      plot-fn(xlim, fhat(a), label: none, z-index: 2.2),
      lq.place(pos, 1.5, pad(1em, $y = #fhat(a)$), align: align)
    )).flatten()
  ),
  caption: [Graph of the speed for servos with hold position as a function of the input value]
) <fig:InputValueSpeedGraph>

#figure(
  booktab-table(
    columns: 8,
    align: center + horizon,
    row-gutter: 0pt,
    ..range(1, 4).map(i =>
      table.vline(stroke: table-stroke.at(if i == 2 {"thick"} else {"thin"}), x: i * 2)
    ),

    table.header(..(180, 360).map(x => table.cell(colspan: 4)[*Angle #x*]), level: 1),
    table.header(..((1, 2).map(x => table.cell(colspan: 2)[*Speed #x*])) * 2, level: 2),
    table.hline(),
    table.header(..([*Input\ Value*], [*Final\ Speed*]) * 4, level: 3),
    table.hline(),
    ..zip(data.map(((_, d)) => d)).flatten()
  ),
  caption: [Raw data of the input value speed for servos with hold position]
) <table:InputValueSpeedData>

= Aiming sensor pitch measurement <AimingServoPitch>

#let data = load-data("data/Aiming_Sensor_Pitch.dat").slice(0, -1)
#let data-error = data.map(((x, y)) => (x, float(y) - float(x)))
#let avg-error = data-error.map(row => row.at(1)).sum() / data-error.len()
#let avg-error = calc.round(avg-error, digits: 3)

When aiming sensors are used to measure the pitch of the camera, their output is offset from the real camera pitch angle. This section contains the measured values for many camera angles, found experimentally. Some notes about this process:

- Measurements were done using a camera block on a hinge to set the camera pitch to known values, and then taking the measurement from an aiming sensor at the base
- Aiming servos with verticality checks disabled have a similar behavior, although their angle measurement ends up being a lot more noisy
- Angle measurements are in degrees and have an error of $plus.minus 0.0005 degree$
- The average error between the measured pitch and the camera pitch is $#avg-error degree$

#figure(
  lq.diagram(
    title: [Measured pitch as a function of actual pitch],
    xlabel: [Real pitch],
    ylabel: [Measured pitch],
    plot-data(..get-cols(data, 0, 1)),
    plot-fn((-90, 90), $x + #avg-error$, color: red),
    plot-fn((-90, 90), $x$),
  ),
  caption: [Graph of the pitch measured by aiming sensors as a function of the real camera pitch]
) <fig:AimingSensorPitchGraph>

#figure(
  lq.diagram(
    title: [Error in measured pitch as a function of actual pitch],
    xlabel: [Real pitch],
    ylabel: [Error],
    plot-data(..get-cols(data-error, 0, 1), label: none, stroke: 0.4pt),
  ),
  caption: [Graph of the error in pitch measured by aiming sensors as a function of the real camera pitch]
) <fig:AimingSensorPitchGraphError>

#data-table(
  ([Pitch], [Output]),
  5,
  data,
  [Raw data of the aiming sensor pitch measurement],
  label: <table:AimingSensorPitchData>
)

= Tips

- If you want your system to not modify the input that passes through, configure all of the logic gates to have an output scale of 1. Then, if a gate needs to have more inputs other than the original one, make sure the sum of the output values of those other inputs is 0. This will make the output which reaches whatever your system activates be the output that the sensors/keybinds had
- Arithmetics logic blocks can be used to get always on signals with a constant value by using the addition operation with the desired constant. The signal can be toggled by setting the operation to multiplication and using a $+1$ input
- Organize the logic gates on a testbed while working with them before adding them to your vehicle, having the logic gates organized as opposed to scattered across your entire vehicle will make remembering what each gate does easier. There is no wrong way to organize them as long as they aren't randomly placed, but the way I do it is by splitting the gates into groups depending on function, inside each group the arrows of logic gates point towards the outputs of that gate and away from its inputs, then I put the groups of logic gates that a group outputs to in the direction the arrows of the logic gates that the group uses as output are pointing, while I put the groups that group uses as input in the opposite direction
- If you have problems figuring out how to do something with logic gates, draw it on paper first, being able to see all connections at once helps a lot. Another method is writing it with if statements as they translate to logic gates easily (each logic gate is an individual if statement)
- If you still have any questions or need help with something, feel free to
  contact me on the #link("https://discord.gg/trailmakers")[official Trailmakers discord server]

#text(size: 12pt)[*Made by #context document.author.at(0)*]
