# ==============================================================================
# 
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
import chardet

import pandas as pd

# ------------------------------------------------------------------------------
# Init
# ------------------------------------------------------------------------------
pd.set_option("display.width", 10000)
pd.set_option("display.max_rows", 1000)
pd.set_option("display.max_columns", 12)

sys.stdout.reconfigure(encoding='utf-8')

sources = []
sources.append("examples\\LWOTC\\XComClassData.ini")
sources.append("examples\\classes\\2283957200\\Config\\XComClassData.ini")
sources.append("examples\\classes\\2307690386\\Config\\XComClassData.ini")
sources.append("examples\\classes\\2315630859\\Config\\XComClassData.ini")
sources.append("examples\\classes\\2320661275\\Config\\XComClassData.ini")
sources.append("examples\\classes\\2333540815\\Config\\XComClassData.ini")
sources.append("examples\\classes\\2347951005\\Config\\XComClassData.ini")
sources.append("examples\\classes\\2349299686\\Config\\XComClassData.ini")
sources.append("examples\\classes\\2349334533\\Config\\XComClassData.ini")
sources.append("examples\\classes\\2388969733\\Config\\XComClassData.ini")
sources.append("examples\\classes\\2715505346\\Config\\XComClassData.ini")
sources.append("examples\\classes\\2718035362\\Config\\XComClassData.ini")
sources.append("examples\\classes\\2720287889\\Config\\XComClassData.ini")
sources.append("examples\\classes\\2720855306\\Config\\XComClassData.ini")
sources.append("examples\\classes\\2745435515\\Config\\XComClassData.ini")
sources.append("examples\\classes\\2763217609\\Config\\XComClassData.ini")
sources.append("examples\\classes\\2771922076\\Config\\XComClassData.ini")
sources.append("examples\\classes\\2799438088\\Config\\XComClassData.ini")
sources.append("examples\\classes\\2832143482\\Config\\XComClassData.ini")
sources.append("examples\\classes\\2836852756\\Config\\XComClassData.ini")
sources.append("examples\\classes\\2848939326\\Config\\XComClassData.ini")
sources.append("examples\\classes\\2848987800\\Config\\XComClassData.ini")
sources.append("examples\\classes\\2850649799\\Config\\XComClassData.ini")
sources.append("examples\\classes\\2850679312\\Config\\XComClassData.ini")
sources.append("examples\\classes\\2851288174\\Config\\XComClassData.ini")
sources.append("examples\\classes\\2945843998\\Config\\XComClassData.ini")

textsrc = []
textsrc.append("examples\\perks\\running\\XComGame_ABB.int")
textsrc.append("examples\\perks\\running\\XComGame_Iridar_BountyHunter.int")
textsrc.append("examples\\perks\\running\\XComGame_Iridar_Foxcom.int")
textsrc.append("examples\\perks\\running\\XComGame_Iridar_Skirmisher.int")
textsrc.append("examples\\perks\\running\\XComGame_Iridar_Templar.int")
textsrc.append("examples\\perks\\running\\XComGame_LW2_Classes_Perks.int")
textsrc.append("examples\\perks\\running\\XComGame_Mechtronic.int")
textsrc.append("examples\\perks\\running\\XComGame_Mitzruti.int")
textsrc.append("examples\\perks\\running\\XComGame_Mitzruti_Cryo.int")
textsrc.append("examples\\perks\\running\\XComGame_Mitzruti_GeneMods.int")
textsrc.append("examples\\perks\\running\\XComGame_Mitzruti_Grimys.int")
textsrc.append("examples\\perks\\running\\XComGame_Mitzruti_Isms.int")
textsrc.append("examples\\perks\\running\\XComGame_PetRock.int")
textsrc.append("examples\\perks\\running\\XComGame_ShadowOps_Perks.int")
textsrc.append("examples\\perks\\running\\XComGame_WOTC_ExtendedPerkPack.int")
textsrc.append("examples\\perks\\running\\XComGame_LWOTC.int")
textsrc.append("examples\\perks\\running\\XComGame_LWOTC_LWAlienPack.int")
textsrc.append("examples\\perks\\running\\XComGame_LWOTC_LWFactionBalance.int")
textsrc.append("examples\\perks\\running\\XComGame_LWOTC_LWLaserPack.int")
textsrc.append("examples\\perks\\running\\XComGame_LWOTC_Officer.int")
textsrc.append("examples\\perks\\running\\XComGame_LWOTC_PerkPack.int")
textsrc.append("examples\\perks\\running\\XComGame_LWOTC_SMGPack.int")
textsrc.append("examples\\perks\\running\\XComGame_LWOTC_Toolbox.int")
textsrc.append("examples\\perks\\running\\XComGame_LWOTC_WeaponsArmor.int")
textsrc.append("examples\\perks\\running\\XComGame_WOTC_Akimbo.int")
textsrc.append("examples\\perks\\running\\XComGame_WOTC_Stormrider.int")
textsrc.append("examples\\perks\\running\\XComGame_WOTC_Warden.int")

