extends Label

@export var currency : CurrencyData
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	currency.currency_amount_changed.connect(_on_currency_changed)
	update_label(currency.amount_available)

func _on_currency_changed():
		update_label(currency.amount_available)

func update_label(value):
	text = str(value)
