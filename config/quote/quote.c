#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <time.h>
#include <unistd.h>

#define MAX_QUOTES 100
#define MAX_LENGTH 500

int randint_uniform(int n)
{
    int limit = RAND_MAX - (RAND_MAX % n);
    int r;
    do
    {
        r = rand();
    } while (r >= limit);
    return r % n;
}

int count_lines(FILE *file)
{
    int lines = 0;
    char buffer[MAX_LENGTH];
    while (fgets(buffer, MAX_LENGTH, file) != NULL)
    {
        // Skip lines that are just whitespace
        int only_whitespace = 1;
        for (int i = 0; buffer[i] != '\0'; i++)
        {
            if (!isspace((unsigned char)buffer[i]))
            {
                only_whitespace = 0;
                break;
            }
        }
        if (!only_whitespace)
        {
            lines++;
            if (lines >= MAX_QUOTES)
            {
                break;
            }
        }
    }
    return lines;
}

void read_quotes(FILE *file, char quotes[MAX_QUOTES][MAX_LENGTH], int num_quotes)
{
    rewind(file);
    int count = 0;
    char buffer[MAX_LENGTH];
    while (fgets(buffer, MAX_LENGTH, file) != NULL)
    {
        int only_whitespace = 1;
        for (int i = 0; buffer[i] != '\0'; i++)
        {
            if (!isspace((unsigned char)buffer[i]))
            {
                only_whitespace = 0;
                break;
            }
        }
        if (!only_whitespace)
        {
            strncpy(quotes[count], buffer, MAX_LENGTH - 1);
            quotes[count][MAX_LENGTH - 1] = '\0';
            count++;
            if (count >= num_quotes)
            {
                break;
            }
        }
    }
}

int main()
{
    const char *file_path = "/home/astra/Documents/Dotfiles/config/quote/quotes.txt";
    srand((unsigned int)(time(NULL) ^ getpid()));

    FILE *file = fopen(file_path, "r");
    if (file == NULL)
    {
        printf("Could not open quotes.txt\n");
        return 1;
    }

    int num_quotes = count_lines(file);
    if (num_quotes == 0)
    {
        printf("No quotes found in quotes.txt\n");
        fclose(file);
        return 1;
    }

    char quotes[MAX_QUOTES][MAX_LENGTH];
    read_quotes(file, quotes, num_quotes);

    int random_index = randint_uniform(num_quotes);
    printf("%s", quotes[random_index]);

    fclose(file);
    return 0;
}
