const mergeByName = (array) => {
    const result = {};

    array.forEach((obj) => {
        const { name, ...rest } = obj;

        if (!result[name]) {
            // Initialize if the name does not exist
            result[name] = { ...rest, name };
        } else {
            // Add values if the name exists
            for (const key in rest) {
                if (key !== "date" && key !== "id" && !isNaN(Number(rest[key]))) {
                    result[name][key] = (Number(result[name][key]) || 0) + Number(rest[key]);
                }
            }
        }
    });

    return Object.values(result);
};

module.exports = { mergeByName }