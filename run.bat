@ECHO OFF

REM ECHO ---------------------------------------------------------------------------------
REM ECHO Pull in the perk data from the mods specified
REM ECHO ---------------------------------------------------------------------------------
REM CALL gather_ability_info

REM ECHO ---------------------------------------------------------------------------------
REM ECHO Update abilities and do the mapping
REM ECHO ---------------------------------------------------------------------------------
REM IF EXIST map_abilities_from_class.xlsx del map_abilities_from_class.xlsx
REM CALL marauder data\abilities_from_class.xlsx

REM ECHO ---------------------------------------------------------------------------------
REM ECHO Make the mod files
REM ECHO ---------------------------------------------------------------------------------
CALL make_classes
