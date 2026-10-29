# corvorum README

Source: https://github.com/schuyler/corvorum
Type: CLI tool (Python, Docker)
Length: Minimal — 6 lines
Notable: The gold standard for "the README's length matches the project's complexity." The one-liner IS the joke AND the description.

---

# Corvorum

It detects the presence of crows.

## Usage

Runs in Docker because BirdNET doesn't play well with native Python on MacOS.

```
docker build  -t corvorum:latest .
docker run --rm -v "$(pwd)/samples:/app/samples" corvorum:latest samples/crows/*
```

On Linux you can just `pip install -r requirements.txt` and run `detector.py` directly.
