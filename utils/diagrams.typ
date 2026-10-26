// LTeX: enabled=false

#import "/deps.typ": cetz
#import cetz.draw: *

// ────────────────────────────────── General ───────────────────────────────

#let text-box(pos, body, width: auto, ..args) = content(
  pos,
  {
    set align(center + horizon)
    set par(justify: false)
    set text(bottom-edge: "bounds")
    block(width: width, inset: 0.4em, body)
  },
  frame: "rect",
  fill: white,
  ..args,
)

#let pts-spec(..pts) = {
  let pts = pts.pos()
  for (i, p) in pts.enumerate() {
    let off(j) = pts.at(i + j)
    if p in ("-|", "|-") {
      ((off(-1), p, off(+1)),)
    } else if p in ("-|-", "|-|") {
      let (s, e) = (off(-1), off(+1))
      pts-spec(s, p.slice(0, 2), (s, 50%, e), p.slice(1, 3), e)
    } else { (p,) }
  }
}

#let line-spec(..pts) = line(..pts-spec(..pts.pos()), ..pts.named())
#let mark-style(pos) = ((pos): ")>", fill: black, scale: 0.8)
#let arrow(..pts, pos: "end") = line-spec(..pts, mark: mark-style(pos))
#let arrow-mark(pos, dir: (rel: (1, 0))) = mark(
  pos,
  dir,
  ..mark-style("symbol"),
)

// ──────────────────────────── Settings annotations ────────────────────────────

#let annotated-img(path, body, debug: false) = cetz.canvas({
  scale(y: -1) // Make y axis increase downwards
  get-ctx(ctx => {
    let img = block(width: 7.1cm, image(path))
    let img = content((0, 0), anchor: "south-west", img)
    let (bounds: (high: (max-x, max-y, _))) = cetz.process.many(ctx, img)
    img
    translate(y: -max-y)
    scale(x: max-x / 10)
    floating(if debug {
      let bounds = ((0, 0), (10, max-y))
      grid(..bounds, help-lines: true, step: 0.5)
      for x in range(int(bounds.at(1).at(0)) + 1) {
        content((x, -0.1), anchor: "south", text(size: 0.7em, [#x]))
      }
      for y in range(int(bounds.at(1).at(1)) + 1) {
        content((-0.1, y), anchor: "east", text(size: 0.7em, [#y]))
      }
    })
    floating(body)
  })
})

#let annotation(body, side, pos, targets) = {
  // @typstyle off
  let (x, size, anchor) = (
    left:   (-0.5,  0.65, "east"),
    mid:    ( 4.5, -0.7,  "west"),
    right:  (10.5, -0.95, "west"),
    below:  ( 2.0,  0.5,  "north"),
  ).at(side)
  let pos = (x, pos)
  text-box(pos, body, anchor: anchor)
  for target in targets {
    let target = if type(target) == array {
      target
    } else if side == "below" {
      (0, -size)
    } else { (size, target) }
    arrow(pos, (rel: target))
  }
}

// ────────────────────────────── Circuit diagrams ──────────────────────────────

#let node(..args) = text-box(width: 30.4mm, ..args)
#let hidden-node(pos, _body, ..args) = text-box(width: 5mm, pos, [], ..args)
#let offset(off, ..pts) = pts.map(p => (rel: off, to: p))

#let framed(id, name, body) = group(name: id, {
  group(name: "body", body)
  content((rel: (0, 3.5mm), to: "body.north"), name, name: "name")
  rect-around("name", "body", padding: 1.5mm)
})

#let cell(id, name, elems, hidden: false, last: false) = {
  let prev = "c" + str(id - 1) + ".body"
  let id = "c" + str(id)

  let right(i) = (rel: (1cm, 0), to: prev + "." + str(i) + ".east")
  let pos(i, elem) = if id != "c0" {
    arguments(anchor: "west", right(i))
  } else {
    let space = if "arrows" in elem { 5mm } else { 1.5mm }
    let pos = (rel: (0, -space), to: str(i - 1) + ".south")
    arguments(anchor: "north", if i != 0 { pos } else { () })
  }
  let (wrap, node) = if hidden { (hide, hidden-node) } else { (x => x, node) }
  wrap(framed(id, [Cell $#name$], for (i, e) in elems.enumerate() {
    let hide-last = e.at("hide-last", default: false)
    let wrap = if last and hide-last { hide } else { x => x }
    wrap({
      node(name: str(i), ..pos(i, e), e.body)

      let curr = str(i) + ".north"
      let prev = str(i - 1) + ".south"
      let arrows = e.at("arrows", default: none)

      // @typstyle off
      if arrows == "up" { arrow(curr, prev) }
      else if arrows == "down" { arrow(prev, curr) }
      else if arrows == "both" {
        arrow(..offset((-2mm, 0), prev, curr))
        arrow(..offset((2mm, 0), curr, prev))
      }
    })
  }))
  if hidden { content(id, sym.dots.h.c) }
}

#let cell-group(cells, cell-elems) = group(
  name: "cells",
  for (i, curr) in cells.enumerate() {
    let hidden = curr.at("hidden", default: false)
    cell(i, curr.name, cell-elems, hidden: hidden, last: i == cells.len() - 1)
  },
)
#let cell-anchor(i, anchor) = "cells.c" + str(i) + ".body." + anchor
#let gap(i) = (cell-anchor(i, "east"), 50%, cell-anchor(i + 1, "west"))

#let input-circuit(space, l, r, name: [Input circuit]) = framed("input", name, {
  let center = (rel: (0, -space), to: "cells.south")
  let pos(i) = (rel: (i * 0.75mm, 0), to: center)
  node(pos(-1), anchor: "north-east", name: "left", l)
  node(pos(+1), anchor: "north-west", name: "right", r)
})

#let pos(d, to) = (
  r: arguments((rel: (d, 0), to: to + ".east"), anchor: "west"),
  l: arguments((rel: (-d, 0), to: to + ".west"), anchor: "east"),
  u: arguments((rel: (0, d), to: to + ".north"), anchor: "south"),
  d: arguments((rel: (0, -d), to: to + ".south"), anchor: "north"),
)
