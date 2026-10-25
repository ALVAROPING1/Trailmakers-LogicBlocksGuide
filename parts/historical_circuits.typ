// LTeX: enabled=false

#import "/deps.typ": cetz
#import "/utils/common.typ": steam

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
