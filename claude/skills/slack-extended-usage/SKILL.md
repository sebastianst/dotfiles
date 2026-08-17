---
name: slack-extended-usage
description: Use when creating or editing a Slack message draft with slack_send_message_draft, or when composing a message for a Slack Connect (externally shared) channel where direct sends are refused.
---

# Slack Extended Usage

## Overview

The draft path runs a broken markdown conversion. `slack_send_message` is unaffected — this applies only to drafts, which are unavoidable on Slack Connect (externally shared) channels, where a direct send fails with `mcp_externally_shared_channel_restricted`.

## The rule

**Put the message body inside a ``` fence. Keep `<@USERID>` mentions outside it.**

The converter skips fenced content entirely — text arrives byte-for-byte and the fence markers themselves are consumed, so the draft is sendable as-is with no cleanup.

Mentions must stay outside: a mention *inside* a fence fails the call with `invalid_blocks` and creates no draft at all. Mentions before and after a fence both resolve to proper chips.

**The fence must be exactly three backticks.** A four-backtick fence is not recognised — the content is converted instead of skipped (emphasis eaten, quotes flattened) and the delimiters leak into the message as literal `~~~`. Consequently **you cannot nest a code block inside the body**, since an inner ``` would close the outer fence. For a command or snippet, use single-backtick inline code, or send it as a separate message.

````
<@U09C5ABCDEF> mind reviewing?

```
*Root cause:* `init_nvme.sh` exits 127, so NVMe never mounts.
PR: [foo#123](https://github.com/ethereum-optimism/foo/pull/123)
- removes the 4 dead nodes
```
````

## What survives to the sent message

Fenced content reaches the composer as literal text, then Slack renders it as **mrkdwn** on send. So inside the fence, write Slack's native syntax, not standard markdown. Verified end-to-end by sending each case and reading it back through the API:

| Inside the fence | Sent result |
|---|---|
| `*bold*` (single asterisk) | **bold** |
| `_italic_` | _italic_ |
| `~strike~` (single tilde) | struck |
| `` `code` `` | monospace |
| `>quoted` at the **start of a line** | blockquote |
| `[label](url)` | real labelled link (`<url\|label>`) |
| bare URL | auto-linked |
| `- item` | bullet list (`•`) |
| `**bold**` `~~strike~~` (standard markdown) | **literal characters** — the markers show up in the message |

The doubled forms are the trap: `**bold**` and `~~strike~~` are standard markdown, which nothing downstream understands, so the delimiters ship as visible junk. Halve them.

## Why fence at all

Outside the fence there is nothing to gain and one silent failure to lose:

- `[label](url)` **drops the URL** and keeps only the label — confirmed in the *sent* message, not just the composer. The message looks intentional and the destination is gone.
- A bare URL that **ends a line with another line after it** emits broken mrkdwn `<…>` whose closing `>` lands past the newline, breaking the link and corrupting the next line. A URL with same-line trailing text, or one ending the message, is fine.
- Inline emphasis has its markers consumed with no styling applied — in **both** dialects, so `*bold*` fails here too. The fence is the only way to get emphasis at all.

`-` bullets and `>` quotes also need to be at the **start of a line** in either case; mid-line they stay literal.

Newlines and paragraph breaks are preserved either way.

## Common mistakes

- **Using `[label](url)` outside a fence** because it is correct for `slack_send_message`. In a draft the destination dies silently and the message still reads fine — nothing signals the loss.
- **Trusting the wrong source when checking formatting.** Three views disagree, and each is authoritative for different things. A plaintext *copy* cannot distinguish rendered from stripped, since both yield bare text. The *composer* does not predict the sent result — it shows fenced markdown literally that renders fine once sent. The *API* `text` from `slack_read_channel` is authoritative for mrkdwn-encoded entities (`<url|label>` proves a real link) but is a **lossy fallback** for block-level layout, so blank lines and block spacing can be absent from it while present in the message. Check links via the API, and check styling and layout by looking at the sent message.
- **Putting a mention inside the fence.** Hard failure, no draft created.

## Upstream

Bug lives in Slack's hosted MCP server (`https://mcp.slack.com/mcp`); the plugin is only an OAuth pointer, so nothing is fixable locally. Filed as slackapi/slack-skills-plugin#121.
