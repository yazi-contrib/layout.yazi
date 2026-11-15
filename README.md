# layout.yazi

> Toggle the parent and preview panes in Yazi while it runs, and hide the header line.

[![CI](https://github.com/yazi-contrib/layout.yazi/actions/workflows/ci.yml/badge.svg)](https://github.com/yazi-contrib/layout.yazi/actions/workflows/ci.yml) [![Release](https://img.shields.io/github/v/release/yazi-contrib/layout.yazi)](https://github.com/yazi-contrib/layout.yazi/releases) [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

## Dependencies

- [Yazi](https://yazi-rs.github.io) (the latest release)

## Installation

```sh
ya pkg add yazi-contrib/layout
```

Or by hand, into the folder of your configuration of Yazi:

```sh
git clone https://github.com/yazi-contrib/layout.yazi ~/.config/yazi/plugins/layout.yazi
```

## Usage

Bind keys in `keymap.toml`:

```toml
[mgr]
prepend_keymap = [
  { on = ["u", "p"], run = "plugin layout toggle-parent", desc = "Toggle the parent pane" },
  { on = ["u", "w"], run = "plugin layout toggle-preview", desc = "Toggle the preview pane" },
]
```

Each key flips the pane between its ratio and 0, and redraws. The ratios are the ones of `[mgr] ratio` in
`yazi.toml`.

## Configuration

In `init.lua`:

```lua
require("layout"):setup()                  -- the header line is hidden
require("layout"):setup { header = true }  -- the header line stays
```

| Option   | Default | Meaning                                              |
|----------|---------|------------------------------------------------------|
| `header` | `false` | `true` keeps the header line with the path of Yazi   |

Without the call to `setup`, only the toggles work, and the header stays.

## How it works, and what can break

The toggles replace `Tab.layout`, and `setup` replaces `Root.layout` and `Root.build` as a whole when the
header is hidden. If a new release of Yazi changes them, the plugin has to follow, so it is tested against
the latest Yazi in CI, and the supported versions are in the releases.

## Development

```sh
nix develop
bats tests/
```

The tests start Yazi in a detached tmux session with a configuration of its own that loads the plugin from
this folder, and fail on an error of Lua, a deprecated API, or a start that does not hold.

## The yazi-contrib ecosystem

Plugins of Yazi, one repository for each: `viewer.yazi`, `layout.yazi`, `starship.yazi`.

## License

MIT
