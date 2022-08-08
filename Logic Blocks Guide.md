---
mainfont: Calibri.ttf
mainfontoptions:
- Extension=.ttf
- UprightFont=*
- BoldFont=*b
- ItalicFont=*i
- BoldItalicFont=*z

fontsize: 12pt

# For some reason, boxlinks is necessary for colorlinks to work even though it shouldn't have any effect when colorlinks is set
boxlinks: true
linkcolor: hyperlinkBlue
urlcolor: hyperlinkBlue

geometry: "left=3cm,right=3cm,top=2.5cm,bottom=2.5cm"
header-includes: |
    ```{=latex}
    % Fonts
    \setmathfont{Cambria Math}
    \parskip=3.5pt

    % Hyperlink color
    \definecolor{hyperlinkBlue}{RGB}{5,99,193}

    % Horizontal line width on tables (tabular/aligned)
    \usepackage{array}
    \newcommand\HLine[1]{\noalign{\hrule height #1}}

    % Increase max nesting depth for lists
    \newcommand{\LabelItemI}{\labelitemfont \textbullet}
    \newcommand{\LabelItemII}{\labelitemfont \bfseries \textendash}
    \newcommand{\LabelItemIII}{\labelitemfont \rule[0.5ex]{0.6ex}{0.6ex}}
    \newcommand{\LabelItemIV}{\labelitemfont \textasteriskcentered}

    \usepackage{enumitem}

    \setlistdepth{5}

    \setlist[itemize]{leftmargin=2em}
    \setlist[itemize,1]{label=\LabelItemI, leftmargin=2.5em}
    \setlist[itemize,2]{label=\LabelItemII}
    \setlist[itemize,3]{label=\LabelItemIII}
    \setlist[itemize,4]{label=\LabelItemIV}
    \setlist[itemize,5]{label=\LabelItemI}

    \renewlist{itemize}{itemize}{5}

    % Diagrams
    \usepackage{tikz}
    \usetikzlibrary{positioning, fit}
    \tikzset{node/.style={circle, fill=black!100, inner sep=0pt, minimum size=2.5mm}}

    % Ceiling function
    \usepackage{mathtools}
    \DeclarePairedDelimiter{\ceil}{\lceil}{\rceil}

    % Table of contents
    \renewcommand*\contentsname{}

    \newcommand{\TOCLabelI}{\large \color{black}}
    \newcommand{\TOCLabelII}{\hspace{-0.225em} \color{black} \LabelItemI \hspace{0.5em}}
    \newcommand{\TOCLabelIII}{\hspace{-0.305em} \color{black} \LabelItemIII \hspace{0.5em}}

    \newcommand{\TitleFormat}[1]{\LARGE \underline{#1}}
    \newcommand{\TitleFormatI}[1]{\Large \underline{#1}}
    \newcommand{\TitleFormatII}[1]{\large #1}
    ```
---

# \TitleFormat{Logic Blocks Guide} {.unlisted .unnumbered}

\tableofcontents
\clearpage

\newcommand{\titleA}{Settings}
\phantomsection
\addcontentsline{toc}{section}{\TOCLabelI \titleA}

## \TitleFormatI{\titleA} {.unlisted .unnumbered}

\newcommand{\titleAA}{Distance Sensor}
\phantomsection
\addcontentsline{toc}{subsection}{\TOCLabelII \titleAA}

- **\TitleFormatII{\titleAA}**
  - Range: in meters, $1 \text{ block} = 0.25 m$
  - Output value: from $-1$ to $1$
  - Trigger
    - Normal: sends an output when it detects something
    - Inverted: sends an output when it detects nothing
  - Outputs

    <!-- TODO: Add image and annotations
      - ![](media/image1.png){width="2.2256944444444446in"
            > height="1.3416666666666666in"}
    -->

\newcommand{\titleAB}{Altitude Sensor}
\phantomsection
\addcontentsline{toc}{subsection}{\TOCLabelII \titleAB}

- **\TitleFormatII{\titleAB}**
  - Altitude: in meters above the frame of reference, $1 \text{ block} = 0.25 m$
  - Output value: from $-1$ to $1$
  - Frame of reference
    - Ignore waves: fixed altitude at the average sea level
    - Relative to waves: altitude of the water below the sensor
    - Outside of high seas, both options are equivalent
  - Trigger
    - Normal: sends an output when it's above the altitude you set
    - Below: sends an output when it's below the altitude you set
  - Outputs

    <!-- TODO: Add image and annotations
    ![](media/image2.png){width="3.475in" height="1.9756944444444444in"}
    -->

