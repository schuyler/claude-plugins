# garganorn README

Source: https://github.com/schuyler/garganorn
Type: ATProtocol XRPC server (Python/Flask)
Length: Long (mostly due to API examples)
Notable: Personality + technical depth. Named after a mammoth goose (with photo). Has a bold WARNING about instability. "It's MIT licensed, yo." Community references. Shows full API request/response examples.

---

# Garganorn

Garganorn is intended to be a test bed for experimenting with adding location data to the ATmosphere.

Currently, the project implements an ATProtocol XRPC server designed to serve static location datasets ("gazetteers").

**WARNING: This code has not been formally released and interfaces WILL change without warning. YMMV. Patches welcome.**

The project is named after the earliest recorded [mammoth goose](https://en.wikipedia.org/wiki/Garganornis).

![Garganornis ballmanni](https://upload.wikimedia.org/wikipedia/commons/...)

## Data sources

[... practical details about Foursquare OSP and Overture Maps ...]

## Running the server

```
pip install -e .
flask --app garganorn run --debug --host 0.0.0.0 --port 8000
```

## Querying the XRPC service

[... full curl examples with JSON responses ...]

## Development

As aforementioned, this project is under development and should not be used for production purposes. I intend to try to track the work of the lexicon.community ATGeo working group as it evolves.

Patches are extremely welcome.

Come find us in the BlueSky API Touchers Discord.

## License etc.

It's MIT licensed, yo. See [LICENSE](LICENSE) for details. If it breaks, you get to keep the pieces.
