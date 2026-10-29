# sun-sector README

Source: https://github.com/schuyler/sun-sector
Type: TypeScript library (npm)
Length: Medium-short
Notable: "very smol" — informal register. Points users to a better alternative (SunCalc). Notes on accuracy are honest about limitations. Attribution to source material.

---

# sun-sector

## Overview

This very smol TypeScript library implements rough calculations for the azimuth
and elevation of the sun for any location on Earth at a particular time, as well
as providing times for rise, set, and noon.

## Usage

```
import {SunSector} from 'sun-sector';

const sun = SunSector.from(31.34635, -93.82015)
                     .at("2003-02-01T08:59:00-06:00");

console.log("Azimuth º:", sun.azimuth);
console.log("Elevation º:", sun.elevation);

console.log("Sunrise:", sun.rise);
console.log("Noon:", sun.noon);
console.log("Sunset:", sun.set);
```

## Notes

This code basically implements Louis Strous's excellent tutorial on computing
the position of the Sun from his [Astronomy
Answers](https://www.aa.quae.nl/en/reken/zonpositie.html) site.

When compared to online solar position calculators like
[nrel.gov](https://midcdmz.nrel.gov/solpos/spa.html) or
[gml.noaa.gov](https://gml.noaa.gov/grad/solcalc/), this code returns azimuth
and elevation that are within 0.5º, noon within a minute, and rise/set times
that are within 2 minutes. So it's not perfect, but it's close enough for my
purposes.

You should probably check out [Volodymyr
Agafonkin](https://twitter.com/mourner)'s more fully-featured
[SunCalc](https://github.com/mourner/suncalc) library. Slava Ukraini!

## License

(c) Copyright 2022 Schuyler Erle.

It's Free Software, yo. See [LICENSE.md](LICENSE.md) for the full (3-clause BSD)
license.
