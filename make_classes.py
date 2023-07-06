# ------------------------------------------------------------------------------
# Imports
# ------------------------------------------------------------------------------
import sys
import pandas as pd

# ------------------------------------------------------------------------------
# Init
# ------------------------------------------------------------------------------
modname = "LWOTC_GIJoe"

dfile = "data/data.xlsx"
cfile = "mod/Config/XComClassData.ini"
lfile = "mod/Config/XComGameData.ini"
gfile = "mod/Config/XComGame.ini"
tfile = "mod/Localization/XComGame.int"
sfile = "mod/Config/XComStartingSoldiers.ini"

pd.set_option("display.width", 0)
pd.set_option("display.max_rows", 1000)
pd.set_option("display.max_columns", 10)

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
    print("...reading character data...")
    cdata = pd.read_excel(dfile, sheet_name="characters", header=[0,2],index_col=0)
    print("...reading abilities data...")
    adata = pd.read_excel(dfile, sheet_name="abilities", header=[7,9],index_col=0)

    # --------------------------------------------------------------------------
    # Compile class data for each guy
    # --------------------------------------------------------------------------
    gdata = compile_class_data(cdata, adata)

    # --------------------------------------------------------------------------
    # Make the output files that are dependent on the data
    # --------------------------------------------------------------------------
    ccode, lcode, gcode, tcode, scode = compile_output(gdata)

    # --------------------------------------------------------------------------
    # Save the output files
    # --------------------------------------------------------------------------
    with open(cfile, "w", encoding="utf-8") as f:
        for line in ccode:
            print(line, file=f)

    with open(lfile, "w", encoding="utf-8") as f:
        for line in lcode:
            print(line, file=f)

    with open(gfile, "w", encoding="utf-8") as f:
        for line in gcode:
            print(line, file=f)

    with open(tfile, "w", encoding="utf-8") as f:
        for line in tcode:
            print(line, file=f)

    with open(sfile, "w", encoding="utf-8") as f:
        for line in scode:
            print(line, file=f)

    # --------------------------------------------------------------------------
    # Finish
    # --------------------------------------------------------------------------
    print("...Finished!")

