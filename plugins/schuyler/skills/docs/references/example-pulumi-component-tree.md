# pulumi-component-tree README

Source: https://github.com/schuyler/pulumi-component-tree
Type: Python library (PyPI, infrastructure-as-code)
Length: Long, API-documentation heavy
Notable: Most formal/technical of all the READMEs. Written for a professional audience (Pulumi/DevOps users). Still leads with a clear one-paragraph description. Code examples are comprehensive and practical.

---

# pulumi-component-tree

A Python framework for building tree-structured Pulumi components that facilitate clear organization and dependency management of cloud infrastructure resources. The tree structure naturally maps to how cloud resources are typically organized - for example, VPCs containing subnets, or Kubernetes clusters containing node pools.

## Features

- Type-safe properties using TypedDict for each component type
- Automatic parent-child dependency management
- Property inheritance from parent to child components
- Fluent API for building resource trees using the `<<` operator
- Context manager support for automatic construction
- Full type hints and mypy compatibility
- Python 3.8+ support

## Requirements / Installation

[...]

## Basic Usage

```python
from typing import TypedDict
from pulumi_component_tree import ComponentTree

class NetworkProps(TypedDict, total=False):
    cidr: str
    name: str

class NetworkResource(ComponentTree[NetworkProps]):
    def _construct(self) -> None:
        self.network_name = self.props["name"]
        self.network_cidr = self.props["cidr"]
```

[... comprehensive API documentation, advanced usage, resource trees explanation ...]

## License

BSD 2-Clause
