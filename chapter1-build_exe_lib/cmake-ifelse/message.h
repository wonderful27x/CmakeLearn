#ifndef MESSAGE_H
#define MESSAGE_H

#include <string>
#include <iostream>

class Message {
public:
    Message(const std::string &msg) : _message(msg) {}

    friend std::ostream &operator<<(std::ostream &ost, Message &msg) {
        return msg.PrintMessage(ost);
    }

private:
    std::string _message;
    std::ostream &PrintMessage(std::ostream &ost);
};

#endif
