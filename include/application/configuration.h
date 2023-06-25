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

    #define TARGET_TRIPLET @TARGET_TRIPLET@
    #define TARGET_PLATFORM @TARGET_PLATFORM@
    #define TARGET_ARCH @TARGET_ARCH@

    /* Construct the string literal in pieces to prevent the source from
    getting matched.  Store it in a pointer rather than an array
    because some compilers will just produce instructions to fill the
    array rather than assigning a pointer to a static array.  */
    char const* TargetPlatform = "INFO" ":" "platform[" TARGET_PLATFORM "]";
    char const* TargetArch = "INFO" ":" "arch[" TARGET_ARCH "]";

};

} // namespace application

#endif // APPLICATION_CONFIGURATION_H_INCLUDED
