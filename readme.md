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
