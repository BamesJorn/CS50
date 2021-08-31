import csv
import sys
import re


def main():

    # Ensure correct usage
    if len(sys.argv) != 3:
        sys.exit("Usage: python dna.py data.csv sequence.txt")

    # create list of dicts 'database' and fill it with data from the given file
    database = []
    with open(sys.argv[1], "r") as data:
        reader = csv.DictReader(data)
        for row in reader:
            database.append(row)

    # read a person's DNA sequence into string 'dna'
    with open(sys.argv[2], "r") as sequence:
        dna = sequence.readline()

    # get the STR types stored in database and put them in list of strings called 'STRs'
    strs = list(database[0])

    # store amount of STR types in 'num_strs'
    num_strs = len(strs)

    # extract the longest consequtive STR sequence, if any
    persons_strs = []
    for i in range(1, num_strs):
        persons_strs.append(find_strs(strs[i], dna))

    # look for a match in database
    database_len = len(database)
    found = False
    
    # iterate over each person present in the database
    for person in range(database_len):
        count = 0
        
        # for every person look for each of the given STR sequences
        for i in range(1, num_strs):
            if int(database[person][strs[i]]) == persons_strs[i - 1]:
                count += 1
        if count == num_strs - 1:
            found = True
            print(database[person]['name'])
    if found == False:
        print("No match")


def find_strs(str_i, dna):
    # look for sequences and record the starting positions
    seq = []
    for s in re.finditer(str_i, dna):
        seq.append(s.start())

    # count the amount of consequitive sequences, return the longest
    length = len(str_i)
    count, maxcount = 0, 0
    for i in range(0, len(seq) - 1):
        if seq[i] + length == seq[i + 1]:
            count += 1
        else:
            if maxcount <= count:
                maxcount = count + 1
                count = 0
    if maxcount <= count and len(seq) != 0:
        maxcount = count + 1
    return maxcount


if __name__ == "__main__":
    main()