# ------------------------------------------------------------------------------
# Class data
# ------------------------------------------------------------------------------
def compile_class_data(cdata, adata):
    # --------------------------------------------------------------------------
    # Start
    # --------------------------------------------------------------------------
    print("...compiling class data...")
    gdata = {}

    # --------------------------------------------------------------------------
    # Add summary variables to the abilities data
    # --------------------------------------------------------------------------
    adata[('Summary','attributes_summary')] = summarize_tags(adata, 'Attributes')
    adata[('Summary','keywords_summary')]   = summarize_tags(adata, 'Keywords')

    # --------------------------------------------------------------------------
    # List of the stats we'll track (Strength is ignored)
    # --------------------------------------------------------------------------
    stats = ["Aim","HP","Will","Hack","Dodge","Psi"]

    # --------------------------------------------------------------------------
    # Each record is a guy
    # --------------------------------------------------------------------------
    for guy, rec in cdata.iterrows():
        # ----------------------------------------------------------------------
        # Skip those not included
        # ----------------------------------------------------------------------
        if not rec['Properties']['Include'] == "x":
            continue

        # ----------------------------------------------------------------------
        # Start record for this guy
        # ----------------------------------------------------------------------
        gdata[guy] = {}

        # ----------------------------------------------------------------------
        # Set the general properties
        # ----------------------------------------------------------------------
        gdata[guy]['code_name']         = rec['Properties']['Character']
        gdata[guy]['classname']         = "GIJoe__" + guy
        gdata[guy]['loadout_ref']       = "Loadout_GIJoe__" + guy
        gdata[guy]['include']           = this_or_nothing(rec['Properties']['Include'])
        gdata[guy]['team']              = this_or_nothing(rec['Properties']['Team'])
        gdata[guy]['role']              = this_or_nothing(rec['Properties']['Role Tags'])
        gdata[guy]['first_name']        = this_or_nothing(rec['Properties']['First Name'])
        gdata[guy]['last_name']         = this_or_nothing(rec['Properties']['Last Name'])
        gdata[guy]['mos']               = this_or_nothing(rec['Properties']['MOS'])
        gdata[guy]['group']             = this_or_nothing(rec['Properties']['Group'])
        gdata[guy]['rank']              = this_or_nothing(rec['Properties']['Rank'])
        gdata[guy]['real_weapon']       = this_or_nothing(rec['Properties']['Real Weapon'])
        gdata[guy]['primary_trait']     = this_or_nothing(rec['Properties']['Unique Personal Attribute'])
        gdata[guy]['description']       = this_or_nothing(rec['Properties']['Description'])

        # ----------------------------------------------------------------------
        # Summarize the Person's attributes
        # ----------------------------------------------------------------------
        gdata[guy]['attributes'] = summarize_tags_series(rec, 'Attributes')

        # ----------------------------------------------------------------------
        # Stat progression
        # ----------------------------------------------------------------------
        gdata[guy]['stat_progression'] = {}

        for stat in stats:
            gdata[guy]['stat_progression'][stat] = {}
            gdata[guy]['stat_progression'][stat]['Tot'] = 0

        for col in cdata.columns:
            if not col[0] == 'Ranked Stats':
                continue

            for stat in stats:
                if col[1].startswith(stat):
                    gdata[guy]['stat_progression'][stat][col[1].replace(stat,"")  ] = rec[col]
                    if rec[col] > 0:
                        gdata[guy]['stat_progression'][stat]['Tot'] += rec[col]

        # ----------------------------------------------------------------------
        # Allowable weapons
        # ----------------------------------------------------------------------
        gdata[guy]['primary_weapons'] = []
        gdata[guy]['secondary_weapons'] = []
        gdata[guy]['loadout_primary'] = "MISSING"
        gdata[guy]['loadout_secondary'] = "MISSING"

        for col in cdata.columns:
            if col[0] == "Primary Weapon":
                if rec[col] in ['x','xx']:
                    gdata[guy]['primary_weapons'].append(col[1])
                if rec[col] in ['xx']:
                    gdata[guy]['loadout_primary'] = col[1]

            elif col[0] == "Secondary Weapon":
                if rec[col] in ['x','xx']:
                    gdata[guy]['secondary_weapons'].append(col[1])
                if rec[col] in ['xx']:
                    gdata[guy]['loadout_secondary'] = col[1]

        # ----------------------------------------------------------------------
        # Get their abilities
        # ----------------------------------------------------------------------
        col = ("Characters", guy)
        cols_to_take = []
        cols_to_take.append(('Abilities','desc'))
        cols_to_take.append(('Abilities','friendlyname'))
        cols_to_take.append(('Abilities','slot'))
        cols_to_take.append(('Characters',guy))
        cols_to_take.append(('Summary','attributes_summary'))
        cols_to_take.append(('Summary','keywords_summary'))

        #print(adata.head())
        #print(adata.columns.to_list())

        adatax = adata[cols_to_take].dropna(subset=[('Characters',guy)])
        adatax = adatax.droplevel(level=0,axis=1)
        adatax = adatax.rename(columns={guy:'character'})
        adatax = adatax.astype({'character':str})
        adatax = adatax.sort_values(by='character')

        gdata[guy]['abilities'] = adatax

    #print(gdata['Breaker'])
    # --------------------------------------------------------------------------
    # Finish
    # --------------------------------------------------------------------------
    return gdata

