#include <iostream>

#include "message.h"

int main() {
    Message say_hello("Hello, Cmake World!");
    std::cout << say_hello << std::endl;

    return 0;
};
