#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

typedef struct node
{
    char word[46];
    struct node *next;
}
node;

int main(void)
{

    node* table[26];
    node *n = malloc(sizeof(node));     // malloc for a temporary node n
    if (n == NULL)
    {
        printf("Cannot malloc for temp node");
        return 1;
    }
    n->word[0] = 'W';
    n->word[1] = 'o';
    n->next = NULL;
    n->next = table[2];
    table[2] = n;
    n = malloc(sizeof(node));
    if (n == NULL)
    {
        printf("Cannot malloc for temp node");
        return 1;
    }
    n->word[0] = 'Q';
    n->next = NULL;
    table[2]->next = n;
    table[2]->next->word[0] = 'T';
    printf("%s\n", table[2]->next->word);
    free(n);
    free(table[2]);
}