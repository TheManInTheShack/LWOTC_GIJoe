# ==============================================================================
# Game Text Dominator
# ==============================================================================

# ------------------------------------------------------------------------------
# Import
# ------------------------------------------------------------------------------
from datetime import datetime
import time
import os
import sys
import argparse
import pandas as pd

# ------------------------------------------------------------------------------
# Init
# ------------------------------------------------------------------------------
file_handle = "joe_text"

# --------------------------------------------------------------------------
# Command Line Interface
# --------------------------------------------------------------------------
parser = argparse.ArgumentParser()
parser.add_argument("direction", nargs='?',  type=str, default="", help="'t' or 'e', gives the intended direction of the file")

args = parser.parse_args()

# ------------------------------------------------------------------------------
# Main
# ------------------------------------------------------------------------------
def main():
    # --------------------------------------------------------------------------
    # Start
    # --------------------------------------------------------------------------
    print("Initiating communication adjustment correlation procedure...")

    # --------------------------------------------------------------------------
    # Sort out the input/output file names
    # --------------------------------------------------------------------------
    text_file = file_handle + ".txt"
    excel_file = file_handle + ".xlsx"

    # --------------------------------------------------------------------------
    # User choose which direction
    # --------------------------------------------------------------------------
    if args.direction.lower().startswith("t"):
        choice = "1"
    elif args.direction.lower().startswith("e"):
        choice = "2"
    else:
        print("...Do you want to go text-to-spreadsheet, or spreadsheet-to-text?")
        print("   1: text-to-spreadsheet")
        print("   2: spreadsheet-to-text")

        good = ""
        while not good:
            choice = str(input("Please choose: \n"))
            if choice in ["1","2"]:
                good = True
                print("...an excellent choice, Commander...")
            elif choice.lower() == "q":
                print("...very well, Commander. We will forego this procedure...for now.")
                sys.exit()
            else:
                print("...sorry, Commander, but you must only enter a '1' or a '2'.  Please try again.  Or if you would like to abort the procedure, you may enter 'Q'")

    # --------------------------------------------------------------------------
    # Validate that the direction we are going jibes with the timestamps of the
    # files and that everything exists, etc.
    # --------------------------------------------------------------------------
    ttime = 0
    if os.path.isfile(text_file):
        ttime = os.path.getmtime(text_file)

    etime = 0
    if os.path.isfile(excel_file):
        etime = os.path.getmtime(excel_file)

    backward = False
    if choice == "1" and etime and etime > ttime:
        backward = True
    elif choice == "2" and ttime and ttime > etime:
        backward = True

    if backward:
        print("Hmmm...Commander, it seems your requested output file is newer than your input...for fear of losing information, please re-save the files so that the one you want to translate is newer.")
        sys.exit()

    # --------------------------------------------------------------------------
    # Read whichever the input is and hold it in the standard internal format
    # --------------------------------------------------------------------------
    if choice == "1":
        data, warnings = parse_text_version(text_file)
    elif choice == "2":
        data, warnings = parse_excel_version(excel_file)

    # --------------------------------------------------------------------------
    # Output whichever one is appropriate
    # --------------------------------------------------------------------------
    if choice == "1":
        x = write_excel_output(data, excel_file)
    elif choice == "2":
        x = write_text_output(data, text_file)

    # --------------------------------------------------------------------------
    # Write out warnings
    # --------------------------------------------------------------------------
    with open("warnings.txt", "w", encoding="utf-8") as f:
        for line in warnings:
            print(line, file=f)

    # --------------------------------------------------------------------------
    # Finish
    # --------------------------------------------------------------------------
    print("...Success! This information is under our control, my dear Commander...Ha Ha Ha Haaaa!")
    time.sleep(5)

