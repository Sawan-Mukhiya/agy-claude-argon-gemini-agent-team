# Antigravity Team: Claude / Argon Supervisor + Gemini Flash Workers

A lightweight, ready-to-use team of AI agents for Google's Antigravity CLI (`agy`).

Instead of having one model do everything, this setup gives you a smart division of labor:
- **A smart lead model** (Claude 3.5/3.7 Sonnet, Opus, or Gemini 4 Argon) acts as the supervisor—breaking down problems, planning steps, and coordinating work.
- **Lightning-fast Gemini 3.8 Flash subagents** handle the heavy lifting—exploring the codebase, reproducing bugs, writing focused code fixes, and verifying diffs.

This gives you deep, reliable reasoning for decisions while keeping subagent tasks fast, responsive, and token-efficient.

---

## The Agent Team

1. **`claude-argon-supervisor`** *(Lead / Primary Agent)*  
   Plans the approach, delegates work to specialized subagents, and makes sure the final solution meets your goals.
2. **`flash-researcher`** *(Read-Only)*  
   Quickly searches the codebase, checks symbols/outlines, and reads docs without altering any files.
3. **`flash-debugger`** *(Read-Only)*  
   Reproduces bugs, runs targeted tests, and traces error stack traces to find the real root cause before code is touched.
4. **`flash-implementer`** *(Single Code Editor)*  
   The only worker authorized to edit files. It makes clean, minimal fixes matching project style.
5. **`flash-reviewer`** *(Read-Only)*  
   Audits the resulting code diff for bugs, edge cases, and regressions, and runs verification checks.

---

## Verified Model Routing

**You don't need to guess which model is running under the hood.**

- **Subagents run on Gemini 3.8 Flash**: Each worker is configured with `model: flash`. In Antigravity, this routes directly to Gemini 3.8 Flash (`gemini-3.8-flash-tiered`). The supervisor is also explicitly instructed to request `flash` during delegation, ensuring subagents never accidentally inherit or drain quota from your lead model.
- **Supervisor uses your preferred lead model**: Set your primary model to Claude Sonnet (great default), Claude Opus (for deep logic), or Gemini 4 Argon using `/model`. Setting `/effort low` in the CLI is also recommended for cost-efficient planning.

---

## Quick Setup (Initiated from GitHub)

Get started in seconds—no build step, compilation, or package manager required.

### 1. Clone the repository

```bash
git clone https://github.com/Sawan-Mukhiya/agy-claude-argon-gemini-agent-team.git
cd agy-claude-argon-gemini-agent-team
```
*(Or click **Code → Download ZIP** on GitHub and extract it).*

### 2. Add to your project

Choose whichever method fits your workflow best:

#### Option A: Just copy the `.agents` folder (Simplest & Recommended)
Copy the `.agents` folder into the root directory of your project:

```text
your-project/
  .agents/
    agents/
      claude-argon-supervisor/
      flash-researcher/
      flash-debugger/
      flash-implementer/
      flash-reviewer/
```

**That's all you need!** Antigravity automatically detects custom agents in your workspace's `.agents/agents/` folder as soon as you open the CLI. No installation scripts or dependencies needed.

#### Option B: Use the `install.ps1` helper (PowerShell)
If you prefer an automated copy:

```powershell
# Copy agents into an existing project folder:
.\install.ps1 -TargetDir "C:\path\to\your-project"

# Or overwrite existing versions in that project:
.\install.ps1 -TargetDir "C:\path\to\your-project" -Force

# Or make the team available across all projects on your machine (~/.gemini/config/agents/):
.\install.ps1 -Global
```

---

## How to Use in the CLI

1. **Start Antigravity** in your project folder:
   ```bash
   agy
   ```
   *(Or launch straight into the supervisor: `agy --agent claude-argon-supervisor`)*

2. **Pick your lead model**:
   Type `/model` and select Claude Sonnet, Claude Opus, or Gemini 4 Argon.  
   *(Tip: type `/effort low` to keep planning concise and cost-effective.)*

3. **Activate the supervisor**:
   Type `/agents`, select `claude-argon-supervisor`, and press `Enter` (then `Esc` to close the menu).

4. **Give it your coding task**:
   > *"Inspect the payment webhook, reproduce why signatures fail in production, implement the minimal safe fix, and verify with tests."*

5. **Sit back and monitor**:
   The supervisor coordinates the Flash workers in the background. You can open `/agents` at any time to inspect real-time progress, press `Alt+J` to jump to any subagent asking for approval, or press `Ctrl+K` to quickly approve pending actions.

---

## Built-In Safety & Peace of Mind

- **No file collisions**: Only `flash-implementer` writes files. Multiple agents never race or overwrite each other's changes.
- **Read-only guards**: Researcher, Debugger, and Reviewer have no file-writing tools. They can inspect, search, and diagnose safely.
- **Safe command execution**: Diagnostic commands and test runs operate within Antigravity's standard sandbox and permission system. Destructive actions always ask for your confirmation first.
- **Concise reports**: Workers report compact summaries back to the supervisor rather than dumping massive file logs, keeping your conversation clean and readable.

---

## Helpful References

- Antigravity Subagents Guide: https://antigravity.google/docs/subagents?tab=cli
- Agents Command (`/agents`): https://antigravity.google/docs/cli/commands/agents
- Antigravity CLI Reference: https://antigravity.google/docs/cli/reference
