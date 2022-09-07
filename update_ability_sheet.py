# ==============================================================================
# This thing will take the organized-but-still raw set of abilities that we get
# as the result of gather_ability_data, and updates to the sheet in the 'data'
# file.  It'll keep the existing marks for notes, tags, and the usage by the
# characters, but will update the list itself, by:
# - filling in newly found abilities at the bottom
# - filling in labels to any that don't already have one, when available
# - replacing the 'usage' with the latest version
# - replacing the 'weapons' with the latest version
# - marking as obsolete lines that are no longer found
# ==============================================================================

# ------------------------------------------------------------------------------
# Import
# ------------------------------------------------------------------------------
from datetime import datetime
import os
import sys
import re
import shutil
import math

import openpyxl as xl
import pandas as pd

# ------------------------------------------------------------------------------
# Init
# ------------------------------------------------------------------------------
pd.set_option("display.width", 10000)
pd.set_option("display.max_rows", 20)
pd.set_option("display.max_columns", 6)

sys.stdout.reconfigure(encoding='utf-8')

source_file = "data\\abilities_from_class.xlsx"
config_file = "data\\data.xlsx"

# ------------------------------------------------------------------------------
# Main
# ------------------------------------------------------------------------------
def main():
    # --------------------------------------------------------------------------
    # Start
    # --------------------------------------------------------------------------
    print("Starting...")

    # --------------------------------------------------------------------------
    # Get the source data
    # --------------------------------------------------------------------------
    source_data = pd.read_excel(source_file, index_col=2)
    source_data = source_data.sort_values(by='ability')
    source_data['friendlyname'] = source_data['friendlyname'].fillna("")
    source_data['longdesc'] = source_data['longdesc'].fillna("")
    source_data['helptext'] = source_data['helptext'].fillna("")
    source_data['flyover'] = source_data['flyover'].fillna("")
    source_data['promo'] = source_data['promo'].fillna("")

    print(source_data.columns.to_list())
    print(source_data)

    # --------------------------------------------------------------------------
    # Get the current state of the map data
    # --------------------------------------------------------------------------
    map_data = pd.read_excel(config_file, sheet_name="abilities", skiprows=7, index_col=0)
    map_data = map_data.sort_values(by='ability')
    print(map_data.columns.to_list())
    print(map_data)

    # --------------------------------------------------------------------------
    # Update the data in the model
    # --------------------------------------------------------------------------
    new_data = make_updated_data(source_data, map_data)

    # --------------------------------------------------------------------------
    # Apply the model to the sheet
    # --------------------------------------------------------------------------

    # --------------------------------------------------------------------------
    # Finish
    # --------------------------------------------------------------------------
    print("...finished.")

# ------------------------------------------------------------------------------
# 
# ------------------------------------------------------------------------------
def make_updated_data(source_data, map_data):
    # --------------------------------------------------------------------------
    # Start
    # --------------------------------------------------------------------------
    print("...compiling updated data...")

    # --------------------------------------------------------------------------
    # Compile a master list, as well as indicate if they are static, new,
    # updated, or removed
    # --------------------------------------------------------------------------
    master = {}
    for ability, row in map_data.iterrows():
        master[ability] = "removed"

    for ability, row in source_data.iterrows():
        # ----------------------------------------------------------------------
        # 
        # ----------------------------------------------------------------------
        label = row['longdesc']
        if not label:
            label = row['helptext']
        if not label:
            label = row['flyover']
        if not label:
            label = row['promo']

        # ----------------------------------------------------------------------
        # 
        # ----------------------------------------------------------------------
        if ability in master:
            if not label == map_data.loc[ability]['desc']:
                print(label)
                print(map_data.loc[ability]['desc'])
                master[ability] = "updated"
            elif not row['usage'] == map_data.loc[ability]['usage']:
                master[ability] = "updated"
            elif not row['weapons'] == map_data.loc[ability]['weapons']:
                master[ability] = "updated"
            else:
                master[ability] = "static"
        else:
            master[ability] = "new"

    for item in master:
        print(item, master[item])

    # --------------------------------------------------------------------------
    # We'll pass back a matrix that we'll make a line at a time
    # --------------------------------------------------------------------------
    new_data = []

    # --------------------------------------------------------------------------
    # Finish
    # --------------------------------------------------------------------------
    return new_data

# ------------------------------------------------------------------------------
# Run
# ------------------------------------------------------------------------------
if __name__ == "__main__":
    start_time = datetime.utcnow()
    main()
    end_time     = datetime.utcnow()
    elapsed_time = end_time - start_time
    print("Elapsed time: " + str(elapsed_time))

