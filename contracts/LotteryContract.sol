// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;


contract LotteryContract {
  event TicketPurchase(address indexed player, uint256 amount);
  event TicketRefund(address indexed player, uint256 amount);

  struct Ticket {
    address payable player;
    uint256 amount;
  }

  // Ticket storage
  Ticket[] tickets;

  // Lottery parameters
  uint256 ticketPrice;
  uint256 totalTickets;
  uint256 totalTicketsSold;
  uint256 totalTicketsRefunded;
  address admin;

  // Lottery initial state
  constructor() {
    ticketPrice = 1;
    totalTickets = 10;
    totalTicketsSold = 0;
    totalTicketsRefunded = 0;
    admin = msg.sender;
  }

  modifier onlyOwner {
    require(admin == msg.sender, "Only the contract admin can call this function.");
    _;
  }

  function getBalance() public view onlyOwner returns (uint256) {
    // Returns the contract balance
    return address(this).balance;
  }

  function buyTicket() external payable {
    require(totalTickets > totalTicketsSold, "No more tickets available for selling.");
    require(msg.value >= ticketPrice, "Not enough ETH sent to buy a ticket.");

    // Add ticket to the array
    tickets.push(Ticket({
      player: msg.sender,
      amount: msg.value
    }));

    totalTicketsSold++;
    emit TicketPurchase(msg.sender, msg.value);
  }

  function refundTicket(uint256 amount) external payable {
    require(totalTicketsSold > 0, "No tickets to refund.");

    // Find the ticket to refund
    bool found = false;
    uint256 ticketIndex = 0;
    for (uint256 i = 0; i < tickets.length; i++) {
      if (tickets[i].player == msg.sender && tickets[i].amount == amount) {
        ticketIndex = i;
        found = true;
        break;
      }
    }

    // Check if the ticket exists
    require(found, "Ticket not found.");

    // Refund the ticket
    tickets[ticketIndex].player.transfer(amount);
    totalTicketsSold--;
    totalTicketsRefunded++;
    emit TicketRefund(msg.sender, amount);
  }

}