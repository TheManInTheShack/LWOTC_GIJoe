# ==============================================================================
# Mapify
# Read Excel-based data and maintain a mapping
# - sheets in map are:
#   - source/history of the file, tracking input versions and map runs
#   - contents/configuration, showing each field in each sheet
#     - need to have one or more key fields in each source sheet
#       - uniqueness will be enforced
#     - may have supplemental fields that are summarized/tracked separately
#       - can multiple sheets be melded in this way?
#       - Track unique answers across multiple fields/sheets
#       - Automatically map connections across tables with binaries
#   - one sheet for each item in configuration, with contents/history/user
# ==============================================================================

# ------------------------------------------------------------------------------
# Import
# ------------------------------------------------------------------------------
from datetime import datetime
import os
import sys
import re
import shutil
import argparse

import pandas as pd


pd.set_option("display.width", 10000)
pd.set_option("display.max_rows", 1000)
pd.set_option("display.max_columns", 12)

sys.stdout.reconfigure(encoding='utf-8')

# ------------------------------------------------------------------------------
# Command line interface
# ------------------------------------------------------------------------------
def cli():
    parser = argparse.ArgumentParser()
    parser.add_argument("dfile", type=str, help="data file to use as input")
    args = parser.parse_args()
    return args

# ------------------------------------------------------------------------------
# Initialize 
# ------------------------------------------------------------------------------
def initialize(args):
    init = {}
    return init

# ------------------------------------------------------------------------------
# Main
# ------------------------------------------------------------------------------
def main(args, init):
    # --------------------------------------------------------------------------
    # Start
    # --------------------------------------------------------------------------
    print("Starting...")

    # --------------------------------------------------------------------------
    # Probe around in the input data to determine what we're dealing with
    # --------------------------------------------------------------------------
    dinfo = retrieve_data_information(args.dfile)

    # --------------------------------------------------------------------------
    # Get the contents of the map if it already exists, or make a new one
    # --------------------------------------------------------------------------
    minfo = retrieve_map_information(dinfo)

    # --------------------------------------------------------------------------
    # Resolve the current set with the map
    # --------------------------------------------------------------------------
    #rinfo = resolve_current_and_map(dinfo, minfo)

    # --------------------------------------------------------------------------
    # Update the map
    # --------------------------------------------------------------------------
    #uinfo = write_updated_map_information(rinfo)

    # --------------------------------------------------------------------------
    # Save out the map
    # --------------------------------------------------------------------------
    #x = write_out_map_file(uinfo)

    # --------------------------------------------------------------------------
    # Finish
    # --------------------------------------------------------------------------
    print("...finished.")

# ------------------------------------------------------------------------------
# 
# ------------------------------------------------------------------------------
def retrieve_data_information(fpath):
    # --------------------------------------------------------------------------
    # Start
    # --------------------------------------------------------------------------
    print("...retrieving source data file information...")

    # --------------------------------------------------------------------------
    # Must exist and be the right kind of file
    # --------------------------------------------------------------------------
    if not os.path.isfile(fpath):
        print(f"Sorry, but the file {fpath} doesn't exist!")
        sys.exit()
    if not fpath.lower().endswith(".xlsx"):
        print("Sorry, but the input file must be a .xlsx!")
        sys.exit()

    # --------------------------------------------------------------------------
    # Get the file attributes 
    # --------------------------------------------------------------------------
    fname = os.path.basename(fpath)
    ftime = datetime.fromtimestamp(os.path.getmtime(fpath))
    fsize = os.path.getsize(fpath)

    # --------------------------------------------------------------------------
    # Read the file and get the sheet info
    # --------------------------------------------------------------------------
    sheets = {}
    xl = pd.ExcelFile(fpath)
    for sheet in xl.sheet_names:
        # ----------------------------------------------------------------------
        # Start a structure for this sheet
        # ----------------------------------------------------------------------
        sheets[sheet] = {}

        # ----------------------------------------------------------------------
        # Get a plain vanilla dataframe of the contents
        # ----------------------------------------------------------------------
        data = xl.parse(sheet, header=None)

        # ----------------------------------------------------------------------
        # Determine the proper column names
        # ----------------------------------------------------------------------
        if data.shape[1] > 0:
            colnames = data.iloc[0].fillna("").tolist()
        else:
            colnames = []

        colsgood = True
        if not len(set(colnames)) == len(colnames):
            colsgood = False

        if not colsgood:
            print("Sorry, but the column headers in row one of sheet {sheet} are not unique!")
            sys.exit()

        #sheets[sheet]['colnames'] = colnames

        data = data.drop(index=0)
        data.columns = colnames

        # ----------------------------------------------------------------------
        # Build up information about each column
        # ----------------------------------------------------------------------
        columns = {}
        for col in colnames:
            # ------------------------------------------------------------------
            # Make an entry for this column
            # ------------------------------------------------------------------
            columns[col] = {}
            
            # ------------------------------------------------------------------
            # Check for uniqueness
            # ------------------------------------------------------------------
            unique = False
            if len(set(data[col])) == len(data[col]):
                unique = True
            columns[col]['unique'] = unique

            # ------------------------------------------------------------------
            # Get the detected data type
            # ------------------------------------------------------------------
            columns[col]['dtype']  = data[col].dtypes

            # ------------------------------------------------------------------
            # Store various counts
            # ------------------------------------------------------------------
            counts = data[col].value_counts()
            columns[col]['tokens']     = len(counts)
            columns[col]['complexity'] = columns[col]['tokens'] / data.shape[0]
            columns[col]['blank']      = data.shape[0] - columns[col]['nonblank']
            columns[col]['nonblank']   = len(data[col].dropna())
            columns[col]['density']    = columns[col]['nonblank'] / data.shape[0]
            
        # ----------------------------------------------------------------------
        # Store the final shape and the data itself
        # ----------------------------------------------------------------------
        sheets[sheet]['numrecs'] = data.shape[0]
        sheets[sheet]['numcols'] = data.shape[1]
        sheets[sheet]['data']    = data

    # --------------------------------------------------------------------------
    # Consolidate
    # --------------------------------------------------------------------------
    dinfo = {}
    dinfo['fpath']    = fpath
    dinfo['fname']    = fname
    dinfo['ftime']    = ftime
    dinfo['fsize']    = fsize
    dinfo['sheets']   = sheets

    # --------------------------------------------------------------------------
    # Finish
    # --------------------------------------------------------------------------
    return dinfo

