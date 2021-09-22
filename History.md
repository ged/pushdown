# Release History for pushdown

---
## v0.4.0 [2021-09-21] Michael Granger <ged@faeriemud.org>

Improvements:

- Report operator arguments in the spec matcher failure output.
- Allow the State event callback to accept additional arguments.


## v0.3.0 [2021-09-01] Michael Granger <ged@faeriemud.org>

Change:

- Rework how state data is passed around. Instead of passing it through the
  transition callbacks, which proved to be a terrible idea, the States
  themselves take an optional state argument to their constructor.


## v0.2.0 [2021-08-31] Michael Granger <ged@faeriemud.org>

Improvements:

- Move responsibility for creating transitions into State.
- Add spec helpers with a transition matcher.
- Add missing event handler method to State


## v0.1.0 [2021-08-27] Michael Granger <ged@faeriemud.org>

Initial release.

