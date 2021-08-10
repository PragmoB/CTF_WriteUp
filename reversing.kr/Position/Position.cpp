#include <iostream>
#include <conio.h>

using namespace std;

int main()
{
    char letter[5] = "";
    char Reg;

    int serial[10] = { 7, 6, 8, 7, 6, 7, 7, 7, 7, 6};
    int salt[10];

    letter[3] = 'p';
    for(letter[0] = 'a';letter[0] <= 'z';letter[0]++)
    {
        Reg = letter[0];
        Reg &= 1;
        Reg += 5;
        salt[0] = Reg;

        Reg = letter[0];
        Reg = Reg >> 1;
        Reg &= 1;
        Reg += 5;
        salt[1] = Reg;

        Reg = letter[0];
        Reg = Reg >> 2;
        Reg &= 1;
        Reg += 5;
        salt[2] = Reg;

        Reg = letter[0];
        Reg = Reg >> 3;
        Reg &= 1;
        Reg += 5;
        salt[3] = Reg;

        Reg = letter[0];
        Reg = Reg >> 4;
        Reg &= 1;
        Reg += 5;
        salt[4] = Reg;

        for(letter[1] = 'a';letter[1] <= 'z';letter[1]++)
        {
            if(letter[0] == letter[1] || letter[3] == letter[1]) // 각 문자들은 중복되면 안됨
                continue;

            Reg = letter[1];
            Reg &= 1;
            Reg++;
            salt[5] = Reg;

            Reg = letter[1];
            Reg = Reg >> 1;
            Reg &= 1;
            Reg++;
            salt[6] = Reg;

            Reg = letter[1];
            Reg = Reg >> 3;
            Reg &= 1;
            Reg++;
            salt[7] = Reg;

            Reg = letter[1];
            Reg = Reg >> 4;
            Reg &= 1;
            Reg++;
            salt[8] = Reg;

            Reg = letter[1];
            Reg = Reg >> 2;
            Reg &= 1;
            Reg++;
            salt[9] = Reg;

            // ---------------------------

            if(salt[0] + salt[9] != serial[0])
                continue;
            if(salt[3] + salt[7] != serial[1])
                continue;
            if(salt[8] + salt[1] != serial[2])
                continue;
            if(salt[2] + salt[5] != serial[3])
                continue;
            if(salt[4] + salt[6] != serial[4])
                continue;

            goto clear1;
        }
    }
    clear1:

    Reg = letter[3];
    Reg &= 1;
    Reg++;
    salt[5] = Reg;

    Reg = letter[3];
    Reg = Reg >> 1;
    Reg &= 1;
    Reg++;
    salt[6] = Reg;

    Reg = letter[3];
    Reg = Reg >> 3;
    Reg &= 1;
    Reg++;
    salt[7] = Reg;

    Reg = letter[3];
    Reg = Reg >> 4;
    Reg &= 1;
    Reg++;
    salt[8] = Reg;

    Reg = letter[3];
    Reg = Reg >> 2;
    Reg &= 1;
    Reg++;
    salt[9] = Reg;

    for(letter[2] = 'a';letter[2] <= 'z';letter[2]++)
    {
        Reg = letter[2];
        Reg &= 1;
        Reg += 5;
        salt[0] = Reg;

        Reg = letter[2];
        Reg = Reg >> 1;
        Reg &= 1;
        Reg += 5;
        salt[1] = Reg;

        Reg = letter[2];
        Reg = Reg >> 2;
        Reg &= 1;
        Reg += 5;
        salt[2] = Reg;

        Reg = letter[2];
        Reg = Reg >> 3;
        Reg &= 1;
        Reg += 5;
        salt[3] = Reg;

        Reg = letter[2];
        Reg = Reg >> 4;
        Reg &= 1;
        Reg += 5;
        salt[4] = Reg;

        if(salt[0] + salt[9] != serial[5])
            continue;
        if(salt[3] + salt[7] != serial[6])
            continue;
        if(salt[8] + salt[1] != serial[7])
            continue;
        if(salt[2] + salt[5] != serial[8])
            continue;
        if(salt[4] + salt[6] != serial[9])
            continue;

        goto clear2;
    }
    clear2:
    cout << letter;
    getch();
}
