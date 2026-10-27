// LTeX: language=en

= Tips

- If you want your system to not modify the input that passes through, configure
  all the logic gates to have an output scale of 1. Then, if a gate needs to
  have more inputs other than the original one, make sure the sum of the output
  values of those other inputs is 0. This will make the output which reaches
  whatever your system activates be the output that the sensors/keybinds had
- Arithmetics logic blocks can be used to get always on signals with a constant
  value by using the addition operation with the desired constant. The signal
  can be toggled by setting the operation to multiplication and using a $+1$
  input
- Organize the logic gates on a testbed while working with them before adding
  them to your vehicle, having the logic gates organized as opposed to scattered
  across your entire vehicle will make remembering what each gate does easier.
  There is no wrong way to organize them as long as they aren't randomly placed,
  but the way I do it is by splitting the gates into groups depending on
  function, inside each group the arrows of logic gates point towards the
  outputs of that gate and away from its inputs, then I put the groups of logic
  gates that a group outputs to in the direction the arrows of the logic gates
  that the group uses as output are pointing, while I put the groups that group
  uses as input in the opposite direction
- If you have problems figuring out how to do something with logic gates, draw
  it on paper first, being able to see all connections at once helps a lot.
  Another method is writing it with if statements as they translate to logic
  gates easily (each logic gate is an individual if statement)
- If you still have any questions or need help with something, feel free to
  contact me on the #link("https://discord.gg/trailmakers")[official Trailmakers
    discord server]
