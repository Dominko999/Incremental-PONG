extends VBoxContainer

class_name CurrencyContainer


@export var is_player_currency_display : bool = false:
	set(value):
		is_player_currency_display = value
		if is_inside_tree():
			connect_to_currency_changed()
			_update_display()

@export var currencies_to_display : Dictionary[GlobalEnums.CurrencyType, int] = {}: # accepts a dictionary with currency data and amount of that currency
	set(value):
		currencies_to_display = value
		_update_display()

func _init(price : Dictionary[GlobalEnums.CurrencyType, int] = {}, player_mode : bool = false) -> void:
	currencies_to_display = price
	is_player_currency_display = player_mode

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	connect_to_currency_changed()
	_update_display()

func connect_to_currency_changed():
	if is_player_currency_display:
		for currency_type in GlobalGameStats.currency_data_dictionary:
			var data = GlobalGameStats.currency_data_dictionary[currency_type]
			if not data.currency_amount_changed.is_connected(_update_display):
				data.currency_amount_changed.connect(_update_display)

func _update_display():
	for child in get_children():
		child.queue_free()
	
	if is_player_currency_display:
		for currency_type in GlobalGameStats.currency_data_dictionary:
			var currency_data = GlobalGameStats.currency_data_dictionary[currency_type]
			add_currency_row(currency_data, currency_data.amount_available)
	
	else:
		for currency_type in currencies_to_display:
			var amount = currencies_to_display[currency_type] #gets the amount of curency to display
			var currency_data = GlobalGameStats.currency_data_dictionary[currency_type] # gets the data of said currency 
			add_currency_row(currency_data, amount)


func add_currency_row(currency_data, amount):
	var container = HBoxContainer.new()
	container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if is_player_currency_display:
		container.alignment = BoxContainer.ALIGNMENT_BEGIN
	else:
		container.alignment = BoxContainer.ALIGNMENT_CENTER
	var label = Label.new()
	var icon_rect = TextureRect.new()
	icon_rect.texture = currency_data.icon # currency_data.icon is a texture2D
	icon_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	container.add_theme_constant_override("separation", 10)
	
	icon_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon_rect.custom_minimum_size = Vector2(32, 32) 
	icon_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	
	
	label.text = str(amount)
	add_child(container)
	container.add_child(icon_rect)
	container.add_child(label)
