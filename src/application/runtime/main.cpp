#include "../../../include/application/runtime/main.h"

int main()
{
    application::Configuration Configuration;

#ifndef APPLICATION_CONFIGURATION_H_INCLUDED

    std::cout << "cli configuration header not found!" << std::endl;
    std::cout << "Nothing to report." << "\n" << std::endl;

#else

    std::cout << MSYSTEM << "\n" << std::endl;
    std::cout << MSYSTEM_CARCH << "\n" << std::endl;
    std::cout << MSYSTEM_CHOST << "\n" << std::endl;

#endif // APPLICATION_CONFIGURATION_H_INCLUDED

    std::cout << "Press 'enter' to exit the program." << "\n" << std::endl;
    std::cin.get();
    return 0;
};
