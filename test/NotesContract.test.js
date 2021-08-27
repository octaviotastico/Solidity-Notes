const NotesContract = artifacts.require("NotesContract")

contract("NotesContract", (accounts) => {

  before(async () => {
    this.startTime = new Date();
    this.notesContract = await NotesContract.deployed();
    this.myAccount = accounts[0];
  });

  it("Should have migrated successfully", async () => {
    const { notesContract } = this;
    const address = notesContract.address;
    assert.notEqual(address, undefined);
    assert.notEqual(address, null);
    assert.notEqual(address, "0x0");
    assert.notEqual(address, "");
    assert.isString(address);
  });

  it("Should have at least 1 created note at start", async () => {
    const { notesContract } = this;
    const notesCount = await notesContract.getNotesCount();
    assert.equal(notesCount, 1);
  });

  it("Should check the content of the note", async () => {
    const { myAccount, notesContract } = this;
    const note_0 = await notesContract.getNote(0);
    const note = await notesContract.notes(0);


    assert.equal(note_0[0], note.title);   // Title
    assert.equal(note_0[1], note.content); // Content
    assert.equal(note_0[2], myAccount);    // Owner
    assert.equal(note_0[3].negative, 0);   // createdAt
    assert.equal(note_0[4].negative, 0);   // updatedAt
  });

  it("Should create new notes", async () => {
    const { myAccount, notesContract } = this;
    const note_1 = await notesContract.createNote("Monday", "I need to learn more about Solidity");
    const note_2 = await notesContract.createNote("Tuesday", "Prepare an apple pieeee, and some cupcakes");
    const note_3 = await notesContract.createNote("Wednesday", "I need to stop procastinating and learn more about Delay/Disruption Tolerant Networks :)");

    const note_1_data = note_1.logs[0].args;
    const note_2_data = note_2.logs[0].args;
    const note_3_data = note_3.logs[0].args;

    assert.equal(note_1_data.id.toNumber(), 1);
    assert.equal(note_1_data.title, "Monday");
    assert.equal(note_1_data.content, "I need to learn more about Solidity");
    assert.equal(note_1_data.owner, myAccount);

    assert.equal(note_2_data.id.toNumber(), 2);
    assert.equal(note_2_data.title, "Tuesday");
    assert.equal(note_2_data.content, "Prepare an apple pieeee, and some cupcakes");
    assert.equal(note_2_data.owner, myAccount);

    assert.equal(note_3_data.id.toNumber(), 3);
    assert.equal(note_3_data.title, "Wednesday");
    assert.equal(note_3_data.content, "I need to stop procastinating and learn more about Delay/Disruption Tolerant Networks :)");
    assert.equal(note_3_data.owner, myAccount);
  });

  it("Should have 3 more notes at the end", async () => {
    const { notesContract } = this;
    const notesCount = await notesContract.getNotesCount();
    assert.equal(notesCount, 4);
  });

  it("Should delete a note", async () => {
    const { notesContract } = this;
    const result = await notesContract.deleteNote(0);
    const { deleted } = result.logs[0].args;

    assert.equal(deleted, true);
  });

  it("Should only be 3 notes left", async () => {
    const { notesContract } = this;
    const notesCount = await notesContract.getNotesCount();
    assert.equal(notesCount, 3);
  });

  it("Should not be able to delete a note that doesn't exist", async () => {
    const { notesContract } = this;
    const result = await notesContract.deleteNote(0);
    const { deleted } = result.logs[0].args;

    assert.equal(deleted, false);
  });

});
