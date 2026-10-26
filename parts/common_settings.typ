// LTeX: language=en

#import "/utils/common.typ": tick

= Common block settings

These are settings shared by all blocks in the game that can be activated with
input signals.

== Keybinds <keybinds>

Keybinds are the most common input to activate a block, and all blocks that can
be activated have either a single keybind (green) or two keybinds (green and
red).

- All keybinds on a single block act as a single input for each seat
  - An AND gate with a green and a red keybind configured will send an output
    when just pressing one of the 2 keybinds, but will require someone in each
    seat that has control over it pressing the keybind to send an output
  - If no keybinds are configured, the input isn't taken into account. This only
    makes a difference in AND gates, which would otherwise be impossible to
    trigger without keybinds
- The green keybind has a positive value while the red keybind has a negative
  one. For more information about input values, see @signals
  - For input methods that don't support analog inputs (keyboards and normal
    buttons on controllers), the value is always $1$
  - For input methods that support analog inputs (controller joysticks and
    triggers), the value is the one given by the input method normalized to the
    range $[0, 1]$

== Toggle <toggle>

Toggle allows making inputs alternate the activation state of a block between on
and off without requiring a continuous input signal to remain active.

- There is a toggle setting associated with positive inputs (below the green
  keybind) and another with negative ones (below the red keybind)
- Toggles *inputs*
  - When the sum of the inputs goes from $0$ to a different value, multiple
    things happen depending on the new value:
    + If the opposite sign of the input is toggled on, it is toggled off
      instantly
    + If the sign of the input has toggle enabled, it is toggled: if it was off
      it turns on, and if it was on it turns off (which will happen on the
      falling edge of the input). Otherwise, the gate is enabled normally
  - Toggle retains the value of the last non-$0$ sum of inputs while active
  - To toggle the output instead of the inputs, make the signal go through
    another gate with the toggle

== Timers <timers>

Timers are a group of settings that allow to automate the
activation/deactivation of a block after a set amount of time.

#let textarrow = sym.arrow

- Timers apply to the inputs of the block and are shared by all of them, and
  start as soon as the block receives a *single input*. For logic blocks, this
  still applies even if the block doesn't meet its conditions to send an output
- The number will be rounded to have only 2 decimal places when shown on the
  menu, but the number which will be used is the one written rounded to 8
  decimal places. Due to a bug, only up to 5 characters can be written, so
  depending on the exact value the number of decimals which can be used will
  vary
- All values are specified in seconds
- Delay: amount of time between the block receives an input and the block
  activates
  - Note: each logic gate has an extra delay of #tick due to the state of all
    the logic gates being updated once per physics' frame at the same time
- Duration (previously active time): amount of time before the block
  automatically deactivates after it has been activated
  - A value of $0$ indicates that it will never deactivate automatically
  - Shortest pulse length is $1$ frame (#tick), values smaller than this won't
    activate the block
- Pause (previously inactive time): amount of time before the block reactivates
  and the duration timer is restarted, after the duration timer expires
  - A value of $0$ indicates that the block will never reactivate automatically
  - It's ignored if the duration timer is $0$
- During the delay/pause timers, the block is deactivated by overriding the
  input value with $0$
- The order of the timers is as follows: delay #textarrow duration #textarrow
  pause #textarrow back to duration (if pause is $0$ it ends after the duration
  ends)
- In the case of the delay and duration timers, even though their values are
  expressed in seconds, the game handles them as a number of frames, which can
  be calculated with $"seconds" dot 60$
  - If this number is not an integer, it will be rounded down to the nearest
    integer
  - If this number is an integer, it will randomly either be kept as it is or be
    subtracted one frame depending on the exact value used, so it's recommended
    to add $0.01$ to the original number to make sure it always stays in the
    correct number of frames
  - Pause timers aren't subject to this, and the exact time in seconds is used
    for them
