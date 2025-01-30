const { createNote, getAllNote, updateNote, deleteNote } = require('../controllers/note')

module.exports = (app) => {
    app.post("/admin/note", createNote)
    app.get("/admin/getnote", getAllNote)
    app.delete("/admin/deleteNote/:id", deleteNote)
    app.put("/admin/editNote", updateNote)
}