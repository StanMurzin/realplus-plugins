# RealPlus plugin for Codex and Claude Code

One plugin, two apps. It answers questions about RealPlus New York real estate data (listings, asking and closing
prices, rents, closed deals, price cuts, agents, brokerages, customer portal activity, searches, listings near
subway stations, courthouses, schools, parks, grocery stores, cafes and gyms, and what listing descriptions say -
private terrace, views, washer/dryer, doorman, pets, fireplace): the assistant runs read-only SQL over the Snowflake
semantic view `REALPLUS.GOLD.REALPLUS_BUSINESS`, searches the descriptions of on-market listings and follows the RealPlus answer rules
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
expensive sales near the Brooklyn Supreme Court* or *Brooklyn rentals under $5,000 with a private terrace*. The first time, a browser
window opens: sign in with your Snowflake user. You stay signed in for 90 days.

## Search on a map (Claude Desktop)

Ask, for example: *Show rentals in Brooklyn on a map, I'll draw the area*. An interactive map opens in the chat:
click **Draw area**, click the corners of the area, then **Finish** (or click the first point). You see the sales and
rentals on the market inside it - count, median asking price, markers and a table (click a row to zoom to it).
**Send to chat** passes the result and the area to Claude, so you can keep asking about it (*and 2-bedroom ones?*).

The map shows in Claude Desktop. Terminal Claude Code and Codex can't show it; there ask with coordinates or by
neighborhood. Map tiles: Esri, HERE, Garmin, (c) OpenStreetMap contributors.

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
  a public OAuth client id (PKCE, no secret), plus the map search tools.
- `plugins/realplus/skills/realplus-semantic`: answer rules, semantic view catalog and verified queries.
- `plugins/realplus/assets/map.html`: the map widget (MCP Apps; [Leaflet](https://leafletjs.com) inlined). The
  tools `search_area_on_map` and `listings_in_area` run inside `server.mjs`; the area search is one read-only SQL
  query through the same Snowflake connection.

No data and no credentials are stored in this repository.
