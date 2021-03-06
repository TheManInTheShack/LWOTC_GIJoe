# ==============================================================================
# ==============================================================================

# ------------------------------------------------------------------------------
# Import
# ------------------------------------------------------------------------------
from datetime import datetime
import os
import sys
import re
import shutil

import pandas as pd

# ------------------------------------------------------------------------------
# Init
# ------------------------------------------------------------------------------
pd.set_option("display.width", 10000)
pd.set_option("display.max_rows", 1000)
pd.set_option("display.max_columns", 12)

sys.stdout.reconfigure(encoding='utf-8')

sources = []
#sources.append("S:\Personal Folders\Dickerson\joe\examples\XComClassData_example1.ini")
#sources.append("S:\Personal Folders\Dickerson\joe\examples\XComClassData_example2.ini")
#sources.append("S:\Personal Folders\Dickerson\joe\examples\XComClassData_example3.ini")
#sources.append("S:\Personal Folders\Dickerson\joe\examples\XComClassData_example4.ini")
#sources.append("S:\Personal Folders\Dickerson\joe\examples\XComClassData_example5.ini")
#sources.append("S:\Personal Folders\Dickerson\joe\examples\XComClassData_example6.ini")
#sources.append("S:\Personal Folders\Dickerson\joe\examples\XComClassData_example7.ini")
#sources.append("S:\Personal Folders\Dickerson\joe\examples\XComClassData_example8.ini")
#sources.append("S:\Personal Folders\Dickerson\joe\examples\XComClassData_example9.ini")
#sources.append("S:\Personal Folders\Dickerson\joe\examples\XComClassData_example10.ini")
#sources.append("S:\Personal Folders\Dickerson\joe\examples\XComClassData_example11.ini")
sources.append("S:\Personal Folders\Dickerson\joe\data\XComClassData_LWOTC.ini")

textsrc = []
textsrc.append("S:\Personal Folders\Dickerson\joe\examples\\textbank_1.INT")
textsrc.append("S:\Personal Folders\Dickerson\joe\examples\\textbank_2.INT")
textsrc.append("S:\Personal Folders\Dickerson\joe\examples\\textbank_3.INT")
textsrc.append("S:\Personal Folders\Dickerson\joe\examples\\textbank_4.INT")
textsrc.append("S:\Personal Folders\Dickerson\joe\examples\\textbank_5.INT")
textsrc.append("S:\Personal Folders\Dickerson\joe\examples\\textbank_6.INT")
textsrc.append("S:\Personal Folders\Dickerson\joe\examples\\textbank_7.INT")
textsrc.append("S:\Personal Folders\Dickerson\joe\examples\\textbank_8.INT")
textsrc.append("S:\Personal Folders\Dickerson\joe\examples\\textbank_9.INT")
textsrc.append("S:\Personal Folders\Dickerson\joe\examples\\textbank_10.INT")
textsrc.append("S:\Personal Folders\Dickerson\joe\examples\\textbank_11.INT")
textsrc.append("S:\Personal Folders\Dickerson\joe\examples\\textbank_12.INT")
textsrc.append("S:\Personal Folders\Dickerson\joe\examples\\textbank_13.INT")
textsrc.append("S:\Personal Folders\Dickerson\joe\examples\\textbank_14.INT")
textsrc.append("S:\Personal Folders\Dickerson\joe\examples\\textbank_15.INT")
textsrc.append("S:\Personal Folders\Dickerson\joe\examples\\textbank_16.INT")
textsrc.append("S:\Personal Folders\Dickerson\joe\examples\\textbank_17.INT")
textsrc.append("S:\Personal Folders\Dickerson\joe\examples\\textbank_18.INT")
textsrc.append("S:\Personal Folders\Dickerson\joe\examples\\textbank_19.INT")
textsrc.append("S:\Personal Folders\Dickerson\joe\examples\\textbank_20.INT")

wikisrc = []
wikisrc.append("S:\Personal Folders\Dickerson\joe\data\LWOTC_perks_wiki_rawtext.txt")

