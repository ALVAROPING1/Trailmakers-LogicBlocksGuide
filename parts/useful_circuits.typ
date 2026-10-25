// LTeX: language=en

#import "/deps.typ": cetz
#import "/conf.typ": table-stroke
#import "/utils/common.typ": tick, steam

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
- There are 3 ways of doing it: general circuit (base $N$), decimal (base $10$) and binary (base $2$). Which one is the least complex depends on the situation
  - The general circuit and decimal methods can be implemented using logic gates or accumulators. Generally accumulator-based counters are less complex, but logic gate based designs will still be described as they can be less complex under some circumstances (like needing a counter which only changes its value when a function of its current value is true)

=== General Circuit (Base $N$)

==== Logic Gates Implementation

- $n = "amount of cells"$
- The output is encoded as the position of the active gate in the row of output gates (with the one from the first cell being the minimum value and the one from the last cell being the maximum value)
- Diagram of the circuit:

// LTeX: enabled=false
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
// LTeX: enabled=true

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
    - Using (positive) scale values closer to $0$ increases the amount of stored values beyond $101$
    - Using different minimum/maximum values might reduce the complexity if analog value outputs are wanted by avoiding having to perform transformation of the value ranges
  - The value can be increased/decreased by sending a $plus.minus 1$ input to the accumulator (the circuit is the same for 1 and 2-way)
  - In some cases, it might be useful to not enable use steps and set the scale to $60 dot "spacing"$. This allows to change the stored value on each frame, but requires the input to come from a 1 frame pulse generator to get the normal input behaviour
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

// LTeX: enabled=false
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
// LTeX: enabled=true

- To add cycle, add cycle to the last cell and remove the OR gate from the input circuit
- To make it 2-way, duplicate the input circuit but connect all OR gates except the first from each cell to the OR gate. Then, make each cell 2-way, connect the cells in the same direction using the first OR gate of each cell rather than the last, and connect the new input circuit to all AND gates for the second direction
- Might require a decoder (unless you want to show numbers on a screen)
  - To create it, take $n$ AND gates and assign a different combination of 1 output gate from each cell to each of them (if you only need to use it combined with other circuits, you can combine all of their decoders into a single one to use less gates)
  - Has a complexity of $n$ gates
- Requires a startup pulse to one of the toggled OR gates on each cell to work (achieved with a 1 frame pulse generator)
- Complexity
  #let complexity(a, b, c) = $#a ceil(n/10^(ceil(log_10 n) - 1)) + #b ceil(log_10 n) - #c$
  - 1-way: #complexity(2, 20, 19)

  - 1-way+cycle: #complexity(2, 20, 19)

  - 2-way: #complexity(3, 30, 28)

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
  - 1-way: #complexity(13, 9)

  - 1-way+cycle: #complexity(13, 9)

  - 2-way: #complexity(14, 7)

  - 2-way+cycle: #complexity(14, 8)
- Takes 3 frames to update
- #example-bps("3309037356", "3309037285", "3309037105", "3309037186")

=== Binary (Base $2$)

- Works best when $n$ is a power of $2$. If it isn't, more gates are needed to cap the value at $n$
- $n = 2^"amount of cells"$; $"amount of cells" = ceil(log_2 n)$
- The output is encoded as a binary number with a bit stored in each cell (with the first cell being the least significant digit and the last cell being the most significant digit)
- Diagram of the circuit:

// LTeX: enabled=false
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
// LTeX: enabled=true

- To add cycle, remove the NAND gate from the input circuit and the AND gate on the first cell, and connect the 1 frame pulse generator directly to the OR gate in the first cell
- To make it 2-way, add a NOT gate to each cell with its OR gate as input and a new AND gate connected in the same way as the old AND gate, but using the NOT gate of all previous cells as input instead of the OR gates. Then replace the NAND gate on the input circuit with an OR gate and duplicate it (with the copy being connected to the new AND gates on each cell rather than the old ones). Connect the NOT gate of all the cells to the OR gate of the first input circuit, and the OR gate of all the cells to the OR gate of the second input circuit
- Might require a decoder
  - To create it, add a NOT gate to each cell and replace the NAND gate of the input circuit with an OR gate like in the 2-way version (if using the 1-way versions). Then, take $n$ AND gates and assign each of them a different combination of either the OR or NOT from each cell (if you only need to use it combined with other circuits you can combine all of their decoders into a single one to use less gates)
  - Has a complexity of $ceil(log_2 n) + n - 1$ for the 1-way version, $ceil(log_2 n) + n$ for the 1-way+cycle version and $n$ for the 2-way versions
- Complexity
  #let complexity(a, b) = $#a ceil(log_2 n) #if b != 0 { $+ #b$ }$
  - 1-way: #complexity(2, 3)
  - 1-way+cycle: #complexity(2, 0)
  - 2-way: #complexity(4, 4)
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
- This is just based on the amount of logic gates each circuit uses (unless there is a tie, in which case update speed is used). However, the amount of time it takes for the system to update might also matter depending on the situation. In that case, refer to the circuits' descriptions to compare the speed for the needed use-case

== No-Delay Signal Toggle

- Allows to enable/disable an analog signal without increasing the signal delay like normal AND/XOR gate methods do
- Doesn't work when the output block is an AND/XOR gate
- Commonly used to enable/disable angle sensor stabilization (with the input being angle sensors and the output helicopter engines)

// LTeX: enabled=false
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
// LTeX: enabled=true

- #steam("3054610284")[Example blueprint]
