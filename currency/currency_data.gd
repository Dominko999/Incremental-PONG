extends Resource
class_name CurrencyData

signal currency_amount_changed

@export var name : String
@export var display_name : String # Should be changed into a seperate
@export var icon : Texture2D      # resource (CurrencyString)
@export var type : GlobalEnums.CurrencyType

var amount_available : int = 0:
	set(value): 
		amount_available = value
		currency_amount_changed.emit()
		
var total_amount_collected : int = 0
