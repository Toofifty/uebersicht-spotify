const spotify = require('spotify-node-applescript')
const Promise = require('node-promise').Promise
const wait = require('node-promise').all

const out = (data) => console.log(JSON.stringify(data))

if (process.argv.length < 3) {
    let data = {}
    spotify.isRunning((err, isRunning) => {
        if (err) throw err
        data.running = isRunning
        if (isRunning) {

            let statePromise = new Promise()
            spotify.getState((err, state) => {
                if (err) throw err
                Object.assign(data, state)
                statePromise.resolve()
            })

            let repeatingPromise = new Promise()
            spotify.isRepeating((err, isRepeating) => {
                if (err) throw err
                data.repeating = isRepeating
                repeatingPromise.resolve()
            })

            let shufflingPromise = new Promise()
            spotify.isShuffling((err, isShuffling) => {
                if (err) throw err
                data.shuffling = isShuffling
                shufflingPromise.resolve()
            })

            let trackPromise = new Promise()
            spotify.getTrack((err, track) => {
                if (err) throw err
                data.track = track
                trackPromise.resolve()
            })

            wait([
                statePromise,
                repeatingPromise,
                shufflingPromise,
                trackPromise
            ]).then(() => {
                out(data)
            })

        } else {
            out(data)
        }
    })
}
