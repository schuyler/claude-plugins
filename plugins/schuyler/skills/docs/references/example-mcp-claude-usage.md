# mcp-claude-usage README

Source: https://github.com/schuyler/mcp-claude-usage
Type: MCP server (Python)
Length: Medium
Notable: Clear practical motivation in opening paragraph. Shows JSON output early. "How it works" explains the clever hack. Cost section at the end (one line).

---

# mcp-claude-usage

An MCP server that provides your LLM agents with stats on your Claude individual subscription usage and quota headroom.

This might be useful if you wanted, say, to run an autonomous agent opportunistically on a cron job, while making sure that you don't run past your subscription quota later on when you need it for something more important.

## Usage

Call the `get_usage` tool from Claude Code. It returns:

```json
{
  "5h": {
    "usage": 0.4261,
    "time_elapsed_pct": 0.7269,
    "headroom_pct": 0.3008,
    "resets_at": 1766995200
  }
}
```

- **`usage`**: Current utilization (0.0-1.0)
- **`time_elapsed_pct`**: Portion of rate limit window elapsed (0.0-1.0)
- **`headroom_pct`**: Available capacity relative to linear pace
- **`resets_at`**: Unix timestamp when window resets

Negative headroom means you're consuming tokens at a pace that exceeds your subscription level. Positive headroom means you're still within budget.

## How it works

Anthropic doesn't provide individual user accounts with an API endpoint that exposes subscription usage statistics. This information *is* available, however, in the HTTP headers returned from Claude Code requests.

This MCP provides a `get_usage` tool, which runs a single background request with the `claude` CLI against a local forwarding proxy. The proxy grabs the rate limit metadata from the HTTP response header, does some arithmetic, and returns the result to the MCP client.

## Requirements

- Claude Code CLI installed (or run in a Docker container)
- Log in with a Claude Pro or Max subscription (`claude login`)

## Installation

[... uv sync, config JSON, running locally, Docker ...]

## Cost

Each `get_usage` call spawns a minimal Haiku request (~$0.00001).

## License

(c) 2025 Schuyler Erle, shared under [the MIT License](LICENSE.md).
