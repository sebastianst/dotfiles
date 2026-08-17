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

- `[label](url)` **drops the URL** and keeps only the label — the message looks intentional and the destination is gone.
- A bare URL with content after it emits broken mrkdwn `<…>` that also corrupts the following line.
- Inline emphasis has its markers consumed with no styling applied.

Newlines and paragraph breaks are preserved either way.

## Common mistakes

- **Using `[label](url)` outside a fence** because it is correct for `slack_send_message`. In a draft the destination dies silently and the message still reads fine — nothing signals the loss.
- **Judging a draft by copying its text out of Slack.** A plaintext copy cannot distinguish rendered from stripped, and the composer renders links differently from the sent message. To settle a formatting question, send it and read it back with `slack_read_channel` — the raw API text shows `<url|label>` for real links.
- **Putting a mention inside the fence.** Hard failure, no draft created.

## Upstream

Bug lives in Slack's hosted MCP server (`https://mcp.slack.com/mcp`); the plugin is only an OAuth pointer, so nothing is fixable locally. Filed as slackapi/slack-skills-plugin#121.
