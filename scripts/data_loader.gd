extends Node

var rawdata:Variant=null
var data;


""" DEBUG
func _ready() -> void:
	for i in range(1,8):
		getLevelWords(i)
"""
		
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
## If eraseAfter is set, the field will be removed after filtering, if not, it will be left
##
## @param data: Variant - The Json Data to filter
## @param conditionName: String - The condition to check for
## @param conditionValue: The value of the condition to check for
## @param eraseAfter: bool - Erase the field after filtering
## @returns:
func filterJson(data:Variant,conditionName:String,conditionValue,eraseAfter:bool) -> Variant:
	var returnArray:Variant=[]
	var datacopy = data.duplicate(true)
	for entry in datacopy:
		if entry[conditionName]==conditionValue:
			if eraseAfter:
				if entry.has(conditionName):
					entry.erase(conditionName)
					returnArray+=[entry]
			else:
				returnArray+=[entry]
	return returnArray

## Sorts the provided variant data by difficulty.
##
## @param data: Variant - The data to be sorted
## @returns: Variant - The sorted data
func sortByDifficulty(data: Variant) -> Variant:
	data.sort_custom(Callable(func(a, b): return a["difficulty"] < b["difficulty"]))
	return data


## Get the words only for the specified level, in order that they should be spawned in. 
## Adds some randomness to the selection of difficulty.
##
## @param levelID: int - The levelID of the level to get the data for.
## @param randomness: int - The part of the array the random value can be chosen from (0..randomness).
## @returns: Variant - The spawn data in correct order.
# TODO: Increase randomness to take value from entire array rather than start
func getLevelWords(levelID:int,randomness:int=5)->Variant:
	var levelWords=[]
	if rawdata==null:
		rawdata=loadDatabaseData()
	# Note, this loads teh database data again each time a level is loaded and is very inefficient - but writing it into a variable breaks it.
	var workData = filterJson(rawdata,"level",levelID,true)
	var oldSize=workData.size()
	workData.shuffle()
	if levelID==1:
		workData.resize(15)
	elif levelID==2:
		workData.resize(25)
	elif levelID==0:
		workData.resize(150)
	else:
		workData.resize(15+5*levelID)
	if workData.size()<oldSize: push_error("The data in the database is too small! Some enemy arrays were filled with null pointers!")
		
	workData=sortByDifficulty(workData)
	# Load the words in ascending difficulty into the levelWords array with some randomness
	while workData.size()>0:
		var index=randi_range(0,min(randomness,workData.size()-1)) #Generate a random index to take out of workData from the first "randomness" values
		levelWords+=[workData[index]]
		workData.remove_at(index)
	
	return levelWords
	
