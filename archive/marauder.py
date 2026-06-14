# ==============================================================================
# Marauder
# Read Excel-based data and maintain a mapping
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

import openpyxl as xl
import pandas as pd

from dopes.excel_tools import can_write_to_excel, write_matrix_to_excel_sheet, write_excel_sheet, apply_formatting_to_cell
from dopes.mapping_tools import read_map_sheet

pd.set_option("display.width", 10000)
pd.set_option("display.max_rows", 1000)
pd.set_option("display.max_columns", 20)

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
    print("I solemnly swear that I am up to no good...")

    # --------------------------------------------------------------------------
    # Probe around in the input data to determine what we're dealing with
    # --------------------------------------------------------------------------
    dinfo = retrieve_data_information(args.dfile)

    # --------------------------------------------------------------------------
    # Get the contents of the map if it already exists, or make a new one
    # --------------------------------------------------------------------------
    minfo = retrieve_map_information(dinfo)

    # --------------------------------------------------------------------------
    # Resolve the current set with the map and make a list of differences
    # --------------------------------------------------------------------------
    rinfo = resolve_current_and_map(dinfo, minfo)

    # --------------------------------------------------------------------------
    # Remake the map data structure taking differences into account
    # --------------------------------------------------------------------------
    uinfo = write_updated_map_information(minfo, rinfo)

    # --------------------------------------------------------------------------
    # Save out the map
    # --------------------------------------------------------------------------
    x = write_out_map_file(uinfo)

    # --------------------------------------------------------------------------
    # Finish
    # --------------------------------------------------------------------------
    print("...mischief managed.")

