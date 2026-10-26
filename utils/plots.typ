// LTeX: enabled=false

#import "/deps.typ": lq, symbolica

#let eval-math(expr, values: ()) = {
  symbolica.evaluate(symbolica.math(expr), values: values).re
}

#let plot-fn(range, expr, label: auto, ..args) = lq.plot(
  range,
  x => eval-math(expr, values: ((symbolica.symbol("x"), x),)),
  label: if label == auto { $y = #expr$ } else { label },
  color: black,
  stroke: 1.2pt,
  mark: none,
  ..args,
)

#let plot-data(xs, ys, label: auto, ..args) = lq.plot(
  xs,
  ys,
  label: if label == auto { $f(x)$ } else { label },
  mark: "o",
  ..args,
)

