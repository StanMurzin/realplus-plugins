# RealPlus plugin for Codex and Claude Code

One plugin, two apps. It answers questions about RealPlus New York real estate data (listings, asking and closing
prices, rents, closed deals, price cuts, agents, brokerages, customer portal activity, searches, listings near
subway stations, courthouses, schools, parks, grocery stores, cafes and gyms): the assistant runs
read-only SQL over the Snowflake semantic view `REALPLUS.GOLD.REALPLUS_BUSINESS` and follows the RealPlus answer rules
shipped with the plugin as a skill.

You need a Snowflake user for the RealPlus account; without one the plugin can't read anything.

## Install in Codex

```
codex plugin marketplace add StanMurzin/realplus-plugins
codex plugin add realplus@realplus
```

Or in the Codex app: Plugins → **Add a marketplace** → Source `StanMurzin/realplus-plugins` → install **RealPlus**.
Node.js is not needed: the plugin uses the Node that comes with Codex. Windows only for now.

## Install in Claude Code (terminal, VS Code)

```
/plugin marketplace add StanMurzin/realplus-plugins
/plugin install realplus@realplus
```

Or type `/plugin` → Marketplaces → Add Marketplace → `StanMurzin/realplus-plugins` → install **realplus**.

## Install in Claude Desktop

Customize → Plugins → **Add marketplace** → `StanMurzin/realplus-plugins` → install **realplus**.

Claude Code and Claude Desktop need Node.js 20+ (`node --version`).

## First question

Restart the app, then ask, for example: *How many sales and rentals are on the market?* or *Show the 10 most
expensive sales near the Brooklyn Supreme Court*. The first time, a browser
window opens: sign in with your Snowflake user. You stay signed in for 90 days.

## Update / remove

```
codex plugin marketplace upgrade realplus          # Codex
codex plugin remove realplus@realplus
/plugin marketplace update realplus                # Claude Code
/plugin uninstall realplus@realplus
```

## Troubleshooting

- **Sign in as another user** (or after an expired session): delete the folder `.mcp-auth` in your home folder and
  restart Codex. The sign-in is shared by every app on the computer that uses this connection.
- **Port 33418 in use**: another app is signing in to the same server at that moment; finish or close it and retry.

## What's inside

- `plugins/realplus/server.mjs`: [mcp-remote](https://github.com/geelen/mcp-remote) bundled with the server URL and
  a public OAuth client id (PKCE, no secret).
- `plugins/realplus/skills/realplus-semantic`: answer rules, semantic view catalog and verified queries.

No data and no credentials are stored in this repository.
