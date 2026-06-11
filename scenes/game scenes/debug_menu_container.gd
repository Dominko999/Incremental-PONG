extends PanelContainer

var is_shown : bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	#if Input.is_action_just_pressed("ui_open_debug"):
		#if is_shown:
			#hide()
			#is_shown = false
		#else:
			#show()
			#is_shown = true
	

func _on_add_ten_blue_button_pressed() -> void:
	GlobalGameStats.currency_data_dictionary[GlobalEnums.CurrencyType['BLUE']].amount_available += 10


func _on_add_thousand_blue_button_pressed() -> void:
	GlobalGameStats.currency_data_dictionary[GlobalEnums.CurrencyType['BLUE']].amount_available += 1000



func _on_add_ten_red_button_pressed() -> void:
	GlobalGameStats.currency_data_dictionary[GlobalEnums.CurrencyType['RED']].amount_available += 10



func _on_add_thousand_red_button_pressed() -> void:
	GlobalGameStats.currency_data_dictionary[GlobalEnums.CurrencyType['RED']].amount_available += 1000


func _on_clear_all_currencies_button_pressed() -> void:
	for type in GlobalEnums.CurrencyType:
		if GlobalGameStats.currency_data_dictionary[GlobalEnums.CurrencyType[type]]:
			GlobalGameStats.currency_data_dictionary[GlobalEnums.CurrencyType[type]].amount_available = 0
