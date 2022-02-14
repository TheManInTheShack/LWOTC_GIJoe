@ECHO OFF

CALL pyinstaller ^
 --clean ^
 --onefile --nowindow ^
 --log-level DEBUG ^
 game_text_dominator.py