textsrc.append("examples\\classes\\2283957200\\Localization\\XComGame.int")
textsrc.append("examples\\classes\\2307690386\\Localization\\XComGame.int")
textsrc.append("examples\\classes\\2315630859\\Localization\\XComGame.int")
textsrc.append("examples\\classes\\2320661275\\Localization\\XComGame.int")
textsrc.append("examples\\classes\\2333540815\\Localization\\XComGame.int")
textsrc.append("examples\\classes\\2347951005\\Localization\\XComGame.int")
textsrc.append("examples\\classes\\2349299686\\Localization\\XComGame.int")
textsrc.append("examples\\classes\\2349334533\\Localization\\XComGame.int")
textsrc.append("examples\\classes\\2388969733\\Localization\\XComGame.int")
textsrc.append("examples\\classes\\2715505346\\Localization\\XComGame.int")
textsrc.append("examples\\classes\\2718035362\\Localization\\XComGame.int")
textsrc.append("examples\\classes\\2720287889\\Localization\\XComGame.int")
textsrc.append("examples\\classes\\2720855306\\Localization\\XComGame.int")
textsrc.append("examples\\classes\\2745435515\\Localization\\XComGame.int")
textsrc.append("examples\\classes\\2763217609\\Localization\\XComGame.int")
textsrc.append("examples\\classes\\2771922076\\Localization\\XComGame.int")
textsrc.append("examples\\classes\\2799438088\\Localization\\XComGame.int")
textsrc.append("examples\\classes\\2832143482\\Localization\\XComGame.int")
textsrc.append("examples\\classes\\2836852756\\Localization\\XComGame.int")
textsrc.append("examples\\classes\\2848939326\\Localization\\XComGame.int")
textsrc.append("examples\\classes\\2848987800\\Localization\\XComGame.int")
textsrc.append("examples\\classes\\2850649799\\Localization\\XComGame.int")
textsrc.append("examples\\classes\\2850679312\\Localization\\XComGame.int")
textsrc.append("examples\\classes\\2851288174\\Localization\\XComGame.int")

textsrc.append("examples\\classes\\2865653027\\Localization\\XComGame.int")
textsrc.append("examples\\classes\\2865653098\\Localization\\XComGame.int")
textsrc.append("examples\\classes\\2865653156\\Localization\\XComGame.int")
textsrc.append("examples\\classes\\2905682083\\Localization\\XComGame.int")

textsrc.append("examples\\classes\\2945843998\\Localization\\XComGame.int")

textsrc.append("examples\\perks\\XComGame_WOTC_main.int")
textsrc.append("examples\\perks\\XComGame_misc.int")


