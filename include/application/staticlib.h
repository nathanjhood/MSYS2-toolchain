#ifndef APPLICATION_STATIC_LIB_H_INCLUDED
#define APPLICATION_STATIC_LIB_H_INCLUDED

#include "impl/library.h"

namespace application
{

class StaticLibrary : public Library
{
public:
    StaticLibrary();
    ~StaticLibrary();
    std::string getMessage();
    void setMessage(const std::string& NewMessage);
private:
    std::string Message;
};

} // namespace application

#endif // APPLICATION_STATIC_LIB_H_INCLUDED
