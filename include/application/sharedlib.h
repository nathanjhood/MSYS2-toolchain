#ifndef APPLICATION_SHARED_LIB_H_INCLUDED
#define APPLICATION_SHARED_LIB_H_INCLUDED

#include "impl/library.h"

namespace application
{

class SharedLibrary : public Library
{
public:
    SharedLibrary();
    ~SharedLibrary();
    std::string getMessage();
    void setMessage(const std::string& NewMessage);
private:
    std::string Message;
};

} // namespace application

#endif // APPLICATION_SHARED_LIB_H_INCLUDED