\newcommand{\titleAC}{Speed Sensor}
\phantomsection
\addcontentsline{toc}{subsection}{\TOCLabelII \titleAC}

- **\TitleFormatII{\titleAC}**
  - Speed: in $km/h$ or $mph$ depending on the speed unit settings
    - **IMPORTANT:** only detects the movement in the direction that the arrow points. The speed is measured from the position of the block
  - Output value: from $-1$ to $1$
  - Trigger
    - Normal: sends an output when it goes faster than the speed you set
    - Below: sends an output when it goes slower that the speed you set
  - Outputs

    <!-- TODO: Add image and annotations
    - ![](media/image3.png){width="2.225in"
        > height="1.6291666666666667in"}
    -->

\newcommand{\titleAD}{Angle Sensor}
\phantomsection
\addcontentsline{toc}{subsection}{\TOCLabelII \titleAD}

- **\TitleFormatII{\titleAD}**
  - Direction: in degrees, changes the position of the middle point of the activation threshold
  - Width: in degrees, changes the size of the activation threshold
  - Output value: from $-1$ to $1$
  - Trigger
    - Normal: sends an output when the arrow is inside the activation threshold
    - Outside: sends an output when the arrow is outside the activation threshold
    - Note: the arrow will always try to point up no matter the orientation (in the direction of highest slope of the plane it is in)
  - Outputs

    <!-- TODO: Add image and annotations
      - ![](media/image4.png){width="2.466666666666667in"
            height="2.025in"}
    -->

\newcommand{\titleAE}{Compass}
\phantomsection
\addcontentsline{toc}{subsection}{\TOCLabelII \titleAE}

- **\TitleFormatII{\titleAE}**
  - Direction: in degrees, changes the position of the middle point of the activation threshold
  - Width: in degrees, changes the size of the activation threshold
  - Output value: from $-1$ to $1$
  - Trigger
    - Normal: sends an output when the arrow is inside the activation threshold
    - Outside: sends an output when the arrow is outside the activation threshold
    - Note: the arrow will always try to point north no matter the orientation
  - Outputs

    <!-- TODO: Add image and annotations
      - ![](media/image5.png){width="3.0243055555555554in"
            height="2.2222222222222223in"}
    -->

\newcommand{\titleAF}{Logic Gates}
\phantomsection
\addcontentsline{toc}{subsection}{\TOCLabelII \titleAF}

- **\TitleFormatII{\titleAF}**
  - Keybinds: green ($1$) and red ($-1$), they act as the same input (an and gate with a green and a red keybind will send an output even when just pressing one of the 2 keybinds), but act as a different input for each seat (an and gate with a keybind will require someone in each seat that has control over it pressing the keybind to send an output)
    - Toggle: toggles **inputs**, when an input reaches a gate it will toggle on the color toggled (if there is, it's of the same color as the input and it's off), toggle it off (if there is, it's of the same color as the input and it's on, it will be toggled off after this pulse stops reaching the gate) or toggle the other color off and check again the other 2 rules (if it's not of the same color as the input and the other color it's toggled on)
      - If you want to toggle the output instead of the inputs, make the signal go through another gate with the toggle after the gate in which you want to toggle the output
  - Timers
    - The timers start as soon as the gate receives a **single input**, even if the gate doesn't meet the conditions to send an output
    - The number will be rounded to have only 2 decimal places when shown on the menu, but the number which will be used is the one you wrote rounded to 8 decimal places. Due to a bug only up to 5 characters can be written, so depending on which value you write the number of decimals which can be used will vary
    - Delay: in seconds, only applied when activating but not when deactivating. Note: each logic gate has an extra delay of $1/60 s$ due to the state of all the logic gates being updated only once per physics' frame
    - Duration and pause (previously known as active and inactive time respectively): in seconds, setting the duration to a number different than $0$ and pause to $0$ will make it send a single pulse until turned off and on again. If both of them are not $0$ it will create a cycle which will be repeated until it's deactivated. The shortest length for a pulse is $1$ frame ($1/60 s$), any value lower than this won't send an output
    - The order of the timers is as follows: delay $\rightarrow$ duration $\rightarrow$ pause $\rightarrow$ back to duration (if pause is 0 it ends after the duration ends)
    - In the case of delay and duration timers, even though their values are expressed in seconds, the game handles them as a number of frames. To calculate that number just do $\text{seconds} \cdot 60$. If this number is not an integer, it will be rounded down to the nearest integer. If this number is an integer however, it will randomly either be kept as it is or be subtracted one frame, so it's recommended to add $0.01$ to the original number to make sure it always stays in the correct number of frames. Pause timers aren't subject to this, and the exact time in seconds is used for them
  - Output value: from $-1$ to $1$
  - Outputs

    <!-- TODO: Add image and annotations
      - ![](media/image6.png){width="3.720833333333333in"
            height="1.5090277777777779in"}
    -->

