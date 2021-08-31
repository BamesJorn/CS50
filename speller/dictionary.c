// Implements a dictionary's functionality
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <strings.h>
#include <ctype.h>
#include <math.h>

#include <stdbool.h>

#include "dictionary.h"

// Represents a node in a hash table
typedef struct node
{
    char word[LENGTH + 1];
    struct node *next;
}
node;

// Number of buckets in hash table
const unsigned int N = 77777;

// Hash table
node *table[N];

// Returns true if word is in dictionary, else false
bool check(const char *word)
{
    // hash and compare
    unsigned int index = hash(word);
    node *compare = table[index];
    while (compare != NULL)
    {
        if (strcasecmp(compare->word, word) == 0)
        {
            return true;
        }
        compare = compare->next;
    }
    return false;
}

// Hashes word to a number using djb2 by Bernstein
unsigned int hash(const char *word)
{
    unsigned long hash = 5381;
    int c;
    while ((c = tolower(*word++)))
    {
        hash = ((hash << 5) + hash) + c; /* hash * 33 + c */
    }
    return hash % N;
}


// Loads dictionary into memory, returning true if successful, else false
unsigned int word_count = 0;
bool load(const char *dictionary)
{
    // check the given pointer
    if (dictionary == NULL)
    {
        printf("Invalid dictionary file pointer\n");
        return false;
    }
    // open the dictionary file for reading
    FILE *dict = fopen(dictionary, "r");
    if (dict == NULL)
    {
        printf("Cannot open the dictionary file\n");
        return false;
    }

    char word[LENGTH + 1];
    while (fscanf(dict, "%s", word) != EOF)
    {
        node *n = malloc(sizeof(node));     // malloc for a temporary node n
        if (n == NULL)
        {
            printf("Cannot malloc for temp node");
            return false;
        }
        if (strcmp(word, "\n") == 0)         // skip a step if line is empty
        {
            continue;
        }
        strcpy(n->word, word);              // copy word into temp node
        unsigned int index = hash(n->word); // hash the word
        // set the pointer of node next to temp node to point at the first very element of linked list 'table[index]'
        n->next = table[index];
        table[index] = n;       // tldr node 'table[index]' again is the head
        word_count++;
    }
    fclose(dict);
    return true;
}

// Returns number of words in dictionary if loaded, else 0 if not yet loaded
unsigned int size(void)
{
    return word_count;
}

// Unloads dictionary from memory, returning true if successful, else false
bool unload(void)
{
    for (int i = 0; i < N; i++)
    {
        node *tmp = table[i];
        node *cursor = table[i];
        while (cursor != NULL)
        {
            cursor = cursor->next;
            free(tmp);
            tmp = cursor;
        }
        free(tmp);
        free(cursor);
    }
    return true;
}
