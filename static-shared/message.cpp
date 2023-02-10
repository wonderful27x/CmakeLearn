#include "message.h"

std::ostream &Message::PrintMessage(std::ostream &ost) {
    ost << "This is my very nice message: " << std::endl;
    ost << _message;

    return ost;
}