# ------------------------------------------------------------------------------
# Make the output
# ------------------------------------------------------------------------------
def compile_output(gdata):
    # --------------------------------------------------------------------------
    # Start
    # --------------------------------------------------------------------------
    print("...compiling output...")
    ccode = []
    lcode = []
    gcode = []
    tcode = []
    scode = []

    # --------------------------------------------------------------------------
    # CLASSES
    # The first thing is a list of the classes to be added to the main set
    # --------------------------------------------------------------------------
    ccode.append("; " + "*"*98)
    ccode.append("; " + "Add GI Joe classes to game")
    ccode.append("; " + "*"*98)
    ccode.append("[XComGame.X2SoldierClass_DefaultClasses]")
    for guy in gdata:
        if gdata[guy]['include'] == "x":
            line = '+SoldierClasses="' + gdata[guy]['classname'] + '"'
            ccode.append(line)
    ccode.append("")

    # --------------------------------------------------------------------------
    # LOADOUT
    # Start the bit at the beginning of the loadout code
    # --------------------------------------------------------------------------
    lcode.append("; " + "*"*98)
    lcode.append("; " + "Add loadouts for GI Joe classes")
    lcode.append("; " + "*"*98)
    lcode.append("[XComGame.X2ItemTemplateManager]")

    # --------------------------------------------------------------------------
    # GAME
    # Do the preliminary stuff needed in the file
    # --------------------------------------------------------------------------
    gcode.append("; " + "*"*98)
    gcode.append("; " + "Add Mod to game and prevent custom classes from rolling in random AWC")
    gcode.append("; " + "*"*98)
    gcode.append("[" + modname + ".X2DownloadableContentInfo_" + modname +"]")
    gcode.append('DLCIdentifier="' + modname + '"')
    gcode.append("")
    gcode.append("[XComGame.CHHelpers]")

    # --------------------------------------------------------------------------
    # TEXT LOCALIZATION
    # Fill in the text tags to be used for the created objects
    # --------------------------------------------------------------------------
    tcode.append("; " + "*"*98)
    tcode.append("; " + "Text fields")
    tcode.append("; " + "*"*98)

    # --------------------------------------------------------------------------
    # STARTING SOLDIERS
    # Start the file
    # --------------------------------------------------------------------------
    scode.append("; " + "*"*98)
    scode.append("; " + "For usage with the 'Starting Soldiers' mod")
    scode.append("; " + "*"*98)
    starting_clusters = {}
    starting_clusters['G.I. Joe']           = []
    starting_clusters['G.I. Joe Renegades'] = []
    starting_clusters['Battleforce 2000']   = []
    starting_clusters['G.I. Joe Ally']      = []
    starting_clusters['Arashikage']         = []
    starting_clusters['Oktober Guard']      = []
    starting_clusters['Cobra']              = []
    starting_clusters['M.A.R.S.']           = []
    starting_clusters['Dreadnoks']          = []
    starting_clusters['M.A.S.K.']           = []
    starting_clusters['V.E.N.O.M.']         = []
    starting_clusters['Danger Girl']        = []
    starting_clusters['Unaffiliated']       = []

    # --------------------------------------------------------------------------
    # Now every soldier gets a class
    # --------------------------------------------------------------------------
    for guy in gdata:
        # ----------------------------------------------------------------------
        # Skip over those without the include flag
        # ----------------------------------------------------------------------
        if not gdata[guy]['include'] == "x":
            continue

        # ----------------------------------------------------------------------
        # Get the primary and secondary weapons because we will need to tweak
        # some abilities based on which slot holds what
        # ----------------------------------------------------------------------
        slot_primary   = gdata[guy]['loadout_primary']
        slot_secondary = gdata[guy]['loadout_secondary']

        # ----------------------------------------------------------------------
        # CLASSES
        # Header
        # ----------------------------------------------------------------------
        ccode.append("; " + "*"*98)
        ccode.append("; " + "Code Name:".ljust(20) + guy)
        ccode.append("; " + "M.O.S.:".ljust(20)             + gdata[guy]['mos'])
        ccode.append("; ")

        ccode.append("; " + "Primary Weapon:".ljust(20)     + gdata[guy]['loadout_primary'])
        ccode.append("; " + "Secondary Weapon:".ljust(20)   + gdata[guy]['loadout_secondary'])
        ccode.append("; ")

        ccode.append("; " + "Total Aim:".ljust(20)          + str(int(gdata[guy]['stat_progression']['Aim']['Tot'])))
        ccode.append("; " + "Total HP:".ljust(20)           + str(int(gdata[guy]['stat_progression']['HP']['Tot'])))
        ccode.append("; " + "Total Will:".ljust(20)         + str(int(gdata[guy]['stat_progression']['Will']['Tot'])))
        ccode.append("; " + "Total Hack:".ljust(20)         + str(int(gdata[guy]['stat_progression']['Hack']['Tot'])))
        ccode.append("; " + "Total Dodge:".ljust(20)        + str(int(gdata[guy]['stat_progression']['Dodge']['Tot'])))
        ccode.append("; " + "Total Psi:".ljust(20)          + str(int(gdata[guy]['stat_progression']['Psi']['Tot'])))
        ccode.append("; ")

        ccode.append("; " + "Role:".ljust(20)               + gdata[guy]['role'])
        ccode.append("; " + "Group:".ljust(20)              + gdata[guy]['group'])
        ccode.append("; " + "Personal Trait:".ljust(20)     + gdata[guy]['primary_trait'])
        ccode.append("; " + "Attributes:".ljust(20)         + gdata[guy]['attributes'])
        ccode.append("; ")

        ccode.append("; " + "Real Name:".ljust(20)          + gdata[guy]['first_name'] + " " + gdata[guy]['last_name'])
        ccode.append("; " + "Military Rank:".ljust(20)      + gdata[guy]['rank'])
        ccode.append("; " + "Real Weapon:".ljust(20)        + gdata[guy]['real_weapon'])
        ccode.append("; ")

        ccode.append("; " + "Rank:".ljust(10) + "Ability:".ljust(30) + "Description:")
        div = True
        for j, rec in gdata[guy]['abilities'].iterrows():
            try:
                num = float(rec['character'])
            except:
                print(guy, rec)
                num = 0

            #print(rec['character'], num, type(num))
            if (num > 90.0) and div:
                ccode.append("; ")
                div = False
            ccode.append("; " + rec['character'].center(10) + str(rec['friendlyname']).ljust(30) + str(rec['desc']))
        ccode.append("; ")

        ccode.append("; " + "*"*98)
        ccode.append("[" + gdata[guy]['classname'] + " X2SoldierClassTemplate]")

        # ----------------------------------------------------------------------
        # CLASSES
        # General
        # ----------------------------------------------------------------------
        ccode.append('+bMultiplayerOnly=0')
        ccode.append('+ClassPoints=4')
        ccode.append('+IconImage="img:///UILibrary_InfantryClass.class_infantry"')
        ccode.append('+NumInForcedDeck=0')
        ccode.append('+NumInDeck=4')
        ccode.append('+KillAssistsPerKill=4')
        ccode.append('+bAllowAWCAbilities=true')
        ccode.append('+bCanHaveBonds=true')
        ccode.append('+BaseAbilityPointsPerPromotion=3')
        ccode.append('+SquaddieLoadout="' + gdata[guy]['loadout_ref'] + '"')
        ccode.append('+AllowedArmors="soldier"')
        ccode.append("")

        # ----------------------------------------------------------------------
        # CLASSES
        # Allowed weapons for primary and secondary
        # ----------------------------------------------------------------------
        for weapon in gdata[guy]['primary_weapons']:
            ccode.append('+AllowedWeapons=(SlotType=eInvSlot_PrimaryWeapon, WeaponType="' + weapon +'")')
        for weapon in gdata[guy]['secondary_weapons']:
            ccode.append('+AllowedWeapons=(SlotType=eInvSlot_SecondaryWeapon, WeaponType="' + weapon +'")')

        # ----------------------------------------------------------------------
        # CLASSES
        # Determine correct thing to go in heavy, if any
        # ----------------------------------------------------------------------
        if 'lw_gauntlet' in gdata[guy]['secondary_weapons']:
            ccode.append('+AllowedWeapons=(SlotType=eInvSlot_HeavyWeapon, WeaponType="heavyammo")')
        elif 'iri_rocket_launcher' in gdata[guy]['secondary_weapons']:
            ccode.append('+AllowedWeapons=(SlotType=eInvSlot_HeavyWeapon, WeaponType="heavyammo")')
        elif 'Sparkbit_CV' in gdata[guy]['secondary_weapons']:
            ccode.append('+AllowedWeapons=(SlotType=eInvSlot_HeavyWeapon, WeaponType="heavy")')
        #else:
        #    ccode.append('+AllowedWeapons=(SlotType=eInvSlot_HeavyWeapon, WeaponType="heavy")')
        ccode.append("")

        # ----------------------------------------------------------------------
        # CLASSES
        # Ranks
        # ----------------------------------------------------------------------
        for i in range(1,9):
            # ------------------------------------------------------------------
            # Header
            # ------------------------------------------------------------------
            ccode.append("; Rank " + str(i))
            ccode.append("+SoldierRanks=(".ljust(120) + "\\\\")
            
            # ------------------------------------------------------------------
            # Abilities
            # ------------------------------------------------------------------
            ccode.append("  AbilitySlots=(".ljust(120) + "\\\\")

            this_rank_abilities = gdata[guy]['abilities'][gdata[guy]['abilities']['character']==str(float(i))]

            abilities = []
            for ability,rec in this_rank_abilities.iterrows():
                pieces = []
                pieces.append("AbilityName=" + quoted(ability))
                #print(guy, ability, rec)

                if pd.notna(rec['slot']):
                    pieces.append("ApplyToWeaponSlot=" + rec['slot'])

                line = "(AbilityType=(" + ",".join(pieces) + "))"
                abilities.append(line)

            for j, line in enumerate(abilities):
                if j < len(abilities)-1:
                    line += ","
                ccode.append("                    " + line.ljust(100) + "\\\\")

            ccode.append("  ),".ljust(120) + "\\\\")
            
            # ------------------------------------------------------------------
            # Stats
            # ------------------------------------------------------------------
            ccode.append("  aStatProgression=(".ljust(120) + "\\\\")

            statlines = []
            for stat in gdata[guy]['stat_progression']:
                if gdata[guy]['stat_progression'][stat][str(i)] > 0:
                    if stat == "Aim":
                        stype = "eStat_Offense"
                    elif stat == "HP":
                        stype = "eStat_HP"
                    elif stat == "Will":
                        stype = "eStat_Will"
                    elif stat == "Hack":
                        stype = "eStat_Hacking"
                    elif stat == "Strength":
                        stype = "eStat_Strength"
                    elif stat == "Dodge":
                        stype = "eStat_Dodge"
                    elif stat == "Psi":
                        stype = "eStat_CombatSims"
                    line = "(StatType=" + stype.ljust(16) + ",StatAmount=" + str(gdata[guy]['stat_progression'][stat][str(i)]) + ")"
                    statlines.append(line)

            for j, line in enumerate(statlines):
                if j < len(statlines)-1:
                    line += ","
                ccode.append("                    " + line.ljust(100) + "\\\\")

            ccode.append("  )".ljust(120) + "\\\\")

            # ------------------------------------------------------------------
            # Finish
            # ------------------------------------------------------------------
            ccode.append(")")
            ccode.append("")

        # ----------------------------------------------------------------------
        # CLASSES
        # Finish the class code
        # ----------------------------------------------------------------------
        ccode.append("")

        # ----------------------------------------------------------------------
        # LOADOUT
        # Now do the loadout code
        # ----------------------------------------------------------------------
        loadoutname   = '"' + gdata[guy]['loadout_ref'] + '"'
        primaryname   = '"' + gdata[guy]['loadout_primary'] + '_CV"'
        secondaryname = '"' + gdata[guy]['loadout_secondary'] + '_CV"'

        lcode.append("+Loadouts=(LoadoutName=" + loadoutname.ljust(32) + ", Items[0]=(Item=" + primaryname.ljust(25) + "), Items[1]=(Item=" + secondaryname.ljust(25) + "))")

        # ----------------------------------------------------------------------
        # GAME
        # Need a list for excluding the classes from AWC loadout
        # ----------------------------------------------------------------------
        gcode.append("+ClassesExcludedFromAWCRoll=" + gdata[guy]['classname'])

        # ----------------------------------------------------------------------
        # TEXT LOCALIZATION
        # ----------------------------------------------------------------------
        tcode.append("; " + "-"*78)
        tcode.append("; " + guy)
        tcode.append("; " + "-"*78)

        tcode.append("[" + gdata[guy]['classname'] + " X2SoldierClassTemplate]")
        tcode.append("DisplayName".ljust(20)            + " = " + "GI Joe: " + quoted(guy))
        tcode.append("ClassSummary".ljust(20)           + " = " + quoted(gdata[guy]['mos']))
        tcode.append("LeftAbilityTreeTitle".ljust(20)   + " = " + quoted(gdata[guy]['role']))
        #tcode.append("RightAbilityTreeTitle".ljust(20)  + " = " + quoted(gdata[guy]['group']))
        tcode.append("RandomNicknames[0]".ljust(20)     + " = " + quoted(guy))
        tcode.append("")

        # ----------------------------------------------------------------------
        # STARTING SOLDIERS
        # Add the line to the appropriate list
        # ----------------------------------------------------------------------
        cluster = gdata[guy]['team']
        full_name = '"' + gdata[guy]['first_name'] + " " + gdata[guy]['last_name'] + '"'
        class_name = '"' + gdata[guy]['classname'] + '"'

        line = ".CHARACTER_INFO=(SoldierName=" + full_name.ljust(30) + ", SoldierClass=" + class_name.ljust(30) + ", SoldierRank=2)"

        starting_clusters[cluster].append(line) 

    # --------------------------------------------------------------------------
    # STARTING SOLDIERS
    # --------------------------------------------------------------------------
    for cluster in starting_clusters:
        scode.append("; " + "-"*78)
        scode.append("; " + cluster)
        scode.append("; " + "-"*78)
        scode.append("[WOTCStartingSoldiers.X2DownloadableContentInfo_WOTCStartingSoldiers]")
            
        for line in starting_clusters[cluster]:
            #if not cluster == 'G.I. Joe':
            #    continue
            scode.append(line)
        scode.append("")

    scode.append("+bRemoveStartingSoldiers=true;")
    scode.append("+bReplaceStartingSquad=true;")

    # --------------------------------------------------------------------------
    # Finish
    # --------------------------------------------------------------------------
    return ccode, lcode, gcode, tcode, scode