# ------------------------------------------------------------------------------
# Read the input excel file and examine all of the sheets
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
            # Store various counts
            # ------------------------------------------------------------------
            counts = data[col].value_counts()
            columns[col]['tokens']     = len(counts)
            columns[col]['complexity'] = columns[col]['tokens'] / data.shape[0]
            columns[col]['nonblank']   = len(data[col].dropna())
            columns[col]['blank']      = data.shape[0] - columns[col]['nonblank']
            columns[col]['density']    = columns[col]['nonblank'] / data.shape[0]

            # ------------------------------------------------------------------
            # Get the default data type
            # ------------------------------------------------------------------
            columns[col]['dtype']  = str(data[col].dtypes)

            # ------------------------------------------------------------------
            # Detect the data type as we want to think of it
            # ------------------------------------------------------------------
            vals = sorted([x for x in counts.index if not x == ""])
            if len(vals) == 0:
                content = "empty"
            else:
                type1 = type(vals[0])
                type2 = type(vals[-1])

                if type1 is str or type2 is str:
                    content = "text"
                elif type1 is float or type2 is float:
                    content = "float"
                elif type1 is int and type2 is int:
                    content = "integer"
                else:
                    print("WARNING! TYPE DETECTION FLAW: ", vals[0], type1, vals[-1], type2)
                    sys.exit()

            columns[col]['content']  = content
            
        # ----------------------------------------------------------------------
        # Store the final shape and the data itself
        # ----------------------------------------------------------------------
        sheets[sheet]['numrecs'] = data.shape[0]
        sheets[sheet]['numcols'] = data.shape[1]
        sheets[sheet]['data']    = data
        sheets[sheet]['columns'] = columns

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
    # User info
    # --------------------------------------------------------------------------
    print(f"...looking for map file {map_name}...")
    
    # --------------------------------------------------------------------------
    # Maybe the file doesn't exist yet
    # --------------------------------------------------------------------------
    if not os.path.isfile(map_name):
        # ----------------------------------------------------------------------
        # User info
        # ----------------------------------------------------------------------
        print("...file not found, creating new mapping data...")

        # ----------------------------------------------------------------------
        # Source is just the single row of what the file starts as
        # ----------------------------------------------------------------------
        src = {}
        src['Map Version']   = 1
        src['File Version']  = 1
        src['File Name']     = map_name
        src['File Size']     = dinfo['fsize']
        src['File Time']     = dinfo['ftime']
        source = pd.DataFrame.from_dict(src, orient='index').T

        # ----------------------------------------------------------------------
        # Sheets is the sheet-level stuff
        # ----------------------------------------------------------------------
        snames = []
        snames.append("Sheet")
        snames.append("Alias")
        snames.append("Num Cols")
        snames.append("Num Recs")
        snames.append("Hist Init")
        snames.append("Hist Full")
        snames.append("Hist Last")
        snames.append("Track")

        sdata = []
        for sheet in dinfo['sheets']:
            line = []
            line.append(sheet)
            line.append(sheet)
            line.append(dinfo['sheets'][sheet]['numcols'])
            line.append(dinfo['sheets'][sheet]['numrecs'])
            line.append("ADD1")
            line.append("ADD1")
            line.append("ADD1")
            line.append("x")
            
            sdata.append(line)

        sheets = pd.DataFrame(sdata)
        sheets.columns = snames

        # ----------------------------------------------------------------------
        # Contents is a full listing of the sheets and columns
        # ----------------------------------------------------------------------
        cnames = []
        cnames.append("Sheet")
        cnames.append("Column")
        cnames.append("Data Type")
        cnames.append("Content")
        cnames.append("Unique")
        cnames.append("Tokens")
        cnames.append("Complexity")
        cnames.append("Nonblanks")
        cnames.append("Blanks")
        cnames.append("Density")
        cnames.append("Hist Init")
        cnames.append("Hist Full")
        cnames.append("Hist Last")
        cnames.append("Track")
        cnames.append("Key")
        cnames.append("Markup")

        cdata = []
        for sheet in dinfo['sheets']:
            for col in dinfo['sheets'][sheet]['columns']:
                unique     = dinfo['sheets'][sheet]['columns'][col]['unique']
                dtype      = dinfo['sheets'][sheet]['columns'][col]['dtype']
                content    = dinfo['sheets'][sheet]['columns'][col]['content']
                tokens     = dinfo['sheets'][sheet]['columns'][col]['tokens']
                complexity = dinfo['sheets'][sheet]['columns'][col]['complexity']
                nonblank   = dinfo['sheets'][sheet]['columns'][col]['nonblank']
                blanks     = dinfo['sheets'][sheet]['columns'][col]['blank']
                density    = dinfo['sheets'][sheet]['columns'][col]['density']

                line = []
                line.append(sheet)
                line.append(col)
                line.append(dtype)
                line.append(content)
                line.append(unique)
                line.append(tokens)
                line.append(complexity)
                line.append(nonblank)
                line.append(blanks)
                line.append(density)
                line.append("ADD1")
                line.append("ADD1")
                line.append("ADD1")
                line.append("x")
                line.append("")
                line.append("")

                cdata.append(line)


        fields = pd.DataFrame(cdata)
        fields.columns = cnames

        # ----------------------------------------------------------------------
        # Consolidate
        # ----------------------------------------------------------------------
        minfo = {}
        minfo['map_name'] = map_name
        minfo['source']  = source
        minfo['sheets']  = sheets
        minfo['fields']  = fields
        minfo['newmap']  = True

    # --------------------------------------------------------------------------
    # If the map already exists, read in everything and validate it
    # --------------------------------------------------------------------------
    else:
        # ----------------------------------------------------------------------
        # User info
        # ----------------------------------------------------------------------
        print("...file found, parsing existing mapping data...")
        minfo = {}
        minfo['map_name'] = map_name
        minfo['source'] = read_map_sheet(map_file, "Source Data File")
        minfo['sheets'] = read_map_sheet(map_file, "Contents - Sheets")
        minfo['fields'] = read_map_sheet(map_file, "Contents - Fields")
        minfo['newmap'] = False
        #TODO

    #print("")
    #print(minfo['source'])
    #print("")
    #print(minfo['sheets'])
    #print("")
    #print(minfo['fields'])
    #print("")
    #print(minfo['newmap'])

    # --------------------------------------------------------------------------
    # Finish
    # --------------------------------------------------------------------------
    return minfo

# ------------------------------------------------------------------------------
# Interpret the current data against the map and make a list of needed updates
# ------------------------------------------------------------------------------
def resolve_current_and_map(dinfo, minfo):
    # --------------------------------------------------------------------------
    # Start
    # --------------------------------------------------------------------------
    print("...resolving current data with map data...")

    # --------------------------------------------------------------------------
    # If it's new, there are no differences, so just move along
    # --------------------------------------------------------------------------
    if minfo['newmap']:
        return {}

    # --------------------------------------------------------------------------
    # Finish
    # --------------------------------------------------------------------------
    return rinfo