# ------------------------------------------------------------------------------
# Main
# ------------------------------------------------------------------------------
def main():
    # --------------------------------------------------------------------------
    # Start
    # --------------------------------------------------------------------------
    print("Starting...")

    # --------------------------------------------------------------------------
    # Get the data
    # --------------------------------------------------------------------------
    idata = parsed_file_data(sources)

    # --------------------------------------------------------------------------
    # Organize the text data
    # --------------------------------------------------------------------------
    tdata = parsed_text_data(textsrc)
    wdata = parsed_wiki_text_data(wikisrc)

    # --------------------------------------------------------------------------
    # Organize into abilities
    # --------------------------------------------------------------------------
    adata = gather_ability_data(idata,tdata)

    # --------------------------------------------------------------------------
    # save out the piece that shows abilities used by classes
    # --------------------------------------------------------------------------
    o = adata.to_excel("data/abilities_from_class.xlsx")

    # --------------------------------------------------------------------------
    # save out the whole list of abilities
    # --------------------------------------------------------------------------
    #df_tdata = pd.DataFrame.from_dict(tdata, orient='index')
    #o = df_tdata.to_excel("data/abilities.xlsx")

    # --------------------------------------------------------------------------
    # Finish
    # --------------------------------------------------------------------------
    print("...finished.")

# ------------------------------------------------------------------------------
# Parse the raw files
# ------------------------------------------------------------------------------
def parsed_file_data(sources):
    # --------------------------------------------------------------------------
    # --------------------------------------------------------------------------
    alldata = []
    for src in sources:
        fdata = open(src,'r',encoding='utf-8').read().splitlines()
        alldata.extend(fdata)

    # --------------------------------------------------------------------------
    # --------------------------------------------------------------------------
    condensed = []
    buff = ""
    for line in alldata:
        line = line.strip()
        if line.startswith(";"):
            continue
        if line.endswith("\\\\"):
            buff += line[:-2]
        else:
            if len(buff) > 0:
                condensed.append(buff)
                buff=""
            buff += line

    # --------------------------------------------------------------------------
    # --------------------------------------------------------------------------
    mashed = {}
    section = ""
    for line in condensed:
        if line.startswith("[") and line.endswith("]"):
            section = line
            mashed[section] = ""
            continue
        mashed[section] += line

    # --------------------------------------------------------------------------
    # --------------------------------------------------------------------------
    remixed = {}
    for item in mashed:
        remixed[item] = []
        pieces = mashed[item].split("+")
        for line in pieces:
            remixed[item].append(line)

    # --------------------------------------------------------------------------
    # Ok that's a good stopping point, send that back
    # --------------------------------------------------------------------------
    return remixed

# ------------------------------------------------------------------------------
# 
# ------------------------------------------------------------------------------
def parsed_text_data(textsrc):
    # --------------------------------------------------------------------------
    # Work through each text file
    # --------------------------------------------------------------------------
    tdata = {}
    tdata_a = {}
    current = ""
    for tfile in textsrc:
        # ----------------------------------------------------------------------
        # Get the contents of the file
        # ----------------------------------------------------------------------
        data = open(tfile, encoding='utf-16-le', errors='replace').read()
        data1 = data.encode('utf-8').decode('utf-8')

        # ----------------------------------------------------------------------
        # Go through each line
        # ----------------------------------------------------------------------
        for line in data1.splitlines():
            # ------------------------------------------------------------------
            # Clean up the line
            # ------------------------------------------------------------------
            line = str(line).strip()

            # ------------------------------------------------------------------
            # Skip blank lines and comments
            # ------------------------------------------------------------------
            if len(line) == 0:
                continue
            if line.startswith(";"):
                continue

            # ------------------------------------------------------------------
            # If we're on a new section
            # ------------------------------------------------------------------
            if line.endswith("]"):
                # --------------------------------------------------------------
                # Remove the BOM if it's there on the first line of the file
                # --------------------------------------------------------------
                line = "[" + line.split('[')[1]

                # --------------------------------------------------------------
                # Set this as the current section
                # --------------------------------------------------------------
                current = line

                # --------------------------------------------------------------
                # Start the entry
                # --------------------------------------------------------------
                if not current in tdata:
                    tdata[current] = {}

                # --------------------------------------------------------------
                # That's all we need for this line
                # --------------------------------------------------------------
                continue

            # ------------------------------------------------------------------
            # Skip out if it's not an ability section
            # ------------------------------------------------------------------
            if not current.endswith("X2AbilityTemplate]"):
                continue

            # ------------------------------------------------------------------
            # Get the bare ability name
            # ------------------------------------------------------------------
            aname = current[1:-1].replace(" X2AbilityTemplate","")

            # ------------------------------------------------------------------
            # Add the record to the abilities if we're on the first thing in
            # the section
            # ------------------------------------------------------------------
            if not aname in tdata_a:
                tdata_a[aname] = {}
                tdata_a[aname]['source'] = tfile

            # ------------------------------------------------------------------
            # Add whatever this thing is
            # ------------------------------------------------------------------
            if "=" in line:
                key,val = line.split("=",1)
                tdata_a[aname][key] = val
            else:
                continue

    #for item in tdata_a:
    #    print(item, tdata_a[item])

    # --------------------------------------------------------------------------
    # Finish
    # --------------------------------------------------------------------------
    return tdata_a