# ------------------------------------------------------------------------------
# Read in the text version of the data
# ------------------------------------------------------------------------------
def parse_text_version(text_file):
    # --------------------------------------------------------------------------
    # Start
    # --------------------------------------------------------------------------
    print("...one moment while the fribulator frabulates...")

    # --------------------------------------------------------------------------
    # Read the file contents
    # --------------------------------------------------------------------------
    lines = open(text_file, encoding="cp1252").read().splitlines()

    # --------------------------------------------------------------------------
    # Work through each line and build up the internal data structure
    # --------------------------------------------------------------------------
    data = {}
    current_section = ""
    comment = ""
    warnings = []
    for i, line in enumerate(lines):
        # ----------------------------------------------------------------------
        # Clean up tab characters
        # ----------------------------------------------------------------------
        line = line.replace("\t"," ")

        # ----------------------------------------------------------------------
        # Strip out any stray spaces
        # ----------------------------------------------------------------------
        line = line.strip()

        # ----------------------------------------------------------------------
        # Skip white space
        # ----------------------------------------------------------------------
        if len(line) == 0:
            continue

        # ----------------------------------------------------------------------
        # Maybe it's a new section
        # ----------------------------------------------------------------------
        if line.startswith("[") and line.endswith("]"):
            current_section = line[1:-1]
            if current_section in data:
                warnings.append("WARNING!  Section " + current_section + " seems to be repeated in the data.")
            else:
                data[current_section] = {}
                comment = ""

            continue

        # ----------------------------------------------------------------------
        # Maybe it's a comment
        # ----------------------------------------------------------------------
        if line.startswith(";"):
            comment += line[1:]
            continue

        # ----------------------------------------------------------------------
        # Any other line should be setting a text field, and should strictly
        # follow the format vname="text", so check for the equal sign first
        # ----------------------------------------------------------------------
        if not "=" in line:
            warnings.append("WARNING! Malformed line " + str(i+1) + " does not contain a '=' character and cannot be parsed: " + line)
            continue
        else:
            var, val = line.split("=",1)
            var = var.strip()
            val = val.strip()

        # ----------------------------------------------------------------------
        # We have to have both things
        # ----------------------------------------------------------------------
        if not var:
            warnings.append("WARNING! Line " + str(i+1) + " is missing variable reference on the left side of the '=': " + line)
        elif not val:
            warnings.append("WARNING! Line " + str(i+1) + " is missing text value on the right side of the '=': " + line)

        # ----------------------------------------------------------------------
        # Maybe it's a list
        # ----------------------------------------------------------------------
        if val.startswith("("):
            this_rec = {}
            this_rec['type']    = "list"
            this_rec['value']   = val
            this_rec['comment'] = comment

        # ----------------------------------------------------------------------
        # if it's properly quoted, strip those out
        # ----------------------------------------------------------------------
        elif val.startswith('"') and val.endswith('"'):
            val = val[1:-1]
            this_rec = {}
            this_rec['type']    = "text"
            this_rec['value']   = val
            this_rec['comment'] = comment

        # ----------------------------------------------------------------------
        # If it's anything else, just go with what is there
        # ----------------------------------------------------------------------
        else:
            this_rec = {}
            this_rec['type']    = "text"
            this_rec['value']   = val
            this_rec['comment'] = comment

        # ----------------------------------------------------------------------
        # Warn if the variable is already in the section
        # ----------------------------------------------------------------------
        if var in data[current_section]:
            warnings.append("WARNING! Variable " + var + " is duplicated for section " + current_section + " on line " + str(i+1) + "...it will be overwritten.")

        # ----------------------------------------------------------------------
        # Write in the data
        # ----------------------------------------------------------------------
        data[current_section][var] = this_rec
        comment = ""

    # --------------------------------------------------------------------------
    # Finish
    # --------------------------------------------------------------------------
    return data, warnings