# ------------------------------------------------------------------------------
# Make a clean updated version of the map info
# ------------------------------------------------------------------------------
def write_updated_map_information(minfo, rinfo):
    # --------------------------------------------------------------------------
    # Start
    # --------------------------------------------------------------------------
    print("...updating map information...")

    # --------------------------------------------------------------------------
    # If it's new, it's just what we made earlier
    # --------------------------------------------------------------------------
    if minfo['newmap']:
        uinfo = minfo.copy()
        return uinfo

    # --------------------------------------------------------------------------
    # 
    # --------------------------------------------------------------------------
    uinfo = {}
        #TODO

    # --------------------------------------------------------------------------
    # Finish
    # --------------------------------------------------------------------------
    return uinfo

# ------------------------------------------------------------------------------
# Format and write out the map document
# ------------------------------------------------------------------------------
def write_out_map_file(uinfo):
    # --------------------------------------------------------------------------
    # Start
    # --------------------------------------------------------------------------
    print(f"...writing out map file {uinfo['map_name']}...")

    # --------------------------------------------------------------------------
    # Add the titles to the components and hold them as matrices
    # --------------------------------------------------------------------------
    source_data = prep_table_for_output(uinfo['source'], "Source Data File")
    sheets_data = prep_table_for_output(uinfo['sheets'], "Contents - Sheets")
    fields_data = prep_table_for_output(uinfo['fields'], "Contents - Fields")

    # --------------------------------------------------------------------------
    # Set up formatting
    # --------------------------------------------------------------------------
    fmt = {}
    fmt['reverse_rows']    = [1, 2, 3]
    fmt['short_rows']      = [2]
    fmt['wrap_rows']       = [3]
    fmt['fix_rows_after']  = 3
    fmt['freeze_panes']    = "A4"

    source_fmt = fmt.copy()
    source_fmt['column_widths'] = [10, 10, 50, 12, 24, 5]
    source_fmt['gutter_cols']   = ["F"]
    source_fmt['zoom']          = 100

    sheets_fmt = fmt.copy()
    sheets_fmt['column_widths'] = [20, 20, 8, 10, 10, 16, 16, 16, 5]
    sheets_fmt['gutter_cols']   = ["I"]
    sheets_fmt['user_cols']     = ["H"]
    sheets_fmt['zoom']          = 90

    fields_fmt = fmt.copy()
    fields_fmt['column_widths'] = [20, 30, 12, 12, 12, 12, 12, 12, 12, 12, 16, 16, 16, 8, 8, 25, 5]
    fields_fmt['gutter_cols']   = ["Q"]
    fields_fmt['user_cols']     = ["N","O","P"]
    fields_fmt['zoom']          = 90

    # --------------------------------------------------------------------------
    # Write all sheets to the file
    # --------------------------------------------------------------------------
    if uinfo['newmap']:
        wb = xl.Workbook()
        default_sheet = wb.active
        wb.remove(default_sheet)
    else:
        wb = xl.load_workbook(uinfo['map_name'])

    o  = write_excel_sheet(wb, "Source Data File",  source_data, source_fmt)
    o  = write_excel_sheet(wb, "Contents - Sheets", sheets_data, sheets_fmt)
    o  = write_excel_sheet(wb, "Contents - Fields", fields_data, fields_fmt)

    wb.save(uinfo['map_name'])
    wb.close()

    # --------------------------------------------------------------------------
    # Finish
    # --------------------------------------------------------------------------
    return True

# ------------------------------------------------------------------------------
# For the regularized output, we want every table to have a three-line heading:
#  - First line has a text title in the leftmost cell, and nothing else
#  - Second line is completely blank
#  - Third line is the variable headings, which must be unique text
# ------------------------------------------------------------------------------
def prep_table_for_output(df, title):
    empty = [""]*(df.shape[1])
    line1 = empty.copy()
    line1[0] = title
    line2 = empty.copy()
    line3 = [x for x in df.columns]
    body = df.values.tolist()
    matrix = []
    matrix.append(line1)
    matrix.append(line2)
    matrix.append(line3)
    matrix.extend(body)
    return matrix

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

