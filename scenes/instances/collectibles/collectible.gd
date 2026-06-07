extends Area2D
class_name Collectible

@export var currency_rewards : Array[CurrencyReward] # an resource that stores the id and amount of currency earned after collecting the collectible
@export var collected_sfx : GlobalEnums.Sounds = -1


func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("currency_collector"):
		collect()
	if body.is_in_group("left_edge"):
		queue_free()

func collect():
	if currency_rewards != null:
		for currency_reward in currency_rewards:
			GlobalGameStats.add_currency(currency_reward.currency, currency_reward.amount)
	
	if collected_sfx != -1:
		GlobalSoundManager.play_sfx(collected_sfx, true)
		
	
	queue_free()
