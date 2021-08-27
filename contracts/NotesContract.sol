// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract NotesContract {

  constructor() {
    createNote("First Note", "This is a note created by the constructor :)");
  }

  uint notesCount = 0;
  uint notesNextID = 0;

  struct Note {
    uint id;
    string title;
    string content;

    address owner;
    uint createdAt;
    uint updatedAt;
  }

  mapping (uint => Note) public notes;

  // Event created to return logs in createNote
  event NoteCreated(uint id, string title, string content, address owner);
  // Event created to return logs in deleteNote
  event NoteDeleted(bool deleted);

  /*
  * @dev Creates a new note and inserts it in the notes map.
  * @param title: Title of the note.
  * @param content: Content of the note.
  */
  function createNote(string memory _title, string memory _content) public {
    Note memory note = Note({
      id: notesNextID,
      title: _title,
      content: _content,

      owner: msg.sender,
      createdAt: block.timestamp,
      updatedAt: block.timestamp
    });
    notes[notesNextID] = note;

    notesCount++;
    notesNextID++;

    emit NoteCreated(note.id, note.title, note.content, note.owner);
  }


  /*
  * @dev Returns the note with the given id.
  * @param id: ID of the note.
  */
  function getNote(uint _id) public view returns (string memory, string memory, address, uint, uint) {
    return (
      notes[_id].title,
      notes[_id].content,
      notes[_id].owner,
      notes[_id].createdAt,
      notes[_id].updatedAt
    );
  }


  /*
  * @dev Returns the amount of created notes.
  */
  function getNotesCount() public view returns (uint) {
    return notesCount;
  }


  /*
  * @dev Updates the title of a note by the one given by parameter
  * @param id: ID of the note.
  * @param title: New title of the note.
  */
  function updateTitle(uint _id, string memory _title) public view returns (uint) {
    Note memory note = notes[_id];
    note.title = _title;
    note.updatedAt = block.timestamp;
    return note.id;
  }


  /*
  * @dev Updates the content of a note by the content given by parameter
  * @param id: ID of the note.
  * @param content: New content of the note.
  */
  function updateContent(uint _id, string memory _content) public view returns (uint) {
    Note memory note = notes[_id];
    note.content = _content;
    note.updatedAt = block.timestamp;
    return note.id;
  }


  /*
  * @dev Updates the title and content of a note by the ones given by parameters
  * @param id: ID of the note.
  * @param title: New title of the note.
  * @param content: New content of the note.
  */
  function updateNote(uint _id, string memory _title, string memory _content) public view returns (uint) {
    updateTitle(_id, _title);
    updateContent(_id, _content);
    return _id;
  }


  /*
  * @dev Deletes a note by the given id.
  * @param id: ID of the note.
  */
  function deleteNote(uint _id) public {
    if (notes[_id].owner == msg.sender) {
      delete notes[_id];
      notesCount--;
      emit NoteDeleted(true);
    }
    emit NoteDeleted(false);
  }


  /*
  * @dev Returns an array with all the notes so far.
  */
  function getNotes() public view returns (Note[] memory) {
    Note[] memory notesArray = new Note[](notesCount);
    for (uint i = 0; i < notesCount; i++) {
      notesArray[i] = notes[i];
    }
    return notesArray;
  }


  /*
  * @dev Returns a filtered array with all the notes of a given owner.
  */
  function getNotesByOwner(address _owner) public view returns (Note[] memory) {
    Note[] memory notesArray = new Note[](notesCount);
    uint notesArrayIndex = 0;
    for (uint i = 0; i < notesCount; i++) {
      if (notes[i].owner == _owner) {
        notesArray[notesArrayIndex] = notes[i];
        notesArrayIndex++;
      }
    }
    return notesArray;
  }


  /*
  * @dev Returns a filtered array with all the notes with a given title.
  */
  function getNotesByTitle(string memory _title) public view returns (Note[] memory) {
    Note[] memory notesArray = new Note[](notesCount);
    uint notesArrayIndex = 0;
    for (uint i = 0; i < notesCount; i++) {
      if (compareStrings(notes[i].title, _title)) {
        notesArray[notesArrayIndex] = notes[i];
        notesArrayIndex++;
      }
    }
    return notesArray;
  }


  ///// AUX Functions /////
  function compareStrings(string memory a, string memory b) internal pure returns (bool) {
    return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))));
  }

}