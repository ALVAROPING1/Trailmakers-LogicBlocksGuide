// LTeX: language=en

#import "/deps.typ": cetz
#import "/utils/common.typ": steam

= Historical Circuits

This section contains old circuits that were previously in @useful-circuits, but
have since been superseded by new blocks. They are kept here for historical
reasons and in case they are seen in older circuits.

== NOR/NOT Gate

- Superseded by the NOR gate block
- Inverts the state of the input
- Made by connecting an always on input (a sensor that is always on, all sensors
  can be configured to work like this but the most commonly used one is a
  distance sensor with 0 range and invert trigger) to an XOR gate
- If it only has a single input that isn't the always on input it will act as a
  NOT gate, otherwise it will act as a NOR gate
- You can make a NAND/XNOR gate by making an AND/XOR gate output to a NOT gate
  and taking the output from the NOT gate

== Counter

#import "useful_circuits.typ": example-bps

- Superseded by accumulators, see @counter for more information
- The complexity of a design is the amount of logic gates used by it, without
  counting the ones used to create a startup pulse or always on blocks (as those
  can be reused)
- There are 3 ways of doing it: general circuit (base $N$), decimal (base $10$)
  and binary (base $2$). Which one is the least complex depends on the situation

=== General Circuit (Base $N$)

- $n = "amount of cells"$
- The output is encoded as the position of the active gate in the row of output
  gates (with the one from the first cell being the minimum value and the one
  from the last cell being the maximum value)
- Diagram of the circuit:

// LTeX: enabled=false
#figure(
  cetz.canvas({
    import "/utils/diagrams.typ": *
    // Nodes
    let cells = ($1$, none, $k$, $k+1$, none, $n$)
    cell-group(cells, (
      (body: [Toggled OR gate with 1 tick delay (output)]),
      (body: [AND gate], arrows: "both", hide-last: true),
    ))
    node(
      name: "input",
      (rel: (0, -1.5), to: "cells.south"),
      [1 tick pulse generator (input)],
    )

    // Arrows
    // Between cells
    for curr in range(1, cells.len()) {
      arrow(cell-anchor(curr - 1, "1.east"), "-|-", cell-anchor(curr, "0.west"))
    }
    // Input connections
    let input = (rel: (0, 0.5), to: "input.north")
    let (first, last) = ("cells.c0.body.south", "cells.c4.body.south")
    arrow(first, "|-", input, "-|", last, pos: "symbol")
    line(input, "input")
    for target in range(1, cells.len() - 2) {
      arrow(cell-anchor(target, "south"), ((), "|-", input), pos: "start")
    }
  }),
  caption: [Diagram of the general method counter (logic gates implementation)],
) <fig:CounterGeneral>
// LTeX: enabled=true

- To add cycle, add an AND gate to the last cell configured in the same way as
  the others and using the first cell as its next cell
- To make it 2-way, add a new AND gate to each cell configured in the same way
  as the other one but going in the opposite direction and using a different
  pulse generator as input
- Requires a startup pulse to one of the toggled OR gates to work (achieved with
  a 1 tick pulse generator)
- Complexity
  - 1-way: $2n$
  - 1-way+cycle: $2n + 1$
  - 2-way: $3n$
  - 2-way+cycle: $3n + 1$
- Takes 3 ticks to update
- #example-bps("2134486907", "2134487841", "2075055361", "2134489564")

=== Decimal (Base $10$)

- Works best when $n$ is of the form $c dot 10^k$ where $c$ is an integer in the
  range $[1, 9]$ and $k$ is any positive integer. If it isn't, more gates are
  needed to cap the value at $n$
- $n = 10^"amount of cells"$; $"amount of cells" = ceil(log_10 n)$
- Each cell is the general circuit for $n=10$ with cycle and no input gate,
  except for the last cell which can have any value $2 <= n <= 10$ and doesn't
  need to have cycle
- The output is encoded as a decimal number with a digit stored in each cell
  (with the first cell being the least significant digit and the last cell being
  the most significant digit)
- Diagram of the circuit:

