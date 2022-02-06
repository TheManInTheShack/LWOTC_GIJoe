@ECHO OFF

del "data\perks_markup.xlsx"

CALL breaker push "data\perks_markup.txt" "data\perks_markup.xlsx" "perks_config.txt"

