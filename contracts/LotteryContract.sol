// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;


contract LotteryContract {
  event TicketPurchase(address indexed player, uint256 amount);
  event TicketRefund(address indexed player, uint256 amount);
  event MsgValue(string msg, uint256 value);

  struct Ticket {
    address payable player;
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
    ticketPrice = 1 ether;
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

  function buyTicket() public payable {
    require(totalTickets > totalTicketsSold, "No more tickets available for selling.");
    require(msg.value >= ticketPrice, "Not enough ETH sent to buy a ticket.");
    require(msg.sender != admin, "You cannot buy tickets for yourself.");

    // Add ticket to the array
    tickets.push(Ticket({
      player: payable(msg.sender)
    }));

    // Update total tickets sold
    totalTicketsSold++;

    // Emit event
    emit TicketPurchase(msg.sender, msg.value);
  }

  function refundTicket() external payable {
    require(totalTicketsSold > 0, "No tickets to refund.");
    require(msg.sender != admin, "You cannot refund tickets for yourself.");

    // Find the ticket to refund
    bool found = false;
    uint256 ticketIndex = 0;
    for (uint256 i = 0; i < tickets.length; i++) {
      if (tickets[i].player == msg.sender) {
        ticketIndex = i;
        found = true;
        break;
      }
    }

    // Check if the ticket exists
    require(found, "Ticket not found.");

    // Refund the ticket
    tickets[ticketIndex].player.transfer(ticketPrice);
    totalTicketsSold--;
    totalTicketsRefunded++;

    // Emit event
    emit TicketRefund(msg.sender, ticketPrice);
  }

  function getTicketIndex(address player) external view returns (uint256) {
    for (uint256 i = 0; i < totalTicketsSold; i++) {
      if (tickets[i].player == player) {
        return i;
      }
    }
    return 0;
  }

  function pickWinner() external payable onlyOwner {
    require(totalTicketsSold > 0, "No tickets to pick a winner from.");

    uint256 winnerIndex = random(totalTicketsSold);
    Ticket memory winner = tickets[winnerIndex];

    uint256 balance = getBalance();
    // Transfer player 90% of the balance
    payable(winner.player).transfer(balance * 9 / 10);
    // Transfer the rest to the contract
    payable(admin).transfer(balance * 1 / 10);
  }


  /*
  * @dev Function to get the ticket price (in ETH).
  */
  function getTicketPrice() external view returns (uint256) {
    return ticketPrice;
  }


  /*
  * @dev Function to get the total number of tickets available for sale.
  */
  function getTotalTickets() external view returns (uint256) {
    return totalTickets;
  }


  /*
  * @dev Function to get the total amount of tickets sold.
  */
  function getTotalTicketsSold() external view returns (uint256) {
    return totalTicketsSold;
  }


  /*
  * @dev Function to get the total amount of tickets refunded.
  */
  function getTotalTicketsRefunded() external view returns (uint256) {
    return totalTicketsRefunded;
  }


  /*
  * @dev Function to get the admin address.
  */
  function getAdmin() external view returns (address) {
    return admin;
  }


  /*
  * @dev Function to get a list of tickets owned by a player
  */
  function getTicketsByPlayer(address player) public view returns (Ticket[] memory) {
    Ticket[] memory ticketsOfPlayer = new Ticket[](tickets.length);
    uint256 ticketCount = 0;

    for (uint256 i = 0; i < tickets.length; i++) {
      if (tickets[i].player == player) {
        ticketsOfPlayer[ticketCount] = tickets[i];
        ticketCount++;
      }
    }

    return ticketsOfPlayer;
  }

  ///// Helper functions /////
  function random(uint256 max) internal pure returns (uint256) {
    return uint256(keccak256(abi.encodePacked(max))) % max;
  }

  function random2(uint256 max) internal view returns (uint) {
    return uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp, max))) % max;
  }

}