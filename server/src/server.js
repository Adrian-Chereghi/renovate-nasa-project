require("dotenv").config();

const http = require("http");
const app = require("./app");
const {loadPlanetsData} = require("./models/planets.model");
const {loadLaunchesData} = require("./models/launches.model");

const server = http.createServer(app);
const PORT = process.env.PORT || 8000;

async function startServer() {
    await loadPlanetsData();
    await loadLaunchesData();

    server.listen(PORT, () => {
        console.log(`Listening on port ${PORT}...`);
    });
}

startServer();
