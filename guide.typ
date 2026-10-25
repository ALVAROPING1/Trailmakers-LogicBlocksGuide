// LTeX: enabled=false

#import "/conf.typ": conf

#show: conf.with(
  title: "Logic Blocks Guide",
  author: "ALVAROPING1",
  date: datetime.today(),
  appendixes: [
    #include "/parts/appendixes/hinge_angle.typ"
    #include "/parts/appendixes/input_value_speed.typ"
    #include "/parts/appendixes/aiming_sensor_pitch.typ"
    #include "/parts/appendixes/tips.typ"
  ],
)

// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║                                 Document                                  ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

#include "/parts/introduction.typ"
#include "/parts/blocks.typ"
#include "/parts/common_settings.typ"
#include "/parts/signals.typ"
#include "/parts/useful_circuits.typ"
#include "/parts/historical_circuits.typ"
