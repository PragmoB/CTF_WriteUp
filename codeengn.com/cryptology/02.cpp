#include <iostream>
#include <cstdio>

using namespace std;

int main()
{
    int indexset[4];
    int pset[4];
    char rowset[] = "efpsty";


    for(indexset[0] = 0;indexset[0] < 6 - 3; indexset[0]++)
    for(indexset[1] = indexset[0] + 1; indexset[1] < 6 - 2; indexset[1]++)
    for(indexset[2] = indexset[1] + 1; indexset[2] < 6 - 1;indexset[2]++)
    for(indexset[3] = indexset[2] + 1; indexset[3] < 6;indexset[3]++)
    {
        for(pset[0] = 0;pset[0] < 4;pset[0]++)
        for(pset[1] = 0; pset[1] < 4;pset[1]++)
        {
            if(pset[0] == pset[1])
                continue;
        for(pset[2] = 0; pset[2] < 4;pset[2]++)
        {
            if(pset[0] == pset[2] || pset[1] == pset[2])
                continue;
        for(pset[3] = 0; pset[3] < 4 && pset[2] ;pset[3]++)
        {
            if(pset[0] == pset[3] || pset[1] == pset[3] || pset[2] == pset[3])
                continue;

            printf("%c%cor%cloa%c\n", rowset[indexset[pset[0]]], rowset[indexset[pset[1]]], rowset[indexset[pset[2]]] , rowset[indexset[pset[3]]]);
        }
        }
        }

    }
}
