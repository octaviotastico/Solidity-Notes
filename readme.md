# Solidity Projects

---

## **About this repo**

This is a repo used to learn about Solidity and Smart Contracts.

Inside the `contracts` directory, you will find the contracts I created.

So far there's only two of them: NotesContract and LotteryContract.

- **NotesContract**: It's a very very simple contract that lets you create, read, update, and delete some notes, that consists only on a title and a description.

- **LotteryContract**: It's a lottery system where players can buy tickets for a lottery. When the admin decides to end the lottery, one of the users that bought a ticket will be choosen at random and will win 90% of the balance so far and the admin will keep the remaining 10%.


## **What do I need to run this app?**

- [Truffle](https://github.com/trufflesuite/truffle)
- [Ganache](https://github.com/trufflesuite/ganache-ui)

### How to install install Truffle.

```
sudo npm install truffle -g
```

### How to install Ganache

```
sudo npm install ganache-cli -g
```

Or, you can download a GUI for Ganache here: https://www.trufflesuite.com/ganache.

## **How to run**

1. Run the Ganache app and click on the "Quickstart - Ethereum" button.

![](assets/ganache.png)

You will see an Ethereum network with 10 addresses. This is what we will be using to use this contracts.

2. Open a terminal (in the root directory) and **compile the code**.
```
truffle deploy
```

3. On the same terminal, **enter the truffle console**.

```
truffle console
```

Once you're inside `truffle console`, you can then use the app.

## **Usage Examples**

NotesContract Example:
```javascript
// First, we can save the contract on a variable.
let notesContract = await NotesContract.deployed()

// We can check our address, to see if it is working.
notesContract.address

// We can call public functions, for example notesCount.
// This should print "1", because there is a note created
await notesContract.getNotesCount()

// Obviously we can also create notes.
await notesContract.createNote("Monday", "I need to learn more about Solidity")
await notesContract.createNote("Tuesday", "Prepare an apple pieeee, and some cupcakes")
await notesContract.createNote("Wednesday", "I need to stop procastinating and learn more about Delay/Disruption Tolerant Networks :)")

// And then see their content
await notesContract.notes(1)
await notesContract.notes(2)
await notesContract.notes(3)
```

LotteryContract Example:

```javascript
// Save the contract in a variable
let lotteryContract = await LotteryContract.deployed()

// Check its address to see if it is working
lotteryContract.address

// Get the admin address
lotteryContract.getAdmin()

// Buy a ticket (One ether = 1,000,000,000,000,000,000 wei (10^18))
await lotteryContract.buyTicket({from: accounts[0], value: 1 * 10 ** 18}) // This should throw an error since account 0 is admin (admins can't buy lottery tickets).

// Tickets for player 1
await lotteryContract.buyTicket({from: accounts[1], value: 1 * 10 ** 18})
await lotteryContract.buyTicket({from: accounts[1], value: 1 * 10 ** 18})
await lotteryContract.buyTicket({from: accounts[1], value: 1 * 10 ** 18})

// Tickets for player 2
await lotteryContract.buyTicket({from: accounts[2], value: 1 * 10 ** 18})
await lotteryContract.buyTicket({from: accounts[2], value: 1 * 10 ** 18})

// Tickets for player 3
await lotteryContract.buyTicket({from: accounts[3], value: 1 * 10 ** 18})

// Refund player 3
await lotteryContract.refundTicket({from: accounts[3]})

// Pick a winner
await lotteryContract.pickWinner()
```