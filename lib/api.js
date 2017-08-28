const spotify = require('spotify-node-applescript')
const Promise = require('node-promise').Promise
const wait = require('node-promise').all

const out = (data) => console.log(JSON.stringify(data))

if (process.argv.length > 2) {
    // translate arguments into functions
    // it looks stupid but it works
    const _ = {
        'playpause': spotify.playPause,
        'previous':  spotify.previous,
        'shuffle':   spotify.toggleShuffling,
        'repeat':    spotify.toggleRepeating,
        'next':      spotify.next
    }[process.argv[2]](err => {
        if (err) throw err
    })
} else {
    // otherwise just throw back the status
    let data = {}
    spotify.isRunning((err, isRunning) => {
        if (err) throw err
        data.running = isRunning
        if (isRunning) {
            let promises = [
                new Promise(), new Promise(), // state, repeat
                new Promise(), new Promise()  // shuffle, track
            ]

            spotify.getState((err, state) => {
                if (err) throw err
                Object.assign(data, state)
                promises[0].resolve()
            })

            spotify.isRepeating((err, isRepeating) => {
                if (err) throw err
                data.repeating = isRepeating
                promises[1].resolve()
            })

            spotify.isShuffling((err, isShuffling) => {
                if (err) throw err
                data.shuffling = isShuffling
                promises[2].resolve()
            })

            spotify.getTrack((err, track) => {
                if (err) throw err
                data.track = track
                promises[3].resolve()
            })

            wait(promises).then(() => out(data))
        } else out(data)
    })
}
