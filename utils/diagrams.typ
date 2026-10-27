// LTeX: enabled=false

#import "/deps.typ": cetz
#import cetz.draw: *

// ────────────────────────────────── General ───────────────────────────────

/// Creates a text box within a CeTZ diagram
///
/// - pos (coordinate): Position of the text box
/// - body (content): Content of the text box
/// - width (auto, length, float): Width of the text box
/// - args (arguments): Extra arguments to pass to `cetz.draw.content`
/// -> array
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

/// Processes the points defining of a line path. Allows some extra aliases as
/// points to create various types of lines:
/// - `-|` and `|-`: Orthogonal line from the previous to the next point,
///   starting horizontally/vertically
/// - `-|-` and `|-|`: Orthogonal line from the previous to the next point and
///   going through the midpoint of the points and starting horizontally/vertically
///
/// - pts (arguments): Points defining the path
/// -> array
#let path-spec(..pts) = {
  let pts = pts.pos()
  for (i, p) in pts.enumerate() {
    let off(j) = pts.at(i + j)
    if p in ("-|", "|-") {
      ((off(-1), p, off(+1)),)
    } else if p in ("-|-", "|-|") {
      let (s, e) = (off(-1), off(+1))
      path-spec(s, p.slice(0, 2), (s, 50%, e), p.slice(1, 3), e)
    } else { (p,) }
  }
}

/// Creates a line defined by `path-spec()`
///
/// - pts (arguments): Points defining the path
/// -> array
#let line-spec(..pts) = line(..path-spec(..pts.pos()), ..pts.named())
/// Creates the style definition of an arrow mark
///
/// - pos (str): Position of the mark, one of `start`, `end`, or `symbol`
/// -> dictionary
#let mark-style(pos) = ((pos): ")>", fill: black, scale: 0.8)
/// Creates an arrow defined by `path-spec()`
///
/// - pts (arguments): Points defining the path
/// - pos (str): Position of the mark, one of `start`, `end`, or `symbol` (both)
/// -> array
#let arrow(..pts, pos: "end") = line-spec(..pts, mark: mark-style(pos))
/// Creates an arrow mark
///
/// - pos (coordinate): Position of the mark
/// - dir (coordinate): Direction in which the mark points
/// -> array
#let arrow-mark(pos, dir: (rel: (1, 0))) = mark(
  pos,
  dir,
  anchor: "center",
  ..mark-style("symbol"),
)

// ──────────────────────────── Settings annotations ────────────────────────────

/// Creates a CeTZ diagram to annotate an image
///
/// - path (str, path): Path to the image to annotate
/// - body (array): Body of the diagram
/// - debug (bool): Whether do display a debug grid of coordinates
/// -> any
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
      // Add grid labels
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

/// Creates an annotation within an `annotated-img()`
///
/// - body (content): Content of the annotation
/// - side (str): Side of the image in which the annotation should be placed,
///   one of `left`, `right`, `mid`, or `below`
/// - pos (float, length): Vertical position of the annotation
/// - targets (array, float): Targets of the annotation arrows, either an
///   `(x, y)` tuple or a number specifying the vertical position
/// -> array
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

/// Draws a text node on a diagram
#let node(..args) = text-box(width: 30.4mm, ..args)
/// Draws a text node on a diagram with hidden contents
#let hidden-node(pos, _body, ..args) = text-box(width: 5mm, pos, [], ..args)
/// Offsets an array of points by the given vector
///
/// - off (array): Offset vector
/// - pts (arguments): Array of points to offset
/// -> array
#let offset(off, ..pts) = pts.map(p => (rel: off, to: p))

/// Creates a framed group of elements
///
/// - id (str): ID of the group
/// - name (content): Displayed name of the group
/// - body (array): Body of the group
/// -> array
#let framed(id, name, body) = group(name: id, {
  group(name: "body", body)
  content((rel: (0, 3.5mm), to: "body.north"), name, name: "name")
  rect-around("name", "body", padding: 1.5mm)
})

/// Draws a repeatable cell of elements
///
/// - id (int): Index of the cell
/// - name (str): Displayed name of the cell
/// - elems (array): Array of elements contained in the cell, each defined as a
///   dictionary with the following keys
///   - body (content): Body of the element
///   - hide-last (bool, none): Whether the element should be hidden in the last
///     cell
///   - arrows (str, none): Arrows to display between the current and previous
///     element, one of `up`, `down`, `both`, or `none`
/// - hidden (bool): Whether the cell should be hidden with a `...`
/// - last (bool): Whether the cell is the last
/// -> array
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

/// Draws a group of similar cells
///
/// - cells (array): Array of cell definitions, each either `content` or `none`
///   (hidden)
/// - cell-elems (array): Array of elements to add to each cell
/// -> array
#let cell-group(cells, cell-elems) = group(
  name: "cells",
  for (i, curr) in cells.enumerate() {
    let hidden = curr == none
    cell(i, curr, cell-elems, hidden: hidden, last: i == cells.len() - 1)
  },
)
/// Gets the ID of a cell element given by its index and anchor
#let cell-anchor(i, anchor) = "cells.c" + str(i) + ".body." + anchor
/// Gets the position of a gap between cells
#let gap(i) = (cell-anchor(i, "east"), 50%, cell-anchor(i + 1, "west"))

/// Draws an input circuit formed by 2 gates
///
/// - space (length, float): Vertical space between the cells and input circuit
/// - l (content): Content of the left gate
/// - r (content): Content of the right gate
/// - name (content): Name of the group
/// -> array
#let input-circuit(space, l, r, name: [Input circuit]) = framed("input", name, {
  let center = (rel: (0, -space), to: "cells.south")
  let pos(i) = (rel: (i * 0.75mm, 0), to: center)
  node(pos(-1), anchor: "north-east", name: "left", l)
  node(pos(+1), anchor: "north-west", name: "right", r)
})

/// Gets the arguments to position an element relative to another in a given direction
///
/// - d (length, float): Distance from the element
/// - to (str): Element to calculate position relative to
/// -> dictionary
#let pos(d, to) = (
  r: arguments((rel: (d, 0), to: to + ".east"), anchor: "west"),
  l: arguments((rel: (-d, 0), to: to + ".west"), anchor: "east"),
  u: arguments((rel: (0, d), to: to + ".north"), anchor: "south"),
  d: arguments((rel: (0, -d), to: to + ".south"), anchor: "north"),
)
