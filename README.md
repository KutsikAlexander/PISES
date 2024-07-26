# Introduction

Pretty Inaccurate Stellar Nucleosynthesis Simulator (PISNS) or Pretty Inaccurate Stars' Evolution Simulator (PISES)

## Game Summary

PISNS (or PISES) is a clicker game where each click increases the mass of the star. The goal is to recreate all chemical elements which are produced in the star during its evolution.

## Inspiration

- [Cookie clicker](https://store.steampowered.com/app/1454400/Cookie_Clicker/)
- [Banana clicker](https://store.steampowered.com/app/2923300/Banana/)

## Player experience

Click and watch how your star burns. Monitor temperature of the star and chemical compounds

## Science reference

- [Stellar nucleosynthesis](https://en.wikipedia.org/wiki/Stellar_nucleosynthesis)

## Development Software

Godot Engine v4.2 (maybe too overkill for such simple concept)

## Genre

Clicker

## Target Audience

Children 10-16 years old who obsess with the cosmos, graduate and postgraduate students, astrophysicists and nuclear physicists.

## Target platforms

- Linux/SteamOS
- Windows
- MacOS
- Android
- Web

# Concept

## Gameplay overview

Click to add more chemical elements to your star. More nucleons mean more mass. Big mass can ignite some nuclear reactions. Nuclear fusion produces energy/temperature. Big temperatures can also ignite some nuclear reactions. Nuclear reactions consume the mass of the star. Each element will unlock in the game progress via nuclear reactions. Each nuclear reaction has a temperature threshold. Player mission is to keep balance between min temperature (star will burn out) and max temperature (star will blow up)

## Theme Interpretation (Shadows and alchemy)

- Alchemy interpretation

Nuclear synthesis is the process of combining two isotopes into a new one with emission of some energy. Almost all known elements in the universe heavier than H are products of stellar nucleosynthesis.

- Shadows interpretation

Star produces light which is opposite of shadow.

## Primary Mechanics

- Add some chemical elements into your star via clicks
- Big mass can ignite some nuclear reactions
- Nuclear fusion produce energy/temperature
- Nuclear fusion consume mass of some isotope and produce another (heavier) isotope
- Each nuclear reaction has temperature threshold
- Unlock new elements via nuclear reaction which produce this elements
- Star has a minimum temperature which is demanded on its mass (bigger mass -> bigger minimum temperature) and elements in it. 
- Star has a maximum temperature which is demanded on its mass (bigger mass -> bigger maximum temperature) and elements in it.
- If star's temperature lower than minimal temperature, star burn out
- If star's temperature bigger than maximum temperature, star blow up

## Secondary Mechanics

- Star customization.
- - Each element radiates electromagnetic waves with some length (aka color). Combination of some chemical elements in different proportions can give a unique color.
- - Object with a certain temperature emits an electromagnetic wave with a certain length (aka color). Hottest star emits blue light.

## Gameplay implementation

- Mass of the star is represented by the sum of elements' mass.
- Mass of the elements is represented by a float number.
- Temperature is a float number. Value of temperature decreases with time multiplied by coefficient.
- Nuclear reaction is a periodic process which subtract some amount of an element's mass, add some value to the mass of another element and add some value to temperature.
- - Produced mass of new element(float) = consumed mass of element(float) * mass defect coefficient(float) 
- - mass defect coefficient < 1.0 due to [mass defect](https://en.wikipedia.org/wiki/Nuclear_binding_energy). The star will become lighter with time. 
- - Additional temperature value(float) = consumed mass of element(float) * temperature coefficient(float).
- - temperature coefficient can be whatever value due to game balance purpose
- - Each nuclear reaction has a temperature threshold (float). Threshold is stored as a reaction property. Reaction can turn off or turn on depending on current temperature.
- - Each reaction is stored as an object/resource.
- - [There is no reaction which can produce element heavier than 56Fe](https://en.wikipedia.org/wiki/Iron_peak)

### Reaction list

- [p-p chain reaction](https://en.wikipedia.org/wiki/Proton%E2%80%93proton_chain)
- [CNO-cycle](https://en.wikipedia.org/wiki/CNO_cycle)
- [Triple-alpha process](https://en.wikipedia.org/wiki/Triple-alpha_process)
- [Alpha process](https://en.wikipedia.org/wiki/Alpha_process)

## Achievements

Player can obtain achievement for:
- discovering some element or reaching temperature for some reaction
- gaining mass which is equal to real known starts' mass (every achievement will be named after this star).

# Art

- Stellar/nebula background. Became less visible (darker) due to the star's light intensity.
- Main star is a simple circle/sphere which changes color based on chemical compounds and/or temperature. Star's texture is generated via [Perlin Noise](https://en.wikipedia.org/wiki/Perlin_noise) or shaders.
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
- When a player hovers over the star, its sprite changes to a ring graph. Each ring represents an abundance of elements in the star.
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