---
name: Bug report
about: Create a report to help us improve
title: "[BUG] Report Template"
labels: bug
assignees: ''
type: Bug

---

**Describe the bug**
A clear and concise description of what the bug is.

**Game flavor & version**
- Flavor: [e.g. Retail, Classic Era, Classic Season of Discovery, Classic TBC, Classic WotLK, Classic Cataclysm, Classic MoP, Forever, other private]
- Game version / build: [e.g. 11.0.5 (57000) or Classic 1.15.4]
- Addon version: [e.g. v1.2.3 or commit hash]

**To Reproduce**
Steps to reproduce the behavior in-game:
1. Open / reload UI with the addon enabled
2. Go to '...'
3. Click / type '...'
4. See error / incorrect behavior

**Expected behavior**
A clear and concise description of what you expected to happen.

**Screenshots / video**
If applicable, add screenshots (or a short video) of the UI, error popup, or relevant frames. Drag-and-drop images directly into the issue.

**Exception / error logs**
Paste any Lua errors from:
- Chat (red text)
- BugSack / BugGrabber
- `/dump` or other relevant output
- `Errors` or `Blizzard_DebugTools` output


**Loaded addons**
List any other addons that were enabled when the bug occurred (especially ones that might conflict).  
`/dump GetAddOnMetadata("YourAddon", "Version")` or the full list from `/reload` + BugSack is helpful.

**Additional context**
- Did this start after a game patch, addon update, or profile change?
- Any relevant SavedVariables snippets or config options?
- Does it happen with only this addon enabled?
- Any other details that may help.
