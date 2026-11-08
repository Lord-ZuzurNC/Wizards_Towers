class_name CardCatalog
extends RefCounted
## Loads every card of a folder, by id.

const DEFAULT_FOLDER := "res://data/cards"


static func load_folder(folder := DEFAULT_FOLDER) -> Dictionary[StringName, Card]:
	var cards: Dictionary[StringName, Card] = { }
	for file in ResourceLoader.list_directory(folder):
		var card := load(folder.path_join(file)) as Card
		if card != null:
			cards[card.id] = card
	return cards
