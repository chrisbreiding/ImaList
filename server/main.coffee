require('dotenv').load()

express = require 'express'
server = require './src/server'

server express, (process.env.PORT or 3000)