// LTeX: enabled=false
#figure(
  cetz.canvas({
    import "/utils/diagrams.typ": *
    // Nodes
    let cells = ($1$, none, $k$, $k+1$, none, $ceil(log_10 n)$)
    cell-group(cells, (
      (body: [All OR gates except the last]),
      (body: [Last OR gate], hide-last: true),
      (body: [All AND gates]),
    ))
    input-circuit(2cm, [1 tick pulse generator (input)], [OR gate])

    // Arrows
    let input-dist = (rel: (0, -5mm), to: "cells.c0.south")
    let input = (rel: (0, -5mm), to: input-dist)
    let step = (
      (rel: (0, 5mm), to: "cells.c0.north"),
      "-|",
      (rel: (5mm, 0), to: "cells.c5.body.east"),
    )

    arrow("input.body.right.north", "|-", input, "cells.c0.body.south")
    line("input.body.left.north", ((), "|-", input))

    let end = "cells.c4.body.1.east"
    line-spec(input-dist, "-|", (end, "-|", gap(4)), end)
    arrow(
      "cells.c0.body.0.east",
      ((), "-|", gap(0)),
      "|-",
      step,
      "|-",
      "input.body.right.east",
    )

    for i in range(4) {
      line-spec(cell-anchor(i, "1.east"), "-|", (input-dist, "-|", gap(i)))
      line-spec(cell-anchor(i + 1, "0.east"), "-|", (step, "-|", gap(i + 1)))
      let v = (gap(i), 50%, gap(i + 1))
      arrow-mark((v, "|-", input-dist))
      arrow-mark((v, "|-", step))
    }
    arrow-mark((input-dist, "-|", (input-dist, 50%, gap(0))))
    arrow-mark((step, "-|", (step, 50%, gap(4))))

    for i in range(5) {
      arrow(cell-anchor(i + 1, "2.west"), ((), "-|", gap(i)), pos: "start")
    }
    line("cells.c5.body.0.east", ((), "-|", step))
  }),
  caption: [Diagram of the decimal method counter (logic gates implementation)],
) <fig:CounterDecimal>
// LTeX: enabled=true

- To add cycle, add cycle to the last cell and remove the OR gate from the input
  circuit
- To make it 2-way, duplicate the input circuit but connect all OR gates except
  the first from each cell to the OR gate. Then, make each cell 2-way, connect
  the cells in the same direction using the first OR gate of each cell rather
  than the last, and connect the new input circuit to all AND gates for the
  second direction
- Might require a decoder (unless you want to show numbers on a screen)
  - To create it, take $n$ AND gates and assign a different combination of 1
    output gate from each cell to each of them (if you only need to use it
    combined with other circuits, you can combine all of their decoders into a
    single one to use less gates)
  - Has a complexity of $n$ gates
- Requires a startup pulse to one of the toggled OR gates on each cell to work
  (achieved with a 1 tick pulse generator)
- Complexity
  #let complexity(a, b, c) = {
    $#a ceil(n/10^(ceil(log_10 n) - 1)) + #b ceil(log_10 n) - #c$
  }
  - 1-way: #complexity(2, 20, 19)

  - 1-way+cycle: #complexity(2, 20, 19)

  - 2-way: #complexity(3, 30, 28)

  - 2-way+cycle: #complexity(3, 30, 28)
- Takes 3 ticks to update with cycle and 4 ticks otherwise
- #example-bps("2134491881", "2134492935", "2134494676", "2134496082")

=== Binary (Base $2$)

- Works best when $n$ is a power of $2$. If it isn't, more gates are needed to
  cap the value at $n$
- $n = 2^"amount of cells"$; $"amount of cells" = ceil(log_2 n)$
- The output is encoded as a binary number with a bit stored in each cell (with
  the first cell being the least significant digit and the last cell being the
  most significant digit)
- Diagram of the circuit:

// LTeX: enabled=false
#figure(
  cetz.canvas({
    import "/utils/diagrams.typ": *
    // Nodes
    let cells = ($1$, none, $k$, $k+1$, none, $ceil(log_2 n)$)
    cell-group(cells, (
      (body: [Toggled OR gate (output)]),
      (body: [AND gate], arrows: "up"),
    ))
    input-circuit(1.5cm, [1 tick pulse generator (input)], [NAND gate])

    // Arrows
    // Between cells
    for i in range(5) {
      arrow(cell-anchor(i, "0.east"), "-|-", cell-anchor(i + 1, "1.west"))
    }

    // Input
    let input = ("cells.south", 50%, "input.north")
    let top-line = (
      (rel: (0, 5mm), to: "cells.c0.north"),
      "-|",
      (rel: (5mm, 0), to: "cells.c5.body.east"),
    )

    let (first, last) = ("cells.c0.body.south", "cells.c5.body.south")
    arrow(first, "|-", input, "-|", last, pos: "symbol")
    for i in ("left", "right") {
      line("input.body." + i + ".north", ((), "|-", input))
    }
    for i in range(1, cells.len() - 1) {
      arrow(cell-anchor(i, "south"), ((), "|-", input), pos: "start")
      line((cell-anchor(i, "0.east"), "-|", gap(i)), ((), "|-", top-line))
    }

    arrow(
      ("cells.c0.body.0.east", "-|", gap(0)),
      "|-",
      top-line,
      "|-",
      "input.body.right.east",
    )
    line("cells.c5.body.0.east", ((), "-|", top-line))

    for i in range(4) {
      let v = (gap(i), 50%, gap(i + 1))
      arrow-mark((v, "|-", top-line))
    }
    arrow-mark(((gap(4), "|-", top-line), 50%, top-line))
  }),
  caption: [Diagram of the binary method counter],
) <fig:CounterBinary>
// LTeX: enabled=true

