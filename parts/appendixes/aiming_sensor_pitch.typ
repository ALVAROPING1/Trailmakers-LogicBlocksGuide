// LTeX: language=en

#import "/utils/data.typ": *
#import "/utils/plots.typ": *
#import "/utils/common.typ": array-avg, array-std

= Aiming sensor pitch measurement <AimingSensorPitch>

#let (header, ..data) = csv("/data/Aiming_Sensor_Pitch.csv")
#let data-error = data.map(((x, y)) => (x, float(y) - float(x)))
#let error = data-error.map(row => row.at(1))
#let funcs = (array-avg, array-std)
#let (avg-error, std-error) = funcs.map(fn => calc.round(fn(error), digits: 3))

When aiming sensors are used to measure the pitch of the camera, their output is
offset from the real camera pitch angle. This section contains the measured
values for many camera angles, found experimentally. Some notes about this
process:

- Measurements were done using a camera block on a hinge to set the camera pitch
  to known values, and then taking the measurement from an aiming sensor at the
  base
- Aiming servos with verticality checks disabled have a similar behavior,
  although their angle measurement ends up being a lot more noisy
- Angle measurements are in degrees and have an error of
  $plus.minus 0.0005 degree$
- The average error between the measured pitch and the camera pitch is
  $#avg-error degree$, with a standard deviation of $#std-error degree$

// LTeX: enabled=false
#figure(
  lq.diagram(
    title: [Measured pitch as a function of actual pitch],
    xlabel: [Real pitch],
    ylabel: [Measured pitch],
    plot-data(..get-cols(data, 0, 1)),
    plot-fn((-90, 90), $x + #avg-error$, color: red),
    plot-fn((-90, 90), $x$),
  ),
  caption: [
    Graph of the pitch measured by aiming sensors as a function of the real
    camera pitch
  ],
) <fig:AimingSensorPitchGraph>

#figure(
  lq.diagram(
    title: [Error in measured pitch as a function of actual pitch],
    xlabel: [Real pitch],
    ylabel: [Error],
    plot-data(..get-cols(data-error, 0, 1), label: none, stroke: 0.4pt),
  ),
  caption: [
    Graph of the error in pitch measured by aiming sensors as a function of the
    real camera pitch
  ],
) <fig:AimingSensorPitchGraphError>

#data-table(
  header,
  5,
  data,
  [Raw data of the aiming sensor pitch measurement],
  label: <table:AimingSensorPitchData>,
)