# ------------------------------------------------------------------------------
# Make a new column in a dataframe summarizing things flagged elsewhere in the
# dataframe
# ------------------------------------------------------------------------------
def summarize_tags(df, levelname):
    # --------------------------------------------------------------------------
    # Each record
    # --------------------------------------------------------------------------
    summary = []
    for i, rec in df.iterrows():
        # ----------------------------------------------------------------------
        # Each column, check if they have data there and add the name of the
        # column (minus the level) to the list
        # ----------------------------------------------------------------------
        this_sum = []
        for col in df.columns:
            if col[0] == levelname:
                if not pd.isnull(rec[col]):
                    this_sum.append(col[1])

        # ----------------------------------------------------------------------
        # Add the list of column names as an entry for this variable
        # ----------------------------------------------------------------------
        summary.append(", ".join(this_sum))

    # --------------------------------------------------------------------------
    # Finish
    # --------------------------------------------------------------------------
    return summary

# ------------------------------------------------------------------------------
# Make a new column in a dataframe summarizing things flagged elsewhere in the
# dataframe
# same thing but only one level, from a series
# ------------------------------------------------------------------------------
def summarize_tags_series(series, levelname):
    # --------------------------------------------------------------------------
    # Get the record as a dictionary
    # --------------------------------------------------------------------------
    data = series.to_dict()

    # --------------------------------------------------------------------------
    # Go through each multi-level key and gather the ones flagged at the
    # specified level
    # --------------------------------------------------------------------------
    this_sum = []
    for key in data:
        if key[0] == levelname:
            if not pd.isnull(data[key]):
                this_sum.append(key[1])

    # --------------------------------------------------------------------------
    # Make it into a comma separated list
    # --------------------------------------------------------------------------
    summary = ", ".join(this_sum)

    # --------------------------------------------------------------------------
    # Finish
    # --------------------------------------------------------------------------
    return summary

