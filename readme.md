----------------------------------------------------------------------------------------------------
make_class.py
this takes in the same data file, and outputs .ini files to be put into a mod folder in the game
* XComClassData.ini - this holds the class definitions for each soldier
* XComGameData.ini - this holds the initial loadout definitions for each soldier

----------------------------------------------------------------------------------------------------
gather_ability_info.py
this one reads stuff out of the 'examples' folder and compiles an organized list of abilities
with the appropriate data and the descriptions from the localization text if they can be found.
This list accounts for things that have actually been used as part of a class; there are many more
named abilities in the descriptive text but without the context information of how they are used,
those can't be used without time-consuming teting.

----------------------------------------------------------------------------------------------------
update_ability_sheet.py
This thing will take the organized-but-still raw set of abilities that we get as the result of 
gather_ability_data, and updates to the sheet in the 'data' file.  It'll keep the existing marks 
for notes, tags, and the usage by the characters, but will update the list itself, by:
- filling in newly found abilities at the bottom
- filling in labels to any that don't already have one, when available
- replacing the 'usage' with the latest version
- replacing the 'weapons' with the latest version
- marking as obsolete lines that are no longer found
