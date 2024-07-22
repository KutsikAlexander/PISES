# Introduction

Pretty Inaccurate Stellar Nucleosynthes Simulator (PISNS) or Pretty Inaccurate Stars' Evolution Simulator (PISES)

## Game Summary

N/A

## Inspiration

- [Cookie clicker]()
- [Banana clicker]()
- [Stellar clicker ... something]() <- I hate this one

## Science reference

- [Stellar Nucleosynthes]()
- [p-p chain reaction]()
- [CNO-cycle]()

## Player Experience

N/A

## Development Software

Godot Engine v4.2 (maybe too overkill for such simple concept)

## Genre

Clicker

## Target Audience

Children 10-16 years old who obsess with cosmos, graduate and postgraduate students, astrophysicists and nuclear physicists.

## Target platforms

- Linux/SteamOS
- Windows
- MacOS
- Android
- Web

# Concept

## Gameplay overview

Click to add more chemical elements to your star. More nucleons mean more mass. Big mass can ignite some nuclear reactions. Nuclear fusion produce energy/temperature. Big temperature also can ignite some nuclear reaction. Nuclear reaction consume mass of the star. Each element will unlocks in the game progress via nuclear reactions. Each nuclear reaction has temperature threshold. Player mission is to keep balance between min temperature (star will burn out) and max temperature (star will blow up)

## Theme Interpretation (Shadows and alchemy)

- Alchemy interpretation

Nuclear synthes is the process of combining two isotopes into new one with emission of some energy. Almost all known elements in the universe heavier then H are product of stellar nucleosynthes.

- Shadows interpretation

Star produce light which is opposite of shadow.

## Primary Mechanics

- Add some chemical elements into your star via clicks
- Big mass can ignite some nuclear reactions
- Nuclear fusion produce energy/temperature
- Nuclear fusion consume mass of some isotope and produce another (heavier) isotope
- Each nuclear reaction has temperature threshold
- Unlock new elements via nuclear reaction which produce this elements
- Star has minimum temperature which is demand on its mass (bigger mass -> bigger minimum temperature) and elements in it. 
- Star has maximum temperature which is demand on its mass (bigger mass -> bigger maximum temperature) and elements in it.
- If star's temperature lower than minimal temperature, star burn out
- If star's temperature bigger than maximum temperature, star blow up

## Secondary Mechanics

- Star customization.
- - Each elements radiate electromagnetic wave with some length (aka color). Combination of some chemicals element in different proportion can give a unique color.
- - Object with certain temperature emit electromagnetic wave with certain length (aka color). Hottest star emit blue light.

## Gameplay implementation

- Mass of the star represents as sum of elements' mass.
- Mass of the elements represents as float number.
- Temperature is a float number. Value of temperature decrease with time multiplied by coefficient.
- Nuclear reaction is a periodic process with subtract some amount of element's mass, add some value to mass of another element and add some value to temperature.
- - Produced mass of new element(float) = consumed mass of element(float) * mass defect coefficient(float) 
- - mass defect coefficient < 1.0 due to [mass defect](). The star will become lighter with time. 
- - Additional temperature value(float) = consumed mass of element(float) * temperature coefficient(float).
- - temperature coefficient can be whatever value due to game balance purpose
- - Each nuclear reaction has a temperature threshold (float). Thresholds are stored as reaction property. Reaction can turn off or turn on dependent on current temperature.
- - Each reaction store as object/resource.
- - [There is no reaction which can produce element heavier than 56Fe]()

### Reaction list

- [p-p chain reaction]()
- [CNO-cycle]()
- ...

## Achievements

Player can obtain achievement for:
- discovering some element or reaching temperature for some reaction
- gaining mass which is equal to real known start's mass (every achievement will be named after this star).

# Art

- Stellar/nebula background. Became less visible (darker) due to star's light intensity.
- Main star is simple circle/sphere which change color based on chemical compound and/or temperature. Star's texture is generated via [Perlin Noise]() or shaders.
- There are few planets around the star. Player can see planets' shadow.

# Audio
## Music

Some ambient interstellar music.

## Sound effects

- Sound of burning.
- Sound for clicks on UI.

# Game Experience
## UI

- Label for displaying star's current mass
- Ruler for temperature. Scale is logarithmic. Display min and max temperature. Display temperature of reactions.
- Ruler for light spectrum
- Option menu for element selection
- When player hover over the star, star sprite change to ring graph. Each ring represent abundance of element in the star.
- Button for game menu:
- - Continue button
- - Settings
- - Achievement/info button
- - Credits button
- - Exit button

## Controls

Click the left mouse button to add the chosen element.

# Development Timeline

- [ ] Create prototype
- [ ] Implement click mechanic
- [ ] Implement burning mechanic
- [ ] Implement game UI for temperature display
- [ ] Implement multiple reactions
- [ ] Implement lose mechanic
- [ ] The star can change color
- [ ] Add planets. Planets cast shadow
- [ ] Achievements