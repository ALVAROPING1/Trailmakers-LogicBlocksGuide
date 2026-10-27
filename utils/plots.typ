// LTeX: enabled=false

#import "/deps.typ": lq
#import "common.typ": eval-math

/// Creates a plot of a function `f(x)` defined by a math expression
///
/// - range (array): Array of $x$ values to evaluate the expression at
/// - expr (content): Math expression to evaluate
/// - label (auto, content): Label of the plot
/// - args (arguments): Extra arguments to pass to `lq.plot()`
/// -> any
#let plot-fn(range, expr, label: auto, ..args) = lq.plot(
  range,
  x => eval-math(expr, values: (x: x)),
  label: if label == auto { $y = #expr$ } else { label },
  color: black,
  stroke: 1.2pt,
  mark: none,
  ..args,
)

/// Plots an array of points
///
/// - xs (array): Array of $x$ coordinates
/// - ys (array): Array of $y$ coordinates
/// - label (auto, content): Label of the plot
/// - args (arguments): Extra arguments to pass to `lq.plot()`
/// -> any
#let plot-data(xs, ys, label: auto, ..args) = lq.plot(
  xs,
  ys,
  label: if label == auto { $f(x)$ } else { label },
  mark: "o",
  ..args,
)

