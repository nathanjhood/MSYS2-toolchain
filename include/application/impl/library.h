#ifndef APPLICATION_LIBRARY_H_INCLUDED
#define APPLICATION_LIBRARY_H_INCLUDED

#include "../../application/configuration.h"

class Library
{
public:
    Library();
    ~Library();
    std::string getMessage();
    void setMessage(const std::string& NewMessage);
private:
    std::string Message;
};

#endif // APPLICATION_LIBRARY_H_INCLUDED
