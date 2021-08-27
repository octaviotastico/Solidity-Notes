const NotesContract = artifacts.require("NotesContract")

contract("NotesContract", (accounts) => {

  let notesContract;
  let myAccount;

  before(async () => {
    notesContract = await NotesContract.deployed();
    myAccount = accounts[0];
  });


  it("Should have migrated successfully", async () => {
    const { address } = notesContract;
    assert.notEqual(address, undefined);
    assert.notEqual(address, null);
    assert.notEqual(address, "0x0");
    assert.notEqual(address, "");
    assert.isString(address);
  });


  it("Should have at least 1 created note at start", async () => {
    const notesCount = await notesContract.getNotesCount();
    assert.equal(notesCount, 1);
  });


  it("Should check the content of the only created note", async () => {
    const note = await notesContract.getNote(0);

    assert.equal(note[0], "First Note");                                   // Title
    assert.equal(note[1], "This is a note created by the constructor :)"); // Content
    assert.equal(note[2], myAccount);                                      // Owner
    assert.equal(note[3].negative, 0);                                     // createdAt
    assert.equal(note[4].negative, 0);                                     // updatedAt
  });


  it("Should create new notes", async () => {
    const data = [
      { noteTitle: "Monday", noteContent: "I need to learn more about Solidity" },
      { noteTitle: "Monday", noteContent: "Prepare an apple pieeee, and some cupcakes" },
      { noteTitle: "Friday", noteContent: "I need to stop procastinating and learn more about Delay/Disruption Tolerant Networks :)" },
    ];

    for (let i = 0; i < data.length; i++) {
      const { noteTitle, noteContent } = data[i];
      const res = await notesContract.createNote(noteTitle, noteContent);
      const { id, title, content, owner } = res.logs[0].args;

      assert.equal(id.toNumber(), i + 1);
      assert.equal(title, noteTitle);
      assert.equal(content, noteContent);
      assert.equal(owner, myAccount);
    }
  });


  it("Should now have 4 more notes", async () => {
    const notesCount = await notesContract.getNotesCount();
    assert.equal(notesCount, 4);
  });


  it("Should edit a note", async () => {
    await notesContract.updateNote(0, "Updated Title", "Updated Content");
    const note = await notesContract.getNote(0);

    assert.equal(note[0], "Updated Title");
    assert.equal(note[1], "Updated Content");
    assert.equal(note[2], myAccount);
  });


  it("Should delete a note", async () => {
    const result = await notesContract.deleteNote(0);
    const { deleted } = result.logs[0].args;

    assert.equal(deleted, true);
  });


  it("Should only be 3 notes left", async () => {
    const notesCount = await notesContract.getNotesCount();

    assert.equal(notesCount, 3);
  });


  it("Should not be able to delete a note that doesn't exist", async () => {
    const result = await notesContract.deleteNote(0);
    const { deleted } = result.logs[0].args;

    assert.equal(deleted, false);
  });


  it("Should get all notes with 'Monday' title", async () => {
    await notesContract.createNote("Monday", "This is the second note with monday on it's title");
    const result = await notesContract.getNotesByTitle("Monday");

    // Get the initialized notes
    let notes = result.filter((note) => note[0] !== "0");

    assert.equal(notes.length, 2);
    notes.forEach(note =>
      assert.equal(note[1], "Monday")
    );
  });

});
