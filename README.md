# grok-codex

Use your OpenAI Codex subscription (ChatGPT Plus/Pro) with [Grok CLI](https://x.ai/cli) — no X/Twitter account needed.

## What this does

```
┌─────────┐       ┌──────────────────┐       ┌─────────────────────────────────────┐
│ Grok CLI│──────▶│ openai-oauth proxy│──────▶│ chatgpt.com/backend-api/codex/...  │
│         │       │ localhost:10531   │       │ (your Codex subscription)           │
└─────────┘       └──────────────────┘       └─────────────────────────────────────┘
```

- Runs a local proxy ([openai-oauth](https://github.com/EvanZhouDev/openai-oauth)) that authenticates with your existing Codex/ChatGPT OAuth tokens
- Configures Grok CLI to use the proxy as its model backend
- Bypasses X/Twitter authentication entirely
- Auto-starts the proxy when you run `grok`, stops it when you exit

## Prerequisites

- [Grok CLI](https://x.ai/cli) installed (`curl -fsSL https://x.ai/cli/install.sh | bash`)
- [Node.js](https://nodejs.org) (for npm/npx)
- An OpenAI Codex subscription (ChatGPT Plus, Pro, Business, Enterprise, Edu, or Go)

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/Arjun-Ingole/grok-codex/main/install.sh | bash
```

Or manually:

```bash
git clone https://github.com/Arjun-Ingole/grok-codex.git
cd grok-codex
./grok-codex setup
```

## Usage

After setup, just use `grok` as normal — no X/Twitter login needed:

```bash
grok                    # TUI with GPT-5.5 (default)
grok -m gpt-5.4        # Use GPT-5.4
grok -m gpt-5.4-mini   # Fast mini model
grok -m gpt-5.3-codex  # Industry-leading coding model
grok models             # List all available models
```

## Available Models

| Model | Description |
|-------|-------------|
| `gpt-5.5` | Newest frontier model, 1M context (default) |
| `gpt-5.4` | Flagship + stronger reasoning |
| `gpt-5.4-mini` | Fast mini for lighter tasks |
| `gpt-5.3-codex` | Industry-leading coding model |
| `gpt-5.2` | Previous gen, deep deliberation |

Models are determined by your Codex subscription tier. Run `grok-codex models` to see what's available on your account.

## Commands

```
grok-codex setup       # Install and configure everything
grok-codex uninstall   # Remove all grok-codex configuration
grok-codex status      # Check current setup status
grok-codex models      # List models available on your account
grok-codex accounts    # List available Codex accounts
grok-codex switch      # Switch to a different Codex account
grok-codex help        # Show help
```

## Multi-Account Support

If you have multiple Codex accounts (e.g., personal + team, Plus + Business), you can switch between them without reconfiguration.

### List accounts

```bash
grok-codex accounts
```

Output:
```
     ACCOUNT                  PLAN      5H USAGE     WEEKLY USAGE            LAST ACTIVITY
------------------------------------------------------------------------------------------
  01 arjun@pazy.io            Business  0% (16:08)   26% (10:10 on 11 Jun)   4m ago       
* 02 arjuningole38@gmail.com  Plus      99% (20:29)  100% (15:29 on 17 Jun)  Now          
```

The `*` marks the currently active account.

### Switch accounts

```bash
# Switch by email
grok-codex switch arjun@pazy.io

# Or by account number
grok-codex switch 01
```

The next time you run `grok`, it will use the switched account automatically.

### Check active account

```bash
grok-codex status
```

Shows the currently active Codex account and all other setup info.

> **Note:** Multi-account support requires [`codex-auth`](https://github.com/EvanZhouDev/codex-auth) to be installed. Install via: `brew install codex-auth`

## How it works

1. **OAuth proxy**: Uses [openai-oauth](https://github.com/EvanZhouDev/openai-oauth) which reads your `~/.codex/auth.json` (created by `codex login`) and proxies requests to OpenAI's Codex backend (`chatgpt.com/backend-api/codex/responses`)

2. **Auth bypass**: Sets `XAI_API_KEY` (dummy value) and `[endpoints] models_base_url` in Grok's config, which makes Grok skip X/Twitter auth and use API-key mode instead

3. **Wrapper script**: A thin bash wrapper (`~/.grok/bin/grok-with-codex`) that starts the proxy before launching Grok and cleans up on exit

4. **Shell alias**: Overrides the `grok` command to use the wrapper

5. **Multi-account support**: Integrates with [`codex-auth`](https://github.com/EvanZhouDev/codex-auth) to automatically use whichever account is currently active

## If your auth expires

```bash
npx @openai/codex login
```

This refreshes `~/.codex/auth.json`. The proxy auto-discovers the updated tokens.

## Configuration

| Environment Variable | Default | Description |
|---------------------|---------|-------------|
| `GROK_CODEX_PORT` | `10531` | Port for the local proxy |
| `GROK_HOME` | `~/.grok` | Grok configuration directory |
| `CODEX_HOME` | `~/.codex` | Codex configuration directory |

## Uninstall

```bash
grok-codex uninstall
```

This removes the wrapper, shell alias, and model config. Your Grok CLI returns to default (X/Twitter auth).

## Troubleshooting

**Proxy fails to start**
```bash
# Check logs
cat /tmp/openai-oauth.log

# Refresh Codex auth
npx @openai/codex login
```

**Grok still asks for X/Twitter login**
```bash
# Verify setup
grok-codex status

# Re-run setup
grok-codex setup
```

**Context window shows wrong size**
The `context_window` values are set in `~/.grok/config.toml`. Edit the `[model."gpt-5.5"]` section to adjust.

## License

MIT
