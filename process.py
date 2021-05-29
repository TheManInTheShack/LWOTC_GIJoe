# ==============================================================================
# ==============================================================================

# ------------------------------------------------------------------------------
# Import
# ------------------------------------------------------------------------------
from datetime import datetime
import os
import sys
import argparse
import shutil
import json
import operator

import pandas as pd
from textblob import TextBlob
from nltk.corpus import stopwords


# ------------------------------------------------------------------------------
# Init
# ------------------------------------------------------------------------------
stops = stopwords.words()

pd.set_option("display.width", 10000)
pd.set_option("display.max_rows", 50)
pd.set_option("display.max_columns", 8)

# ------------------------------------------------------------------------------
# CLI
# ------------------------------------------------------------------------------
parser = argparse.ArgumentParser()
#parser.add_argument("some_arg_alas",  type=str, help="help text to be displayed")
#parser.add_argument("other_arg_alas", type=int, help="help text to be displayed")

args = parser.parse_args()

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
    characters   = pd.read_excel("data.xlsx", sheet_name="characters"   , header=0, index_col=0, skiprows=2)
    abilities    = pd.read_excel("data.xlsx", sheet_name="abilities"    , header=0, index_col=0, skiprows=2)
    lexicon      = pd.read_excel("data.xlsx", sheet_name="lexicon"      , header=0, index_col=0, skiprows=2)
    ability_tags = pd.read_excel("data.xlsx", sheet_name="Ability Tags" , header=0,              skiprows=2)

    # --------------------------------------------------------------------------
    # Lexify the Perk Description text (just done once)
    # --------------------------------------------------------------------------
    #newlex = lexify_series(abilities['Perk Description'])
    #x = write_output_lexicon(newlex)
    
    # --------------------------------------------------------------------------
    # Add already-existing lexical keywords to abilities
    # --------------------------------------------------------------------------
    #abilitex = add_lexical_keywords(abilities, lexicon)
    #x = write_simple(abilitex, "out_abilities.xlsx", "abilities")

    # --------------------------------------------------------------------------
    # Sort out Ability tags
    # --------------------------------------------------------------------------
    abilitag = organize_tags(abilities, "Ability Tags" , ability_tags, "Tag")
    x = write_simple(abilitag, "out_ability_tags.xlsx", "ability_tags", show_index=False)

    # --------------------------------------------------------------------------
    # Write the character classes
    # --------------------------------------------------------------------------
    class_data = compile_class_data(characters, abilities, abilitag)

    # --------------------------------------------------------------------------
    # Finish
    # --------------------------------------------------------------------------
    print("...finished.")

# ------------------------------------------------------------------------------
# Given a Pandas Series presumed to be text, build a lexicon
# ------------------------------------------------------------------------------
def lexify_series(text_series):
    # --------------------------------------------------------------------------
    # Start
    # --------------------------------------------------------------------------
    print("...lexifying text series...")

    # --------------------------------------------------------------------------
    # Go through each record
    # --------------------------------------------------------------------------
    lexicon = {}
    for i, text in text_series.iteritems():
        # ----------------------------------------------------------------------
        # Textblob gives us everything we need
        # ----------------------------------------------------------------------
        blob = TextBlob(text)

        # ----------------------------------------------------------------------
        # Grab the part-of-speech tags and make them a lookup table
        # ----------------------------------------------------------------------
        tags = dict(blob.tags)

        # ----------------------------------------------------------------------
        # Each word is its own entry
        # ----------------------------------------------------------------------
        for word in blob.words:
            # ------------------------------------------------------------------
            # Start a new word
            # ------------------------------------------------------------------
            if not word.lower() in lexicon:
                lexicon[word.lower()] = {}
                lexicon[word.lower()]['instances'] = []
                lexicon[word.lower()]['variations'] = []
                lexicon[word.lower()]['usage'] = []
                lexicon[word.lower()]['lemn'] = ""
                lexicon[word.lower()]['lemv'] = ""

            # ------------------------------------------------------------------
            # Add this record to the list of instances
            # ------------------------------------------------------------------
            if not i in lexicon[word.lower()]['instances']:
                lexicon[word.lower()]['instances'].append(i)

            # ------------------------------------------------------------------
            # Add this format to the list of variations
            # ------------------------------------------------------------------
            if not word in lexicon[word.lower()]['variations']:
                lexicon[word.lower()]['variations'].append(word)

            # ------------------------------------------------------------------
            # Determine the usage
            # ------------------------------------------------------------------
            if word in tags:
                usage = tags[word]
            else:
                useage = ""
            if not usage in lexicon[word.lower()]['usage']:
                lexicon[word.lower()]['usage'].append(usage)

            # ------------------------------------------------------------------
            # Lemmatize the word for both noun and verb
            # ------------------------------------------------------------------
            lemn = word.lemmatize("n").lower()
            lemv = word.lemmatize("v").lower()

            if not lemn in lexicon[word.lower()]['lemn']:
                lexicon[word.lower()]['lemn'] = lemn

            if not lemv in lexicon[word.lower()]['lemv']:
                lexicon[word.lower()]['lemv'] = lemv

            # ------------------------------------------------------------------
            # Flag if it's a stopword
            # ------------------------------------------------------------------
            if word in stops:
                lexicon[word.lower()]['stopword'] = True
            else:
                lexicon[word.lower()]['stopword'] = False

            # ------------------------------------------------------------------
            # Flag if it doesn't contain any letters
            # ------------------------------------------------------------------
            is_nontext = True
            for char in word:
                if char.lower() in "abcdefghijklmnopqrstuvwxyz":
                    is_nontext = False

            lexicon[word.lower()]['not text'] = is_nontext

            # ------------------------------------------------------------------
            # Check if it's a number
            # ------------------------------------------------------------------
            if is_number(word):
                lexicon[word.lower()]['number'] = True
            else:
                lexicon[word.lower()]['number'] = False

            # ------------------------------------------------------------------
            # Get the WordNet synsets 
            # ------------------------------------------------------------------
            lexicon[word.lower()]['synsets'] = word.synsets

            # ------------------------------------------------------------------
            # Get the dictionary defiition
            # ------------------------------------------------------------------
            #lexicon[word.lower()]['definition'] = word.definitions

    # --------------------------------------------------------------------------
    # Finish
    # --------------------------------------------------------------------------
    return lexicon

