const express = require('express')

const cors = require('cors')

const bodyParser = require('body-parser')

const helmet = require('helmet')

const app = express()
const port = 3069

app.use(bodyParser.json())
app.use(cors())
app.use(helmet())

app.get('/message/:input', (req, res) => {
    console.log(req.params.input)
    return res.json({
        succes: true,
        message: req.params.input
    })
})



app.listen(port,async() => {
    console.log(`Tempy API listening at port https://localhost:${port}`)
})