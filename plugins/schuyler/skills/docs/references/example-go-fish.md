# go-fish README

Source: https://github.com/schuyler/go-fish
Type: Design document / aspirational project (Go)
Length: Long
Notable: This is really a design spec, not a usage README. Written as a thinking-through-the-architecture document. Shows how Schuyler writes when the project IS the design. Detailed references section.

---

# go-fish

A data structure server to be written in Go.

Why Go? Because it looks fun.

Why a data structure server? Because a certain existing data structure server is fast and convenient, but also single-threaded, difficult to cluster, and doesn't provide an architecture to plug in new data structures.

## objectives

* fun to hack on
* Redis protocol compatible
* pluggable data structures
* distributed
* durable
* higher availability
* tolerant to network partition
* easy to manage
* maybe useful, someday

## design ideas

### Raft as a starting point

[... detailed architecture discussion about using Raft consensus ...]

### partitioning

[... detailed discussion of data partitioning strategy ...]

## possible next steps

[... ordered list of concrete implementation steps ...]

## stuff to consider

Log persistence. Log compaction. Partition snapshots.

## references

[... extensive list of Go libraries and related projects ...]
