// LTeX: enabled=false

/// Advances to the next clean page
/// -> content
#let newpage() = pagebreak(weak: true)

#let conf(
  title: none,
  author: none,
  description: none,
  date: none,
  appendixes: none,
  lang: "en",
  doc,
) = {
  // ───────────────────────────── Document setup ─────────────────────────────
  set document(
    title: title,
    author: author,
    description: description,
    date: date,
  )

  // ─────────────────────────────── Page setup ───────────────────────────────

  let in-frontmatter = state("in-frontmatter", false) // to control page number format in frontmatter

  // Text
  set text(size: 10pt, lang: lang, font: "New Computer Modern")

  set par(
    leading: 0.55em,
    spacing: 1.15em,
    first-line-indent: 1.8em,
    justify: true,
  )

  // Headings
  set heading(numbering: "1.1 ")
  show heading: set block(above: 1.4em, below: 1em)
  // prevent floating elements from spilling into the next section
  show heading.where(level: 2): it => {
    place.flush()
    it
  }

  // Figures

  // more space around figures
  // https://stackoverflow.com/questions/78622060/add-spacing-around-figure-in-typst
  show figure.where(kind: image).or(figure.where(kind: table)): it => {
    let figure-spacing = 0.75em

    if it.placement == none {
      block(it, inset: (y: figure-spacing))
    } else {
      place(
        it.placement,
        float: true,
        clearance: figure-spacing,
        block(align(center, it), spacing: figure-spacing, width: 100%),
      )
    }
  }

  show figure: set figure(gap: 1em)

  // References & Links
  let hyperlink-blue = rgb(5, 99, 193)
  show ref: set text(hyperlink-blue)
  show link: set text(hyperlink-blue)
  // underline external links
  show link: it => if type(it.dest) == str { underline(it) } else { it }

  // Lists
  let square(size) = rect(width: size, height: size, fill: black, stroke: none)
  // indent lists
  set list(indent: 1em, marker: ([•], [–], move(dy: 0.2em, square(0.25em))))
  set enum(indent: 1em, numbering: "1)")

  // Page layout
  set page(
    paper: "a4",
    margin: 2.5cm,
    footer: context {
      set align(center)
      // roman page numbers for the frontmatter, arabic otherwise
      counter(page).display(if in-frontmatter.get() { "i" } else { "1" })
    },
  )

  // Plot diagrams
  import "/deps.typ": lq
  show: lq.set-tick(inset: 4pt)
  show: lq.set-diagram(
    height: 27.5em,
    width: 42em,
    margin: 0%,
    xaxis: (subticks: 1),
    yaxis: (subticks: 1),
    legend: (position: top+left),
  )

  // ──────────────────────────────── Frontmatter ─────────────────────────────

  in-frontmatter.update(true)

  // Title
  {
    set align(center)
    set par(spacing: 0.8em)

    text(size: 18pt, underline(title))
    image("img/thumbnail.png", width: 100%)

    align(right, text(
      size: 12pt,
      date.display("[month repr:long] [day], [year]"),
    ))
  }

  // Outlines
  set outline.entry(fill: repeat([.], gap: 2pt))

  /// Formats an outline entry.
  ///
  /// - it (content): Outline entry.
  /// - fill (boolean): When `true`, add dots between the body and the page number.
  /// - page (boolean): When `true`, shows the page number.
  /// - above (auto, fraction, relative): The spacing between this block and its predecessor (`block.above`).
  /// - text-weight (int, str): Text weight (`text.weight`).
  /// - indented (boolean): Whether to indent the entry.
  /// - justified (boolean): When `false`, wraps the entry in a `block` to prevent justification.
  /// -> content
  let outline-entry-formatter(
    it,
    fill: true,
    above: auto,
    text-weight: "regular",
    indented: true,
    justified: true,
  ) = {
    set block(above: above)
    set text(
      weight: text-weight,
      fill: black,
    )
    show link: set text(black) // reset link color

    let entry-body = {
      it.body()

      // fill
      sym.space.nobreak
      box(width: 1fr, if fill { it.fill } else {})
      sym.space.en

      it.page()
    }
    let entry = (it.prefix(), entry-body)

    let justified-wrapper = if not justified { block } else { x => { x } }

    justified-wrapper(
      link(
        it.element.location(), // make entry linkable
        if indented { it.indented(..entry) } else { entry.join() },
      ),
    )
  }

  // top-level outline entries
  show outline.entry.where(level: 1): it => {
    // non-TOC outlines
    if it.element.func() != heading {
      return outline-entry-formatter(it)
    }

    // TOC outlines
    outline-entry-formatter(
      it,
      above: 1.3em,
      text-weight: "semibold",
      justified: false,
      indented: false,
      fill: false,
    )
  }

  // other TOC entries in regular with adapted filling
  show outline.entry.where(level: 2).or(outline.entry.where(level: 3)): outline-entry-formatter.with(
    above: 0.5em,
  )

  // contents
  outline(title: "Contents", depth: 3)
  // figures
  outline(title: "List of Figures", target: figure.where(kind: image))
  // tables
  outline(title: "List of Tables", target: figure.where(kind: table))

  newpage()
  in-frontmatter.update(false)

  // ─────────────────────────────── Document body ────────────────────────────

  // References style
  show ref: it => {
    let el = it.element
    if el == none { return it }
    // Override heading references
    if el.func() == heading and regex("\d+") in el.numbering {
      return [#it, _#link(el.location(), el.body)_]
    }
    it
  }

  // chapter on new page
  show heading.where(level: 1): it => {
    if counter(heading).get().first() != 2 or regex("\d+") not in it.numbering {
      newpage()
    }
    it
  }

  counter(page).update(1) // first chapter starts at page 1

  doc

  newpage()

  // ─────────────────────────────── Appendixes ───────────────────────────────

  show heading.where(level: 1): set heading(
    // configure supplement
    supplement: "Appendix",
    numbering: "A ",
  )
  counter(heading).update(0)

  if appendixes != none { appendixes }

  text(size: 12pt)[*Made by #author*]
}

// "booktab" table style
#let table-stroke = (thin: 0.2pt, thick: 0.7pt)
#set table.hline(stroke: table-stroke.thin)
#set table.vline(stroke: table-stroke.thin)
#let booktab-table(..args) = {
  show table: block.with(stroke: (y: table-stroke.thick))
  table(
    row-gutter: 0.2em,
    stroke: (_, y) => if y == 0 { (bottom: table-stroke.thin) },
    ..args
  )
}