# ------------------------------------------------------------------------------
# Read in the excel version of the data
# ------------------------------------------------------------------------------
def parse_excel_version(excel_file):
    # --------------------------------------------------------------------------
    # Start
    # --------------------------------------------------------------------------
    print("...one moment while the jibjabber jobulates...")

    # --------------------------------------------------------------------------
    # Get the data from the file as a dataframe and fill in any blanks with the
    # empty string
    # --------------------------------------------------------------------------
    df = pd.read_excel(excel_file, index_col='idx')
    df = df.fillna("")

    # --------------------------------------------------------------------------
    # Work through each line and create the internal set
    # --------------------------------------------------------------------------
    data = {}
    warnings = []
    for i, rec in df.iterrows():
        # ----------------------------------------------------------------------
        # Unpack
        # ----------------------------------------------------------------------
        section = rec['section']
        var     = rec['var']
        vtype   = rec['type']
        value   = rec['value']
        comment = rec['comment']

        # ----------------------------------------------------------------------
        # Validate that the stuff we need is there
        # ----------------------------------------------------------------------
        bad = False
        if not section:
            warnings.append("WARNING! Section missing at index " + str(i))
            bad = True
        if not var:
            warnings.append("WARNING! Variable Name missing at index " + str(i))
            bad = True
        if not vtype:
            warnings.append("WARNING! Variable Type missing at index " + str(i))
            bad = True
        if not vtype in ["list", "text"]:
            warnings.append("WARNING! Variable Type can only be 'text' or 'list' at index " + str(i))
            bad = True
        if not value:
            warnings.append("WARNING! Text Value missing at index " + str(i))
            bad = True

        if bad:
            continue

        # ----------------------------------------------------------------------
        # Make the section if it's not there yet
        # ----------------------------------------------------------------------
        if not section in data:
            data[section] = {}

        # ----------------------------------------------------------------------
        # Fill in the record 
        # ----------------------------------------------------------------------
        this_rec = {}
        this_rec['type'] = vtype
        this_rec['value'] = value
        this_rec['comment'] = comment
        data[section][var] = this_rec

    # --------------------------------------------------------------------------
    # Finish
    # --------------------------------------------------------------------------
    return data, warnings

# ------------------------------------------------------------------------------
# Write out the excel version
# ------------------------------------------------------------------------------
def write_excel_output(data, excel_file):
    # --------------------------------------------------------------------------
    # Start
    # --------------------------------------------------------------------------
    print("...writing out tabular version of data to Excel...")

    # --------------------------------------------------------------------------
    # restate the data as a clean matrix
    # --------------------------------------------------------------------------
    matrix = []
    for section in data:
        for var in data[section]:
            rec = data[section][var]
            rec['section'] = section
            rec['var'] = var
            matrix.append(rec)

    # --------------------------------------------------------------------------
    # Make that into a dataframe
    # --------------------------------------------------------------------------
    df = pd.DataFrame(matrix)
    order = []
    order.append("section")
    order.append("var")
    order.append("type")
    order.append("value")
    order.append("comment")
    df = df[order]

    # --------------------------------------------------------------------------
    # Save it out to file
    # --------------------------------------------------------------------------
    x = df.to_excel(excel_file, index_label="idx")

    # --------------------------------------------------------------------------
    # Finish
    # --------------------------------------------------------------------------
    return True

# ------------------------------------------------------------------------------
# Write out the text version
# ------------------------------------------------------------------------------
def write_text_output(data, text_file):
    # --------------------------------------------------------------------------
    # Start
    # --------------------------------------------------------------------------
    print("...writing out the text version of the data as syntax...")

    # --------------------------------------------------------------------------
    # Make the text block
    # --------------------------------------------------------------------------
    block = []
    for section in data:
        # ----------------------------------------------------------------------
        # Section header
        # ----------------------------------------------------------------------
        slug = "[" + section + "]"
        block.append(slug)

        # ----------------------------------------------------------------------
        # Each variable
        # ----------------------------------------------------------------------
        for var in data[section]:
            # ------------------------------------------------------------------
            # Unpack
            # ------------------------------------------------------------------
            vtype   = data[section][var]['type']
            value   = data[section][var]['value']
            comment = data[section][var]['comment']

            # ------------------------------------------------------------------
            # Add comment if it's there
            # ------------------------------------------------------------------
            if comment:
                slug = ";" + comment
                block.append(slug)

            # ------------------------------------------------------------------
            # Add the variable
            # ------------------------------------------------------------------
            slug = var + " = " + '"' + value + '"'
            block.append(slug)

        # ----------------------------------------------------------------------
        # Add a line of white space at the end
        # ----------------------------------------------------------------------
        block.append("")

    # --------------------------------------------------------------------------
    # Save out the file
    # --------------------------------------------------------------------------
    with open(text_file, "w", encoding="cp1252") as f:
        for line in block:
            print(line, file=f)

    # --------------------------------------------------------------------------
    # Finish
    # --------------------------------------------------------------------------
    return True

# ------------------------------------------------------------------------------
# Run
# ------------------------------------------------------------------------------
if __name__ == "__main__":
    start_time = datetime.utcnow()
    main()
    end_time     = datetime.utcnow()
    elapsed_time = end_time - start_time
