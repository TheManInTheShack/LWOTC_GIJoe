@ECHO OFF

REM ECHO ---------------------------------------------------------------------------------
REM ECHO Pull in the perk data from the mods specified
REM ECHO ---------------------------------------------------------------------------------
REM CALL gather_ability_info

ECHO ---------------------------------------------------------------------------------
ECHO Update abilities and do the mapping
ECHO ---------------------------------------------------------------------------------
CALL mapify data\abilities_from_class.xlsx

REM ECHO ---------------------------------------------------------------------------------
REM ECHO Make the mod files
REM ECHO ---------------------------------------------------------------------------------
REM CALL make_classes
