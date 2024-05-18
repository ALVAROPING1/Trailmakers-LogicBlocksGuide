---
title: Logic Blocks Guide
author: ALVAROPING1
date: \today
lang: en

toc: true
toc-depth: 3

linkcolor: hyperlinkBlue
urlcolor: hyperlinkBlue

geometry: "top=2.54cm, bottom=2.54cm, left=2.54cm, right=2.54cm"

header-includes: |
    ```{=latex}
    % Fonts
    \parskip=3.5pt

    % Hyperlink color
    \definecolor{hyperlinkBlue}{RGB}{5,99,193}

    % Custom horizontal line width on tables (tabular/aligned)
    \usepackage{booktabs}
    \aboverulesep=0ex
    \belowrulesep=0ex
    \newcommand\HLine[1]{\specialrule{#1}{0pt}{0pt}}

    % Multi page tables
    \usepackage{longtable}

    % Force figure location
    \usepackage{float}
    % Correct hiperlink to figures
    \usepackage{caption}

    % Add table of figures/tables, we can't use pandoc's built-in option because it doesn't remove color like for the table of contents
    \newcommand{\lists}{{\hypersetup{linkcolor=} \listoffigures \listoftables}}

    % Multi line table cells
    \usepackage{makecell}
    \renewcommand\theadfont{\bfseries}

    % Increase table cell height
    \renewcommand{\arraystretch}{1.4}

    % Increase table header height
    \renewcommand\theadgape{\Gape[5pt]}

    % Merge rows/columns in tables
    \usepackage{multirow}

    % Vertically center table cells
    \usepackage{array}

    % Custom list labels
    \newcommand{\LabelItemI}{\labelitemfont \textbullet}
    \newcommand{\LabelItemII}{\labelitemfont \bfseries \textendash}
    \newcommand{\LabelItemIII}{\labelitemfont \rule[0.5ex]{0.6ex}{0.6ex}}
    \newcommand{\LabelItemIV}{\labelitemfont \textasteriskcentered}

    % Increase max nesting depth for lists
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
    \usetikzlibrary{positioning, fit, calc, arrows.meta, backgrounds, decorations.markings}
    % Node/line/arrow styles
    \tikzset{
        % Basic node
        rectangleNode/.style={rectangle, draw=black, fill=white, thick, minimum height=6.6mm},
        % Node for image annotations
        annotation/.style={rectangleNode, align=left},
        % Node for diagram nodes
        node/.style={rectangleNode, align=center, minimum width=30.4mm},
        % Node for hidden diagram nodes
        hiddenNode/.style={rectangleNode, draw=none, fill=none, minimum width=5mm},
        % Style for lines
        line/.style={-, thick},
        % Style for arrows
        arrow/.style={->, thick},
        % Style for arrows with the tip on the middle
        ->-/.style={line, decoration={markings, mark=at position 0.5 with {\arrow{>}}}, postaction={decorate}},
    }
    % Custom to-paths
    \tikzset{
        % Vertical line through the end point
        *|/.style={/tikz/to path={(\tikztostart -| \tikztotarget) -- (\tikztotarget) \tikztonodes}}
    }

    % Plot graphs
    \usepackage{pgfplots}
    \pgfplotsset{every axis plot/.append style={very thick}}

    % Images location
    \graphicspath{ {img/} }

    % Ceiling function
    \usepackage{mathtools}
    \DeclarePairedDelimiter{\ceil}{\lceil}{\rceil}

    % Title command
    \makeatletter
    \renewcommand{\maketitle}{
        \pagenumbering{roman}
        \begin{center}
            \LARGE\underline{\@title}\\
            \vspace{1mm}
            \begin{figure}[h]
                \makebox[\textwidth][c]{
                    \includegraphics[width=\linewidth]{thumbnail}
                }
            \end{figure}
            \raggedleft\large{\@date} \\
        \end{center}
    }
    \makeatother
    ```
---

\lists
\clearpage
\pagenumbering{arabic}

# Introduction