\newcommand{\titleB}{Output Value}
\phantomsection
\addcontentsline{toc}{section}{\TOCLabelI \titleB}

## \TitleFormatI{\titleB} {.unlisted .unnumbered}

- When something is activated, it acts as if you pressed the keybind. Positive values act as the green keybind and negative values act as the red keybind. For things that only have green keybind, the absolute value will be used
- Goes from $-1$ to $1$
  - Due to a bug only up to 5 characters can be written, so depending on if the value is positive or negative you will only be able to use up to 4 or 3 decimals respectively. More decimals can be achieved by using multiple gates: if the number is expressed in scientific notation as $\pm a \cdot 10^b$, $a$ can be any number such that $0 \leq a \leq 10$ with up to 7 decimals while $b$ can be any integer such that $-81 \leq b \leq -1$. If $a$ has more than 7 decimals, it will be rounded to 7 decimals
- It's the percentage of power that whatever it activates will use, applied to the value set in the settings (if applicable)
  - For engines it affects the max speed and acceleration (the torque)
  - For thrusters/gimbals/propellers/underwater propellers/outboard boat engines it affects the power
  - For servos/hinges/large hinges it affects the angle
    - For hinges the speed depends on the max angle and not the angle achieved with the output value, resulting in faster speeds when using decimal output value
    - Hinges are currently bugged resulting in angles way lower than they should be. There is a table at the end of this guide with the multiplier for each output value [\underline{here}](#OutputValue2MultiplierTable)
  - For spinning servos/helicopter engines/pistons it affects the speed
  - For tone generators it affects the volume
  - For the rest of the blocks, it doesn't affect anything
\newcommand{\titleBA}{How the output value is calculated}
- **\TitleFormatII{\titleBA}**
  \phantomsection
  \addcontentsline{toc}{subsection}{\TOCLabelII \titleBA}
  - First the gate checks if its conditions are met
    - AND gate: all inputs are on
    - OR gate: at least 1 input is on
    - XOR gate: only 1 input is on
  - Second it adds up the output values of all of its inputs
    - If the result is $> 1$ it gets replaced with $1$
    - If the result is $< -1$ it gets replaced with $-1$
  - Third it multiplies the result by its output value
  - Lastly it sends the result as its output value. On the steam version, the final output value must also be different from 0 to send an output
  - Diagram made by Zoomah:

    <!-- TODO: Add image and annotations
      - ![](media/image7.png){width="5.300694444444445in"
            height="1.511111111111111in"}
    -->

  - Example

An AND gate with an output value of $0.5$ has 2 inputs, one of them has an output value of $0.8$ and the other of $0.5$. When both of them are on at the same time (so the AND gate sends an output) the output values of the inputs are added up, $0.8 + 0.5 = 1.3$. Because $1.3$ is bigger than $1$, the gate replaces it with $1$, then that value is multiplied by the output value of the gate, $1 \cdot 0.5 = 0.5$, so the AND gate sends an output of $0.5$

\newcommand{\titleC}{Useful Circuits}
\phantomsection
\addcontentsline{toc}{section}{\TOCLabelI \titleC}

## \TitleFormatI{\titleC} {.unlisted .unnumbered}

\newcommand{\titleCA}{NOR/NOT Gate}
\phantomsection
\addcontentsline{toc}{subsection}{\TOCLabelII \titleCA}

- **\TitleFormatII{\titleCA}**
  - Inverts the state of the input
  - Made by connecting an always on input (a sensor that is always on, all sensors can be configured to work like this but the most commonly used one is a distance sensor with 0 range and invert trigger) to a XOR gate
  - If it only has a single input that isn't the always on input it will act as a NOT gate, if it has multiple it will act as a NOR gate
  - You can make a NAND/XNOR gate by making an AND/XOR gate output to a NOT gate and taking the output from the NOT gate

\newcommand{\titleCB}{Pulse generator/Rising edge detector}
\phantomsection
\addcontentsline{toc}{subsection}{\TOCLabelII \titleCB}

- **\TitleFormatII{\titleCB}**
  - Sends a pulse of a specific length (usually a single frame which is $1/60 s$) when the input goes from off to on
  - Made by setting the duration to the length of the pulse on an OR gate

\newcommand{\titleCC}{Falling edge detector}
\phantomsection
\addcontentsline{toc}{subsection}{\TOCLabelII \titleCC}

- **\TitleFormatII{\titleCC}**
  - Sends a pulse of a specific length when the input goes from on to off
  - Made by connecting a NOT gate to a pulse generator

\newcommand{\titleCD}{Latch}
\phantomsection
\addcontentsline{toc}{subsection}{\TOCLabelII \titleCD}

- **\TitleFormatII{\titleCD}**
  - Stores a single bit of information
  - Made by activating toggle on an OR gate, requires the input to be a pulse to be easily controlled by other gates (use a pulse generator for this)

\newcommand{\titleCE}{Counter}
\phantomsection
\addcontentsline{toc}{subsection}{\TOCLabelII \titleCE}

- **\TitleFormatII{\titleCE}**
  - Can store the value of a variable with $n$ possible values
  - There are 3 ways of doing it: general method, base 10 and binary. Which one uses less gates depends on the situation
    \newcommand{\titleCEA}{General Circuit}
    - \titleCEA
      \phantomsection
      \addcontentsline{toc}{subsubsection}{\TOCLabelIII \titleCEA}
      - $n = \text{amount of cells}$
      - Diagram of the circuit:
        <!-- TODO: diagram of the circuit-->
      - You can add an extra AND gate to each cell, reverse the direction of their inputs (right to left rather than left to right) and add a second pulse generator as input connected to those extra AND gates to allow the value to go up and down rather than only up
      - Requires a startup pulse to one of the toggled OR gates work (achieved with a 1 frame pulse generator)
      - Complexity (amount of logic gates used without the ones used to create the startup pulse as those can be reused)
        - 1-way: $2n$
        - 1-way+cycle: $2n + 1$
        - 2-way: $3n$
        - 2-way+cycle: $3n + 1$
      - Takes 3 frames to update
      - Example blueprints: [\underline{1-way}](https://steamcommunity.com/sharedfiles/filedetails/?id=2134486907), [\underline{1-way+cycle}](https://steamcommunity.com/sharedfiles/filedetails/?id=2134487841), [\underline{2-way}](https://steamcommunity.com/sharedfiles/filedetails/?id=2075055361) and [\underline{2-way+cycle}](https://steamcommunity.com/sharedfiles/filedetails/?id=2134489564)
    \newcommand{\titleCEB}{Base 10}
    - \titleCEB
      \phantomsection
      \addcontentsline{toc}{subsubsection}{\TOCLabelIII \titleCEB}
      - $n = 10^\text{amount of cells}; \text{ amount of cells} = \log_{10} n$
      - Each cell is the general circuit for $n=10$ with cycle (except for the last cell which can have any value between $2$ and $10$ for $n$ and doesn't need to have cycle) and only the first cell with an input gate
      - Diagram of the circuit:
        <!-- TODO: diagram of the circuit-->
      - You can use the 2-way version of the general method for the cells to make it 2-way, the only thing that changes is that the AND gate of the extra gates that connects to the next cell is the first one rather than the last
      - Might require a decoder to be used (unless you just want to show numbers on a screen, you can use each cell as a digit of the number in that case), to create it you just need to take $n$ AND gates and assign a different combination of 1 output gate from each cell to each of them (if you only need to use it combined with other circuits you can combine all of their decoders into a single one to use less gates)
      - Requires a startup pulse to one of the toggled OR gates on each cell work (achieved with a 1 frame pulse generator)
      - Complexity (amount of logic gates used without the ones used to create the startup pulse as those can be reused)
        - 1-way: $2 \ceil[\Big]{\frac{n}{10^{\ceil{\log_{10} n} - 1}}} + 20 \ceil{\log_{10} n} - 20$
        - 1-way+cycle: $2 \ceil[\Big]{\frac{n}{10^{\ceil{\log_{10} n} - 1}}} + 20 \ceil{\log_{10} n} - 19$
        - 2-way: $3 \ceil[\Big]{ \frac{n}{10^{\ceil{\log_{10} n} - 1}}} + 30 \ceil{\log_{10} n} - 30$
        - 2-way+cycle: $3 \ceil[\Big]{\frac{n}{10^{\ceil{\log_{10} n} - 1}}} + 30 \ceil{\log_{10} n} - 29$
      - Takes 3 frames to update for each cell that needs to change
      - Example blueprints: [\underline{1-way}](https://steamcommunity.com/sharedfiles/filedetails/?id=2134491881), [\underline{1-way+cycle}](https://steamcommunity.com/sharedfiles/filedetails/?id=2134492935), [\underline{2-way}](https://steamcommunity.com/sharedfiles/filedetails/?id=2134494676) and [\underline{2-way+cycle}](https://steamcommunity.com/sharedfiles/filedetails/?id=2134496082)
    \newcommand{\titleCEC}{Binary}
    - \titleCEC
      \phantomsection
      \addcontentsline{toc}{subsubsection}{\TOCLabelIII \titleCEC}
      - $n = 2^\text{amount of cells}; \text{ amount of cells} = \log_2 n$
      - Diagram of the circuit:
        <!-- TODO: diagram of the circuit-->
      - To make it 2-way you need to modify the input circuit to make the 1 frame pulse generator and the OR gate send an input directly to the AND gate in each cell (you can't skip the AND gate in the first cell in this case). Then, duplicate the input circuit and add a new AND gate to each cell, but make the OR gate have all *output 1* gates as input rather than all *output 2* gates. Connect the new AND gate in each cell in the same way the old AND gate was connected, but use all previous cells' *output 2* gates as input rather than all previous cells' *output 1* gates. Finally add a NOR gate with both AND gates from the first cell as input (this will be used for the decoder). To make this 2-way version cycle remove the OR gate from the input circuit and skip the AND gate for the increase direction in the first cell (connect the input directly to *output 1* for that cell)
      - Might require a decoder to be used, to create it you just need to take *n* AND gates and assign a different combination of either *output 1* or *output 2* from each cell (if you only need to use it combined with other circuits you can combine all of their decoders into a single one to use less gates). If you are using the 2-way versions, all AND gates need to have the NOR gate (which has both AND gates from the first cell as input) as input to remove a false positive while changing values
      - Complexity (amount of logic gates used without the always on sensor used to create the NOT gates nor gates used to create the startup pulse as those can be reused)
        - 1-way: $3 \ceil{\log_2 n} + 2$
        - 1-way+cycle: $3 \ceil{\log_2 n}$
        - 2-way: $4 \ceil{\log_2 n} + 5$
        - 2-way+cycle: $4 \ceil{\log_2 n} + 2$
      - Takes 4 frames to update for 1-way and 3 frames for the other versions
      - Example blueprints: [\underline{1-way}](https://steamcommunity.com/sharedfiles/filedetails/?id=2134497489), [\underline{1-way+cycle}](https://steamcommunity.com/sharedfiles/filedetails/?id=2134498845), [\underline{2-way}](https://steamcommunity.com/sharedfiles/filedetails/?id=2134500019) and [\underline{2-way+cycle}](https://steamcommunity.com/sharedfiles/filedetails/?id=2134500705)
    \newcommand{\titleCED}{When to use each method}
    - \titleCED
      \phantomsection
      \addcontentsline{toc}{subsubsection}{\TOCLabelIII \titleCED}

+---+----------------------------+-------------------------------------+
|   | **1-way**                  | **2-way**                           |
+===+============================+=====================================+
| > | Doesn't require an         | Doesn't require an individual       |
|   | individual decoder:        | decoder:                            |
| * |                            |                                     |
| * | - For *n*\<6 use the     | - For *n*≤5 use the general       |
| W |     general method         |     method                          |
| i |                            |                                     |
| t | - For *n*≥6 use the      | - For *n*\>5 use the binary       |
| h |     binary method          |     method                          |
| o |                            |                                     |
| u | Requires an individual     | Requires an individual decoder:     |
| t | decoder:                   |                                     |
| > |                            | - For *n*≤10 use the general      |
|   | - For *n*\<15 use the    |     method                          |
| c |     general method         |                                     |
| y |                            | - For *n>*10 use the binary       |
| c | - For *n*≥15 use the     |     method                          |
| l |     binary method          |                                     |
| e |                            | Show values directly on a screen    |
| * | Show values directly on a  | (only numbers for n>12)             |
| * | screen (only numbers for   |                                     |
|   | n>12)                      | - For *n*≤10 use the general      |
|   |                            |     method                          |
|   | - For *n*≤12 use the     |                                     |
|   |     general method         | - For 10\<*n*\<15 use the binary  |
|   |                            |     method                          |
|   | - For *n*\>12 use the    |                                     |
|   |     base 10 method         | - For *n*≥15 use the base 10      |
|   |                            |     method                          |
+---+----------------------------+-------------------------------------+
| > | Doesn't require an         | Doesn't require an individual       |
|   | individual decoder:        | decoder:                            |
| * |                            |                                     |
| * | - Use the binary method  | - For *n*≤3 use the general       |
| W |                            |     method                          |
| i | Requires an individual     |                                     |
| t | decoder:                   | - For *n*\>3 use the binary       |
| h |                            |     method                          |
| > | - For *n*\<12 use the    |                                     |
|   |     general method         | Requires an individual decoder:     |
| c |                            |                                     |
| y | - For *n*≥12 use the     | - For *n*≤6 use the general       |
| c |     binary method          |     method                          |
| l |                            |                                     |
| e | Show values directly on a  | - For *n*\>6 use the binary       |
| * | screen (only numbers for   |     method                          |
| * | *n*\>12)                   |                                     |
|   |                            | Show values directly on a screen    |
|   | - For *n*\<12 use the    | (only numbers for *n*\>12)          |
|   |     general method         |                                     |
|   |                            | - For *n*≤6 use the general       |
|   | - For *n*=12 use the     |     method                          |
|   |     binary method          |                                     |
|   |                            | - For 6\<*n*≤16 use the binary    |
|   | - For *n*\>12 use the    |     method                          |
|   |     base 10 method         |                                     |
|   |                            | - For *n*\>16 use the base 10     |
|   |                            |     method                          |
+---+----------------------------+-------------------------------------+

Note: this is just based on the amount of logic gates each method uses (unless there is a tie, in which case speed is used), however the amount of time it takes for the system to update might also matter depending on the situation, in which case on average the fastest is the general method, followed by the binary method and lastly the base 10 method (in the 1-way version the binary and base 10 positions must be swapped)

\newcommand{\titleD}{Output value to multiplier table for hinges}
\phantomsection
\addcontentsline{toc}{section}{\TOCLabelI \titleD}

## \TitleFormatI{\titleD} {#OutputValue2MultiplierTable .unlisted .unnumbered}

- Final angle is the resulting angle of the hinge measured with a max angle of $90$ degrees and an error of $\pm 0.005$ degrees

- The multiplier was calculated by doing $\text{multiplier} = \frac{\text{final angle}}{90}$

  -----------------------------------------------------------------------------------------------------------------
  **Output   **Final   **Multiplier**   **Output   **Final   **Multiplier**   **Output   **Final   **Multiplier**
  value**    angle**                    value**    angle**                    value**    angle**   
  ---------- --------- ---------------- ---------- --------- ---------------- ---------- --------- ----------------
  1.000      90.000    1.00000000       0.810      31.275    0.34750000       0.480      05.640    0.06266667

  0.995      88.345    0.98161111       0.805      30.215    0.33572222       0.470      05.295    0.05883333

  0.990      86.680    0.96311111       0.800      29.195    0.32438889       0.460      04.960    0.05511111

  0.985      85.000    0.94444444       0.795      28.225    0.31361111       0.450      04.640    0.05155556

  0.980      83.315    0.92572222       0.790      27.300    0.30333333       0.440      04.335    0.04816667

  0.975      81.620    0.90688889       0.785      26.425    0.29361111       0.430      04.040    0.04488889

  0.970      79.920    0.88800000       0.780      25.595    0.28438889       0.420      03.760    0.04177778

  0.965      78.215    0.86905556       0.775      24.825    0.27583333       0.410      03.495    0.03883333

  0.960      76.505    0.85005556       0.770      24.105    0.26783333       0.400      03.245    0.03605556

  0.955      74.795    0.83105556       0.765      23.440    0.26044444       0.390      03.005    0.03338889

  0.950      73.085    0.81205556       0.760      22.830    0.25366667       0.380      02.775    0.03083333

  0.945      71.380    0.79311111       0.755      22.280    0.24755556       0.370      02.560    0.02844444

  0.940      69.675    0.77416667       0.750      21.790    0.24211111       0.360      02.355    0.02616667

  0.935      67.975    0.75527778       0.740      20.920    0.23244444       0.350      02.160    0.02400000

  0.930      66.280    0.73644444       0.730      20.075    0.22305556       0.340      01.980    0.02200000

  0.925      64.595    0.71772222       0.720      19.255    0.21394444       0.330      01.805    0.02005556

  0.920      62.920    0.69911111       0.710      18.460    0.20511111       0.320      01.645    0.01827778

  0.915      61.250    0.68055556       0.700      17.685    0.19650000       0.310      01.495    0.01661111

  0.910      59.595    0.66216667       0.690      16.930    0.18811111       0.300      01.350    0.01500000

  0.905      57.955    0.64394444       0.680      16.200    0.18000000       0.290      01.220    0.01355556

  0.900      56.325    0.62583333       0.670      15.490    0.17211111       0.280      01.095    0.01216667

  0.895      54.715    0.60794444       0.660      14.800    0.16444444       0.270      00.980    0.01088889

  0.890      53.125    0.59027778       0.650      14.135    0.15705556       0.269      00.970    0.01077778

  0.885      51.550    0.57277778       0.640      13.485    0.14983333       0.268      00.955    0.01061111

  0.880      49.995    0.55550000       0.630      12.860    0.14288889       0.267      00.945    0.01050000

  0.875      48.465    0.53850000       0.620      12.250    0.13611111       0.266      00.935    0.01038889

  0.870      46.960    0.52177778       0.610      11.660    0.12955556       0.265      00.925    0.01027778

  0.865      45.480    0.50533333       0.600      11.095    0.12327778       0.264      00.915    0.01016667

  0.860      44.025    0.48916667       0.590      10.545    0.11716667       0.263      00.905    0.01005556

  0.855      42.600    0.47333333       0.580      10.010    0.11122222       0.262      00.000    0.00000000

  0.850      41.200    0.45777778       0.570      09.500    0.10555556       0.261      00.000    0.00000000

  0.845      39.830    0.44255556       0.560      09.000    0.10000000       0.260      00.000    0.00000000

  0.840      38.505    0.42783333       0.550      08.525    0.09472222       0.250      00.000    0.00000000

  0.835      37.200    0.41333333       0.540      08.065    0.08961111       0.200      00.000    0.00000000

  0.830      35.940    0.39933333       0.530      07.620    0.08466667       0.150      00.000    0.00000000

  0.825      34.715    0.38572222       0.520      07.190    0.07988889       0.100      00.000    0.00000000

  0.820      33.530    0.37255556       0.510      06.780    0.07533333       0.050      00.000    0.00000000

  0.815      32.380    0.35977778       0.500      06.380    0.07088889       0.000      00.000    0.00000000

                                        0.490      06.005    0.06672222                            
  -----------------------------------------------------------------------------------------------------------------

- Graph of the multiplier as a function of the output value
  <!-- TODO: Add graph-->

\newcommand{\titleE}{Tips}
\phantomsection
\addcontentsline{toc}{section}{\TOCLabelI \titleE}

## \TitleFormatI{\titleE} {.unlisted .unnumbered}

- If you want your system to not modify the input that passes through, configure all of the logic gates to have an output value of 1. Then, if a gate needs to have more inputs other than the original one, make sure the sum of the output values of those other inputs is 0. This will make the output which reaches whatever your system activates be the output that the sensors/keybinds had
- Organize the logic gates on a testbed while working with them before adding them to your vehicle, having the logic gates organized as opposed to scattered across your entire vehicle will make remembering what each gate does easier. There is no wrong way to organize them as long as they aren't randomly placed, but the way I do it is by splitting the gates into groups depending on function, inside each group the arrows of logic gates point towards the outputs of that gate and away from its inputs, then I put the groups of logic gates that a group outputs to in the direction the arrows of the logic gates that the group uses as output are pointing, while I put the groups that group uses as input in the opposite direction
- If you have problems figuring out how to do something with logic gates, draw it on paper first, being able to see all connections at once helps a lot. Another method is writing it with if statements as they translate to logic gates easily (each logic gate is an individual if statement)
- If you still have any questions or need help with something, feel free to contact me on the [\underline{official trailmakers discord server}](https://discord.gg/trailmakers)

## \large Made by ALVAROPING1#6682 {.unlisted .unnumbered}
