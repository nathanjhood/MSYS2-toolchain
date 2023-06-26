#include "../../../include/application/impl/library.h"

Library::Library() : Message("Generic library: constructed.")
{

};

Library::~Library()
{
    Message.clear();
};

std::string Library::Library::getMessage()
{
    return Message;
};

void Library::Library::setMessage(const std::string& NewMessage)
{
    Message.clear();
    Message = NewMessage;
};
