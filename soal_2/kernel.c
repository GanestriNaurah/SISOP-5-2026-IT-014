int cursor = 0;
char color = 0x07;

void putInMemory(int segment, int address, char character);
int getChar();

void printChar(char c) {
    putInMemory(0xB800, cursor, c);
    putInMemory(0xB800, cursor + 1, color);
    cursor += 2;
}

void printString(char* str) {
    int i = 0;

    while (str[i] != 0) {
        printChar(str[i]);
        i++;
    }
}

void newline() {
    int row = cursor / 160;
    row++;
    cursor = row * 160;
}

void clearScreen() {
    int i;

    for (i = 0; i < 80 * 25 * 2; i += 2) {
        putInMemory(0xB800, i, ' ');
        putInMemory(0xB800, i + 1, color);
    }

    cursor = 0;
}

void readString(char* str) {

    int i = 0;
    char c;

    while (1) {

        c = getChar();

        if (c == 13) {
            str[i] = 0;
            break;
        }

        if (c == 8) {

            if (i > 0) {
                i--;
                cursor -= 2;
                printChar(' ');
                cursor -= 2;
            }

        } else {

            str[i] = c;
            i++;

            printChar(c);
        }
    }
}

int strcmp(char* a, char* b) {

    int i = 0;

    while (a[i] != 0 && b[i] != 0) {

        if (a[i] != b[i]) {
            return 0;
        }

        i++;
    }

    return a[i] == b[i];
}

int startsWith(char* str, char* prefix) {

    int i = 0;

    while (prefix[i] != 0) {

        if (str[i] != prefix[i]) {
            return 0;
        }

        i++;
    }

    return 1;
}

int atoi(char* str) {

    int result = 0;
    int i = 0;

    while (str[i] != 0) {
        result = result * 10 + (str[i] - '0');
        i++;
    }

    return result;
}

void intToString(int n, char* str) {

    int i = 0;
    int j;
    char temp;

    if (n == 0) {
        str[0] = '0';
        str[1] = 0;
        return;
    }

    while (n > 0) {
        str[i] = (n % 10) + '0';
        n = n / 10;
        i++;
    }

    str[i] = 0;

    for (j = 0; j < i / 2; j++) {
        temp = str[j];
        str[j] = str[i - j - 1];
        str[i - j - 1] = temp;
    }
}

int factorial(int n) {

    int result = 1;
    int i;

    for (i = 1; i <= n; i++) {
        result *= i;

        if (result < 0) {
            return -1;
        }
    }

    return result;
}

void main() {

    char cmd[64];
    char result[64];

    int a;
    int b;
    int value;

    clearScreen();

    printString("Welcome to Assistant's Last Gift");
    newline();

    printString("type 'help'");
    newline();
    newline();

    while (1) {

        printString("> ");

        readString(cmd);

        newline();

        if (strcmp(cmd, "check")) {

            printString("ok");

        } else if (strcmp(cmd, "help")) {

            printString("check add sub fac season triangle clear about");

        } else if (strcmp(cmd, "about")) {

            printString("Farewell Party OS");

        } else if (startsWith(cmd, "add ")) {

            a = atoi(cmd + 4);

            b = atoi(cmd + 6);

            intToString(a + b, result);

            printString(result);

        } else if (startsWith(cmd, "sub ")) {

            a = atoi(cmd + 4);

            b = atoi(cmd + 7);

            intToString(a - b, result);

            printString(result);

        } else if (startsWith(cmd, "fac ")) {

            value = atoi(cmd + 4);

            if (value > 8) {

                printString("know your limit little bro.");

            } else {

                intToString(factorial(value), result);

                printString(result);
            }

        } else if (strcmp(cmd, "season winter")) {

            color = 0x01;
            printString("winter mode");

        } else if (strcmp(cmd, "season spring")) {

            color = 0x02;
            printString("spring mode");

        } else if (strcmp(cmd, "season summer")) {

            color = 0x0E;
            printString("summer mode");

        } else if (strcmp(cmd, "season fall")) {

            color = 0x06;
            printString("fall mode");

        } else if (strcmp(cmd, "season radiant")) {

            color = 0x05;
            printString("radiant mode");

        } else if (startsWith(cmd, "triangle ")) {

            int n = atoi(cmd + 9);
            int i;
            int j;

            for (i = 1; i <= n; i++) {

                for (j = 0; j < i; j++) {
                    printChar('x');
                }

                newline();
            }

        } else if (strcmp(cmd, "clear")) {

            clearScreen();

        } else {

            printString("unknown command");
        }

        newline();
    }
}
