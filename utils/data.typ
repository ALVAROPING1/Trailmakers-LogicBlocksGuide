// LTeX: enabled=false

#import "/conf.typ": booktab-table, table-stroke

/// Alias for zipping an array of arrays
///
/// - arr (array): Arrays to zip
/// -> array
#let zip(arr) = arr.at(0).zip(..arr.slice(1))

/// Folds a `Nx1` column vector into a `KxCols` matrix in row-major order
///
/// - data (array): Array of data elements
/// - cols (int): Number of result columns
/// -> array
#let transpose(data, cols) = {
  let col-size = calc.ceil(data.len() / cols)
  let default = ("",) * data.at(0).len()
  let fill = col-size * cols - data.len()
  zip((data + (default,) * fill).chunks(col-size))
}

/// Displays data on a table folded `cols` times
///
/// - header (array, content): Header of each column
/// - cols (int): Amount of columns to fold the data into
/// - data (array): Array of data elements
/// - caption (content): Caption of the table
/// - label (label, none): Label of the table
/// -> content
#let data-table(header, cols, data, caption, label: none) = [
  #show figure: set block(breakable: true)
  #figure(
    booktab-table(
      columns: header.len() * cols,
      align: center + horizon,
      row-gutter: 0pt,
      ..range(1, cols).map(i => table.vline(
        stroke: table-stroke.thick,
        x: i * header.len(),
      )),

      table.header(..(header.map(h => [*#h*])) * cols),
      ..transpose(data, cols).flatten(),
    ),
    caption: caption,
  )
  #if label != none {
    assert(
      type(label) == std.label,
      message: "You must provide a label, e.g. `<table:id>`",
    )
    label
  }
]

/// Gets the specified columns in column-major order from a row-major data matrix
///
/// - data (array): Array of rows
/// - cols (arguments): Index of the columns to get
/// -> array
#let get-cols(data, ..cols) = cols.map(c => data.map(row => float(row.at(c))))
