const express = require('express');
const app = express();

app.get('/', (req, res) => res.send('Welcome to Cloud-Native Node.js API!'));

const port = process.env.PORT || 3000;
app.listen(port, () => console.log(`API listening on port ${port}`));
