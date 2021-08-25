// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract NotesContract {

  constructor() {
    createNote("Example title", "Example content");
  }

  uint public notesCount = 0;
  uint notesNextID = 0;

  struct Note {
    uint id;
    string title;
    string content;

    uint createdAt;
    uint updatedAt;
  }

  mapping (uint => Note) public notes;

  function createNote(string memory _title, string memory _content) public returns (uint) {
    Note memory note = Note({
      id: notesNextID,
      title: _title,
      content: _content,
      createdAt: block.timestamp,
      updatedAt: block.timestamp
    });

    notes[notesNextID] = note;

    notesCount++;
    notesNextID++;

    return note.id;
  }

  function getNote(uint _id) public view returns (string memory, string memory) {
    return (notes[_id].title, notes[_id].content);
  }

  function updateTitle(uint _id, string memory _title) public view returns (uint) {
    Note memory note = notes[_id];
    note.title = _title;
    note.updatedAt = block.timestamp;
    return note.id;
  }

  function updateContent(uint _id, string memory _content) public view returns (uint) {
    Note memory note = notes[_id];
    note.content = _content;
    note.updatedAt = block.timestamp;
    return note.id;
  }

  function updateNote(uint _id, string memory _title, string memory _content) public view returns (uint) {
    updateTitle(_id, _title);
    updateContent(_id, _content);
    return _id;
  }

}