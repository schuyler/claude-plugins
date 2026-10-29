# boolgen README

Source: https://github.com/schuyler/boolgen
Type: Python library + CLI tool (PyPI)
Length: Medium
Notable: States motivation upfront (digital logic circuits). Honest about ChatGPT use. Clean structure. Input format explained by example, not specification.

---

# boolgen

`boolgen` is a Python library and command-line tool for generating and
simplifying Boolean expressions from truth tables.

The library implements a version of the [Quine-McCluskey
method](https://en.wikipedia.org/wiki/Quine%E2%80%93McCluskey_algorithm) to
perform the simplification. I created it to help with [designing digital logic
circuits](https://github.com/SebLague/Digital-Logic-Sim) from truth tables.

## Installation

To install `boolgen`, use pip:

```bash
pip install boolgen
```

If you download the source, you can run the [unit tests](tests/).

## Command-Line Interface

```bash
boolgen <input_file>
```

### Example Input File

```
A B C D= E=
0 0 0 0 1
0 0 1 1 0
0 1 0 1 0
1 0 0 1 0
1 1 1 0 1
```

### Output

```
D = A | B & ~C
E = ~A & ~B & ~C | A & B & C
```

## Library

You can also `import boolgen` into your own project. See the function
definitions for an idea of how it all works.

## Contributing

Contributions are welcome! Please fork the repository and submit pull requests.

## License

This project is licensed under the MIT License. See [LICENSE.md](LICENSE.md)
for details.

TBQH I used ChatGPT liberally when creating this module, so if you find your
own code in here, please let me know so I can remove it or else attribute you
properly.
