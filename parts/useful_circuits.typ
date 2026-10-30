// LTeX: language=en

#import "/deps.typ": cetz
#import "/conf.typ": table-stroke
#import "/utils/common.typ": hfrac, steam, tick

= Useful Circuits <useful-circuits>

This section contains commonly used logic circuits and how to make them, to aid
in the design and understanding of more complex logic circuits.

== Pulse generator/Rising edge detector

- Sends a pulse of a specific length (usually a single frame which is #tick)
  when the input goes from off to on
- Made by setting the duration to the length of the pulse on an OR gate

== Falling edge detector

- Sends a pulse of a specific length when the input goes from on to off
- Made by connecting a NOT gate to a pulse generator

== Latch (T-FlipFlop)

- Stores a single bit of information
- Made by activating toggle on an OR gate, requires the input to be a pulse to
  be easily controlled by other gates (use a pulse generator for this)

== Decoder

- Converts a single real value signal into multiple signals representing the
  same value in base $n$
  - For a number $x = limits(sum)_(i = a)^b (c_i * n^i)$, obtains the
    coefficients $c_i$ in separate gates
  - Integers $a$ and $b$ define the range of coefficients obtained
  - To decode integers, $a = 0$ and $b = ceil(log_n "maximum_value")$ are used
- There is a general circuit that works for any base $n$, although for the
  special case of $n = 2$ (binary) there is a better implementation. Both of
  them will be described here

=== General Circuit (Base $N$)

- Made by repeating a cell circuit for each $c_i$ that wants to be extracted:

// LTeX: enabled=false
#figure(
  cetz.canvas({
    import "/utils/diagrams.typ": *
    // Nodes
    let cells = ($0$, $1$, $2$, none, $k$, none, $n$)
    framed("cell", [Cell $i$], {
      node(name: "div", (), [Arithmetic gate $times hfrac(1, b^i)$])
      node(name: "mod", ..pos(5mm, "div").r, [Arithmetic gate $% b$])
      node(name: "floor", ..pos(5mm, "mod").r, [Functions gate $floor(b)$])
    })

    let pos = pos(1cm, "cell.body")
    text-box(name: "in", ..pos.l, [Input], frame: none)
    text-box(name: "out", ..pos.r, [Output], frame: none)
    let cell-elems = ("div", "mod", "floor")
    let elems = ("in", ..cell-elems.map(x => "cell.body." + x), "out")
    for (prev, curr) in elems.windows(2) {
      arrow(prev + ".east", curr + ".west")
    }
  }),
  caption: [Diagram of the cells of the general method decoder],
) <fig:DecoderGeneral>
// LTeX: enabled=true

- In some cases, some of the gates in the cell can be skipped:
  - When $i = 0$, the division can be skipped
  - When $i = a$, the floor can be skipped
  - When $i = b$, the modulo can be skipped
- For some values of $i$, the constant needed in the arithmetics gate the
  division might not fit in the configuration setting due to being too small.
  There are 2 ways to solve this:
  - Chaining the division of multiple cells, at the cost of increased output
    latency
  - Using variable division with the denominator specified on a different
    arithmetic gate, at the cost of an extra block

=== Binary (Base $2$)

- Made by repeating a cell circuit for each $c_i$ that wants to be extracted:

// LTeX: enabled=false
#figure(
  cetz.canvas({
    import "/utils/diagrams.typ": *
    // Nodes
    let cells = ($0$, $1$, $2$, none, $k$, none, $n$)
    framed("cell", [Cell $i$], {
      node(name: "mod", (), [Arithmetic gate $% 2^(i + 1)$])
      node(name: "comparison", ..pos(5mm, "mod").r, [Comparator\ $>= 2^i$])
    })

    let pos = pos(1cm, "cell.body")
    text-box(name: "in", ..pos.l, [Input], frame: none)
    text-box(name: "out", ..pos.r, [Output], frame: none)
    let cell-elems = ("mod", "comparison")
    let elems = ("in", ..cell-elems.map(x => "cell.body." + x), "out")
    for (prev, curr) in elems.windows(2) {
      arrow(prev + ".east", curr + ".west")
    }
  }),
  caption: [Diagram of the cells of the binary decoder],
) <fig:DecoderBinary>
// LTeX: enabled=true

- In some cases, some of the gates in the cell can be skipped:
  - When $i = b$, the modulo can be skipped

== Counter <counter>

