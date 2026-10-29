# autobus README

Source: https://github.com/schuyler/autobus
Type: Python library (PyPI package)
Length: Long, thorough
Notable: Best example of Schuyler's full-length README style. Synopsis with working code upfront. Honest references section that recommends a competitor. Personal asides mixed with technical content. Conversational tone throughout.

---

# autobus

Autobus is a lightweight, networked, opinionated event bus for Python 3.

Autobus supports two transport backends:
- **UDP multicast** (default) - Zero configuration, no external dependencies
- **Redis pub/sub** - For distributed systems across network boundaries

It also leans on [asyncio](https://docs.python.org/3/library/asyncio.html),
[pydantic](https://docs.pydantic.dev/), and
[schedule](https://schedule.readthedocs.io/en/stable/) to do most of its heavy
lifting.

## Synopsis

```python
import autobus
import asyncio

@autobus.subscribe(MyEventClass)
def handle_my_event(event):
    # do something in response
    ...

autobus.run()
```

and then elsewhere, maybe in another process entirely:

```python
event = MyEventClass(...)
autobus.publish(event)
autobus.run()
```

Presto! The event you published in one place is transparently handled in
another.

## Installation

```sh
pip install autobus
```

For Redis transport support:

```sh
pip install autobus[redis]
```

## Usage

[... detailed sections on defining events, publishing, receiving, scheduling, running ...]

## Configuration

[... transport backends, namespaces, encryption ...]

## Operation

[... logging, asyncio integration, long-running handlers, caveats ...]

## Testing

```sh
# Run UDP multicast tests (no external dependencies)
pytest tests/test_multicast.py

# Run Redis tests (requires Redis)
REDIS_URL=redis://localhost:6379 pytest tests/test_redis.py
```

### Redis on MacOS

Just for my future reference. You _can_ install Redis with `brew install redis`,
but if you have Docker running locally, this works too:

```sh
docker pull redis:alpine
docker run --name redis -d -p 6379:6379 redis:alpine
```

## Contributing

I regard autobus as essentially feature complete, so a lack of recent releases
just means that no one's reported any bugs.

That said, patches are welcome. By all means, please send pull requests!

## License

MIT. See [LICENSE.md](LICENSE.md) for details.

## References

Autobus was significantly inspired by [Lightbus](https://lightbus.org/latest/).
Lightbus is more feature rich than Autobus, and, honestly, Adam Charnock not
only has a Discord chat but he actually publishes a phone number and encourages
you to call him if you want to talk about the project. You should probably use
Lightbus instead of Autobus. For myself. I wanted something similar to Lightbus
but simpler, and I thought it would be fun to write my own, which it was. So
here we are.

Thanks to [@javawizard](https://github.com/javawizard) for donating ownership
of the `autobus` project in PyPI.

Autobus was conceived and written to support AI chatbot experiments in
collaboration with [@hackerfriendly](https://github.com/hackerfriendly). Thanks
as always for the collaboration, Rob!
