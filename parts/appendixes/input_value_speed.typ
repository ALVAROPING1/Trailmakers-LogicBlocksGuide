// LTeX: language=en

#import "/utils/data.typ": *
#import "/utils/plots.typ": *
#import "/deps.typ": strfmt

= Input value to speed for servos with hold position <InputValueSpeed>

Due to a bug, the speed at which rotating servos with hold position rotate
changes with the input value when small values are used. This section contains
the speed multipliers used for many input values, found experimentally. Some
notes about this process:

#let fhat(angle) = $x/0.0611 dot #angle/90$

- Speed is the speed required on a servo with an input value of $1$ to match the
  speed of a servo with a speed being tested and the given input value, with an
  error of $plus.minus 0.00005$ speed units for speeds lower than $1$ and an
  error of $plus.minus 0.0005$ otherwise
  - To compare the speeds of the servos, they were run continuously for some
    time and the final angle was compared
    - For servos with $360$ angle, they were run for $3$ min
    - For servos with less than $360$ angle, they were run for slightly less
      than the time required to reach the maximum angle
  - Servos with a configured speed of $1$ and $2$ as well as $360$ and $180$
    angle were tested, with other speeds/angles being checked to verify the
    results
- $f_(s, a)(x)$ represents the resulting speed of a servo with $s$ speed, $a$
  angle, and $x$ input value
- The resulting speed can be approximated by
  $hat(f)_(s, a)(x) = min(fhat(a), s)$

// LTeX: enabled=false
#let path = "/data/Input_Value_Speed{}_{}.csv"
#let load-data(angle, speed) = csv(strfmt(path, speed, angle)).slice(1)
#let (angles, speeds) = ((180, 360), (1, 2))
#let data-cases = angles.map(a => speeds.map(s => (a, s))).join()
#let data = data-cases.map(conf => (conf, load-data(..conf)))

#let pairs = data.map(((_, d)) => d)
#let xlim = (0, calc.max(..pairs.join().map(((x, _)) => float(x))))

#figure(
  lq.diagram(
    title: [Speed as a function of the input value],
    xlabel: [Input value],
    ylabel: [Speed],
    xlim: xlim,
    ylim: (0, 2),
    yaxis: (tick-distance: 0.2),
    cycle: (green, blue, rgb("#0000ff"), rgb("#ff0000")),
    ..data
      .enumerate()
      .map(((i, ((angle, speed), d))) => plot-data(
        ..get-cols(d, 0, 1),
        label: $f_(#speed, #angle)(x)$,
        z-index: if i < 2 { 2.1 } else { 2 },
      )),
    ..((180, 35%, right), (360, 75%, left))
      .map(((a, pos, align)) => (
        plot-fn(xlim, fhat(a), label: none, z-index: 2.2),
        lq.place(pos, 1.5, pad(1em, $y = #fhat(a)$), align: align),
      ))
      .flatten(),
  ),
  caption: [
    Graph of the speed for servos with hold position as a function of the input
    value
  ],
) <fig:InputValueSpeedGraph>

#let headers = (
  angles.map(x => [*Angle #x*]),
  speeds.map(x => [*Speed #x*]),
  ([*Input\ Value*], [*Final\ Speed*]),
)
#figure(
  booktab-table(
    columns: 8,
    align: center + horizon,
    row-gutter: 0pt,
    ..range(1, 4).map(i => table.vline(
      stroke: table-stroke.at(if i == 2 { "thick" } else { "thin" }),
      x: i * 2,
    )),

    ..for (l, cells) in headers.enumerate() {
      let pow = calc.pow(2, l)
      let cells = cells.map(table.cell.with(colspan: int(4 / pow)))
      (table.header(level: l + 1, ..cells * pow),)
      (table.hline(),)
    },
    ..zip(pairs).flatten(),
  ),
  caption: [Raw data of the input value speed for servos with hold position],
) <table:InputValueSpeedData>
