extends Node

var data;

func _ready() -> void:
	data = loadDatabaseData()

## Load the appropriate data from the database for the level provided.
##
## @returns: Variant - the json data (full)
func loadDatabaseData() -> Variant:
	# Open file
	var json_string = FileAccess.open("res://data/database.json",FileAccess.READ).get_as_text()
	var json = JSON.new()
	var error = json.parse(json_string)
	var data_received
	if error == OK:
		data_received = json.data
	else:
		push_error("There has been an error in the loading and parsing of the json string.")
	return data_received[GlobalState.language]

## Filter the json data by the provided arguments. Checks if the field "conditionName" has a value of "conditionValue"
##
## @param data: Variant - The Json Data to filter
## @param conditionName: String - The condition to check for
## @param conditionValue: The value of the condition to check for
## @returns:
func filterJson(data:Variant,conditionName:String,conditionValue) -> Variant:
	var returnArray:Variant=[]
	for entry in data:
		if entry[conditionName]==conditionValue:
			returnArray+=[entry]
	return returnArray

## Get the words only for the specified level
##
##
func getLevelWords(levelID:int):
	pass
	
