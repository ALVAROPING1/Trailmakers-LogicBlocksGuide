// LTeX: enabled=false

#import "/deps.typ": *

/// LaTeX's `\noindent`, removes the first-line indentation of the paragraph
#let noindent(body) = par(body, first-line-indent: 0pt)

#let scientific(x, ..args) = num(x, exponent: "sci", round: (precision: 3), product: sym.dot, ..args)
#import "plots.typ": eval-math

#let hfrac(x, y) = $frac(#x, #y, style: "horizontal")$
#let tick = $hfrac(1, 60) "s"$

#let steam(id, body) = link("https://steamcommunity.com/sharedfiles/filedetails/?id=" + id, body)

#let block-ref(id) = link(id, {
  let name = str(id).replace("-", " ")
  upper(name.at(0)) + name.slice(1)
})
#let math-blocks = block-ref(<math-blocks>)
#let logic-gates = block-ref(<logic-gates>)
