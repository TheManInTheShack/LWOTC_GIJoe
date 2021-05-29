# ------------------------------------------------------------------------------
# Imports
# ------------------------------------------------------------------------------
import sys
import pandas as pd

# ------------------------------------------------------------------------------
# Init
# ------------------------------------------------------------------------------
dfile = "data.xlsx"
cfile = "XComClassData.ini"
lfile = "XComGameData.ini"

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
    cdata = pd.read_excel(dfile, sheet_name="characters", header=[0,2],index_col=0,engine="openpyxl")
    adata = pd.read_excel(dfile, sheet_name="abilities", header=[0,2],index_col=0,engine="openpyxl")

    # --------------------------------------------------------------------------
    # Compile class data for each guy
    # --------------------------------------------------------------------------
    gdata = compile_class_data(cdata, adata)

    # --------------------------------------------------------------------------
    # Make the output file
    # --------------------------------------------------------------------------
    ccode, lcode = compile_output(gdata)

    # --------------------------------------------------------------------------
    # Save the output files
    # --------------------------------------------------------------------------
    with open(cfile, "w", encoding="utf-8") as f:
        for line in ccode:
            print(line, file=f)

    with open(lfile, "w", encoding="utf-8") as f:
        for line in lcode:
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
        # Start record for this guy
        # ----------------------------------------------------------------------
        gdata[guy] = {}

        # ----------------------------------------------------------------------
        # Set the general properties
        # ----------------------------------------------------------------------
        gdata[guy]['code_name']       = rec['Properties']['Character']
        gdata[guy]['classname']       = "GIJoe__" + guy
        gdata[guy]['loadout_ref']     = "Loadout_GIJoe__" + guy
        gdata[guy]['role']            = this_or_nothing(rec['Properties']['Role Tags'])
        gdata[guy]['first_name']      = this_or_nothing(rec['Properties']['First Name'])
        gdata[guy]['last_name']       = this_or_nothing(rec['Properties']['Last Name'])
        gdata[guy]['mos']             = this_or_nothing(rec['Properties']['MOS'])
        gdata[guy]['group']           = this_or_nothing(rec['Properties']['Group'])
        gdata[guy]['rank']            = this_or_nothing(rec['Properties']['Rank'])
        gdata[guy]['real_weapon']     = this_or_nothing(rec['Properties']['Real Weapon'])
        gdata[guy]['primary_trait']   = this_or_nothing(rec['Properties']['Attribute'])

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
        cols_to_take.append(('Abilities','Perk Description'))
        #cols_to_take.append(('Abilities','Ability Tags'))
        #cols_to_take.append(('Abilities','Role Tags'))
        #cols_to_take.append(('Abilities','Talent Tags'))
        #cols_to_take.append(('Abilities','Equipment Tags'))
        cols_to_take.append(('Abilities','Perk Friendly Name'))
        cols_to_take.append(('Characters',guy))
        cols_to_take.append(('Summary','attributes_summary'))
        cols_to_take.append(('Summary','keywords_summary'))

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
    ccode = []
    lcode = []

    # --------------------------------------------------------------------------
    # CLASSES
    # The first thing is a list of the classes to be added to the main set
    # --------------------------------------------------------------------------
    ccode.append("; " + "*"*98)
    ccode.append("; " + "Add classes to game")
    ccode.append("; " + "*"*98)
    ccode.append("[XComGame.X2SoldierClass_DefaultClasses]")
    for guy in gdata:
        line = '+SoldierClass="' + gdata[guy]['classname'] + '"'
        ccode.append(line)
    ccode.append("")

    # --------------------------------------------------------------------------
    # LOADOUT
    # Start the bit at the beginning of the loadout code
    # --------------------------------------------------------------------------
    lcode.append("[XComGame.X2ItemTemplateManager]")

    # --------------------------------------------------------------------------
    # Now every soldier gets a class
    # --------------------------------------------------------------------------
    for guy in gdata:
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
        ccode.append("; " + "Traits:".ljust(20)             + gdata[guy]['attributes'])
        ccode.append("; ")

        ccode.append("; " + "Real Name:".ljust(20)          + gdata[guy]['first_name'] + " " + gdata[guy]['last_name'])
        ccode.append("; " + "Military Rank:".ljust(20)      + gdata[guy]['rank'])
        ccode.append("; " + "Real Weapon:".ljust(20)        + gdata[guy]['real_weapon'])
        ccode.append("; ")

        ccode.append("; " + "Rank:".ljust(10) + "Ability:".ljust(30) + "Description:")
        for j, rec in gdata[guy]['abilities'].iterrows():
            ccode.append("; " + rec['character'].center(10) + rec['Perk Friendly Name'].ljust(30) + rec['Perk Description'])

        ccode.append("; " + "*"*98)
        ccode.append("[" + gdata[guy]['classname'] + " X2SoldierClassTemplate]")

        # ----------------------------------------------------------------------
        # CLASSES
        # General
        # ----------------------------------------------------------------------
        ccode.append('+bMultiplayerOnly=0')
        ccode.append('+ClassPoints=4')
        ccode.append('+IconImage="img:///UILibrary_InfantryClass.class_infantry"')
        ccode.append('+NumInForcedDeck=1')
        ccode.append('+NumInDeck=4')
        ccode.append('+KillAssistsPerKill=4')
        ccode.append('+bAllowAWCAbilities=1')
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
        # If they have the gauntlet, they are heavy ammo, otherwise heavy
        # ----------------------------------------------------------------------
        if 'lw_gauntlet' in gdata[guy]['secondary_weapons']:
            ccode.append('+AllowedWeapons=(SlotType=eInvSlot_HeavyWeapon, WeaponType="heavyammo")')
        else:
            ccode.append('+AllowedWeapons=(SlotType=eInvSlot_HeavyWeapon, WeaponType="heavy")')
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
            ccode.append("+SoldierRanks=(".ljust(80) + "\\\\")
            
            # ------------------------------------------------------------------
            # Abilities
            # ------------------------------------------------------------------
            ccode.append("  AbilitySlots=(".ljust(80) + "\\\\")

            this_rank_abilities = gdata[guy]['abilities'][gdata[guy]['abilities']['character']==i]

            abilities = []
            for ability,rec in this_rank_abilities.iterrows():
                line = "(AbilityType=(AbilityName=" + ability
                abilities.append(line)

            for j, line in enumerate(abilities):
                if j < len(abilities)-1:
                    line += ","
                ccode.append("                    " + line.ljust(60) + "\\\\")

            ccode.append("  ),".ljust(80) + "\\\\")
            
            # ------------------------------------------------------------------
            # Stats
            # ------------------------------------------------------------------
            ccode.append("  aStatProgression=(".ljust(80) + "\\\\")

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
                ccode.append("                    " + line.ljust(60) + "\\\\")

            ccode.append("  )".ljust(80) + "\\\\")

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
        loadoutname = '"' + gdata[guy]['loadout_ref'] + '"'
        primaryname = '"' + gdata[guy]['loadout_primary'] + '_CV"'
        secondaryname = '"' + gdata[guy]['loadout_secondary'] + '_CV"'

        lcode.append("+Loadouts=(LoadoutName=" + loadoutname.ljust(32) + ", Items[0]=(Item=" + primaryname.ljust(25) + "), Items[1]=(Item=" + secondaryname.ljust(25) + "))")

    # --------------------------------------------------------------------------
    # Finish
    # --------------------------------------------------------------------------
    return ccode, lcode


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
# Run
# ------------------------------------------------------------------------------
if __name__ == "__main__":
    main()
