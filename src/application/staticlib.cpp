#include "../../include/application/staticlib.h"

application::StaticLibrary::StaticLibrary() : Message("Static library: constructed.")
{

};

application::StaticLibrary::~StaticLibrary()
{
    Message.clear();
};

std::string application::StaticLibrary::getMessage()
{
    return Message;
};

void application::StaticLibrary::setMessage(const std::string& NewMessage)
{
    Message.clear();
    Message = NewMessage;
};
