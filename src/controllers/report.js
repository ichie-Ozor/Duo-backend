const db = require('../modals');
const moment = require('moment')
const { QueryTypes } = require('sequelize');
const { mergeByName } = require('../util/helper');

module.exports.createReport = (req, res) => {
    console.log(req.body, "body")
    const successReport = []
    const reportError = []
    const data = req.body
    // Object.keys(data).forEach(key => {
    data.forEach(element => {
        console.log(element)

        const {
            query_type = "create_report",
            date = "",
            cash,
            ceo,
            name,
            pos,
            room,
            owe,
            damage,
            transfer,
            total,
            amt,
            oweing
        } = element
        const queryDate = date == "" ? moment(new Date()).format("YYYY-MM-DD") : date
        db.sequelize
            .query(`CALL report(
        :query_type,
        :date,
        :name,
        :cash,
        :pos,
        :transfer,
        :ceo,
        :damage,
        :room,
        :owe,
        :total,
        :amt,
        :oweing        
        )`,
                {
                    replacements: {
                        query_type,
                        date: queryDate,
                        name,
                        cash,
                        pos,
                        transfer,
                        ceo,
                        damage,
                        room,
                        owe,
                        total,
                        amt,
                        oweing
                    }
                }
            ).then((result) => {
                console.log(result, "report backend")
                successReport.push({
                    message: "saved successfully",
                    result
                })
            }).catch((err) => {
                console.log(err, "error")
                reportError.push({
                    message: `failed to saved ${element}`,
                    err
                })
            })
    });
    if (successReport.length > 0) {
        res.status(200).json({
            success: true,
            message: `the message has being saved successfully`
        })
    }
    if (reportError.length > 0) {
        console.log(reportError, "errrrrrrrr")
        res.status(500).json({
            success: false,
            message: `there is an error while trying to save ${reportError.err || reportError.message}`
        })
    }
}

module.exports.getAllReport = (req, res) => {
    const query_type = "getReport"
    const { from, to } = req.query
    db.sequelize
        .query(
            `SELECT * FROM report WHERE date >= :from AND date <= :to`,
            {
                replacements: { from, to },
                type: QueryTypes.SELECT
            }
        )
        .then((resp) => {
            const response = mergeByName(resp)
            console.log(resp, "report backend")
            res.status(200).json({
                success: true,
                response
            })
        }).catch((err) => {
            res.status(500).json({
                success: false,
                message: `failed to get result ${err.message}`,
                err
            })
        })
}


module.exports.getTodayReport = (req, res) => {
    console.log(req.url, " param")
    const query_type = "getTodayReport"
    const date = moment(new Date()).format("YYYY-MM-DD")
    // const {
    //     cash = null,
    //     ceo = null,
    //     name = null,
    //     pos = null,
    //     room = null,
    //     damage = null,
    //     transfer = null,
    //     total = null,
    //     amt = null,
    //     oweing = null
    // } = req.body
    // db.sequelize.query(
    //     `CALL report(
    //     :query_type,
    //     :date,
    //     :name,
    //     :cash,
    //     :pos,
    //     :transfer,
    //     :ceo,
    //     :damage,
    //     :room,
    //     :amt,
    //     :oweing,
    //     :total        
    //     )`,
    //     {
    //         replacements: {
    //             query_type,
    //             date,
    //             name,
    //             cash,
    //             pos,
    //             transfer,
    //             ceo,
    //             damage,
    //             room,
    //             amt,
    //             oweing,
    //             total
    //         }
    //     }
    db.sequelize
        .query(
            `SELECT * FROM report WHERE date = :date`,
            {
                replacements: { date },
                type: db.sequelize.QueryTypes.SELECT
            }
        ).then((results) => {
            console.log(results, "result")
            //////////////////////////////
            // const mergeByName = (array) => {
            //     const result = {};

            //     array.forEach((obj) => {
            //         const { name, ...rest } = obj;

            //         if (!result[name]) {
            //             // Initialize if the name does not exist
            //             result[name] = { ...rest, name };
            //         } else {
            //             // Add values if the name exists
            //             for (const key in rest) {
            //                 if (key !== "date" && key !== "id" && !isNaN(Number(rest[key]))) {
            //                     result[name][key] = (Number(result[name][key]) || 0) + Number(rest[key]);
            //                 }
            //             }
            //         }
            //     });

            //     return Object.values(result);
            // };

            const response = mergeByName(results);
            console.log(response, "response", typeof response);
            // //////////////////////////
            res.status(200).json({
                success: true,
                response
            })
        }).catch((err) => {
            res.status(500).json({
                success: false,
                message: `failed to get result ${err.message}`,
                err
            })
        })
}


module.exports.getSaleStaff = (req, res) => {
    db.sequelize
        .query(
            `SELECT id, name FROM users WHERE accessTo = "vip" OR accessTo = "vibe"`)
        .then(([resp, metadata]) => {
            console.log(resp, "staff")
            res.status(200).json({
                success: true,
                message: "staffs fetched successfully",
                resp
            })
        }).catch((err) => {
            res.status(500).json({
                success: false,
                message: `failed to get result ${err.message}`,
                err
            })
        })
}


// module.exports.getSaleStaff = (req, res) => {
//     db.sequelize
//         .query(
//             `SELECT id, name, accessTo FROM users WHERE accessTo = :accessVip OR accessVibe`,
//             {
//                 replacements: { accessVip: "vip", accessVibe: "vibe" },
//                 type: db.sequelize.QueryTypes.SELECT,
//             }
//         ).then((resp) => {
//             console.log(resp, )
//             res.status(200).json({
//                 success: true,
//                 message: "Staff fetched successfully",
//                 data: resp
//             })
//         }).catch((err) => {
//             res.status(500).json({
//                 success: false,
//                 message: `Failed to fetch staff: ${err.message}`
//             })
//         })
// }

module.exports.getOneReport = (req, res) => { }

module.exports.deleteStaff = async (req, res) => {
    const { userId } = req.params

    if (!userId) {
        return res.status(400).json({
            success: false,
            message: "You are yet to supply the id and name of the staff to be deleted"
        });
    }
    try {
        console.log(db.sequelize.models.User, "sequalize")
        const result = await db.sequelize.models.User.destroy({
            where: { id: userId }
        });
        if (result === 0) {
            return res.status(404).json({
                success: false,
                message: "Staff not found"
            });
        }
        res.status(200).json({
            success: true,
            message: "Staff deleted successfully"
        });
    } catch (err) {
        console.error("Error trying to delete staff", err);
        res.status(500).json({
            success: false,
            message: "Staff could not be deleted"
        })
    }
}