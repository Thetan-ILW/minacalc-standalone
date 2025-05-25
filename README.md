# minacalc-standalone
Standalone version of MinaCalc along with a C API for easy access and bindings

# How to build
MinaCalc requires C++20.

The following commands assume GCC and Linux. Adjust the commands to your platform of choice

gcc MinaCalc/MinaCalc.cpp API.cpp -DSTANDALONE_CALC -std=c++20 -lstdc++ -lm -shared -fpic -o libminacalc.so

# Example usage
```c
#include <stdio.h>
#include "API.h"

int main() {
    printf("calc version: %d\n", calc_version());
}
```

Run with `gcc -lstdc++ -lm main.c libminacalc.a && ./a.out` (or equivalent for your platform and compiler)
