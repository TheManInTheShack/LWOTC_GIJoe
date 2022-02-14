@ECHO OFF

REM ECHO use Breaker to transform the text-based power markup set to Excel
REM del "data\perks_markup.xlsx"
REM CALL breaker push "data\perks_markup.txt" "data\perks_markup.xlsx" "perks_config.txt"

REM ECHO Pull in the perk data from the mods specified
REM CALL gather_ability_info

ECHO Make the mod files
CALL make_classes
