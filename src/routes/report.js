const {
    createReport,
    getTodayReport,
    getSaleStaff,
    getAllReport,
    deleteStaff
} = require('../controllers/report')

module.exports = (app) => {
    app.post("/manager/report", createReport)
    app.get("/admin/report", getTodayReport)
    app.delete("/admin/deleteReport/:userId", deleteStaff)
    app.get("/manager/getSaleStaff", getSaleStaff)
    app.get("/admin/reportRange", getAllReport)
}