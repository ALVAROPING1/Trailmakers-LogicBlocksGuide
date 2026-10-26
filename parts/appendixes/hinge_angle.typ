// LTeX: language=en

#import "/utils/data.typ": *
#import "/utils/plots.typ": *
#import "/deps.typ": strfmt

= Input value to multiplier for hinges/wings with control surfaces <InputValueMultiplier>

By default, the angle by which hinges/wings/other blocks with the "steering help" setting rotate doesn't scale linearly with the input value. The angle is smaller than what a linear relationship would result in, to improve steering on controller. In hinges, this can be adjusted with the steering mode setting, where a "linear" value results in a linear relationship while any other value results in the non-linear relationship. This section contains the multipliers used for many input values in the non-linear relationship, found experimentally. Some notes about this process:

- Final angle is the resulting angle of the hinge measured with a max angle of $90 degree$ and an error of $plus.minus 0.005 degree$
- The multiplier was calculated with $"multiplier" = "final angle"/90$
- A calculator using this data made by confusionextended can be found #link("https://www.desmos.com/calculator/i70yadxqyy")[here]

// LTeX: enabled=false
#let (_, ..data) = csv("/data/Input_Value_Multiplier.csv")
#let data = data.map(((i, a)) => (i, a, strfmt("{:.8}", float(a) / 90)))

#data-table(
  ([Input\ Value], [Final\ Angle], [Multiplier]),
  3,
  data,
  [Raw data of the input value multiplier for hinges],
  label: <table:InputValueMultiplierData>,
)

#import "/utils/plots.typ": plot-data, plot-fn

#figure(
  lq.diagram(
    title: [Multiplier as a function of the input value],
    xlabel: [Input value],
    ylabel: [Multiplier],
    plot-data(..get-cols(data, 0, 2), clip: false),
    plot-fn((0, 1), $x$),
  ),
  caption: [Graph of the multiplier for hinges as a function of the input value],
) <fig:InputValueMultiplierGraph>

