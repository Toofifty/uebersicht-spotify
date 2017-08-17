command: "node spotify/lib/api"

refreshFrequency: 1000

get: (cls) ->
    @elm.find(cls)

update: (output, el) ->
    if output.substr(0, 5) == 'track'
        # something failed in spotify
        return
    try
        data = JSON.parse(output)
    catch err
        console.error(err)
        return

    dis = @

    @elm = $(el)

    @get('.debug').text(output)
    @get('.artwork').attr('src', data.track.artwork_url)
    @get('.name').text(data.track.name)
    @get('.artist').text(data.track.artist)

    el.onclick = ->
        console.log('clicked')

style: """
    .spotify-main
        background: #222
        border: 1px solid rgba(255, 255, 255, 0.1)
        border-radius: 4px
        color: white
        font-family: Helvetica Neue
        position: absolute
        left: 100px
        top: 100px
        padding: 20px

    .artwork
        width: 64px
        height: 64px
        border-radius 2px
        display: inline-block
        vertical-align: middle

    .info
        display: inline-block
        vertical-align: middle

    h2.name
        margin: 5px
        font-weight: 500
        font-size: 1em

    h3.artist
        margin: 5px
        font-weight: 300
        font-size: 0.9em

"""

render: (output) -> """
    <div class='spotify-main'>
        <div class='track' />
            <img class='artwork' src='' />
            <div class='info'>
                <h2 class='name'></h2>
                <h3 class='artist'></h3>
            </div>
        </div>
        <p class='debug'></p>
    </div>
"""