wikisrc = []
wikisrc.append("data\old\LWOTC_perks_wiki_rawtext.txt")

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
    o = adata.to_excel("data/abilities_from_class.xlsx", index=False)

    # --------------------------------------------------------------------------
    # save out the whole list of abilities
    # --------------------------------------------------------------------------
    df_tdata = pd.DataFrame.from_dict(tdata, orient='index')
    o = df_tdata.to_excel("data/all_abilities_text.xlsx")

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
    current = ""
    for tfile in textsrc:
        # ----------------------------------------------------------------------
        # 
        # ----------------------------------------------------------------------
        print(f"...reading ability text labels from file: {tfile}")
        # ----------------------------------------------------------------------
        # What kind of file encoding?
        # ----------------------------------------------------------------------
        fcontents = open(tfile, 'rb').read()
        fencoding = chardet.detect(fcontents)['encoding']

        # ----------------------------------------------------------------------
        # Get the contents of the file
        # ----------------------------------------------------------------------
        data = open(tfile, encoding=fencoding, errors='replace').read()
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
            aname = current[1:-1].replace(" X2AbilityTemplate","").lower()

            #print(aname.ljust(50), line)

            # ------------------------------------------------------------------
            # Add the record to the abilities if we're on the first thing in
            # the section
            # ------------------------------------------------------------------
            if not aname in tdata:
                tdata[aname] = {}
                tdata[aname]['source'] = tfile

            # ------------------------------------------------------------------
            # Add whatever this thing is
            # ------------------------------------------------------------------
            if "=" in line:
                key,val = line.split("=",1)
                key = key.strip().lower().replace("+","")
                val = val.strip()
                tdata[aname][key] = val
            else:
                continue

    #print("------------")
    #for item in tdata:
    #    print(item, tdata[item])
    #print("------------")

    # --------------------------------------------------------------------------
    # Finish
    # --------------------------------------------------------------------------
    return tdata

