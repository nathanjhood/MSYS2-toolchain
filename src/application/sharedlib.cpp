#include "../../include/application/sharedlib.h"

application::SharedLibrary::SharedLibrary() : Message("Shared library: constructed.")
{

};

application::SharedLibrary::~SharedLibrary()
{
    Message.clear();
};

std::string application::SharedLibrary::getMessage()
{
    return Message;
};

void application::SharedLibrary::setMessage(const std::string& NewMessage)
{
    Message.clear();
    Message = NewMessage;
};
