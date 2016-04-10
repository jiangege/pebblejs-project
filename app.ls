require! express
app = express!
app.use express.static "#{__dirname}/public"
app.listen port = (process.env.port or 8088)
console.log "The web server has started... port:#{port}"
