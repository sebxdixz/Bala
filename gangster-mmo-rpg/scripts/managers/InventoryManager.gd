extends Node
class_name InventoryManager

## Maneja el inventario del jugador y los items equipados

signal inventory_updated
signal item_added(item: Item)
signal item_removed(item: Item)
signal item_equipped(item: Item)

@export var max_inventory_slots: int = 20
var inventory_items: Array[Item] = []
var equipped_items: Dictionary = {}

func _ready():
	print("🎒 Inventory Manager initialized - Max slots: %d" % max_inventory_slots)
	
	# Crear algunos items de ejemplo para testing
	add_example_items()

func add_example_items():
	var example_items = ClothingItem.create_example_items()
	for item in example_items:
		add_item(item)
	
	print("✨ Added %d example items to inventory" % example_items.size())

func add_item(item: Item) -> bool:
	if inventory_items.size() >= max_inventory_slots:
		print("❌ Inventory full! Cannot add %s" % item.item_name)
		return false
	
	inventory_items.append(item)
	item_added.emit(item)
	inventory_updated.emit()
	
	print("✅ Added to inventory: %s (Slot %d/%d)" % [item.item_name, inventory_items.size(), max_inventory_slots])
	return true

func remove_item(item: Item) -> bool:
	var index = inventory_items.find(item)
	if index == -1:
		return false
	
	inventory_items.remove_at(index)
	item_removed.emit(item)
	inventory_updated.emit()
	return true

func equip_item(item: Item) -> bool:
	if item not in inventory_items:
		print("❌ Item not in inventory: %s" % item.item_name)
		return false
	
	# Por ahora equipar simplemente y mantener en inventario
	var player = get_tree().get_first_node_in_group("player")
	if player and player.has_method("equip_item"):
		player.equip_item(item)
		item_equipped.emit(item)
		return true
	
	return false

func get_items_by_type(item_type: Item.ItemType) -> Array[Item]:
	var filtered_items: Array[Item] = []
	for item in inventory_items:
		if item.item_type == item_type:
			filtered_items.append(item)
	return filtered_items

func get_inventory_value() -> int:
	var total_value = 0
	for item in inventory_items:
		total_value += item.price
	return total_value

func print_inventory():
	print("=== INVENTORY ===")
	print("Items: %d/%d" % [inventory_items.size(), max_inventory_slots])
	print("Total Value: $%d" % get_inventory_value())
	
	for i in range(inventory_items.size()):
		var item = inventory_items[i]
		var rarity_text = Item.Rarity.keys()[item.rarity]
		print("%d. %s [%s] - $%d (+%d flow)" % [i+1, item.item_name, rarity_text, item.price, item.flow_bonus])
	
	print("=================")
