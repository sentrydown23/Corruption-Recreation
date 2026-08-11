var baseNotes:String = "game/notes/base";

function onNoteCreation(note)
{
    note.noteSprite = baseNotes;
}

function onStrumCreation(note)
{
    note.sprite = baseNotes;
}