- To add cycle, remove the NAND gate from the input circuit and the AND gate on
  the first cell, and connect the 1 tick pulse generator directly to the OR gate
  in the first cell
- To make it 2-way, add a NOT gate to each cell with its OR gate as input and a
  new AND gate connected in the same way as the old AND gate, but using the NOT
  gate of all previous cells as input instead of the OR gates. Then replace the
  NAND gate on the input circuit with an OR gate and duplicate it (with the copy
  being connected to the new AND gates on each cell rather than the old ones).
  Connect the NOT gate of all the cells to the OR gate of the first input
  circuit, and the OR gate of all the cells to the OR gate of the second input
  circuit
- Might require a decoder
  - To create it, add a NOT gate to each cell and replace the NAND gate of the
    input circuit with an OR gate like in the 2-way version (if using the 1-way
    versions). Then, take $n$ AND gates and assign each of them a different
    combination of either the OR or NOT from each cell (if you only need to use
    it combined with other circuits you can combine all of their decoders into a
    single one to use less gates)
  - Has a complexity of $ceil(log_2 n) + n - 1$ for the 1-way version,
    $ceil(log_2 n) + n$ for the 1-way+cycle version and $n$ for the 2-way
    versions
- Complexity
  #let complexity(a, b) = $#a ceil(log_2 n) #if b != 0 { $+ #b$ }$
  - 1-way: #complexity(2, 3)
  - 1-way+cycle: #complexity(2, 0)
  - 2-way: #complexity(4, 4)
  - 2-way+cycle: #complexity(4, 0)
- Takes 3 ticks to update for 1-way+cycle and 4 ticks otherwise
- #example-bps("2134497489", "2134498845", "2134500019", "2134500705")

== Feedback Loop

- Superseded by accumulators
- Allows storing an analog value in the range $[-1, 1]$
- Made by connecting 2 OR gates to each other, connecting the input to both of
  them, and taking the output from one of them
- Each tick the input is active, the stored value increases by the value of the
  input
  - With a close to 0 input value, the circuit can be used to generate an analog
    output value
- One of the OR gates can be replaced with an XOR to add a reset input. In this
  case, the normal input should go to the OR gate only and the reset input must
  be 2 different signals connected to the XOR gate
  - Be aware that this method adds a 1 tick jitter to the stored signal

=== Clamped Feedback Loop

- Allows limiting the output signal of a feedback loop to the range $[0, 1]$
- Diagram of the circuit:

// LTeX: enabled=false
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
    let invert = [OR gate with -1 output scale]
    node(..pos(5mm, "c+1").u, invert, name: "c-1")
    node(..pos(1cm, "c-1").r, [#invert (output)], name: "output")

    // Arrows
    let input-split = (rel: (5mm, 0), to: "input.east")
    line("input", input-split)
    let (top, bottom) = ("c0.body.0.west", "c0.body.1.west")
    arrow(top, "-|", input-split, "|-", bottom, pos: "symbol")
    arrow("c+1", "c0.body.1.east")
    arrow("c+1", "c-1")
    arrow("c-1", "output")
    arrow("c0.body.0.east", ((), "-|", "c-1.west"), pos: "start")
    let bottom = "c0.body.south"
    arrow(bottom, (rel: (0, -5mm), to: bottom), "-|", "output")
  }),
  caption: [Diagram of the clamped feedback loop],
) <fig:ClampedFeedbackLoop>
// LTeX: enabled=true

- Note: the input signal is reversed. This means that a negative value increases
  the stored value while a positive value decreases it
- Keybinds can be added to one of the OR gates in the feedback loop to go to the
  max/min value. The green keybind sets the min value while the red keybind sets
  the max value
- #steam("2911246646")[Example blueprint]
- Python script to simulate the behaviour (input value is automatically
  reversed):
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