# ------------------------------------------------------------------------------
# Add the lexical keywords to the abilities grid
# ------------------------------------------------------------------------------
def add_lexical_keywords(abilities, lexicon):
    # --------------------------------------------------------------------------
    # Start
    # --------------------------------------------------------------------------
    print("...adding lexical keywords to abilities...")

    #print(abilities)
    #print(lexicon)

    # --------------------------------------------------------------------------
    # A lookup table from word to keyword
    # --------------------------------------------------------------------------
    lookup = lexicon['keyword'].dropna().to_dict()

    # --------------------------------------------------------------------------
    # An alphabetical list of the keywords
    # --------------------------------------------------------------------------
    keywords = sorted(list(set([lookup[x] for x in lookup])))

    # --------------------------------------------------------------------------
    # Go through each keyword, which will become its own column
    # Prime each one with the text that we'll examine
    # --------------------------------------------------------------------------
    #print(lookup)
    for keyword in keywords:
        abilities[keyword] = abilities['Perk Description']
        abilities[keyword] = abilities[keyword].apply(flag_keyword, args=(keyword, lookup))

    # --------------------------------------------------------------------------
    # Finish
    # --------------------------------------------------------------------------
    return abilities

# ------------------------------------------------------------------------------
# Fill in key words given a text, a particular key, and the lookup of words to
# keywords
# ------------------------------------------------------------------------------
def flag_keyword(text, keyword, lookup):
    # --------------------------------------------------------------------------
    # Textblob the text and pull out its words
    # --------------------------------------------------------------------------
    blob = TextBlob(text)
    words = [x.lower() for x in list(blob.words)]

    # --------------------------------------------------------------------------
    # If it's there we want the lookup
    # --------------------------------------------------------------------------
    flag = ""
    for word in words:
        if word in lookup:
            if lookup[word] == keyword:
                flag = "X"

    #print(keyword, text, words, flag)

    # --------------------------------------------------------------------------
    # Finish
    # --------------------------------------------------------------------------
    return flag

