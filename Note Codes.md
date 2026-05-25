## World_IncreaseInteractionStage()
is a native engine command in Company of Heroes 2 used to dynamically manage progressive map layout changes during a mission. Its primary purpose is to advance the map's current Interaction/Inactivity State, which drops active boundary restrictions and expands the playable area for the player.

When maps are designed with out-of-bounds layers (e.g., Stage 1 borders), calling this function removes the dynamic black fog/shroud restrictions, allows the player's units to move into the newly opened territory, and updates the minimap boundaries in real-time.

- [Support Files Scenario Pack](http://modding.companyofheroes.com/scenario-pack)
- [Support Files Win Condition](http://modding.companyofheroes.com/win-condition-pack)
