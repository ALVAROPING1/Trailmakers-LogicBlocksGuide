// LTeX: enabled=false

#import "/deps.typ": *

/// LaTeX's `\noindent`, removes the first-line indentation of the paragraph
#let noindent(body) = par(body, first-line-indent: 0pt)

/// Prints a number in scientific notation
///
/// - x (int, float, str): Number to format
/// - args (arguments): Extra arguments passed to `zero.num`
/// -> content
#let scientific(x, ..args) = num(
  x,
  exponent: "sci",
  round: (precision: 3),
  product: sym.dot,
  ..args,
)
/// Evaluates a math expression with the given symbol values
///
/// - expr (content): Math expression to evaluate
/// - values (dictionary): Map of symbol names to their values
/// -> float
#let eval-math(expr, values: (:)) = {
  let values = values.pairs().map(((k, v)) => (symbolica.symbol(k), v))
  symbolica.evaluate(symbolica.math(expr), values: values).re
}

/// Alias for a horizontal fraction in math mode
#let hfrac(num, denom) = $frac(#num, #denom, style: "horizontal")$
/// In-game tick length
#let tick = $hfrac(1, 60) "s"$

#let steam-url = "https://steamcommunity.com/sharedfiles/filedetails/?id="

/// Creates a link to a steam workshop upload
///
/// - id (str): Workshop ID
/// - body (content): Body of the link
/// -> content
#let steam(id, body) = link(steam-url + id, body)

/// Creates a reference to a block's description
///
/// - id (label): Label of the block's header
/// -> content
#let block-ref(id) = link(id, {
  let name = str(id).replace("-", " ")
  upper(name.at(0)) + name.slice(1)
})
#let math-blocks = block-ref(<math-blocks>)
#let logic-gates = block-ref(<logic-gates>)
