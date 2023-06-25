#include "../../../include/application/runtime/main.h"

int main()
{
    application::Configuration Configuration;

#ifndef APPLICATION_CONFIGURATION_H_INCLUDED

    std::cout << "cli configuration header not found!" << std::endl;
    std::cout << "Nothing to report." << "\n" << std::endl;

#else

    std::cout << TARGET_TRIPLET << "\n" << std::endl;
    std::cout << TARGET_PLATFORM << "\n" << std::endl;
    std::cout << TARGET_ARCH << "\n" << std::endl;

#endif // APPLICATION_CONFIGURATION_H_INCLUDED

    std::cout << "Press 'enter' to exit the program." << "\n" << std::endl;
    std::cin.get();
    return 0;
};
