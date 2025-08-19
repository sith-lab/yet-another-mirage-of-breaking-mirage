import os
import numpy as np
from scipy.stats import pearsonr
import sys


profiling_key = [0x20, 0x5e, 0x87, 0x2e, 0x1e, 0xfc, 0x8f, 0x27, 0x10, 0xc4, 0x82, 0x43, 0xaf, 0x1c, 0xdb, 0xa1]

victim_key = [0xde, 0x94, 0x73, 0x5a, 0x1a, 0x2e, 0x6b, 0x06, 0xe7, 0xaa, 0xec, 0xed, 0x8b, 0x81, 0x5a, 0xe6]

mapping = {
            0 : 0,
            1 : 1,
            2 : 2,
            3 : 3,
            4 : 5,
            5 : 6,
            6 : 7,
            7 : 4,
            8 : 10, 
            9 : 11,
            10 : 8,
            11 : 9,
            12 : 15,
            13 : 12,
            14 : 13,
            15 : 14
        }
position = mapping[int(sys.argv[1])]
max_traces = int(sys.argv[2])
profiling_key_dir = sys.argv[3]
victim_key_dir    = sys.argv[4]
true_byte = profiling_key[position]
expected_key_byte = victim_key[position]
########## Process gem5 logs ######################
def list_files_in_subdirectories(path):
    all_files = []
    for root, dirs, files in os.walk(path):
        for single_file in files:
            test_file = os.path.join(root, single_file)
            all_files.append(test_file)
    return all_files


######## Develop tuples ###########################
def develop_tuples(round_timing_tuples, filename, key_position): 
    #print("Processing ", filename)
    sys.stdout.flush()
    datalines = open(filename).readlines()
    index = 0
    for data in datalines:
        if(index > max_traces):
            continue
        index = index + 1
        if(data is not None and data.find("Attacker") >= 0):
            data = data.strip().split()
            time = int(data[3][:-1])
            ciphertext = [int(h, 16) for h in data[6:22]]
            round_timing_tuples.append([ciphertext[key_position], time])

round_timing_tuples = []

all_files = list_files_in_subdirectories(profiling_key_dir)
for filename in all_files:
    develop_tuples(round_timing_tuples, filename, position)

############ Develop True Profile #########################


true_profile_list = {}
for round_timing_tuple in round_timing_tuples:
    index = round_timing_tuple[0] ^ true_byte
    if(index not in true_profile_list.keys()):
        true_profile_list[index] = []
    true_profile_list[index].append(round_timing_tuple[1])

true_profile = {}
for key in true_profile_list.keys():
    true_profile[key] = np.mean(np.array(true_profile_list[key]))
    true_profile = {key: true_profile[key] for key in sorted(true_profile)}

#print(true_profile)


########### Develop guess profiles and perform correlation #############
round_timing_tuples = []
all_files = list_files_in_subdirectories(victim_key_dir)
for filename in all_files:
    develop_tuples(round_timing_tuples, filename, position)

corr = {}
significant = 0
for key_guess in range(0, 256):
    guess_profile_list = {}
    for round_timing_tuple in round_timing_tuples:
        index = round_timing_tuple[0] ^ key_guess
        if(index not in guess_profile_list.keys()):
            guess_profile_list[index] = []
        guess_profile_list[index].append(round_timing_tuple[1])

    guess_profile = {}
    for key in guess_profile_list.keys():
        guess_profile[key] = np.mean(np.array(guess_profile_list[key]))
        guess_profile = {key: guess_profile[key] for key in sorted(guess_profile)}
    
    # Process correlation
    true_profile_corr = []
    guess_profile_corr = []

    for index in range(0, 256):
        if(index in true_profile.keys()):
            true_profile_corr.append(true_profile[index])
        else:
            true_profile_corr.append(0)

        if(index in guess_profile.keys()):
            guess_profile_corr.append(guess_profile[index])
        else:
            guess_profile_corr.append(0)
    #print("Key guess: ", key_guess, " - ", pearsonr(true_profile_corr, guess_profile_corr)[0]) 
    corr[key_guess] = np.abs(pearsonr(true_profile_corr, guess_profile_corr)[0])



print((256 - list(sorted(corr, key=lambda k: corr[k])).index(expected_key_byte)))
