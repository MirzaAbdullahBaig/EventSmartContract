// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5 <0.9;

contract EventContract{
    struct Event {
        address Organizer;
        string Name;
        uint Date;
        uint Price;
        uint ticketCount;
        uint ticketremain; 
    }

    mapping (uint=>Event) public events;
    mapping (address=>mapping(uint=>uint)) public Tickets;
    uint public NextId;

    function CreateEvent (string memory Name, uint Date, uint Price, uint ticketCount) external {
        require (Date>block.timestamp, "You can organize event for future");
        require (ticketCount>0, "You can organize event if you creat more then ZERO tickets");

        events [NextId] = Event (msg.sender, Name, Date, Price, ticketCount, ticketCount);
        NextId++;
    }

    function buyTicket(uint id, uint quantity) external payable {
        require (events[id].Date !=0, "Events does not exist");
        require (events[id].Date>block.timestamp, "Sorry, event has ended");
        Event storage _event = events[id];
        require (msg.value==(_event.Price*quantity), "Not enough price");
        require (_event.ticketremain>=quantity, "sorry, All tickets are sold");
        _event.ticketremain-=quantity;
        Tickets[msg.sender][id]+=quantity;
    }

    function TransferTicket (uint id, uint quantity, address to) external {
        require (events[id].Date !=0, "Events does not exist");
        require (events[id].Date>block.timestamp, "Sorry, event has ended");
        require (Tickets[msg.sender][id]>=quantity, "You don't have enough tickets");
        Tickets [msg.sender][id]-=quantity;
        Tickets [to] [id]+= quantity;
    }
}