# ------------------------------------------------------------------------------
# Get the ability data
# ------------------------------------------------------------------------------
def gather_ability_data(idata,tdata):
    # --------------------------------------------------------------------------
    # Go through each of the detected sections
    # --------------------------------------------------------------------------
    cleaned = {}
    weapons = {}
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
            # Skip all blank lines
            # ------------------------------------------------------------------
            if not line:
                continue

            # ------------------------------------------------------------------
            # Remove this problem-causing-nothing-doing item
            # ------------------------------------------------------------------
            if line.lower().endswith("!soldierranks=()"):
                line = line[:-16]

            # ------------------------------------------------------------------
            # Skip all the lines that aren't about ranking or weapons
            # ------------------------------------------------------------------
            if not line.lower().startswith("soldierranks") and not line.lower().startswith("randomabilitydecks") and not line.lower().startswith("allowedweapons"):
                continue

            # ------------------------------------------------------------------
            # Start the structure
            # ------------------------------------------------------------------
            if not item in cleaned:
                cleaned[item] = {}
                cleaned[item]["abilities"] = []
                cleaned[item]["stats"] = []
                cleaned[item]["weapons"] = []

            # ------------------------------------------------------------------
            # Maybe it's a weapon line
            # ------------------------------------------------------------------
            if line.lower().startswith("allowedweapons"):
                line = line.lower().replace(" ","")
                if 'primaryweapon' in line:
                    wslot = "primary"
                elif 'secondaryweapon' in line:
                    wslot = "secondary"
                elif 'heavyweapon' in line:
                    wslot = "heavy"
                else:
                    print("bad weapon slot line: ", line)
                weapon = line.split("weapontype=")[1]
                weapon = weapon.split('")')[0]
                weapon = weapon.replace('"',"")

                wslug = (wslot, weapon)
                if not wslug in weapons:
                    weapons[wslug] = 0
                weapons[wslug] += 1
                cleaned[item]['weapons'].append(wslug)

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
    # Look at the weapons
    # --------------------------------------------------------------------------
    #for weapon in weapons:
    #    print(weapon, weapons[weapon])

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
        #print(cleaned[item])

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
                    aname_mixed = piece.replace("AbilityName=","").replace('"',"")
                    aname = aname_mixed.lower()
                    

                    # ----------------------------------------------------------
                    # Start an ability record if it's not there
                    # ----------------------------------------------------------
                    if not aname in abilities:
                        abilities[aname] = {}
                        abilities[aname]['usage'] = []
                        abilities[aname]['slot'] = {}
                        abilities[aname]['weapons'] = {}
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
                    # ----------------------------------------------------------
                    # That directly gives us the slot...
                    # ----------------------------------------------------------
                    slottext = piece.replace("ApplyToWeaponSlot=","")
                    if not slottext in abilities[aname]['slot']:
                        abilities[aname]['slot'][slottext] = 0
                    abilities[aname]['slot'][slottext] += 1

                    # ----------------------------------------------------------
                    # ...and indirectly gives us the weapon(s)
                    # ----------------------------------------------------------
                    #print(slottext, cleaned[item]['weapons'])
                    if 'primary' in slottext.lower():
                        this_slot = "primary"
                    elif 'secondary' in slottext.lower():
                        this_slot = "secondary"
                    else:
                        this_slot = ""

                    for wpn in cleaned[item]['weapons']:
                        if not this_slot == wpn[0]:
                            continue

                        weapon = wpn[1].lower()

                        if not weapon in abilities[aname]['weapons']:
                            abilities[aname]['weapons'][weapon] = 0

                        abilities[aname]['weapons'][weapon] += 1
                    
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
        source       = ""
        if abil in tdata:
            if 'locfriendlyname' in tdata[abil]:
                friendlyname = tdata[abil]['locfriendlyname'].replace('"',"")
            if 'loclongdescription' in tdata[abil]:
                longdesc     = tdata[abil]['loclongdescription'].replace('"',"")
            if 'lochelptext' in tdata[abil]:
                helptext     = tdata[abil]['lochelptext'].replace('"',"")
            if 'locflyovertext' in tdata[abil]:
                flyover      = tdata[abil]['locflyovertext'].replace('"',"")
            if 'locpromotionpopuptext' in tdata[abil]:
                promo        = tdata[abil]['locpromotionpopuptext'].replace('"',"")

            source = tdata[abil]['source']

        # ----------------------------------------------------------------------
        # Determine the basic rank by taking the floor of the average rank
        # ----------------------------------------------------------------------
        rankbase = len(abilities[abil]['usage'])
        ranks = []
        for item in abilities[abil]['usage']:
            if type(item[1]) is int:
                ranks.append(float(item[1]))
            elif item[1].lower().startswith("tier"):
                num = int(item[1].lower().replace("tier","").replace("_xcomabilities",""))
                if num == 1:
                    slug = 1.49
                elif num == 2.0:
                    slug = 3.49
                elif num == 3.0:
                    slug = 5.49
                elif num == 4.0:
                    slug = 7.49

                ranks.append(slug)

        avgrank = sum(ranks) / rankbase
        if avgrank % 1 < 0.67:
            rank = math.floor(avgrank)
        else:
            rank = round(avgrank)

        # ----------------------------------------------------------------------
        # Make the record and append
        # ----------------------------------------------------------------------
        rec = []
        rec.append(abil)
        rec.append(len(abilities[abil]['usage']))
        rec.append(str(abilities[abil]['usage']))
        rec.append(str(abilities[abil]['slot']))
        rec.append(str(abilities[abil]['weapons']))
        rec.append(abilities[abil]['lowrank'])
        rec.append(avgrank)
        rec.append(rank)
        rec.append(friendlyname)
        rec.append(longdesc)
        rec.append(promo)
        rec.append(source)

        abil_recs.append(rec)

    # --------------------------------------------------------------------------
    # Make that into a data frame
    # --------------------------------------------------------------------------
    cols = []
    cols.append('ability')
    cols.append('instances')
    cols.append('usage')
    cols.append('slot')
    cols.append('weapons')
    cols.append('lowrank')
    cols.append('avgrank')
    cols.append('rank')
    cols.append('friendlyname')
    cols.append('longdesc')
    cols.append('promo')
    cols.append('textsource')

    adata = pd.DataFrame(abil_recs, columns=cols)
    adata = adata.sort_values(by=['avgrank','instances','ability'],ascending=[True, False, True]).reset_index()

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


    #for item in abilities:
    #    print(item.ljust(30), "|".join(abilities[item]['desc']))

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

