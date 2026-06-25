# Architecture

## Agents

**Hermes (Brain / Orchestrator)**
Routes to Groq `openai/gpt-oss-120b`. Handles all planning, task decomposition, memory, and coordination. Talks to the human in `#sprint-main`. Has persistent memory so it can recall context across sessions without being re-briefed.

**OpenClaw (Hands / Coder)**
Routes to Ollama `qwen2.5-coder` locally. Receives task specs from Hermes in `#agent-coder`, writes code, runs shell commands, and reports back with a structured What I Did / What's Left / What Needs Your Call update.

---

## Slack Channels

| Channel | Who uses it | Purpose |
|---|---|---|
| `#sprint-main` | Human + Hermes | Goal setting, plans, approvals, status reports |
| `#agent-coder` | Hermes + OpenClaw | Task handoffs, code output, agent reports |
| `#agent-log` | Hermes (auto) | Autonomous cron runs, raw activity trail |

---

## Model Routing

**Hermes → Groq `openai/gpt-oss-120b`**
Used for planning because it has strong reasoning and handles long structured outputs well. The planning step runs infrequently so the free rate limit is not a problem.

**OpenClaw → Ollama `qwen2.5-coder`**
Used for coding because it runs locally (no rate limits, no cost), is specifically fine-tuned for code generation, and coding tasks run in tight loops that would burn through a cloud API's free tier quickly.

---

## App Structure

```
forge2-kanban/
├── backend/          # Laravel 11 REST API (SQLite)
├── frontend/         # React 19 + Vite SPA
├── skills/           # Hermes reusable skills
├── agent-log.md      # Chat transcript of the agent loop
├── ARCHITECTURE.md   # This file
└── README.md
```

---

## Data Model

```
Board
  └── KanbanList (ordered by position)
        └── Card
              ├── Tag (many-to-many)
              └── Member (many-to-many)
```
