const {
    createReport,
    getTodayReport,
    getSaleStaff,
    getAllReport
} = require('../controllers/report')

module.exports = (app) => {
    app.post("/manager/report", createReport)
    app.get("/admin/report", getTodayReport)
    app.get("/manager/getSaleStaff", getSaleStaff)
    app.get("/admin/reportRange", getAllReport)
}