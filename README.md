# minacalc-standalone
Standalone version of MinaCalc along with a C API for easy access and bindings

# How to build
MinaCalc requires C++20.

## Windows
Install Visual Studio 2022
Run `build.bat`

## Linux
Run `build-linux`

## MacOS
Run `build-macos`

# Example usage
```c
#include <stdio.h>
#include "API.h"

int main() {
    printf("calc version: %d\n", calc_version());
}
```

Run with `gcc -lstdc++ -lm main.c libminacalc.a && ./a.out` (or equivalent for your platform and compiler)