# ------------------------------------------------------------------------------
# Return either the value of a cell or a proper None
# ------------------------------------------------------------------------------
def this_or_nothing(thing):
    if not pd.isnull(thing):
        return thing
    else:
        return ""

# ------------------------------------------------------------------------------
# Put quotes around a text string, escaping existing quotes with "" if necessary
# ------------------------------------------------------------------------------
def quoted(string, escape=True):
    if escape and '"' in string:
        string = string.replace('"', '""')
    return '"' + string + '"'

# ------------------------------------------------------------------------------
# Get the perk data from the text file
# ------------------------------------------------------------------------------
def parse_perk_data(pfile):
    # --------------------------------------------------------------------------
    # Start
    # --------------------------------------------------------------------------
    print("...reading marked up text source...")

    # --------------------------------------------------------------------------
    # Get the text data out of the file and hold it as a list
    # --------------------------------------------------------------------------
    fdata = open(pfile, "r", encoding="utf-8").read().splitlines()

    # --------------------------------------------------------------------------
    # Work through it and catalog things at the perk level
    # --------------------------------------------------------------------------
    perks = []
    perk = {}
    for i, line in enumerate(fdata):
        # ----------------------------------------------------------------------
        # Trim whitespace
        # ----------------------------------------------------------------------
        line = line.strip()

        # ----------------------------------------------------------------------
        # Skip blank lines
        # ----------------------------------------------------------------------
        if len(line) == 0:
            continue

        # ----------------------------------------------------------------------
        # Section headers, just skip for now
        # ----------------------------------------------------------------------
        if line.startswith("/"):
            continue

        # ----------------------------------------------------------------------
        # When we hit a new perk
        # ----------------------------------------------------------------------
        if line.startswith("----"):
            # ------------------------------------------------------------------
            # Add the previous perk to the list if it's there
            # ------------------------------------------------------------------
            if perk:
                perks.append(perk)

            # ------------------------------------------------------------------
            # Start a new perk
            # ------------------------------------------------------------------
            perk = {}
            pname, pdesc = line[5:].split(":",1)
            perk[("Ability", "Name")] = pname.strip()
            perk[("Ability", "Desc")] = pdesc.strip()

        # ----------------------------------------------------------------------
        # When we hit an alias tag
        # ----------------------------------------------------------------------
        elif line.startswith("="):
            perk[("Ability", "Alias")] = re.sub("^=+","",line).strip()

        # ----------------------------------------------------------------------
        # When we hit a source tag
        # ----------------------------------------------------------------------
        elif line.startswith(":"):
            tag = re.sub("^#+","",line).strip()
            perk[("Source", tag)] = "x"

        # ----------------------------------------------------------------------
        # When we hit a dependency tag
        # ----------------------------------------------------------------------
        elif line.startswith("#"):
            tag = re.sub("^#+","",line).strip()
            perk[("Dependency", tag)] = "x"

        # ----------------------------------------------------------------------
        # When we hit a theme tag
        # ----------------------------------------------------------------------
        elif line.startswith("*"):
            tag = re.sub("^\*+","",line).strip()
            perk[("Theme", tag)] = "x"

        # ----------------------------------------------------------------------
        # When we hit a character tag
        # ----------------------------------------------------------------------
        elif line.startswith("@"):
            tag = re.sub("^@+","",line).strip()
            perk[("Character", tag)] = "x"

        # ----------------------------------------------------------------------
        # When we have hit the last line
        # ----------------------------------------------------------------------
        if i == len(fdata)-1:
            perks.append(perk)

    # --------------------------------------------------------------------------
    # Make that into a dataframe
    # --------------------------------------------------------------------------
    tdata = pd.DataFrame(perks)
    tdata.columns = pd.MultiIndex.from_tuples(tdata.columns)
    tdata = tdata.sort_index(axis=1)

    # --------------------------------------------------------------------------
    # Finish
    # --------------------------------------------------------------------------
    return tdata

# ------------------------------------------------------------------------------
# Run
# ------------------------------------------------------------------------------
if __name__ == "__main__":
    main()
