const express = require('express');
const { ethers, JsonRpcProvider} = require('ethers');
const { readFileSync } = require("fs");
require('dotenv').config();

const app = express();
const port = 3000;


const abi = JSON.parse(readFileSync('./contracts/JobContract.abi', 'utf-8'));

const provider = new JsonRpcProvider('http://localhost:8545');

const contractAddress = "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266";
const contract = new ethers.Contract(contractAddress, abi, provider);

app.use(express.urlencoded({ extended: true }));
app.use(express.json());

app.set('view engine', 'ejs');

app.get('/set-employment-status', async (req, res) => {
    res.render('setEmploymentStatus');
});

app.post('/set-employment-status', async (req, res) => {
    const { address, status, jobDescription } = req.body;
    try {
        await contract.setEmploymentStatus(address, status, jobDescription);
        res.redirect('/set-employment-status');
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Internal server error' });
    }
});

app.get('/employment-status-history', async (req, res) => {
    const { address } = req.query;
    try {
        const history = await contract.getEmploymentStatusHistoryWithJobChange(address);
        res.render('employmentStatusHistory', { history });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Internal server error' });
    }
});

app.listen(port, () => {
    console.log(`Server is running on http://localhost:${port}`);
});
