---
name: Apex Engineering
colors:
  surface: '#131313'
  surface-dim: '#131313'
  surface-bright: '#393939'
  surface-container-lowest: '#0e0e0e'
  surface-container-low: '#1c1b1b'
  surface-container: '#20201f'
  surface-container-high: '#2a2a2a'
  surface-container-highest: '#353535'
  on-surface: '#e5e2e1'
  on-surface-variant: '#e7bdb2'
  inverse-surface: '#e5e2e1'
  inverse-on-surface: '#313030'
  outline: '#ad887e'
  outline-variant: '#5d4038'
  surface-tint: '#ffb5a0'
  primary: '#ffb5a0'
  on-primary: '#601400'
  primary-container: '#ff5625'
  on-primary-container: '#541100'
  inverse-primary: '#b12d00'
  secondary: '#c6c6c7'
  on-secondary: '#2f3131'
  secondary-container: '#454747'
  on-secondary-container: '#b4b5b5'
  tertiary: '#c9c6c5'
  on-tertiary: '#313030'
  tertiary-container: '#929090'
  on-tertiary-container: '#2a2a29'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#ffdbd1'
  primary-fixed-dim: '#ffb5a0'
  on-primary-fixed: '#3b0900'
  on-primary-fixed-variant: '#872000'
  secondary-fixed: '#e2e2e2'
  secondary-fixed-dim: '#c6c6c7'
  on-secondary-fixed: '#1a1c1c'
  on-secondary-fixed-variant: '#454747'
  tertiary-fixed: '#e5e2e1'
  tertiary-fixed-dim: '#c9c6c5'
  on-tertiary-fixed: '#1c1b1b'
  on-tertiary-fixed-variant: '#474646'
  background: '#131313'
  on-background: '#e5e2e1'
  surface-variant: '#353535'
typography:
  headline-xl:
    fontFamily: Source Serif 4
    fontSize: 120px
    fontWeight: '700'
    lineHeight: 110px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Source Serif 4
    fontSize: 64px
    fontWeight: '600'
    lineHeight: 72px
    letterSpacing: 0.02em
  headline-lg-mobile:
    fontFamily: Source Serif 4
    fontSize: 40px
    fontWeight: '600'
    lineHeight: 44px
  headline-md:
    fontFamily: Source Serif 4
    fontSize: 32px
    fontWeight: '600'
    lineHeight: 40px
  body-lg:
    fontFamily: JetBrains Mono
    fontSize: 18px
    fontWeight: '400'
    lineHeight: 28px
  body-md:
    fontFamily: JetBrains Mono
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  label-caps:
    fontFamily: JetBrains Mono
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
    letterSpacing: 0.2em
  data-display:
    fontFamily: JetBrains Mono
    fontSize: 16px
    fontWeight: '700'
    lineHeight: 16px
spacing:
  unit: 4px
  gutter: 24px
  margin: 40px
  stack-sm: 8px
  stack-md: 16px
  stack-lg: 48px
rounded:
  none: 0px
  sm: 0px
  md: 0px
  lg: 0px
  xl: 0px
  full: 0px
---

## Brand & Style
The design system is rooted in the high-stakes world of automotive performance and precision engineering. It evokes a sense of technical mastery, raw power, and uncompromising accuracy. The aesthetic draws heavily from **Brutalism** and **Modernism**, utilizing a "form-follows-function" philosophy that prioritizes legibility and data density.

The visual narrative is built on the concept of "Chassis and Heat"—a rock-solid, dark structural foundation (Chassis) ignited by high-energy, high-visibility accents (Heat). This system is designed for professionals and enthusiasts who value performance telemetry, mechanical specs, and technical proof over superficial decoration.

## Colors
The palette is hyper-focused on high contrast and functional signaling.
- **Chassis (Dark Tones):** The primary background is a deep, technical black (#0D0D0D), with secondary surfaces using #1A1A1A to create subtle depth without losing the "void" feel.
- **Heat (Primary Accent):** A vibrant, high-vis orange (#FF4500) is used exclusively for calls to action, active statuses, and critical data points. It represents friction and energy.
- **Pure White:** Used for high-impact typography and essential structural elements.
- **Carbon (Neutral Gray):** Mid-tone grays are used for secondary data and labels to prevent visual fatigue while maintaining a technical "blueprint" feel.

## Typography
This design system employs a high-contrast typographic pairing to distinguish between "The Narrative" and "The Data."
- **Source Serif 4:** Used for massive headlines and editorial moments. It provides a classic, authoritative weight that feels "engineered" rather than just pretty.
- **JetBrains Mono:** Used for all technical specifications, labels, and body copy. The monospaced nature ensures that columns of numbers and telemetry data remain perfectly aligned, mimicking a developer terminal or a race car's digital dashboard.
- **Case Treatment:** Labels and system statuses should always be in uppercase with generous letter spacing to enhance the technical feel.

## Layout & Spacing
The layout follows a **Fixed Grid** philosophy with a structural, modular approach. 
- **Grid:** A 12-column grid for desktop with 24px gutters. Elements are often "boxed" in by thin lines rather than being separated by whitespace alone.
- **Micro-spacing:** Based on a 4px baseline grid. Padding within technical components (like data cards) should be tight and efficient.
- **Margins:** Generous outer margins (40px+) create a "letterbox" effect, framing the technical content like a high-end cinematic display.
- **Data Density:** While headlines are sparse and impactful, data sections should be dense, organized in clear horizontal rows or vertical stacks.

## Elevation & Depth
In this design system, depth is achieved through **Tonal Layering** and **Structural Outlines** rather than traditional shadows.
- **Z-Axis:** Instead of shadows, use slight color shifts (e.g., #0D0D0D for the page, #1A1A1A for a card) and 1px borders in a muted gray (#333) to define surfaces.
- **Texture:** A subtle "Carbon Fiber" or dot-matrix overlay may be applied to the base background to give the UI a physical, tactile quality.
- **Interactive States:** High-energy "Heat" glows are used sparingly to indicate active selection or hover, appearing as if the component is radiating heat from performance.

## Shapes
The shape language is strictly **Sharp (0px)**. 
Every corner is a right angle to reinforce the sense of mechanical precision and industrial construction. There are no soft edges in this system. Elements like buttons, input fields, and containers are defined by their hard perimeters, suggesting they are machined components rather than organic objects.

## Components
- **Buttons:** Rectangular with no radius. Primary buttons use a solid 'Heat' background with black monospaced text. Secondary buttons use a white outline with no fill.
- **Status Indicators:** Use a small 8px square of solid 'Heat' color next to text (e.g., "• OPERATIONAL") to indicate system states.
- **Technical Lists:** Rows separated by 1px horizontal lines. Key-value pairs should be aligned to the grid, with the key in a muted gray and the value in high-contrast white.
- **Input Fields:** Bottom-border only or full 1px outlines. Labels sit above the field in "label-caps" style.
- **Data Chips:** Small, square-edged containers with monospaced text. Often used for tags like "BUILD 004" or "SPEC-B".
- **Dividers:** Use thin (1px) lines in 'Carbon' or 'Heat' to separate major content blocks, occasionally using "double slashes" ( // ) as separators within text strings.