# ------------------------------------------------------------------------------
# Get the ability data
# ------------------------------------------------------------------------------
def gather_ability_data(idata,tdata):
    # --------------------------------------------------------------------------
    # Go through each of the detected sections
    # --------------------------------------------------------------------------
    cleaned = {}
    for item in idata:
        # ----------------------------------------------------------------------
        # We only care about sections where we are defining a class
        # ----------------------------------------------------------------------
        if not 'x2soldierclasstemplate' in item.lower():
            continue
        if len(idata[item]) < 3:
            continue

        # ----------------------------------------------------------------------
        # Go through each line of the section
        # ----------------------------------------------------------------------
        current_rank = 0
        for line in idata[item]:
            # ------------------------------------------------------------------
            # Skip all the lines that aren't about ranking
            # ------------------------------------------------------------------
            if not line:
                continue
            if not line.lower().startswith("soldierranks") and not line.lower().startswith("randomabilitydecks"):
                continue

            # ------------------------------------------------------------------
            # Start the structure
            # ------------------------------------------------------------------
            if not item in cleaned:
                cleaned[item] = {}
                cleaned[item]["abilities"] = []
                cleaned[item]["stats"] = []

            # ------------------------------------------------------------------
            # Maybe it's a random deck like
            # ------------------------------------------------------------------
            if line.lower().startswith("randomabilitydecks"):
                # --------------------------------------------------------------
                # Cut the line down to just the interior part, and split it up
                # into its pieces, which should be individual ability or stat lines
                # --------------------------------------------------------------
                deckname = line.replace(" ","").split(",",1)[0].replace("RandomAbilityDecks=(DeckName=","").replace('"',"")
                clean_line = line.replace(" ","").replace("\t","").split(",",1)[1][:-2]
                clean_line = clean_line.replace("Abilities=(","")
                pieces = clean_line.split("),(")

                # --------------------------------------------------------------
                # Go through each of those pieces
                # --------------------------------------------------------------
                for piece in pieces:
                    # ----------------------------------------------------------
                    # Clean up parentheses we no longer need
                    # ----------------------------------------------------------
                    piece = piece.replace("(","").replace(")","")

                    # ----------------------------------------------------------
                    # Add to the thing, using the deck name as a temporary
                    # rank placeholder.  If it's the RPGO traits, automatically
                    # put it as rank 0.
                    # ----------------------------------------------------------
                    if deckname == "TraitsXComAbilities":
                        deckname = 0
                    cleaned[item]['abilities'].append([deckname, piece])

            # ------------------------------------------------------------------
            # Maybe it's a rank line
            # ------------------------------------------------------------------
            if line.lower().startswith("soldierranks"):
                # --------------------------------------------------------------
                # We're on a new rank, which will go 1-7/8 for each class
                # --------------------------------------------------------------
                current_rank += 1

                # --------------------------------------------------------------
                # Cut the line down to just the interior part, and split it up
                # into its pieces, which should be individual ability or stat lines
                # --------------------------------------------------------------
                clean_line = line.replace(" ","").replace("\t","").replace("SoldierRanks=(AbilitySlots=","")[:-2]
                pieces = re.split('\)\),|\),\(', clean_line)

                # --------------------------------------------------------------
                # Go through each of those pieces
                # --------------------------------------------------------------
                for piece in pieces:
                    # ----------------------------------------------------------
                    # Clean up parentheses we no longer need
                    # ----------------------------------------------------------
                    piece = piece.replace("(","").replace(")","").replace(" ","")
    
                    # ----------------------------------------------------------
                    # If it's calling a random deck, we want to reach back in
                    # to the abilities already done and swap out the rank for
                    # the placeholder.  Since this happens the first time it
                    # hits one, it will always give the lowest rank for this
                    # list. Then discad the dekc part
                    # ----------------------------------------------------------
                    if piece.lower().startswith("randomdeckname"):
                        # ------------------------------------------------------
                        # Extract the deck name
                        # ------------------------------------------------------
                        deckname = piece.replace('"',"").replace(")","").replace("RandomDeckName=","")

                        # ------------------------------------------------------
                        # Work back through the abilities and swap it out
                        # ------------------------------------------------------
                        for k, clrec in enumerate(cleaned[item]['abilities']):
                            if clrec[0] == deckname:
                                clrec[0] = current_rank

                    # ----------------------------------------------------------
                    # ...or it's just a directly called ability
                    # ----------------------------------------------------------
                    if piece.lower().startswith("abilitytype"):
                        cleaned[item]['abilities'].append([current_rank, piece])
                    if piece.lower().startswith("astatprogression"):
                        cleaned[item]['stats'].append([current_rank, piece])


    # --------------------------------------------------------------------------
    # Fill in a clean dictionary of ability information
    # --------------------------------------------------------------------------
    abilities = {}
    for item in cleaned:
        # ----------------------------------------------------------------------
        # Debug
        # ----------------------------------------------------------------------
        #print("-------------------")
        #print(item)

        # ----------------------------------------------------------------------
        # Get the class name
        # ----------------------------------------------------------------------
        cname = item[1:-1].replace(" X2SoldierClassTemplate","")

        # ----------------------------------------------------------------------
        # Work through each item in the abilities list
        # ----------------------------------------------------------------------
        for thing in cleaned[item]['abilities']:
            # ------------------------------------------------------------------
            # Unpack
            # ------------------------------------------------------------------
            rank = thing[0]
            slug = thing[1]

            # ------------------------------------------------------------------
            # Clean up the text blob a little more and cut it into pieces,
            # which would be the ability name and maybe slot data
            # ------------------------------------------------------------------
            slug = slug.replace("AbilityType=","").replace('"',"")
            pieces = slug.split(",")

            print#(rank, slug)

            # ------------------------------------------------------------------
            # Go through each component for this ability
            # ------------------------------------------------------------------
            for piece in pieces:
                # --------------------------------------------------------------
                # Maybe it's the name of the ability
                # --------------------------------------------------------------
                if piece.startswith("AbilityName="):
                    # ----------------------------------------------------------
                    # Get the actual ability name
                    # ----------------------------------------------------------
                    aname = piece.replace("AbilityName=","").replace('"',"")

                    # ----------------------------------------------------------
                    # Start an ability record if it's not there
                    # ----------------------------------------------------------
                    if not aname in abilities:
                        abilities[aname] = {}
                        abilities[aname]['usage'] = []
                        abilities[aname]['slot'] = ""
                        abilities[aname]['lowrank'] = 10

                    # ----------------------------------------------------------
                    # Make a record
                    # ----------------------------------------------------------
                    abilities[aname]['usage'].append((cname, rank))

                    # ----------------------------------------------------------
                    # Replace the rank if it's lower than the current
                    # There may have been some where we never could derive
                    # the rank on a random one; these will get ignored for
                    # this part.
                    # ----------------------------------------------------------
                    if type(rank) == int and rank < abilities[aname]['lowrank']:
                        abilities[aname]['lowrank'] = rank

                # --------------------------------------------------------------
                # ...or maybe it's the slot
                # --------------------------------------------------------------
                if piece.startswith("ApplyToWeaponSlot="):
                    abilities[aname]['slot'] = piece.replace("ApplyToWeaponSlot=","")

    # --------------------------------------------------------------------------
    # Work through each detected ability
    # --------------------------------------------------------------------------
    abil_recs = []
    for abil in abilities:
        # ----------------------------------------------------------------------
        # Pull the text pieces if they were found for this ability
        # ----------------------------------------------------------------------
        friendlyname = ""
        longdesc     = ""
        helptext     = ""
        flyover      = ""
        promo        = ""
        if abil in tdata:
            if 'LocFriendlyName' in tdata[abil]:
                friendlyname = tdata[abil]['LocFriendlyName'].replace('"',"")
            if 'LocLongDescription' in tdata[abil]:
                longdesc     = tdata[abil]['LocLongDescription'].replace('"',"")
            if 'LocHelpText' in tdata[abil]:
                helptext     = tdata[abil]['LocHelpText'].replace('"',"")
            if 'LocFlyoverText' in tdata[abil]:
                flyover      = tdata[abil]['LocFlyoverText'].replace('"',"")
            if 'LocPromotionPopupText' in tdata[abil]:
                promo        = tdata[abil]['LocPromotionPopupText'].replace('"',"")

        # ----------------------------------------------------------------------
        # Make the record and append
        # ----------------------------------------------------------------------
        rec = (abil,len(abilities[abil]['usage']), str(abilities[abil]['usage']), abilities[abil]['lowrank'],abilities[abil]['slot'],friendlyname,longdesc,helptext,flyover,promo)
        abil_recs.append(rec)

    # --------------------------------------------------------------------------
    # Make that into a data frame
    # --------------------------------------------------------------------------
    adata = pd.DataFrame(abil_recs, columns=['ability','instances','usage','lowrank','slot','friendlyname','longdesc','helptext','flyover','promo'])
    adata = adata.sort_values(by='lowrank').reset_index()
    #print(adata)

    # --------------------------------------------------------------------------
    # Finish
    # --------------------------------------------------------------------------
    return adata

# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
def parsed_wiki_text_data(wikisrc):
    # --------------------------------------------------------------------------
    # Each file in the list
    # --------------------------------------------------------------------------
    abilities = {}
    this_rec = {}
    for wfile in wikisrc:
        # ----------------------------------------------------------------------
        # Get the raw data
        # ----------------------------------------------------------------------
        lines = open(wfile, encoding="utf-8").read().splitlines()

        # ----------------------------------------------------------------------
        # Work through line by line
        # ----------------------------------------------------------------------
        prev_line = ""
        for line in lines:
            # ------------------------------------------------------------------
            # skip the second of double lines
            # ------------------------------------------------------------------
            if line == prev_line:
                prev_line = line
                continue
            else:
                prev_line = line

            # ------------------------------------------------------------------
            # If this is an empty line:
            #  - write the existing record if it's there
            #  - start a new record
            # ------------------------------------------------------------------
            if line.strip() == "":
                if 'name' in this_rec:
                    abilities[this_rec['name']] = this_rec
                this_rec = {}
                continue

            # ------------------------------------------------------------------
            # If there's no name yet, that's the name
            # ------------------------------------------------------------------
            if not 'name' in this_rec:
                this_rec['name'] = line
                continue

            # ------------------------------------------------------------------
            # If there is a name but no description, start it
            # ------------------------------------------------------------------
            if 'name' in this_rec and not 'desc' in this_rec:
                this_rec['desc'] = []
                this_rec['desc'].append(line)
                continue

            # ------------------------------------------------------------------
            # If it's the 'available for' line, that is its own thing
            # ------------------------------------------------------------------
            if 'name' in this_rec and 'desc' in this_rec and line.lower().startswith("available for:"):
                this_rec['avail'] = [x.strip() for x in line.split(",")]
                continue

            # ------------------------------------------------------------------
            # Anything else just is part of the description
            # ------------------------------------------------------------------
            if 'name' in this_rec and 'desc' in this_rec:
                this_rec['desc'].append(line)


    for item in abilities:
        print(item.ljust(30), "|".join(abilities[item]['desc']))

    # --------------------------------------------------------------------------
    # Finish
    # --------------------------------------------------------------------------
    return abilities

# ------------------------------------------------------------------------------
# Run
# ------------------------------------------------------------------------------
if __name__ == "__main__":
    start_time = datetime.utcnow()
    main()
    end_time     = datetime.utcnow()
    elapsed_time = end_time - start_time
    print("Elapsed time: " + str(elapsed_time))