# ------------------------------------------------------------------------------
# Get the current state of the map...make a new one with an empty state if there
# isn't one already.
# ------------------------------------------------------------------------------
def retrieve_map_information(dinfo):
    # --------------------------------------------------------------------------
    # Imply the name of the map
    # --------------------------------------------------------------------------
    map_name = "map_" + dinfo['fname']
    
    # --------------------------------------------------------------------------
    # Maybe the file doesn't exist yet
    # --------------------------------------------------------------------------
    if not os.path.isfile(map_name):
        # ----------------------------------------------------------------------
        # Source is just the single row of what the file starts as
        # ----------------------------------------------------------------------
        src = {}
        src['Map_Version']   = 1
        src['File_Version']  = 1
        src['File_Name']     = map_name
        src['File_Size']     = dinfo['fsize']
        src['File_Time']     = dinfo['ftime']
        source = pd.DataFrame.from_dict(src, orient='index').T

        # ----------------------------------------------------------------------
        # Sheets is the sheet-level stuff
        # ----------------------------------------------------------------------
        snames = []
        snames.append("Sheet")
        snames.append("Alias")
        snames.append("Track")
        snames.append("Num_Cols")
        snames.append("Num_Recs")
        snames.append("Note")
        snames.append("Hist_Init")
        snames.append("Hist_Full")
        snames.append("Hist_Last")

        sdata = []
        for sheet in dinfo['sheets']:
            line = []
            line.append(sheet)
            line.append(sheet)
            line.append("x")
            line.append(dinfo['sheets'][sheet]['numcols'])
            line.append(dinfo['sheets'][sheet]['numrecs'])
            line.append("")
            line.append("ADD1")
            line.append("ADD1")
            line.append("ADD1")
            
            sdata.append(line)

        sheets = pd.DataFrame(sdata)
        sheets.columns = snames

        # ----------------------------------------------------------------------
        # Contents is a full listing of the sheets and columns
        # ----------------------------------------------------------------------
        cnames = []
        cnames.append("Sheet")
        cnames.append("Column")
        cnames.append("Track")
        cnames.append("Unique")
        cnames.append("Key")
        cnames.append("Markup")
        cnames.append("Data_Type")
        cnames.append("Hist_Init")
        cnames.append("Hist_Full")
        cnames.append("Hist_Last")

        cdata = []
        for sheet in dinfo['sheets']:
            for col in dinfo['sheets'][sheet]['columns']:
                unique = ""
                if col in dinfo['sheets'][sheet]['unique_cols']:
                    unique = "x"
                dtype = dinfo['sheets'][sheet]['data'][col].dtypes

                line = []
                line.append(sheet)
                line.append(col)
                line.append("x")
                line.append(unique)
                line.append("")
                line.append("")
                line.append(dtype)
                line.append("ADD1")
                line.append("ADD1")
                line.append("ADD1")

                cdata.append(line)


        contents = pd.DataFrame(cdata)
        contents.columns = cnames

        print("")
        print(source)
        print("")
        print(sheets)
        print("")
        print(contents)

        # ----------------------------------------------------------------------
        # Consolidate
        # ----------------------------------------------------------------------
        minfo = {}
        minfo['source']   = source
        minfo['sheets']   = sheets
        minfo['contents'] = contents

    # --------------------------------------------------------------------------
    # 
    # --------------------------------------------------------------------------
    else:
        minfo = {}

    # --------------------------------------------------------------------------
    # Finish
    # --------------------------------------------------------------------------
    return minfo

# ------------------------------------------------------------------------------
# Run
# ------------------------------------------------------------------------------
if __name__ == "__main__":
    start_time = datetime.utcnow()
    args = cli()
    init = initialize(args)
    main(args, init)
    end_time = datetime.utcnow()
    elapsed_time = end_time - start_time
    print("Elapsed time: " + str(elapsed_time))

