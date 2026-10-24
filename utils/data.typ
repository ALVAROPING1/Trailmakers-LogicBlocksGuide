// LTeX: enabled=false

#import "/conf.typ": booktab-table, table-stroke

#let load-data(path) = {
  let data = read(path).split("\n").slice(1).map(l => l.split(" "))
  data
}

#let zip((first, ..rest)) = first.zip(..rest)

#let transpose(data, cols) = {
  let col-size = calc.ceil(data.len()/cols)
  let default = ("",) * data.at(0).len()
  let fill = col-size * cols - data.len()
  zip((data + (default,) * fill).chunks(col-size))
}

#let data-table(header, cols, data, caption, label: none) = [
  #show figure: set block(breakable: true)
  #figure(
    booktab-table(
      columns: header.len() * cols,
      align: center + horizon,
      row-gutter: 0pt,
      ..range(1, cols).map(i =>
        table.vline(stroke: table-stroke.thick, x: i * header.len())
      ),

      table.header(..(header.map(h => [*#h*])) * cols),
      ..transpose(data, cols).flatten(),
    ),
    caption: caption
  )
  #if label != none {
    assert(
      type(label) == std.label,
      message: "You must provide a label, e.g. `<table:id>`",
    )
    label
  }
]

#let get-cols(data, ..cols) = cols.map(c => data.map(row => float(row.at(c))))