// LTeX: enabled=false
#let example-bps(id1, id1c, id2, id2c) = [
  #let examples = (
    steam(id1)[1-way],
    steam(id1c)[1-way+cycle],
    steam(id2)[2-way],
    steam(id2c)[2-way+cycle],
  )
  Example blueprints: #examples.join(", ", last: ", and ")
]
// LTeX: enabled=true

- Stores the value of a variable with $n$ possible (discrete) values
- Depending on how it's made, it can be 1 or 2 way and have cycle or not
  - 1-way: the value can only be increased
  - 2-way: the value can be both increased and decreased
  - Cycle: determines if trying to increase/decrease the value past its
    maximum/minimum will result in it cycling back to the smallest/biggest value
    or staying at the maximum/minimum value
  - Base design described is 1-way without cycle, with the modifications needed
    to implement 2-way or cycle being explained afterwards
- Made by configuring an accumulator with the desired min/max values, setting
  the scale to the step size, and enabling steps mode
  - For simplicity, the integers from $0$ to $n-1$ are usually used by setting
    the min/max values to $0$/$n-1$ respectively and the scale to $1$, but other
    configurations can be useful in certain circumstances
    - Using a negative minimum value allows the initial value to not be the
      lowest value, which might be useful for 2-way counters
    - Using (positive) scale values closer to $0$ increases the amount of stored
      values beyond $101$
    - Using different minimum/maximum can be useful to avoid having to transform
      the output range
  - The value can be increased/decreased by sending a $plus.minus 1$ input to
    the accumulator (the circuit is the same for 1 and 2-way)
  - In some cases, it might be useful to not enable steps mode and set the scale
    to $60 dot "step_size"$. This allows to change the stored value on each
    frame (instead of every 2 frames), but requires the input to come from a 1
    frame pulse generator to get the normal input behaviour
- To add cycle, add a comparator set to equality with the maximum value as
  threshold and connect it to an AND gate with the positive accumulator input as
  second input. Connect that AND gate to an arithmetic logic block set to
  multiplication with a $-1000$ constant and $0.02$ duration, and that
  arithmetic logic block to the accumulator
  - The normal input to the accumulator must come from a 1 frame pulse generator
  - If using the circuit as 2-way, repeat the process with a comparator checking
    for the minimum value and the negative input of the accumulator. The AND
    gate should have an additional $-2$ always on input (which can be achieved
    with an arithmetic logic block set to addition with a $-1000$ constant). The
    arithmetic logic block and input pulse generator can be reused, using
    negative inputs to reduce the value
- Typically combined with a decoder to trigger different blocks depending on the
  current value
  - Using $n$ comparators set to equality with each of the possible states gives
    maximum flexibility
    - In order for the comparators to work, $"step_size" >= 0.001$ must hold
  - Using a decimal (base $10$) decoder followed by a comparator decoder for
    each digit can be used to display values on a screen
  - Multiple counters can be combined and decoded together to reduce the amount
    of needed blocks
- #example-bps("3309036414", "3309036347", "3309036504", "3309036241")

== No-Delay Signal Toggle

- Allows to enable/disable an analog signal without increasing the signal delay
  like normal AND/XOR gate methods do
- Doesn't work when the output block is an AND/XOR gate
- Historically used to enable/disable angle sensor stabilization (with the input
  being angle sensors and the output helicopter engines), although for sensors
  it's been superseded by sensor inputs

// LTeX: enabled=false
#figure(
  cetz.canvas({
    import "/utils/diagrams.typ": *
    // Nodes
    node((), [Input Signals (can be multiple blocks)], name: "input")
    node(..pos(5cm, "input").r, [Output Blocks], name: "output")
    let toggle = [OR Gate with toggle keybind]
    node(..pos(1.5cm, "input").u, toggle, name: "toggle1")
    node(..pos(5cm, "toggle1").r, toggle, name: "toggle2")
    let toggles = ("toggle1", 50%, "toggle2")
    let middle = ("input.north", 50%, "toggle1.south")
    node((toggles, "|-", middle), [XOR gate with -1 output scale], name: "XOR")

    // Arrows
    arrow("input", "output")
    arrow("input", "|-", "XOR")
    arrow("XOR", "-|", "output")
    line("toggle1", "toggle2")
    arrow(toggles, "XOR")
    arrow-mark(("toggle1.east", 50%, toggles), dir: toggles)
    arrow-mark(("toggle2.west", 50%, toggles), dir: toggles)
  }),
  caption: [Diagram of the no-delay signal toggle],
) <fig:NoDelaySignalToggle>
// LTeX: enabled=true

- #steam("3054610284")[Example blueprint]
