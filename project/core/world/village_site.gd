class_name VillageSite
extends Resource
## Where a village stands in a room, and its name.
##
## Villages belong on the world map; until it exists, a room holds them so buying one can be
## tried. Names will be generated with the world (GLOSSARY.md, village).

@export var title := ""
@export var tile := Vector2i()