# ------------------------------------------------------------------------------
# Write the output to file
# ------------------------------------------------------------------------------
def write_output_lexicon(lexicon):
    # --------------------------------------------------------------------------
    # Start
    # --------------------------------------------------------------------------
    print("...preparing lexicon output...")

    # --------------------------------------------------------------------------
    # Put together the matrix
    # --------------------------------------------------------------------------
    output = []
    for word in lexicon:
        inst = len(lexicon[word]['instances'])
        var  = ",".join(lexicon[word]['variations'])
        use  = ",".join(lexicon[word]['usage'])
        lemn = lexicon[word]['lemn']
        lemv = lexicon[word]['lemv']
        stop = lexicon[word]['stopword']
        ntxt = lexicon[word]['not text']
        num  = lexicon[word]['number']
        syn  = len(lexicon[word]['synsets'])

        rec = (word, inst, var, use, lemn, lemv, stop, ntxt, num, syn)
        output.append(rec)

    # --------------------------------------------------------------------------
    # Make it a dataframe
    # --------------------------------------------------------------------------
    df = pd.DataFrame(output, columns=['word','instances','variations','usage','lemmatized (n)', 'lemmatized (v)', 'stop word', 'not text', 'number', 'synsets'])

    # --------------------------------------------------------------------------
    # Write to file
    # --------------------------------------------------------------------------
    df.to_excel("out_lexicon.xlsx", index=False, sheet_name="lexicon")

    # --------------------------------------------------------------------------
    # Finish
    # --------------------------------------------------------------------------
    return True

# ------------------------------------------------------------------------------
# Output the revised abilities
# ------------------------------------------------------------------------------
def write_simple(data, outfile, outsheet, show_index):
    # --------------------------------------------------------------------------
    # Start
    # --------------------------------------------------------------------------
    print("...preparing output worksheet...")

    # --------------------------------------------------------------------------
    # Simple 
    # --------------------------------------------------------------------------
    data.to_excel(outfile, index=show_index, sheet_name=outsheet)

    # --------------------------------------------------------------------------
    # Finish
    # --------------------------------------------------------------------------
    return True

# ------------------------------------------------------------------------------
# 
# ------------------------------------------------------------------------------
def organize_tags(source_data, source_variable, tag_data, tag_variable, delim=","):
    # --------------------------------------------------------------------------
    # Start
    # --------------------------------------------------------------------------
    print("...organizing tag data...")

    # --------------------------------------------------------------------------
    # Get the human-entered tags and the list of what we already have
    # --------------------------------------------------------------------------
    source = source_data[source_variable].to_list()
    existing_tags = tag_data[tag_variable].to_list()

    # --------------------------------------------------------------------------
    # Go through all the tags, split them out, and compile the list of ones
    # that haven't been accounted for yet
    # --------------------------------------------------------------------------
    for item in source:
        tags = str(item).split(delim)
        for tag in tags:
            tag = tag.strip()
            if not tag in existing_tags:
                tag_data = tag_data.append({tag_variable: tag}, ignore_index=True)
                existing_tags.append(tag)

    # --------------------------------------------------------------------------
    # Finish
    # --------------------------------------------------------------------------
    return tag_data

# ------------------------------------------------------------------------------
# Compile the class data
# ------------------------------------------------------------------------------
def compile_class_data(characters, abilities, abilitag):
    # --------------------------------------------------------------------------
    # Start
    # --------------------------------------------------------------------------
    print("...compiling character class data...")
    class_data = {}

    # --------------------------------------------------------------------------
    # Go through each character
    # --------------------------------------------------------------------------
    for i, char in enumerate(characters.index):
        # ----------------------------------------------------------------------
        # 
        # ----------------------------------------------------------------------
        chardata = characters.loc[char]

        # ----------------------------------------------------------------------
        # ----------------------------------------------------------------------
        abil = abilities[['Perk Friendly Name','Role Tags', 'Ability Tags', 'Rank', char, 'Skip']]
        abil = abil.dropna(subset=[char])
        abil = abil.drop(abil[abil['Skip']=="x"].index)
        abil = abil.drop(['Skip'], axis=1)

        if len(abil) == 0:
            continue

        #if i > 0:
        #    continue

        print("------------------------------------------------------------------------------------------------------")
        print(char)
        print("Role:      ", chardata['Role Tags'])
        print("Talent:    ", chardata['Talent Tags'])
        print("Equipment: ", chardata['Equipment Tags'])
        print(abil)
        print("")

        # ----------------------------------------------------------------------
        # Add this soldier to the structure 
        # ----------------------------------------------------------------------
        class_data[char] = chardata


    # --------------------------------------------------------------------------
    # Finish
    # --------------------------------------------------------------------------
    return class_data

# ------------------------------------------------------------------------------
# Little utility for saying whether an item is mathable
# ------------------------------------------------------------------------------
def is_number(s):
    try:
        float(str(s))
        return True
    except ValueError:
        return False

# ------------------------------------------------------------------------------
# Run
# ------------------------------------------------------------------------------
if __name__ == "__main__":
    start_time = datetime.utcnow()
    main()
    end_time     = datetime.utcnow()
    elapsed_time = end_time - start_time
    print("Elapsed time: " + str(elapsed_time))
