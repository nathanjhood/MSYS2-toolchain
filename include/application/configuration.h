#ifndef APPLICATION_CONFIGURATION_H_INCLUDED
#define APPLICATION_CONFIGURATION_H_INCLUDED

/** Include whatever you need from the std:lib here. */
#include <assert.h>
#include <iostream>

namespace application
{
struct Configuration
{

    /** Below comes from CMAKE_C_COMPILER_ID_PLATFORM_CONTENT CMake system variable. */

    #define STRINGIFY_HELPER(X) #X
    #define STRINGIFY(X) STRINGIFY_HELPER(X)

    #define MSYSTEM "@MSYSTEM@"
    #define MSYSTEM_CARCH "@MSYSTEM_CARCH@"
    #define MSYSTEM_CHOST "@MSYSTEM_CHOST@"

    /* Construct the string literal in pieces to prevent the source from
    getting matched.  Store it in a pointer rather than an array
    because some compilers will just produce instructions to fill the
    array rather than assigning a pointer to a static array.  */
    char const* MSystem = "INFO" ":" "Msys Sub-system[" MSYSTEM "]";
    char const* MSystemArch = "INFO" ":" "Msys Sub-system arch[" MSYSTEM_CARCH "]";
    char const* MSystemHost = "INFO" ":" "Msys Sub-system host[" MSYSTEM_CHOST "]";

};

} // namespace application

#endif // APPLICATION_CONFIGURATION_H_INCLUDED