The goal of this document is to explain the logic system in the game [\underline{Trailmakers}](https://store.steampowered.com/app/585420/Trailmakers/). It also aims to act as a comprehensive technical reference manual for all related mechanics and behaviours. This document also contains a section about commonly used logic circuits and how to make them, to aid in the design and understanding of more complex logic circuits.

# Logic Blocks

Logic blocks are a group of blocks that allow to obtain and process information, which in turn can be used to automate tasks or create more complex control schemes for creations, and more generally, perform any finite sequence of steps (known as executing an algorithm).

All logic blocks, with the exception of distance sensors, have a display with an arrow pointing away from the center of the block representing the value of their output signal. This arrow is empty when there is no output ($0$ value), and green/red when the output is positive/negative. Blocks which can take other signals as inputs (\nameref{logic-gates}) additionally have a second arrow pointing to the center of the block representing the input signals, which works like the output arrow but using the value of the sum of the input signals.

Note: due to a bug, only up to 5 characters can be used on any configurable block value. Even though the UI rounds values 1-2 values, the values used are always the values that were typed.

## Sensors

Sensors are a group of blocks that measure a physical property, like speed or angle, and create a boolean output based on it.

### Distance Sensor

Distance sensors check for objects within a straight line in front of them and a predefined distance. Only one half of the detecting face actually detects objects. The detecting face glows white when the sensor creates an output, and stays off otherwise.

Its settings are shown in figure \ref{fig:SensorDistance} and are as follows:

- Range: maximum distance between an object and the sensor for it to be detected, in meters ($1 \text{ block} = 0.25 \text{ m}$)
  - Distance is measured from the center of the block, meaning the distance between the object and the side of the block is half a block ($0.125 \text{ m}$) shorter than the distance measured
- Output value: value of the output signal created by the block, discussed in \nameref{signals}
- Trigger
  - Normal: sends an output when it detects an object
  - Inverted: sends an output when it doesn't detect an object
- Outputs

\begin{figure}[H]
    \centering
    \begin{tikzpicture}
        % Image in a node
        \node[anchor=south west, inner sep=0] (image) at (0,0) {\includegraphics[width=20em]{distance_sensor}};
        % Use the image as the bounding box of the tikzpicture for centering
        \useasboundingbox (image.south east) rectangle (image.north west);

        % Create scope with normalized axes
        \begin{scope}[
            x={($0.05*(image.south east)$)},
            y={($0.05*(image.north west)$)}
        ]
            % Draw grid
            %\draw[lightgray,step=1] (image.south west) grid (image.north east);

            % Draw axes labels
            %\foreach \x in {0,1,...,20} {\node [below] at (\x,0) {\tiny \x};}
            %\foreach \y in {0,1,...,20} {\node [left]  at (0,\y) {\tiny \y};}

            % Nodes
            \node[annotation, left]  (output_on)    at (-1.5, 16.4) {Output (on)\\(will send an\\input to it)};
            \node[annotation, right] (output_off)   at (21.5, 16.4) {Output (off)\\(won't send an\\input to it)};
            \node[annotation, left]  (range)        at (-1.5, 3)    {Range};
            \node[annotation, below] (output_value) at (8.5, -1.5)  {Output value};
            \node[annotation, right] (trigger)      at (21.5, 0)    {Invert trigger (on/off),\\currently off\\(normal trigger)};

            % Arrows
            \draw[arrow] (output_on.east)     -- (4.4, 16.4);
            \draw[arrow] (output_off.west)    -- (9.8, 16.4);
            \draw[arrow] (range.east)         -- (0.3, 3);
            \draw[arrow] (output_value.north) -- (8.5, 0.7);
            \draw[arrow] (trigger.west)       -- (14, 4.5);
        \end{scope}
    \end{tikzpicture}
    \vspace{1cm}
    \caption{Distance Sensor settings}
    \label{fig:SensorDistance}
\end{figure}

### Altitude Sensor

Altitude sensors measure the altitude of the block relative to a predefined frame of reference. They have a display which shows the currently measured altitude rounded to the nearest integer, or "N/A" in build mode.

Its settings are shown in figure \ref{fig:SensorAltitude} and are as follows:

- Altitude: altitude threshold to trigger, in meters above the frame of reference ($1 \text{ block} = 0.25 \text{ m}$)
- Output value: value of the output signal created by the block, discussed in \nameref{signals}
- Frame of reference: position of the $0$ altitude point
  - Ignore waves: fixed at the average sea level
  - Relative to waves: at the position of the water surface at the horizontal coordinates of the sensor
  - Outside of high seas and when the wave setting is set to disabled, both options are equivalent
  - On space sector, it's a "MAX" value while outside an atmosphere and the distance to a point close to the center of the planet while inside of one
- Trigger
  - Normal: sends an output when the altitude is above the configured value
  - Below: sends an output when the altitude is below the configured value
- Outputs

\begin{figure}[H]
    \centering
    \begin{tikzpicture}
        % Image in a node
        \node[anchor=south west, inner sep=0] (image) at (0,0) {\includegraphics[width=20em]{altitude_sensor}};
        % Use the image as the bounding box of the tikzpicture for centering
        \useasboundingbox (image.south east) rectangle (image.north west);

        % Create scope with normalized axes
        \begin{scope}[
            x={($0.05*(image.south east)$)},
            y={($0.05*(image.north west)$)}
        ]
            % Draw grid
            %\draw[lightgray,step=1] (image.south west) grid (image.north east);

            % Draw axes labels
            %\foreach \x in {0,1,...,20} {\node [below] at (\x,0) {\tiny \x};}
            %\foreach \y in {0,1,...,20} {\node [left]  at (0,\y) {\tiny \y};}

            % Nodes
            \node[annotation, left]  (output_on)       at (-1.5, 16.2) {Output (on)\\(will send an\\input to it)};
            \node[annotation, right] (output_off)      at (21.5, 16.2) {Output (off)\\(won't send an\\input to it)};
            \node[annotation, left]  (altitude)        at (-1.5, 2.5)  {Altitude};
            \node[annotation, below] (output_value)    at (4.25, -1.5)  {Output value};
            \node[annotation, below] (reference_frame) at (12.75, -1.5) {Frame of reference};
            \node[annotation, right] (trigger)         at (21.5, -2.5) {Trigger below (on/off),\\currently off\\(normal trigger)};

            % Arrows
            \draw[arrow] (output_on.east)            -- (7.75, 16.2);
            \draw[arrow] (output_off.west)           -- (14.75, 16.2);
            \draw[arrow] (altitude.east)             -- (0.15, 2.5);
            \draw[arrow] (output_value.north)    to[*|] (5.9, 0.6);
            \draw[arrow] (reference_frame.north) to[*|] (10.6, 1.55);
            \draw[arrow] (trigger.west)              -- (16.2, 1.7);
        \end{scope}
    \end{tikzpicture}
    \vspace{1cm}
    \caption{Altitude Sensor settings}
    \label{fig:SensorAltitude}
\end{figure}

### Speed Sensor

Speed sensors measure the speed of the block in a given direction indicated by the arrow on the block. They have a display which shows the currently measured speed as a bar indicator, which is full when the speed is higher than or equal to the trigger speed and empty when the speed is negative or $0$.

Its settings are shown in figure \ref{fig:SensorSpeed} and are as follows:

- Speed: speed threshold to trigger, in km/h or mph depending on the speed unit settings
- Output value: value of the output signal created by the block, discussed in \nameref{signals}
- Trigger
  - Normal: sends an output when the speed is above the configured value
  - Below: sends an output when the speed is below the configured value
- Outputs

\begin{figure}[H]
    \centering
    \begin{tikzpicture}
        % Image in a node
        \node[anchor=south west, inner sep=0] (image) at (0,0) {\includegraphics[width=20em]{speed_sensor}};
        % Use the image as the bounding box of the tikzpicture for centering
        \useasboundingbox (image.south east) rectangle (image.north west);

        % Create scope with normalized axes
        \begin{scope}[
            x={($0.05*(image.south east)$)},
            y={($0.05*(image.north west)$)}
        ]
            % Draw grid
            %\draw[lightgray,step=1] (image.south west) grid (image.north east);

            % Draw axes labels
            %\foreach \x in {0,1,...,20} {\node [below] at (\x,0) {\tiny \x};}
            %\foreach \y in {0,1,...,20} {\node [left]  at (0,\y) {\tiny \y};}

            % Nodes
            \node[annotation, left]  (output_on)    at (-1.5, 15.4) {Output (on)\\(will send an\\input to it)};
            \node[annotation, right] (output_off)   at (21.5, 15.3) {Output (off)\\(won't send an\\input to it)};
            \node[annotation, left]  (speed)        at (-1.5, 2.1)  {Speed};
            \node[annotation, below] (output_value) at (7.7, -1.5)  {Output value};
            \node[annotation, right] (trigger)      at (21.5, 0)    {Trigger below (on/off),\\currently off\\(normal trigger)};

            % Arrows
            \draw[arrow] (output_on.east)     -- (5.25, 15.4);
            \draw[arrow] (output_off.west)    -- (11.65, 15.3);
            \draw[arrow] (speed.east)         -- (0.2, 2.1);
            \draw[arrow] (output_value.north) -- (7.7, 0.45);
            \draw[arrow] (trigger.west)       -- (12.7, 3.4);
        \end{scope}
    \end{tikzpicture}
    \vspace{1cm}
    \caption{Speed Sensor settings}
    \label{fig:SensorSpeed}
\end{figure}

### Gravity Sensor

Gravity sensors measure the gravity strength at the position of the block.

Its settings are shown in figure \ref{fig:SensorGravity} and are as follows:

- Threshold: gravity strength threshold to trigger, relative to the normal gravity ($14 \frac{\text{m}}{\text{s}^2}$)
- Output value: value of the output signal created by the block, discussed in \nameref{signals}
- Trigger
  - Normal: sends an output when the gravity strength is above the configured value
  - Below: sends an output when the gravity strength is below the configured value
- Outputs

<!-- TODO: update figure after the functionality/textures are finalized -->
\begin{figure}[H]
    \centering
    \begin{tikzpicture}
        % Image in a node
        \node[anchor=south west, inner sep=0] (image) at (0,0) {\includegraphics[width=20em]{speed_sensor}};
        % Use the image as the bounding box of the tikzpicture for centering
        \useasboundingbox (image.south east) rectangle (image.north west);

        % Create scope with normalized axes
        \begin{scope}[
            x={($0.05*(image.south east)$)},
            y={($0.05*(image.north west)$)}
        ]
            % Draw grid
            %\draw[lightgray,step=1] (image.south west) grid (image.north east);

            % Draw axes labels
            %\foreach \x in {0,1,...,20} {\node [below] at (\x,0) {\tiny \x};}
            %\foreach \y in {0,1,...,20} {\node [left]  at (0,\y) {\tiny \y};}

            % Nodes
            \node[annotation, left]  (output_on)    at (-1.5, 15.4) {Output (on)\\(will send an\\input to it)};
            \node[annotation, right] (output_off)   at (21.5, 15.3) {Output (off)\\(won't send an\\input to it)};
            \node[annotation, left]  (speed)        at (-1.5, 2.1)  {Speed};
            \node[annotation, below] (output_value) at (7.7, -1.5)  {Output value};
            \node[annotation, right] (trigger)      at (21.5, 0)    {Trigger below (on/off),\\currently off\\(normal trigger)};

            % Arrows
            \draw[arrow] (output_on.east)     -- (5.25, 15.4);
            \draw[arrow] (output_off.west)    -- (11.65, 15.3);
            \draw[arrow] (speed.east)         -- (0.2, 2.1);
            \draw[arrow] (output_value.north) -- (7.7, 0.45);
            \draw[arrow] (trigger.west)       -- (12.7, 3.4);
        \end{scope}
    \end{tikzpicture}
    \vspace{1cm}
    \caption{Gravity Sensor settings}
    \label{fig:SensorGravity}
\end{figure}

### Angle Sensor

Angle sensors measure the angle of the block relative to the direction of highest slope of the plane defined by the square faces of the block. They have a display which shows the currently measured angle, with a blue section representing the activation threshold and an output arrow representing the angle. The arrow will always try to point up no matter the orientation of the block (will point in the direction of highest slope of the plane it is in).

Its settings are shown in figure \ref{fig:SensorAngle} and are as follows:

- Direction: position of the middle point of the activation threshold, in degrees
- Width: size of the activation threshold, in degrees
- Output value: value of the output signal created by the block, discussed in \nameref{signals}
- Trigger
  - Normal: sends an output when the angle is inside of the activation threshold
  - Outside: sends an output when the angle is outside the activation threshold
- Outputs

\begin{figure}[H]
    \centering
    \begin{tikzpicture}
        % Image in a node
        \node[anchor=south west, inner sep=0] (image) at (0,0) {\includegraphics[width=20em]{angle_sensor}};
        % Use the image as the bounding box of the tikzpicture for centering
        \useasboundingbox (image.south east) rectangle (image.north west);

        % Create scope with normalized axes
        \begin{scope}[
            x={($0.05*(image.south east)$)},
            y={($0.05*(image.north west)$)}
        ]
            % Draw grid
            %\draw[lightgray,step=1] (image.south west) grid (image.north east);

            % Draw axes labels
            %\foreach \x in {0,1,...,20} {\node [below] at (\x,0) {\tiny \x};}
            %\foreach \y in {0,1,...,20} {\node [left]  at (0,\y) {\tiny \y};}

            % Nodes
            \node[annotation, left]  (output_on)    at (-1.5, 17.2) {Output (on)\\(will send an\\input to it)};
            \node[annotation, right] (output_off)   at (21.5, 17)   {Output (off)\\(won't send an\\input to it)};
            \node[annotation, left]  (direction)    at (-1.5, 2)    {Direction};
            \node[annotation, below] (width)        at (6.7, -1.5)  {Width};
            \node[annotation, below] (output_value) at (12.5, -1.5) {Output value};
            \node[annotation, right] (trigger)      at (21.5, 3.5)  {Trigger outside (on/off),\\currently off\\(normal trigger)};

            % Arrows
            \draw[arrow] (output_on.east)         -- (7.2, 17.2);
            \draw[arrow] (output_off.west)        -- (13.45, 17);
            \draw[arrow] (direction.east)         -- (0.2, 2);
            \draw[arrow] (width.north)            -- (6.7, 0.7);
            \draw[arrow] (output_value.north) to[*|] (11, 0.7);
            \draw[arrow] (trigger.west)           -- (15.4, 2.25);
        \end{scope}
    \end{tikzpicture}
    \vspace{1cm}
    \caption{Angle Sensor settings}
    \label{fig:SensorAngle}
\end{figure}

### Compass

Compasses measure the angle of the block relative to the closest direction to the north in the plane defined by the square faces of the block. They have a display which shows the currently measured angle, with a red section representing the activation threshold, and an output arrow and cardinal direction letters representing the angle. The arrow will always try to point north no matter the orientation of the block (will point in the direction closest to the north of the plane it is in).

Its settings are shown in figure \ref{fig:SensorCompass} and are as follows:

- Direction: position of the middle point of the activation threshold, in degrees
- Width: size of the activation threshold, in degrees
- Output value: value of the output signal created by the block, discussed in \nameref{signals}
- Trigger
  - Normal: sends an output when the angle is inside of the activation threshold
  - Outside: sends an output when the angle is outside the activation threshold
- Outputs

\begin{figure}[H]
    \centering
    \begin{tikzpicture}
        % Image in a node
        \node[anchor=south west, inner sep=0] (image) at (0,0) {\includegraphics[width=20em]{compass}};
        % Use the image as the bounding box of the tikzpicture for centering
        \useasboundingbox (image.south east) rectangle (image.north west);

        % Create scope with normalized axes
        \begin{scope}[
            x={($0.05*(image.south east)$)},
            y={($0.05*(image.north west)$)}
        ]
            % Draw grid
            %\draw[lightgray,step=1] (image.south west) grid (image.north east);

            % Draw axes labels
            %\foreach \x in {0,1,...,20} {\node [below] at (\x,0) {\tiny \x};}
            %\foreach \y in {0,1,...,20} {\node [left]  at (0,\y) {\tiny \y};}

            % Nodes
            \node[annotation, left]  (output_on)    at (-1.5, 17)   {Output (on)\\(will send an\\input to it)};
            \node[annotation, right] (output_off)   at (21.5, 17)   {Output (off)\\(won't send an\\input to it)};
            \node[annotation, left]  (direction)    at (-1.5, 2.7)  {Direction};
            \node[annotation, below] (width)        at (6.4, -1.5)  {Width};
            \node[annotation, below] (output_value) at (12.4, -1.5) {Output value};
            \node[annotation, right] (trigger)      at (21.5, 4)    {Trigger outside (on/off),\\currently off\\(normal trigger)};

            % Arrows
            \draw[arrow] (output_on.east)         -- (9.55, 17);
            \draw[arrow] (output_off.west)        -- (15.9, 17);
            \draw[arrow] (direction.east)         -- (0.15, 2.7);
            \draw[arrow] (width.north)            -- (6.4, 1.1);
            \draw[arrow] (output_value.north) to[*|] (10.6, 1.1);
            \draw[arrow] (trigger.west)           -- (14.6, 3.3);
        \end{scope}
    \end{tikzpicture}
    \vspace{1cm}
    \caption{Compass settings}
    \label{fig:SensorCompass}
\end{figure}

## Logic gates

Logic gates are a group of blocks that take a set of boolean inputs, and create a boolean output based on their values. The conditions used are as follows, inputs will be discussed on \nameref{signals}:

- AND gate: all inputs are on
- OR gate: at least one input is on
- XOR gate: only one input is on
- NOR gate: all inputs are off

Their settings are shown in figure \ref{fig:LogicGate} and are as follows:

- Keybinds: see \nameref{keybinds}
- Toggle: see \nameref{toggle}
- Timers: see \nameref{timers}
- Output value: multiplier of output signal created by the block, explained in \nameref{output-value-calculation}
- Outputs

\begin{figure}[H]
    \centering
    \begin{tikzpicture}
        % Image in a node
        \node[anchor=south west, inner sep=0] (image) at (0,0) {\includegraphics[width=26em]{logic_gate}};
        % Use the image as the bounding box of the tikzpicture for centering
        \useasboundingbox (image.south east) rectangle (image.north west);

        % Create scope with normalized axes
        \begin{scope}[
            x={($0.05*(image.south east)$)},
            y={($0.05*(image.north west)$)}
        ]
            % Draw grid
            %\draw[lightgray,step=1] (image.south west) grid (image.north east);

            % Draw axes labels
            %\foreach \x in {0,1,...,20} {\node [below] at (\x,0) {\tiny \x};}
            %\foreach \y in {0,1,...,20} {\node [left]  at (0,\y) {\tiny \y};}

            % Nodes
            \node[annotation, left]  (output_on)     at (-1.5, 16.4) {Output (on)\\(will send an\\input to it)};
            \node[annotation, right] (output_off)    at (21.5, 16.4) {Output (off)\\(won't send an\\input to it)};
            \node[annotation, left]  (green_keybind) at (-1.5, 4.5)  {Green keybind};
            \node[annotation, below] (red_keybind)   at (7.4, -1.5)  {Red keybind};
            \node[annotation, below] (toggle)        at (1, -1.5)    {Green/red toggle};
            \node[annotation, below] (pause)         at (11.7, -1.5) {Pause};
            \node[annotation, below] (duration)      at (15, -1.5)   {Duration};
            \node[annotation, right] (delay)         at (21.5, 10)   {Delay};
            \node[annotation, right] (output_value)  at (21.5, 3.1)  {Output value};

            % Arrows
            \draw[arrow] (output_on.east)                   -- (8.8, 16.4);
            \draw[arrow] (output_off.west)                  -- (13.35, 16.4);
            \draw[arrow] (green_keybind.east)               -- (0.1, 4.5);
            \draw[arrow] ($(red_keybind.north) + (1.2, 0)$) -- (8.6, 3.5);
            \draw[arrow] (toggle.north)                     -- (0.5, 1.7);
            \draw[arrow] (toggle.north)                     -- (4.9, 2.1);
            \draw[arrow] ($(pause.north) + (0.8, 0)$)       -- (12.5, 0.3);
            \draw[arrow] (duration.north)                   -- (13.5, 2.4);
            \draw[arrow] (delay.west)                       -- (13.5, 5.5);
            \draw[arrow] (output_value.west)                -- (16.4, 3.1);
        \end{scope}
    \end{tikzpicture}
    \vspace{1cm}
    \caption{Logic Gate settings}
    \label{fig:LogicGate}
\end{figure}

### Output value calculation

These are the steps used by the game to determine the value attached to the output signal created by logic gates. For more information about signals, see \nameref{signals}

1) The gate checks if its conditions are met. If they aren't, the gate doesn't create an output
2) The gate adds up the values of all of its inputs and clamps the result to the $[-1, 1]$ range
   - Values smaller than $-1$ are replaced with $-1$, and values bigger than $1$ with $1$
3) The gate multiplies the result by its output value setting. For NOR gates, their setting replaces the result (which would otherwise always be $0$)
4) The gate sends the result as its output value

This process can be described with the following formula:
$$\text{output} = \text{output\_value} \cdot \operatorname{boolean\_operation}(\text{inputs}) \cdot \sum{\text{inputs}}$$

\begin{figure}[H]
    \centering
    \includegraphics[width=\linewidth]{output_value_diagram}
    \caption{Output value calculation diagram made by Zoomah}
    \label{fig:OutputValueDiagram}
\end{figure}

#### Example

An AND gate with an output value of $0.5$ has 2 inputs, one of them has an output value of $0.8$ and the other of $0.5$. When at least one of them is off, it doesn't send an output. When both of them are on at the same time, the AND gate is able to send an output. On that case, the output values of the inputs are first added up: $0.8 + 0.5 = 1.3$. Because the sum, $1.3$, is bigger than $1$, the gate replaces it with $1$. Then that value is multiplied by the output value of the gate: $1 \cdot 0.5 = 0.5$. Finally, the AND gate sends an output with the value of that multiplication, $0.5$. On the steam version, if the sum of the inputs or the output value of the gate had been $0$, the resultant value of the multiplication would have also been $0$, in which case the gate wouldn't have sent an output

## Math blocks

Math blocks are a group of blocks that take a set of numeric inputs and perform some operation to get an output based on their values, either numeric or boolean.

### Comparison Logic Gate

Comparison logic gates calculate the boolean value of a predefined comparison and return it as their output, where the left hand side is the sum of all their inputs and the right hand side is a constant.

Their settings are shown in figure \ref{fig:Comparator} and are as follows:

- Keybinds: see \nameref{keybinds}
- Toggle: see \nameref{toggle}
- Timers: see \nameref{timers}
- Threshold: value used for the right hand side of the comparison
- Output value: value of the output signal created by the block, discussed in \nameref{signals}
- Comparison mode: comparison operation to perform, possible values are "less than", "less than or equal", "greater than", "greater than or equal", "equal", and "not equal"
- Clamp input: whether the result of the sum of the inputs should be clamped to the $[-1, 1]$ range or not
- Outputs

<!-- TODO: update figure after the functionality/textures are finalized -->
\begin{figure}[H]
    \centering
    \begin{tikzpicture}
        % Image in a node
        \node[anchor=south west, inner sep=0] (image) at (0,0) {\includegraphics[width=26em]{logic_gate}};
        % Use the image as the bounding box of the tikzpicture for centering
        \useasboundingbox (image.south east) rectangle (image.north west);

        % Create scope with normalized axes
        \begin{scope}[
            x={($0.05*(image.south east)$)},
            y={($0.05*(image.north west)$)}
        ]
            % Draw grid
            %\draw[lightgray,step=1] (image.south west) grid (image.north east);

            % Draw axes labels
            %\foreach \x in {0,1,...,20} {\node [below] at (\x,0) {\tiny \x};}
            %\foreach \y in {0,1,...,20} {\node [left]  at (0,\y) {\tiny \y};}

            % Nodes
            \node[annotation, left]  (output_on)     at (-1.5, 16.4) {Output (on)\\(will send an\\input to it)};
            \node[annotation, right] (output_off)    at (21.5, 16.4) {Output (off)\\(won't send an\\input to it)};
            \node[annotation, left]  (green_keybind) at (-1.5, 4.5)  {Green keybind};
            \node[annotation, below] (red_keybind)   at (7.4, -1.5)  {Red keybind};
            \node[annotation, below] (toggle)        at (1, -1.5)    {Green/red toggle};
            \node[annotation, below] (pause)         at (11.7, -1.5) {Pause};
            \node[annotation, below] (duration)      at (15, -1.5)   {Duration};
            \node[annotation, right] (delay)         at (21.5, 10)   {Delay};
            \node[annotation, right] (output_value)  at (21.5, 3.1)  {Output value};

            % Arrows
            \draw[arrow] (output_on.east)                   -- (8.8, 16.4);
            \draw[arrow] (output_off.west)                  -- (13.35, 16.4);
            \draw[arrow] (green_keybind.east)               -- (0.1, 4.5);
            \draw[arrow] ($(red_keybind.north) + (1.2, 0)$) -- (8.6, 3.5);
            \draw[arrow] (toggle.north)                     -- (0.5, 1.7);
            \draw[arrow] (toggle.north)                     -- (4.9, 2.1);
            \draw[arrow] ($(pause.north) + (0.8, 0)$)       -- (12.5, 0.3);
            \draw[arrow] (duration.north)                   -- (13.5, 2.4);
            \draw[arrow] (delay.west)                       -- (13.5, 5.5);
            \draw[arrow] (output_value.west)                -- (16.4, 3.1);
        \end{scope}
    \end{tikzpicture}
    \vspace{1cm}
    \caption{Comparator Logic Gate settings}
    \label{fig:Comparator}
\end{figure}

### Accumulator

Accumulators store and output a numeric value, and allow to increment/decrement it.

Their settings are shown in figure \ref{fig:Accumulator} and are as follows:

- Keybinds: see \nameref{keybinds}
- Toggle: see \nameref{toggle}
- Timers: see \nameref{timers}
- Value bounds: minimum/maximum value that can be stored, the stored value will be clamped to the range defined by these bounds
- Scale: rate of change of the stored value, used to scale the value of the input
- Use steps: whether to change the stored value continuously (in which case the scale is change per second, achieved by using $1/60$th the scale on each frame) or only once per input activation (on the rising edge of the signal)
- Comparison mode: comparison operation to perform, possible values are "less than", "less than or equal", "greater than", "greater than or equal", "equal", and "not equal"
- Clamp input: whether the result of the sum of the inputs should be clamped to the $[-1, 1]$ range or not
- Outputs

<!-- TODO: update figure after the functionality/textures are finalized -->
\begin{figure}[H]
    \centering
    \begin{tikzpicture}
        % Image in a node
        \node[anchor=south west, inner sep=0] (image) at (0,0) {\includegraphics[width=26em]{logic_gate}};
        % Use the image as the bounding box of the tikzpicture for centering
        \useasboundingbox (image.south east) rectangle (image.north west);

        % Create scope with normalized axes
        \begin{scope}[
            x={($0.05*(image.south east)$)},
            y={($0.05*(image.north west)$)}
        ]
            % Draw grid
            %\draw[lightgray,step=1] (image.south west) grid (image.north east);

            % Draw axes labels
            %\foreach \x in {0,1,...,20} {\node [below] at (\x,0) {\tiny \x};}
            %\foreach \y in {0,1,...,20} {\node [left]  at (0,\y) {\tiny \y};}

            % Nodes
            \node[annotation, left]  (output_on)     at (-1.5, 16.4) {Output (on)\\(will send an\\input to it)};
            \node[annotation, right] (output_off)    at (21.5, 16.4) {Output (off)\\(won't send an\\input to it)};
            \node[annotation, left]  (green_keybind) at (-1.5, 4.5)  {Green keybind};
            \node[annotation, below] (red_keybind)   at (7.4, -1.5)  {Red keybind};
            \node[annotation, below] (toggle)        at (1, -1.5)    {Green/red toggle};
            \node[annotation, below] (pause)         at (11.7, -1.5) {Pause};
            \node[annotation, below] (duration)      at (15, -1.5)   {Duration};
            \node[annotation, right] (delay)         at (21.5, 10)   {Delay};
            \node[annotation, right] (output_value)  at (21.5, 3.1)  {Output value};

            % Arrows
            \draw[arrow] (output_on.east)                   -- (8.8, 16.4);
            \draw[arrow] (output_off.west)                  -- (13.35, 16.4);
            \draw[arrow] (green_keybind.east)               -- (0.1, 4.5);
            \draw[arrow] ($(red_keybind.north) + (1.2, 0)$) -- (8.6, 3.5);
            \draw[arrow] (toggle.north)                     -- (0.5, 1.7);
            \draw[arrow] (toggle.north)                     -- (4.9, 2.1);
            \draw[arrow] ($(pause.north) + (0.8, 0)$)       -- (12.5, 0.3);
            \draw[arrow] (duration.north)                   -- (13.5, 2.4);
            \draw[arrow] (delay.west)                       -- (13.5, 5.5);
            \draw[arrow] (output_value.west)                -- (16.4, 3.1);
        \end{scope}
    \end{tikzpicture}
    \vspace{1cm}
    \caption{Accumulator settings}
    \label{fig:Accumulator}
\end{figure}

### Number Display

Number displays show and output the sum of their inputs with an optional rounding, similar to how OR logic gates work.

Their settings are shown in figure \ref{fig:NumberDisplay} and are as follows:

- Keybinds: see \nameref{keybinds}
- Toggle: see \nameref{toggle}
- Timers: see \nameref{timers}
- Output rounding: rounding mode applied to the sum of the inputs, always done to an integer. Possible values are "disabled", "nearest", "floor" (closest smaller number), and "ceil" (closest bigger number)
- Outputs

<!-- TODO: update figure after the functionality/textures are finalized -->
\begin{figure}[H]
    \centering
    \begin{tikzpicture}
        % Image in a node
        \node[anchor=south west, inner sep=0] (image) at (0,0) {\includegraphics[width=26em]{logic_gate}};
        % Use the image as the bounding box of the tikzpicture for centering
        \useasboundingbox (image.south east) rectangle (image.north west);

        % Create scope with normalized axes
        \begin{scope}[
            x={($0.05*(image.south east)$)},
            y={($0.05*(image.north west)$)}
        ]
            % Draw grid
            %\draw[lightgray,step=1] (image.south west) grid (image.north east);

            % Draw axes labels
            %\foreach \x in {0,1,...,20} {\node [below] at (\x,0) {\tiny \x};}
            %\foreach \y in {0,1,...,20} {\node [left]  at (0,\y) {\tiny \y};}

            % Nodes
            \node[annotation, left]  (output_on)     at (-1.5, 16.4) {Output (on)\\(will send an\\input to it)};
            \node[annotation, right] (output_off)    at (21.5, 16.4) {Output (off)\\(won't send an\\input to it)};
            \node[annotation, left]  (green_keybind) at (-1.5, 4.5)  {Green keybind};
            \node[annotation, below] (red_keybind)   at (7.4, -1.5)  {Red keybind};
            \node[annotation, below] (toggle)        at (1, -1.5)    {Green/red toggle};
            \node[annotation, below] (pause)         at (11.7, -1.5) {Pause};
            \node[annotation, below] (duration)      at (15, -1.5)   {Duration};
            \node[annotation, right] (delay)         at (21.5, 10)   {Delay};
            \node[annotation, right] (output_value)  at (21.5, 3.1)  {Output value};

            % Arrows
            \draw[arrow] (output_on.east)                   -- (8.8, 16.4);
            \draw[arrow] (output_off.west)                  -- (13.35, 16.4);
            \draw[arrow] (green_keybind.east)               -- (0.1, 4.5);
            \draw[arrow] ($(red_keybind.north) + (1.2, 0)$) -- (8.6, 3.5);
            \draw[arrow] (toggle.north)                     -- (0.5, 1.7);
            \draw[arrow] (toggle.north)                     -- (4.9, 2.1);
            \draw[arrow] ($(pause.north) + (0.8, 0)$)       -- (12.5, 0.3);
            \draw[arrow] (duration.north)                   -- (13.5, 2.4);
            \draw[arrow] (delay.west)                       -- (13.5, 5.5);
            \draw[arrow] (output_value.west)                -- (16.4, 3.1);
        \end{scope}
    \end{tikzpicture}
    \vspace{1cm}
    \caption{Number Display settings}
    \label{fig:NumberDisplay}
\end{figure}

### Arithmetics Logic Block

Arithmetics logic blocks perform an arithmetic binary operation with a constant and the sum of their inputs, and output the result. The constant is the first operand while the sum of the inputs is the second one.

Their settings are shown in figure \ref{fig:ArithmeticsBlock} and are as follows:

- Keybinds: see \nameref{keybinds}
- Toggle: see \nameref{toggle}
- Timers: see \nameref{timers}
- Constant: constant value to use as the first operand
- Operation: binary operation to perform. Possible values are addition, subtraction, multiplication, and division
- Outputs

<!-- TODO: update figure after the functionality/textures are finalized -->
\begin{figure}[H]
    \centering
    \begin{tikzpicture}
        % Image in a node
        \node[anchor=south west, inner sep=0] (image) at (0,0) {\includegraphics[width=26em]{logic_gate}};
        % Use the image as the bounding box of the tikzpicture for centering
        \useasboundingbox (image.south east) rectangle (image.north west);

        % Create scope with normalized axes
        \begin{scope}[
            x={($0.05*(image.south east)$)},
            y={($0.05*(image.north west)$)}
        ]
            % Draw grid
            %\draw[lightgray,step=1] (image.south west) grid (image.north east);

            % Draw axes labels
            %\foreach \x in {0,1,...,20} {\node [below] at (\x,0) {\tiny \x};}
            %\foreach \y in {0,1,...,20} {\node [left]  at (0,\y) {\tiny \y};}

            % Nodes
            \node[annotation, left]  (output_on)     at (-1.5, 16.4) {Output (on)\\(will send an\\input to it)};
            \node[annotation, right] (output_off)    at (21.5, 16.4) {Output (off)\\(won't send an\\input to it)};
            \node[annotation, left]  (green_keybind) at (-1.5, 4.5)  {Green keybind};
            \node[annotation, below] (red_keybind)   at (7.4, -1.5)  {Red keybind};
            \node[annotation, below] (toggle)        at (1, -1.5)    {Green/red toggle};
            \node[annotation, below] (pause)         at (11.7, -1.5) {Pause};
            \node[annotation, below] (duration)      at (15, -1.5)   {Duration};
            \node[annotation, right] (delay)         at (21.5, 10)   {Delay};
            \node[annotation, right] (output_value)  at (21.5, 3.1)  {Output value};

            % Arrows
            \draw[arrow] (output_on.east)                   -- (8.8, 16.4);
            \draw[arrow] (output_off.west)                  -- (13.35, 16.4);
            \draw[arrow] (green_keybind.east)               -- (0.1, 4.5);
            \draw[arrow] ($(red_keybind.north) + (1.2, 0)$) -- (8.6, 3.5);
            \draw[arrow] (toggle.north)                     -- (0.5, 1.7);
            \draw[arrow] (toggle.north)                     -- (4.9, 2.1);
            \draw[arrow] ($(pause.north) + (0.8, 0)$)       -- (12.5, 0.3);
            \draw[arrow] (duration.north)                   -- (13.5, 2.4);
            \draw[arrow] (delay.west)                       -- (13.5, 5.5);
            \draw[arrow] (output_value.west)                -- (16.4, 3.1);
        \end{scope}
    \end{tikzpicture}
    \vspace{1cm}
    \caption{Arithmetics Logic Block settings}
    \label{fig:ArithmeticsBlock}
\end{figure}

# Common block settings

These are settings shared by all blocks in the game that can be activated with inputs

## Keybinds

Keybinds are the most common input to activate a block, and all blocks that can be activated have either a single keybind (green) or two keybinds (green and red).

- All keybinds on a single block act as a single input for each seat
  - An and gate with a green and a red keybind configured will send an output when just pressing one of the 2 keybinds, but will require someone in each seat that has control over it pressing the keybind to send an output
  - If no keybinds are configured, the input isn't taken into account. This only makes a difference in AND gates, which would otherwise be impossible to trigger without keybinds
- The green keybind has a positive value while the red keybind has a negative one. For more information about input values, see \nameref{signals}
  - For input methods that don't support analog inputs (keyboards and normal buttons on controllers), the value is always $1$
  - For input methods that support analog inputs (controller joysticks and triggers), the value is the one given by the input method normalized to the range $[0, 1]$

## Toggle

Toggle allows to make inputs alternate the activation state of a block between on and off without requiring a continuous input signal to remain active.

- There is a toggle setting associated with positive inputs (below the green keybind) and another with negative ones (below the red keybind)
- Toggles **inputs**
  - When the sum of the inputs goes from $0$ to a different value, multiple things happen depending on the new value:
    1) If the opposite sign of the input is toggled on, it is toggled off instantly
    2) If the sign of the input has toggle enabled, it is toggled: if it was off it turns on, and if it was on it turns off (which will happen on the falling edge of the input). Otherwise, the gate is enabled normally
  - To toggle the output instead of the inputs, make the signal go through another gate with the toggle

## Timers

Timers are a group of settings that allow to automate the activation/deactivation of a block after a set amount of time.

- The timers start as soon as the block receives a **single input**. For logic gates, this still applies even if the gate doesn't meet the conditions to send an output
- The number will be rounded to have only 2 decimal places when shown on the menu, but the number which will be used is the one written rounded to 8 decimal places. Due to a bug, only up to 5 characters can be written, so depending on the exact value the number of decimals which can be used will vary
- All values are specified in seconds
- Delay: amount of time between the block receives an input and the block activates
  - Note: each logic gate has an extra delay of $1/60 s$ due to the state of all the logic gates being updated once per physics' frame at the same time
- Duration (previously active time): amount of time before the block automatically deactivates after it has been activated
  - A value of $0$ indicates that it will never deactivate automatically
  - Shortest pulse length is $1$ frame ($1/60 s$), values smaller than this won't activate the block
- Pause (previously inactive time): amount of time before the block reactivates and the duration timer is restarted, after the duration timer expires
  - A value of $0$ indicates that the block will never reactivate automatically
  - It's ignored if the duration timer is $0$
- The order of the timers is as follows: delay $\rightarrow$ duration $\rightarrow$ pause $\rightarrow$ back to duration (if pause is $0$ it ends after the duration ends)
- In the case of the delay and duration timers, even though their values are expressed in seconds, the game handles them as a number of frames, which can be calculated with $\text{seconds} \cdot 60$
  - If this number is not an integer, it will be rounded down to the nearest integer
  - If this number is an integer, it will randomly either be kept as it is or be subtracted one frame depending on the exact value used, so it's recommended to add $0.01$ to the original number to make sure it always stays in the correct number of frames
  - Pause timers aren't subject to this, and the exact time in seconds is used for them

# Signals

Signals are the method used to communicate different logic blocks between eachother and other blocks. All block inputs, both from logic blocks and keybinds, are represented with signals.

- Input/output value: value in the range $[-1, 1]$ attached to each signal.
  - They are represented in scientific notation as $\pm a \cdot 10^b$ where $a$ can be any number such that $0 \leq a \leq 10$ with up to 7 decimals while $b$ can be any integer such that $-81 \leq b \leq -1$. If $a$ has more than 7 decimals, it will be rounded to 7 decimals.
- Truthness value: value that determines if a signal is on or off
  - On the steam version, a signal is on if its associated value is not $0$
  - On other versions, the truthness depends whether the source that created it is triggered or not

When a block receives a set of inputs, it determines how it is activated based on the value of their sum. Blocks with a single configurable keybind additionally use the absolute value before interpreting the resulting value, which makes both signs equivalent. The resulting value represents the percentage of power that whatever it activates will use, applied to the value set in its settings as a multiplier (if applicable). Values modified for each block are in table \ref{table:InputValueBlocks}. Some important notes:

- For hinges/wings the rotation speed depends on the max angle set in their settings and not on the angle achieved with the output value, resulting in faster speeds with fractional input values for the same final angle
- Due to a bug, fractional inputs in hinges/wings result in angles way lower than they should be. See appendix \nameref{InputValueMultiplier} for more information
- For the gyro stabilizer, it only works with disabled by default, and negative values make it stabilize in the opposite direction
\begin{table}[H]
    \centering
    \begin{tabular}{p{6cm}p{3cm}}
        \toprule
        Block & Value modified \\
        \midrule
        Engines & Max speed and acceleration (torque) \\
        Thrusters, gimbals, propellers, boat engines, and quantum rudder & Power (thrust) \\
        Rotating servos, hinges, and wings with control surfaces (without hold position) & Angle \\
        Spinning servos, helicopter engines, pistons, gyros, and gyro stabilizers & Speed \\
        Tone generators & Volume \\
        Logic gates & Output value \\
        Other & None \\
        \bottomrule
    \end{tabular}
    \caption{Value modified by the output value for each block}
    \label{table:InputValueBlocks}
\end{table}

# Useful Circuits

This section contains commonly used logic circuits and how to make them, to aid in the design and understanding of more complex logic circuits.

## NOR/NOT Gate

- Inverts the state of the input
- Made by connecting an always on input (a sensor that is always on, all sensors can be configured to work like this but the most commonly used one is a distance sensor with 0 range and invert trigger) to a XOR gate
- If it only has a single input that isn't the always on input it will act as a NOT gate, if it has multiple it will act as a NOR gate
- You can make a NAND/XNOR gate by making an AND/XOR gate output to a NOT gate and taking the output from the NOT gate

## Pulse generator/Rising edge detector

- Sends a pulse of a specific length (usually a single frame which is $1/60 s$) when the input goes from off to on
- Made by setting the duration to the length of the pulse on an OR gate

## Falling edge detector

- Sends a pulse of a specific length when the input goes from on to off
- Made by connecting a NOT gate to a pulse generator

## Latch (T-FlipFlop)

- Stores a single bit of information
- Made by activating toggle on an OR gate, requires the input to be a pulse to be easily controlled by other gates (use a pulse generator for this)

## Counter

- Can store the value of a variable with $n$ possible values
- Depending on how it's made, it can be 1 or 2 way and have cycle or not
  - 1-way: the value can only be increased
  - 2-way: the value can be both increased and decreased
  - Cycle: determines if trying to increase/decrease the value past its maximum/minimum will result in it cycling back to the smallest/biggest value or staying at the maximum/minimum value
  - Base designs are 1-way without cycle
- The complexity of a design is the amount of logic gates used by it without counting the ones used to create a startup pulse or always on sensors (those can be reused)
- There are 3 ways of doing it: general circuit (base $N$), decimal (base $10$) and binary (base $2$). Which one is least complex depends on the situation

### General Circuit (Base $N$)

- $n = \text{amount of cells}$
- The output is encoded as the position of the active gate in the row of output gates (with the one from the first cell being the minimum value and the one from the last cell being the maximum value)
\begin{figure}[H]
    \makebox[\textwidth][c]{
    \begin{tikzpicture}
        % Nodes

        % Cell 1
        \node[node]       (OR_1)                          {Toggled OR gate\\with 1 frame\\delay (output)};
        \node[node]       (AND_1)   [below = 5mm of OR_1] {AND gate};
        \coordinate[above=16pt of OR_1]   (cell_1);

        % Hidden cell 1
        \node[hiddenNode] (OR_h1)   [right = of OR_1]     {};
        \node[hiddenNode] (AND_h1)  [right = of AND_1]    {};

        % Cell k
        \node[node]       (OR_k)    [right = of OR_h1]    {Toggled OR gate\\with 1 frame\\delay (output)};
        \node[node]       (AND_k)   [right = of AND_h1]   {AND gate};
        \coordinate[above=16pt of OR_k]   (cell_k);

        % Cell k+1
        \node[node]       (OR_k+1)  [right = of OR_k]     {Toggled OR gate\\with 1 frame\\delay (output)};
        \node[node]       (AND_k+1) [right = of AND_k]    {AND gate};
        \coordinate[above=16pt of OR_k+1] (cell_k+1);

        % Hidden cell 2
        \node[hiddenNode] (OR_h2)   [right = of OR_k+1]   {};
        \node[hiddenNode] (AND_h2)  [right = of AND_k+1]  {};

        % Cell n
        \node[node]       (OR_n)    [right = of OR_h2]    {Toggled OR gate\\with 1 frame\\delay (output)};
        \node[hiddenNode] (AND_n)   [right = of AND_h2]   {};
        \coordinate[above=16pt of OR_n]   (cell_n);

        % Input gate
        \node[node] (input_pulse) at ($(AND_k)!0.5!(AND_k+1) + (0, -2.25)$) {1 frame pulse\\generator (input)};

        % Cell bounding boxes
        \begin{scope}[on background layer]
            \node[node,       fit=(OR_1)(AND_1)(cell_1),       label={[anchor=north, yshift=-2.5pt]Cell $1$}] {};
            \node[hiddenNode, fit=(OR_h1)(AND_h1)]             {$\cdots$};
            \node[node,       fit=(OR_k)(AND_k)(cell_k),       label={[anchor=north, yshift=-2.5pt]Cell $k$}] {};
            \node[node,       fit=(OR_k+1)(AND_k+1)(cell_k+1), label={[anchor=north, yshift=-2.5pt]Cell $k+1$}] {};
            \node[hiddenNode, fit=(OR_h2)(AND_h2)]             {$\cdots$};
            \node[node,       fit=(OR_n)(AND_n)(cell_n),       label={[anchor=north, yshift=-2.5pt]Cell $n$}] {};
        \end{scope}

        % Arrows

        % Cell 1
        \draw[arrow] (AND_1.east)                   -- ($(AND_1.east)!0.5!(AND_h1.west)$)   |- (OR_h1.west);
        \draw[arrow] ($(OR_1.south) + (-2mm, 0)$)   -- ($(AND_1.north) + (-2mm, 0)$);
        \draw[arrow] ($(AND_1.north) + (2mm, 0)$)   -- ($(OR_1.south) + (2mm, 0)$);

        % Hidden cell 1
        \draw[arrow] (AND_h1.east)                  -- ($(AND_h1.east)!0.5!(AND_k.west)$)   |- (OR_k.west);

        % Cell k
        \draw[arrow] (AND_k.east)                   -- ($(AND_k.east)!0.5!(AND_k+1.west)$)  |- (OR_k+1.west);
        \draw[arrow] ($(OR_k.south) + (-2mm, 0)$)   -- ($(AND_k.north) + (-2mm, 0)$);
        \draw[arrow] ($(AND_k.north) + (2mm, 0)$)   -- ($(OR_k.south) + (2mm, 0)$);

        % Cell k+1
        \draw[arrow] (AND_k+1.east)                 -- ($(AND_k+1.east)!0.5!(AND_h2.west)$) |- (OR_h2.west);
        \draw[arrow] ($(OR_k+1.south) + (-2mm, 0)$) -- ($(AND_k+1.north) + (-2mm, 0)$);
        \draw[arrow] ($(AND_k+1.north) + (2mm, 0)$) -- ($(OR_k+1.south) + (2mm, 0)$);

        % Hidden cell 2
        \draw[arrow] (AND_h2.east)                  -- ($(AND_h2.east)!0.5!(AND_n.west)$)   |- (OR_n.west);

        % Input gate
        \coordinate  (input) at ($(input_pulse.north) + (0, 0.5)$);
        \draw[line]  (input_pulse.north)            -- (input);
        \draw[arrow] (input)                        -| (AND_1.south);
        \draw[arrow] (input)                        -| (AND_h2.south);
        \draw[arrow] (input -| AND_h1)              -- (AND_h1.south);
        \draw[arrow] (input -| AND_k)               -- (AND_k.south);
        \draw[arrow] (input -| AND_k+1)             -- (AND_k+1.south);
    \end{tikzpicture}
    }
    \caption{Diagram of the general method counter}
    \label{fig:CounterGeneral}
\end{figure}
- To add cycle, add an AND gate to the last cell configured in the same way as the others and using the first cell as its next cell
- To make it 2-way, add a new AND gate to each cell configured in the same way as the other one but going in the opposite direction and using a different pulse generator as input
- Requires a startup pulse to one of the toggled OR gates to work (achieved with a 1 frame pulse generator)
- Complexity
  - 1-way: $2n$
  - 1-way+cycle: $2n + 1$
  - 2-way: $3n$
  - 2-way+cycle: $3n + 1$
- Takes 3 frames to update
- Example blueprints: [\underline{1-way}](https://steamcommunity.com/sharedfiles/filedetails/?id=2134486907), [\underline{1-way+cycle}](https://steamcommunity.com/sharedfiles/filedetails/?id=2134487841), [\underline{2-way}](https://steamcommunity.com/sharedfiles/filedetails/?id=2075055361) and [\underline{2-way+cycle}](https://steamcommunity.com/sharedfiles/filedetails/?id=2134489564)

### Decimal (Base $10$)

- $n = 10^\text{amount of cells}; \text{ amount of cells} = \ceil{\log_{10} n}$
- Each cell is the general circuit for $n=10$ with cycle and no input gate, except for the last cell which can have any value $2 \leq n \leq 10$ and doesn't need to have cycle
- The output is encoded as a decimal number with a digit stored in each cell (with the first cell being the least significant digit and the last cell being the most significant digit)
\begin{figure}[H]
    \makebox[\textwidth][c]{
    \begin{tikzpicture}
        % Nodes

        % Cell 1
        \node[node]       (ORs_1)                                        {All OR gates\\except the last};
        \node[node]       (OR_final_1)    [below = 1.5mm of ORs_1]       {Last OR gate};
        \node[node]       (ANDs_1)        [below = 1.5mm of OR_final_1]  {All AND gates};
        \coordinate[above=16pt of ORs_1]       (cell_1);

        % Hidden cell 1
        \node[hiddenNode] (ORs_h1)        [right = of ORs_1]             {};
        \node[hiddenNode] (OR_final_h1)   [right = of OR_final_1]        {};
        \node[hiddenNode] (ANDs_h1)       [right = of ANDs_1]            {};

        % Cell k
        \node[node]       (ORs_k)         [right = of ORs_h1]            {All OR gates\\except the last};
        \node[node]       (OR_final_k)    [right = of OR_final_h1]       {Last OR gate};
        \node[node]       (ANDs_k)        [right = of ANDs_h1]           {All AND gates};
        \coordinate[above=16pt of ORs_k]       (cell_k);

        % Cell k+1
        \node[node]       (ORs_k+1)       [right = of ORs_k]             {All OR gates\\except the last};
        \node[node]       (OR_final_k+1)  [right = of OR_final_k]        {Last OR gate};
        \node[node]       (ANDs_k+1)      [right = of ANDs_k]            {All AND gates};
        \coordinate[above=16pt of ORs_k+1]     (cell_k+1);

        % Hidden cell 2
        \node[hiddenNode] (ORs_h2)        [right = of ORs_k+1]           {};
        \node[hiddenNode] (OR_final_h2)   [right = of OR_final_k+1]      {};
        \node[hiddenNode] (ANDs_h2)       [right = of ANDs_k+1]          {};

        % Cell n
        \node[node]       (ORs_n)         [right = of ORs_h2]            {All OR gates\\except the last};
        \node[hiddenNode] (OR_final_n)    [right = of OR_final_h2]       {};
        \node[node]       (ANDs_n)        [right = of ANDs_h2]           {All AND gates};
        \coordinate[above=16pt of ORs_n]       (cell_n);

        % Input gate
        \node[node]       (input_pulse) at ($(ANDs_k) + (0.45, -3.25)$)  {1 frame pulse\\generator (input)};
        \node[node]       (input_OR)      [right = 1.5mm of input_pulse] {OR gate};
        \coordinate[above=16pt of input_pulse] (input_cell);

        % Cell bounding boxes
        \begin{scope}[on background layer]
            \node[node,       fit=(ORs_1)(ANDs_1)(OR_final_1)(cell_1),         label={[anchor=north, yshift=-2.5pt]Cell $1$}] {};
            \node[hiddenNode, fit=(ORs_h1)(ANDs_h1)(OR_final_h1)]              {$\cdots$};
            \node[node,       fit=(ORs_k)(ANDs_k)(OR_final_k)(cell_k),         label={[anchor=north, yshift=-2.5pt]Cell $k$}] {};
            \node[node,       fit=(ORs_k+1)(ANDs_k+1)(OR_final_k+1)(cell_k+1), label={[anchor=north, yshift=-2.5pt]Cell $k+1$}] {};
            \node[hiddenNode, fit=(ORs_h2)(ANDs_h2)(OR_final_h2)]              {$\cdots$};
            \node[node,       fit=(ORs_n)(ANDs_n)(OR_final_n)(cell_n),         label={[anchor=north, yshift=-2.5pt]Cell $\ceil{\log_{10} n}$}] {};
            \node[node,       fit=(input_pulse)(input_OR)(input_cell),         label={[anchor=north, yshift=-2.5pt]Input circuit}] {};
        \end{scope}

        % Arrows

        % Points between cells (top)
        \coordinate (1-h1)    at ($(ORs_1.east)!0.5!(ORs_h1.west)   + (0, 1.75)$);
        \coordinate (h1-k)    at ($(ORs_h1.east)!0.5!(ORs_k.west)   + (0, 1.75)$);
        \coordinate (k-k+1)   at ($(ORs_k.east)!0.5!(ORs_k+1.west)  + (0, 1.75)$);
        \coordinate (k+1-h2)  at ($(ORs_k+1.east)!0.5!(ORs_h2.west) + (0, 1.75)$);
        \coordinate (h2-n)    at ($(ORs_h2.east)!0.5!(ORs_n.west)   + (0, 1.75)$);
        \coordinate (n-)      at ($(ORs_n.east)                     + (0.5, 1.75)$);
        % Points between cells (bottom)
        \coordinate (1-h1-)   at ($(1-h1)                           - (0, 4.6)$);
        \coordinate (h1-k-)   at ($(h1-k)                           - (0, 4.6)$);
        \coordinate (k-k+1-)  at ($(k-k+1)                          - (0, 4.6)$);
        \coordinate (k+1-h2-) at ($(k+1-h2)                         - (0, 4.6)$);
        \coordinate (h2-n-)   at ($(h2-n)                           - (0, 4.6)$);

        % Cell 1
        \draw[line]  (ORs_1.east)         -- (ORs_1 -| 1-h1);
        \draw[arrow] (OR_final_1.east)    -- (OR_final_1 -| 1-h1)      |- (ANDs_h1.west);

        % Hidden cell 1
        \draw[line]  (ORs_h1.east)        -- (ORs_h1 -| h1-k);
        \draw[arrow] (OR_final_h1.east)   -- (OR_final_h1 -| h1-k)     |- (ANDs_k.west);
        \draw[->-]   (ANDs_1 -| 1-h1)     -- (1-h1-) -- (h1-k-)        -- (h1-k |- ANDs_k);
        \draw[->-]   (ORs_1  -| 1-h1)     -- (1-h1)  -- (h1-k)         -- (h1-k |- ORs_k);

        % Cell k
        \draw[line]  (ORs_k.east)         -| (k-k+1);
        \draw[arrow] (OR_final_k.east)    -- (OR_final_k -| k-k+1)     |- (ANDs_k+1.west);
        \draw[->-]   (h1-k-)              -- (k-k+1-);
        \draw[->-]   (h1-k)               -- (k-k+1);
        \draw[line]  (ANDs_k -| k-k+1)    -- (k-k+1-);

        % Cell k+1
        \draw[line]  (ORs_k+1.east)       -| (k+1-h2);
        \draw[arrow] (OR_final_k+1.east)  -- (OR_final_k+1 -| k+1-h2)  |- (ANDs_h2.west);
        \draw[->-]   (k-k+1-)             -- (k+1-h2-);
        \draw[->-]   (k-k+1)              -- (k+1-h2);

        % Hidden cell 2
        \draw[line]  (ORs_h2.east)        -- (ORs_h2 -| h2-n);
        \draw[arrow] (OR_final_h2.east)   -- (OR_final_h2 -| h2-n)     |- (ANDs_n.west);
        \draw[->-]   (ANDs_k+1 -| k+1-h2) -- (k+1-h2-) -- (h2-n-)      -- (h2-n |- ANDs_n);
        \draw[->-]   (k+1-h2)             -- (h2-n);

        % Cell n
        \draw[arrow] (ORs_n.east)         -- (ORs_n -| n-)             |- (input_OR.east);
        \draw[->-]   (ORs_h2 -| h2-n)     -- (h2-n) -- (n-)            -- (n- |- ORs_n);

        % Input gate
        \coordinate  (input) at ($(input_pulse.north) + (0, 1.25)$);
        \draw[arrow] (input_pulse.north)  -- (input)                   -| (ANDs_1.south);
        \draw[line]  (input_OR.north)     |- (input);
        \draw[->-]   (ANDs_1 |- 1-h1-)    -- (1-h1-);
    \end{tikzpicture}
    }
    \caption{Diagram of the decimal method counter}
    \label{fig:CounterDecimal}
\end{figure}
- To add cycle, add cycle to the last cell and remove the OR gate from the input circuit
- To make it 2-way, duplicate the input circuit but connect all OR gates except the first from each cell to the OR gate. Then, make each cell 2-way, connect the cells in the same direction using the first OR gate of each cell rather than the last, and connect the new input circuit to all AND gates for the second direction
- Might require a decoder (unless you want to show numbers on a screen)
  - To create it, take $n$ AND gates and assign a different combination of 1 output gate from each cell to each of them (if you only need to use it combined with other circuits, you can combine all of their decoders into a single one to use less gates)
  - Has a complexity of $n$ gates
- Requires a startup pulse to one of the toggled OR gates on each cell to work (achieved with a 1 frame pulse generator)
- Complexity
  - 1-way: $2 \ceil[\Big]{\frac{n}{10^{\ceil{\log_{10} n} - 1}}} + 20 \ceil{\log_{10} n} - 19$
  - 1-way+cycle: $2 \ceil[\Big]{\frac{n}{10^{\ceil{\log_{10} n} - 1}}} + 20 \ceil{\log_{10} n} - 19$
  - 2-way: $3 \ceil[\Big]{ \frac{n}{10^{\ceil{\log_{10} n} - 1}}} + 30 \ceil{\log_{10} n} - 28$
  - 2-way+cycle: $3 \ceil[\Big]{\frac{n}{10^{\ceil{\log_{10} n} - 1}}} + 30 \ceil{\log_{10} n} - 28$
- Takes 3 frames to update with cycle and 4 frames otherwise
- Example blueprints: [\underline{1-way}](https://steamcommunity.com/sharedfiles/filedetails/?id=2134491881), [\underline{1-way+cycle}](https://steamcommunity.com/sharedfiles/filedetails/?id=2134492935), [\underline{2-way}](https://steamcommunity.com/sharedfiles/filedetails/?id=2134494676) and [\underline{2-way+cycle}](https://steamcommunity.com/sharedfiles/filedetails/?id=2134496082)

### Binary (Base $2$)

- Works best when $n$ is a power of $2$. If it isn't, more gates are needed to cap the value at $n$
- $n = 2^\text{amount of cells}; \text{ amount of cells} = \ceil{\log_2 n}$
- The output is encoded as a binary number with a bit stored in each cell (with the first cell being the least significant digit and the last cell being the most significant digit)
\begin{figure}[H]
    \makebox[\textwidth][c]{
    \begin{tikzpicture}
        % Nodes

        % Cell 1
        \node[node]       (OR_1)                                         {Toggled OR gate\\(output)};
        \node[node]       (AND_1)         [below = 5mm of OR_1]          {AND gate};
        \coordinate[above=16pt of OR_1]        (cell_1);

        % Hidden cell 1
        \node[hiddenNode] (OR_h1)         [right = of OR_1]              {};
        \node[hiddenNode] (AND_h1)        [right = of AND_1]             {};

        % Cell k
        \node[node]       (OR_k)          [right = of OR_h1]             {Toggled OR gate\\(output)};
        \node[node]       (AND_k)         [right = of AND_h1]            {AND gate};
        \coordinate[above=16pt of OR_k]        (cell_k);

        % Cell k+1
        \node[node]       (OR_k+1)        [right = of OR_k]              {Toggled OR gate\\(output)};
        \node[node]       (AND_k+1)       [right = of AND_k]             {AND gate};
        \coordinate[above=16pt of OR_k+1]      (cell_k+1);

        % Hidden cell 2
        \node[hiddenNode] (OR_h2)         [right = of OR_k+1]            {};
        \node[hiddenNode] (AND_h2)        [right = of AND_k+1]           {};

        % Cell n
        \node[node]       (OR_n)          [right = of OR_h2]             {Toggled OR gate\\(output)};
        \node[node]       (AND_n)         [right = of AND_h2]            {AND gate};
        \coordinate[above=16pt of OR_n]        (cell_n);

        % Input circuit
        \node[node]       (input_pulse) at ($(AND_k) + (0.45, -2.75)$)   {1 frame pulse\\generator (input)};
        \node[node]       (input_NAND)    [right = 1.5mm of input_pulse] {NAND gate};
        \coordinate[above=16pt of input_pulse] (input_cell);

        % Cell bounding boxes
        \begin{scope}[on background layer]
            \node[node,       fit=(OR_1)(AND_1)(cell_1),                 label={[anchor=north, yshift=-2.5pt]Cell $1$}] {};
            \node[hiddenNode, fit=(OR_h1)(AND_h1)]                       {$\cdots$};
            \node[node,       fit=(OR_k)(AND_k)(cell_k),                 label={[anchor=north, yshift=-2.5pt]Cell $k$}] {};
            \node[node,       fit=(OR_k+1)(AND_k+1)(cell_k+1),           label={[anchor=north, yshift=-2.5pt]Cell $k+1$}] {};
            \node[hiddenNode, fit=(OR_h2)(AND_h2)]                       {$\cdots$};
            \node[node,       fit=(OR_n)(AND_n)(cell_n),                 label={[anchor=north, yshift=-2.5pt]Cell $\ceil{\log_2 n}$}] {};
            \node[node,       fit=(input_pulse)(input_NAND)(input_cell), label={[anchor=north, yshift=-2.5pt]Input Circuit}] {};
        \end{scope}

        % Arrows

        % Points between cells
        \coordinate (1-h1)   at ($(OR_1.east)!0.5!(OR_h1.west)   + (0, 1.75)$);
        \coordinate (h1-k)   at ($(OR_h1.east)!0.5!(OR_k.west)   + (0, 1.75)$);
        \coordinate (k-k+1)  at ($(OR_k.east)!0.5!(OR_k+1.west)  + (0, 1.75)$);
        \coordinate (k+1-h2) at ($(OR_k+1.east)!0.5!(OR_h2.west) + (0, 1.75)$);
        \coordinate (h2-n)   at ($(OR_h2.east)!0.5!(OR_n.west)   + (0, 1.75)$);
        \coordinate (n-)     at ($(OR_n.east)                    + (0.5, 1.75)$);

        % Cell 1
        \draw[arrow] (AND_1.north)       -- (OR_1.south);
        \draw[arrow] (OR_1.east)         -- (OR_1 -| 1-h1)     |- (AND_h1.west);

        % Hidden cell 1
        \draw[arrow] (OR_h1.east)        -- (OR_h1 -| h1-k)    |- (AND_k.west);
        \draw[->-]   (OR_1 -| 1-h1)      -- (1-h1) -- (h1-k)   -- (h1-k |- OR_k);

        % Cell k
        \draw[arrow] (AND_k.north)       -- (OR_k.south);
        \draw[arrow] (OR_k.east)         -- (OR_k -| k-k+1)    |- (AND_k+1.west);
        \draw[->-]   (h1-k)              -- (k-k+1);
        \draw[line]  (OR_k -| k-k+1)     -- (k-k+1);

        % Cell k+1
        \draw[arrow] (AND_k+1.north)     -- (OR_k+1.south);
        \draw[arrow] (OR_k+1.east)       -- (OR_k+1 -| k+1-h2) |- (AND_h2.west);
        \draw[->-]   (k-k+1)             -- (k+1-h2);
        \draw[line]  (OR_k+1 -| k+1-h2)  -- (k+1-h2);

        % Hidden cell 2
        \draw[arrow] (OR_h2.east)        -- (OR_h2 -| h2-n)    |- (AND_n.west);
        \draw[->-]   (k+1-h2)            -- (h2-n);

        % Cell n
        \draw[arrow] (AND_n.north)       -- (OR_n.south);
        \draw[arrow] (OR_n.east)         -- (OR_n -| n-)       |- (input_NAND.east);
        \draw[->-]   (OR_h2 -| h2-n)     -- (h2-n) -- (n-)     -- (n- |- OR_n);

        \coordinate  (input) at ($(input_pulse.north) + (0, 1.25)$);
        \draw[->-]   (input_pulse.north) -- (input);
        \draw[->-]   (input_NAND.north)  -- (input_NAND |- input);
        \draw[arrow] (input)             -| (AND_1.south);
        \draw[arrow] (input)             -| (AND_n.south);
        \draw[arrow] (input -| AND_h1)   -| (AND_h1.south);
        \draw[arrow] (input -| AND_k)    -| (AND_k.south);
        \draw[arrow] (input -| AND_k+1)  -| (AND_k+1.south);
        \draw[arrow] (input -| AND_h2)   -| (AND_h2.south);
    \end{tikzpicture}
    }
    \caption{Diagram of the binary method counter}
    \label{fig:CounterBinary}
\end{figure}
- To add cycle, remove the NAND gate from the input circuit and the AND gate on the first cell, and connect the 1 frame pulse generator directly to the OR gate in the first cell
- To make it 2-way, add a NOT gate to each cell with its OR gate as input and a new AND gate connected in the same way as the old AND gate, but using the NOT gate of all previous cells as input instead of the OR gates. Then replace the NAND gate on the input circuit with an OR gate and duplicate it (with the copy being connected to the new AND gates on each cell rather than the old ones). Connect the NOT gate of all the cells to the OR gate of the first input circuit, and the OR gate of all the cells to the OR gate of the second input circuit
- Might require a decoder
  - To create it, add a NOT gate to each cell and replace the NAND gate of the input circuit with an OR gate like in the 2-way version (if using the 1-way versions). Then, take $n$ AND gates and assign each of them a different combination of either the OR or NOT from each cell (if you only need to use it combined with other circuits you can combine all of their decoders into a single one to use less gates)
  - Has a complexity of $\ceil{\log_2 n} + n - 1$ for the 1-way version, $\ceil{\log_2 n} + n$ for the 1-way+cycle version and $n$ for the 2-way versions
- Complexity
  - 1-way: $2 \ceil{\log_2 n} + 3$
  - 1-way+cycle: $2 \ceil{\log_2 n}$
  - 2-way: $4 \ceil{\log_2 n} + 4$
  - 2-way+cycle: $4 \ceil{\log_2 n}$
- Takes 3 frames to update for 1-way+cycle and 4 frames otherwise
- Example blueprints: [\underline{1-way}](https://steamcommunity.com/sharedfiles/filedetails/?id=2134497489), [\underline{1-way+cycle}](https://steamcommunity.com/sharedfiles/filedetails/?id=2134498845), [\underline{2-way}](https://steamcommunity.com/sharedfiles/filedetails/?id=2134500019) and [\underline{2-way+cycle}](https://steamcommunity.com/sharedfiles/filedetails/?id=2134500705)

### When to use each method

- Calculated for $n \geq 3$, for $n = 2$ a latch is always best

\begin{table}[H]
    \centering
    \begin{tabular}{|c|m{20em}|m{20em}|}
        \cline{2-3}
        \multicolumn{1}{c|}{} & \thead{1-way} & \thead{2-way} \\
        \hline
        % In order for the "Without cycle" text to be properly vertically centered, the other columns need to be vertically centered as well. To make them look like they are aligned at the top, they must have the same amount of lines
        \rotatebox[origin=c]{90}{\thead{Without cycle}}
        &
        Doesn't require a decoder:
        \begin{itemize}
            \item For $n \leq 3$ use the general circuit
            \item For $n > 3$ use the binary circuit
        \end{itemize}
        Doesn't require an individual decoder:
        \begin{itemize}
            \item For $n \leq 5$ use the general circuit
            \item For $n > 5$ use the binary circuit
        \end{itemize}
        Requires an individual decoder:
        \begin{itemize}
            \item For $n \leq 14$ or $n = 17$ use the general circuit
            \item For $n > 14$ and $n \neq 17$ use the binary circuit
        \end{itemize}
        Show values directly on a screen (only numbers for $n > 12$):
        \begin{itemize}
            \item For $n \leq 12$ use the general circuit
            \item For $n > 12$ use the decimal circuit
            \newline
        \end{itemize}
        &
        Doesn't require a decoder:
        \begin{itemize}
            \item For $n \leq 5$ use the general circuit
            \item For $n > 5$ use the binary circuit
        \end{itemize}
        Doesn't require an individual decoder:
        \begin{itemize}
            \item For $n \leq 5$ use the general circuit
            \item For $n > 5$ use the binary circuit
        \end{itemize}
        Requires an individual decoder:
        \begin{itemize}
            \item For $n \leq 10$ use the general circuit
            \item For $n > 10$ use the binary circuit
            \newline
            \newline
        \end{itemize}
        Show values directly on a screen (only numbers for $n > 16$):
        \begin{itemize}
            \item For $n \leq 10$ use the general circuit
            \item For $10 < n \leq 16$ use the binary circuit
            \item For $n > 16$ use the decimal circuit
        \end{itemize} \\
        \hline
        \rotatebox[origin=c]{90}{\thead{With cycle}}
        &
        Doesn't require a decoder:
        \begin{itemize}
            \item Use the binary circuit
        \end{itemize}
        Doesn't require an individual decoder:
        \begin{itemize}
            \item Use the binary circuit
        \end{itemize}
        Requires an individual decoder:
        \begin{itemize}
            \item For $n \leq 11$ use the general circuit
            \item For $n > 11$ use the binary circuit
        \end{itemize}
        Show values directly on a screen (only numbers for $n > 12$):
        \begin{itemize}
            \item For $n < 12$ use the general circuit
            \item For $n = 12$ use the binary circuit
            \item For $n > 12$ use the decimal circuit
            \newline
        \end{itemize}
        &
        Doesn't require a decoder:
        \begin{itemize}
            \item Use the binary circuit
        \end{itemize}
        Doesn't require an individual decoder:
        \begin{itemize}
            \item Use the binary circuit
        \end{itemize}
        Requires an individual decoder:
        \begin{itemize}
            \item For $n \leq 3$ or $n = 5$ use the general circuit
            \item For $n = 4$ or $n > 5$ use the binary circuit
        \end{itemize}
        Show values directly on a screen (only numbers for $n > 17$):
        \begin{itemize}
            \item For $n \leq 3$ or $n = 5$ use the general circuit
            \item For $n = 4$ or $5 < n \leq 17$ use the binary circuit
            \item For $n > 17$ use the decimal circuit
        \end{itemize} \\
        \hline
    \end{tabular}
    \caption{Comparison of the different counter methods}
    \label{table:CounterComparison}
\end{table}

Note: this is just based on the amount of logic gates each circuit uses (unless there is a tie, in which case update speed is used). However, the amount of time it takes for the system to update might also matter depending on the situation. In that case, the fastest is the general and decimal with cycle circuits, followed by the 1-way binary circuit with cycle, then by the decimal circuit without cycle and lastly the binary circuit without cycle or with 2-way

## No-Delay Signal Toggle

- Allows to enable/disable an analog signal without increasing the signal delay like normal AND/XOR gate methods do
- Doesn't work when the output block is an AND/XOR gate
- Commonly used to enable/disable angle sensor stabilization (with the input being angle sensors and the output helicopter engines)
\begin{figure}[H]
    \centering
    \begin{tikzpicture}[wideNode/.style={node, minimum width=30.5mm}]
        % Nodes

        \node[wideNode] (input_signal)                                 {Input Signals\\(can be multiple\\blocks)};
        \node[wideNode] (output_blocks) [right = 5cm of input_signal]  {Output Blocks};
        \node[wideNode] (input_toggle1) [above = 1.5cm of input_signal]  {OR Gate with\\toggle keybind};
        \node[wideNode] (input_toggle2) [right = 5cm of input_toggle1] {OR Gate with\\toggle keybind};
        \coordinate (toggles)    at ($(input_toggle1)!0.5!(input_toggle2)$);
        \coordinate (middle)     at ($(input_signal)!0.5!(input_toggle1)$);
        \node[node] (XOR)        at (toggles |- middle) {XOR gate with\\-1 output value};

        % Arrows

        \draw[arrow] (input_signal.east)  -- (output_blocks.west);
        \draw[arrow] (input_signal.north) |- (XOR.west);
        \draw[arrow] (XOR.east)           -| (output_blocks.north);
        \draw[->-]   (input_toggle1.east) -- (toggles);
        \draw[->-]   (input_toggle2.west) -- (toggles);
        \draw[arrow] (toggles)            -- (XOR.north);
    \end{tikzpicture}
    \caption{Diagram of the no-delay signal toggle}
    \label{fig:NoDelaySignalToggle}
\end{figure}
- [\underline{Example blueprint}](https://steamcommunity.com/sharedfiles/filedetails/?id=3054610284)

## Feedback Loop

- Allows to store an analog value in the range $[-1, 1]$
- Made by connecting 2 OR gates to each other, connecting the input to both of them, and taking the output from one of them
- Each frame the input is active, the stored value increases by the value of the input
  - With a close to 0 output value as input, the circuit can be used to generate an analog output value
- One of the OR gates can be replaced with an XOR to add a reset input. In this case, the normal input should go to the OR gate only and the reset input must be 2 different signals connected to the XOR gate
  - Be aware that this method adds a 1 frame jitter to the stored signal

### Clamped Feedback Loop

- Allows limiting the output signal of a feedback loop to the range $[0, 1]$
- Diagram of the circuit:
\begin{figure}[H]
    \centering
    \begin{tikzpicture}[trim left=-12em]
        % Nodes

        \node[node] (feedback_top)                               {OR Gate};
        \node[node] (feedback_bot) [below = 5mm of feedback_top] {OR Gate};
        \coordinate (feedback_mid) at ($(feedback_top.west)!0.5!(feedback_bot.west)$);

        \node[node] (input)        [left = of feedback_mid]      {Input Signal};

        \coordinate[above=16pt of feedback_top] (feedback);

        \node[node] (C+1)          [right = of feedback_bot]     {Always on sensor};
        \node[node] (C-1)          [above = 5mm of C+1]          {OR gate with\\-1 output value};

        \node[node] (output)       [right = of C-1]              {OR gate with\\-1 output value\\(output)};

        % Bounding boxes
        \begin{scope}[on background layer]
            \node[node, fit=(feedback_top)(feedback_bot)(feedback), label={[anchor=north, yshift=-2.5pt]Feedback Loop}] {};
        \end{scope}

        % Arrows

        \coordinate  (input_split) at ($(input.east) + (0.5, 0)$);
        \draw[line]  (input.east)                    -- (input_split);
        \draw[arrow] (input_split)                   |- (feedback_top.west);
        \draw[arrow] (input_split)                   |- (feedback_bot.west);
        \draw[arrow] ($(feedback_bot.north) + (2mm, 0)$)  -- ($(feedback_top.south) + (2mm, 0)$);
        \draw[arrow] ($(feedback_top.south) + (-2mm, 0)$) -- ($(feedback_bot.north) + (-2mm, 0)$);
        \draw[arrow] (C+1.west)                      -- (feedback_bot.east);
        \draw[arrow] (C+1.north)                     -- (C-1.south);
        \draw[arrow] (C-1.west |- feedback_top.east) |- (feedback_top.east);
        \draw[arrow] (C-1.east)                      -- (output.west);
        \draw[arrow] (feedback_bot.south) -- ($(feedback_bot.south) + (0, -0.5)$) -| (output);
    \end{tikzpicture}
    \caption{Diagram of the clamped feedback loop}
    \label{fig:ClampedFeedbackLoop}
\end{figure}
- Note: the input signal is reversed. This means that a negative value increases the stored value while a positive value decreases it
- Keybinds can be added to one of the OR gates in the feedback loop to go to the max/min value. The green keybind sets the min value while the red keybind sets the max value
- [\underline{Example blueprint}](https://steamcommunity.com/sharedfiles/filedetails/?id=2911246646)
- Python script to simulate the behaviour (input value is automatically reversed):

  ```python
  def clamp(x: float) -> float:
      return min(max(x, -1), 1)

  def update(
      feedback_top: float, feedback_bottom: float, user_input: float
  ) -> tuple[float, float]:
      return (
          clamp(feedback_bottom - user_input + 1),
          clamp(feedback_top    - user_input - 1)
      )

  def print_state(feedback_top: float, feedback_bottom: float):
      print("State:")
      print("\tFeedback Top: ", round(feedback_top, 3))
      print("\tFeedback Bottom: ", round(feedback_bottom, 3))
      print("Output: ", round(clamp(-(feedback_top - 1)), 3))

  feedback_top, feedback_bottom = 1, 0
  print_state(feedback_top, feedback_bottom)
  while True:
      user_input = input("Enter input (between -1 and 1, Q to quit): ")
      if user_input.lower() == "q":
          break
      try:
          user_input = float(user_input)
      except ValueError:
          print("Invalid input. Try again")
          continue
      feedback_top, feedback_bottom = update(feedback_top, feedback_bottom, user_input)
      print_state(feedback_top, feedback_bottom)
  ```

- Credits to Precache for figuring out this circuit

\clearpage
\appendix

# Input value to multiplier for hinges/wings with control surfaces {#InputValueMultiplier}

Due to a bug, the angle by which hinges/wings/other blocks with the "steering help" setting rotate doesn't scale linearly with the input value. This section contains the multipliers used for many input values, found experimentally. Some notes about this process:

- Final angle is the resulting angle of the hinge measured with a max angle of $90$ degrees and an error of $\pm 0.005$ degrees
- The multiplier was calculated with $\text{multiplier} = \frac{\text{final angle}}{90}$
- A calculator using this data made by confusionextended can be found [\underline{here}](https://www.desmos.com/calculator/i70yadxqyy)

\begin{longtable}{|c|c|c !{\vrule width 3pt} c|c|c !{\vrule width 3pt} c|c|c|}
    \hline
    \thead{Output\\value} & \thead{Final\\angle} & \thead{Multiplier} & \thead{Output\\value} & \thead{Final\\angle} & \thead{Multiplier} & \thead{Output\\value} & \thead{Final\\angle} & \thead{Multiplier} \\
    \HLine{2pt}
    1.000 & 90.000 & 1.00000000 & 0.810 & 31.275 & 0.34750000 & 0.480 & 05.640 & 0.06266667 \\
    \hline
    0.995 & 88.345 & 0.98161111 & 0.805 & 30.215 & 0.33572222 & 0.470 & 05.295 & 0.05883333 \\
    \hline
    0.990 & 86.680 & 0.96311111 & 0.800 & 29.195 & 0.32438889 & 0.460 & 04.960 & 0.05511111 \\
    \hline
    0.985 & 85.000 & 0.94444444 & 0.795 & 28.225 & 0.31361111 & 0.450 & 04.640 & 0.05155556 \\
    \hline
    0.980 & 83.315 & 0.92572222 & 0.790 & 27.300 & 0.30333333 & 0.440 & 04.335 & 0.04816667 \\
    \hline
    0.975 & 81.620 & 0.90688889 & 0.785 & 26.425 & 0.29361111 & 0.430 & 04.040 & 0.04488889 \\
    \hline
    0.970 & 79.920 & 0.88800000 & 0.780 & 25.595 & 0.28438889 & 0.420 & 03.760 & 0.04177778 \\
    \hline
    0.965 & 78.215 & 0.86905556 & 0.775 & 24.825 & 0.27583333 & 0.410 & 03.495 & 0.03883333 \\
    \hline
    0.960 & 76.505 & 0.85005556 & 0.770 & 24.105 & 0.26783333 & 0.400 & 03.245 & 0.03605556 \\
    \hline
    0.955 & 74.795 & 0.83105556 & 0.765 & 23.440 & 0.26044444 & 0.390 & 03.005 & 0.03338889 \\
    \hline
    0.950 & 73.085 & 0.81205556 & 0.760 & 22.830 & 0.25366667 & 0.380 & 02.775 & 0.03083333 \\
    \hline
    0.945 & 71.380 & 0.79311111 & 0.755 & 22.280 & 0.24755556 & 0.370 & 02.560 & 0.02844444 \\
    \hline
    0.940 & 69.675 & 0.77416667 & 0.750 & 21.790 & 0.24211111 & 0.360 & 02.355 & 0.02616667 \\
    \hline
    0.935 & 67.975 & 0.75527778 & 0.740 & 20.920 & 0.23244444 & 0.350 & 02.160 & 0.02400000 \\
    \hline
    0.930 & 66.280 & 0.73644444 & 0.730 & 20.075 & 0.22305556 & 0.340 & 01.980 & 0.02200000 \\
    \hline
    0.925 & 64.595 & 0.71772222 & 0.720 & 19.255 & 0.21394444 & 0.330 & 01.805 & 0.02005556 \\
    \hline
    0.920 & 62.920 & 0.69911111 & 0.710 & 18.460 & 0.20511111 & 0.320 & 01.645 & 0.01827778 \\
    \hline
    0.915 & 61.250 & 0.68055556 & 0.700 & 17.685 & 0.19650000 & 0.310 & 01.495 & 0.01661111 \\
    \hline
    0.910 & 59.595 & 0.66216667 & 0.690 & 16.930 & 0.18811111 & 0.300 & 01.350 & 0.01500000 \\
    \hline
    0.905 & 57.955 & 0.64394444 & 0.680 & 16.200 & 0.18000000 & 0.290 & 01.220 & 0.01355556 \\
    \hline
    0.900 & 56.325 & 0.62583333 & 0.670 & 15.490 & 0.17211111 & 0.280 & 01.095 & 0.01216667 \\
    \hline
    0.895 & 54.715 & 0.60794444 & 0.660 & 14.800 & 0.16444444 & 0.270 & 00.980 & 0.01088889 \\
    \hline
    0.890 & 53.125 & 0.59027778 & 0.650 & 14.135 & 0.15705556 & 0.269 & 00.970 & 0.01077778 \\
    \hline
    0.885 & 51.550 & 0.57277778 & 0.640 & 13.485 & 0.14983333 & 0.268 & 00.955 & 0.01061111 \\
    \hline
    0.880 & 49.995 & 0.55550000 & 0.630 & 12.860 & 0.14288889 & 0.267 & 00.945 & 0.01050000 \\
    \hline
    0.875 & 48.465 & 0.53850000 & 0.620 & 12.250 & 0.13611111 & 0.266 & 00.935 & 0.01038889 \\
    \hline
    0.870 & 46.960 & 0.52177778 & 0.610 & 11.660 & 0.12955556 & 0.265 & 00.925 & 0.01027778 \\
    \hline
    0.865 & 45.480 & 0.50533333 & 0.600 & 11.095 & 0.12327778 & 0.264 & 00.915 & 0.01016667 \\
    \hline
    0.860 & 44.025 & 0.48916667 & 0.590 & 10.545 & 0.11716667 & 0.263 & 00.905 & 0.01005556 \\
    \hline
    0.855 & 42.600 & 0.47333333 & 0.580 & 10.010 & 0.11122222 & 0.262 & 00.000 & 0.00000000 \\
    \hline
    0.850 & 41.200 & 0.45777778 & 0.570 & 09.500 & 0.10555556 & 0.261 & 00.000 & 0.00000000 \\
    \hline
    0.845 & 39.830 & 0.44255556 & 0.560 & 09.000 & 0.10000000 & 0.260 & 00.000 & 0.00000000 \\
    \hline
    0.840 & 38.505 & 0.42783333 & 0.550 & 08.525 & 0.09472222 & 0.250 & 00.000 & 0.00000000 \\
    \hline
    0.835 & 37.200 & 0.41333333 & 0.540 & 08.065 & 0.08961111 & 0.200 & 00.000 & 0.00000000 \\
    \hline
    0.830 & 35.940 & 0.39933333 & 0.530 & 07.620 & 0.08466667 & 0.150 & 00.000 & 0.00000000 \\
    \hline
    0.825 & 34.715 & 0.38572222 & 0.520 & 07.190 & 0.07988889 & 0.100 & 00.000 & 0.00000000 \\
    \hline
    0.820 & 33.530 & 0.37255556 & 0.510 & 06.780 & 0.07533333 & 0.050 & 00.000 & 0.00000000 \\
    \hline
    0.815 & 32.380 & 0.35977778 & 0.500 & 06.380 & 0.07088889 & 0.000 & 00.000 & 0.00000000 \\
    \hline
    \multicolumn{3}{c!{\vrule width 3pt}}{} & 0.490 & 06.005 & 0.06672222 & \multicolumn{3}{c}{} \\
    \cmidrule(l{-3pt}){4-6}
    \caption{Raw data of the output value multiplier for hinges}
    \label{table:OutputValueMultiplierData}
\end{longtable}

\begin{figure}[H]
    \centering
    \begin{tikzpicture}
        \begin{axis}[
            height=27.5em,
            width=42em,
            title={Multiplier as a function of the input value},
            xlabel={Input value},
            ylabel={Multiplier},
            domain = 0:1,
            xmin=0, xmax=1,
            ymin=0, ymax=1,
            minor tick num=1,
            grid=both
        ]
            \addplot[color=blue, mark=*] file {Output_Value_to_Multiplier.dat} node[above left, midway] {$f(x)$};
            \addplot[color=black, samples=3] {x} node[above left, midway] {$y=x$};
        \end{axis}
    \end{tikzpicture}
    \caption{Graph of the multiplier for hinges as a function of the input value}
    \label{fig:OutputValueMultiplierGraph}
\end{figure}

\clearpage

# Tips

- If you want your system to not modify the input that passes through, configure all of the logic gates to have an output value of 1. Then, if a gate needs to have more inputs other than the original one, make sure the sum of the output values of those other inputs is 0. This will make the output which reaches whatever your system activates be the output that the sensors/keybinds had
- Organize the logic gates on a testbed while working with them before adding them to your vehicle, having the logic gates organized as opposed to scattered across your entire vehicle will make remembering what each gate does easier. There is no wrong way to organize them as long as they aren't randomly placed, but the way I do it is by splitting the gates into groups depending on function, inside each group the arrows of logic gates point towards the outputs of that gate and away from its inputs, then I put the groups of logic gates that a group outputs to in the direction the arrows of the logic gates that the group uses as output are pointing, while I put the groups that group uses as input in the opposite direction
- If you have problems figuring out how to do something with logic gates, draw it on paper first, being able to see all connections at once helps a lot. Another method is writing it with if statements as they translate to logic gates easily (each logic gate is an individual if statement)
- If you still have any questions or need help with something, feel free to contact me on the [\underline{official Trailmakers discord server}](https://discord.gg/trailmakers)

## \large Made by ALVAROPING1 {.unlisted .unnumbered}
