const db = require('../modals');


module.exports.createNote = (req, res) => {
    console.log(req.body, "note taken")

    const { header, body, date, query_type = "create_note" } = req.body
    db.sequelize
        .query(`CALL note(
        :query_type,
        :header,
        :body,
        :date
        )`, {
            replacements: {
                query_type,
                header,
                body,
                date
            }
        }).then((result) => {
            console.log(result, "note backend")
            res.status(200).json({
                success: true,
                message: "note saved successfully"
            })
        }).catch((err) => {
            console.log(err, "note error")
            res.status(500).json({
                success: false,
                message: "unable to save note"
            })
        })
}

module.exports.getAllNote = (req, res) => {
    db.sequelize
        .query(`SELECT * FROM note`)
        .then((resp) => {
            res.status(200).json({
                success: true,
                message: "Notes retrieved successfully",
                resp
            })
        }).catch((err) => {
            res.status(500).json({
                success: false,
                message: "failed to get all notes",
                err
            })
        })
}

module.exports.updateNote = (req, res) => {
    const { header, body, date, id } = req.body
    db.sequelize
        .query(`UPDATE SET header="${header}", body="${body}", date="${date}" WHERE id="${id}"`
        ).then((result) => {
            res.status(200).json({
                success: true,
                result: result
            })
        }).catch((err) => {
            console.log(err)
            res.status(500).json({
                success: false,
                message: "unable to make the changes"
            })
        })
}

module.exports.deleteNote = (req, res) => {
    console.log(req.params, "delete backend")
    const { id } = req.params;
    db.sequelize
        .query(`DELETE FROM note WHERE id="${id}"`
        ).then((result) => res.status(200).json({
            success: true,
            message: "note deleted successfuly"
        }))
        .catch((err) => res.status(500).json({
            success: false,
            message: "unable to delete note",
            err
        }))
}