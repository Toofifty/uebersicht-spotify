###

Interactive Spotify Widget for Uebersicht :)
Created by Alex Matheson

###

debug: false

# Decrease for more responsive controls,
# increase for more responsive computer
refreshFrequency: 1000

# E-Z customize
highlight = '#1eaaff'
background = 'linear-gradient(135deg, rgba(0, 0, 0, 0.2), rgba(0, 0, 0, 0.4))'

# Pro customize
style: """
    color: white
    font-family: Consolas, Lato, Menlo, monospace
    bottom: 6px
    left: 6px
    background: #{background}
    border-radius: 5px
    height: 39px
    user-select: none
    overflow: hidden

    .track img
        height: 40px
        width: 40px
        display: inline-block

    .track .info
        display: inline-block
        padding: 10px 20px 10px 10px
        vertical-align: top

    .track .info .name
        color: #{highlight}
        font-weight: 700
        whitespace: pre

    .progress
        height: 1px
        background: #{highlight}
        width: 100%
        position: absolute
        left: 0
        bottom: 0
        border-top: 1px solid rgba(0, 0, 0, 0.4)

    .controls
        display: inline-block
        vertical-align: top
        padding: 8px 20px

    .material-icons.active
        color: #{highlight}

    .debug
        position: fixed
        left: 300px
        top: 300px
"""

command: "node spotify/lib/api"

update: (output, el) ->
    if output.substr(0, 5) == 'track'
        # something failed in spotify
        return
    try
        data = JSON.parse(output)
    catch err
        console.error(err)
        return

    # truncate long names
    if data.track.name.length > 40
        $(el).find('.name').text(data.track.name.substr(0, 37) + '...')
    else
        $(el).find('.name').text(data.track.name)

    $(el).find('.debug').text(output) if @debug

    $(el).find('.artwork').attr('src', data.track.artwork_url)
    $(el).find('.artist').text(data.track.artist)

    progress = data.position / data.track.duration * 100000
    $(el).find('.progress').css('width', progress + '%')

    play = $(el).find('.play-pause')
    playtext = play.text()
    if data.state == 'playing' && playtext != 'pause'
        play.text('pause')
    else if data.state != 'playing' && playtext != 'play_arrow'
        play.text('play_arrow')

    repeat = $(el).find('.repeat')
    if data.repeating && !repeat.hasClass('active')
        repeat.addClass('active')
    else if !data.repeating && repeat.hasClass('active')
        repeat.removeClass('active')

    shuffle = $(el).find('.shuffle')
    if data.shuffling && !shuffle.hasClass('active')
        shuffle.addClass('active')
    else if !data.shuffling && shuffle.hasClass('active')
        shuffle.removeClass('active')

    # only add event listeners if they don't
    # already exist
    if !play[0].onclick
        play[0].onclick = ->
            self.run 'node spotify/lib/api playpause'

        repeat[0].onclick = ->
            self.run 'node spotify/lib/api repeat'

        shuffle[0].onclick = ->
            self.run 'node spotify/lib/api shuffle'

        $(el).find('.prev')[0].onclick = ->
            self.run 'node spotify/lib/api previous'

        $(el).find('.next')[0].onclick = ->
            self.run 'node spotify/lib/api next'
            console.log 'next'

render: (output) -> """
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons"
      rel="stylesheet">
    <div class='track'>
        <div class='controls'>
            <i class='material-icons repeat'>repeat</i>
            <i class='material-icons prev'>skip_previous</i>
            <i class='material-icons play-pause'>play_arrow</i>
            <i class='material-icons next'>skip_next</i>
            <i class='material-icons shuffle'>shuffle</i>
        </div><img class='artwork' src='' />
        <div class='info'>
            <span class='name'></span> by
            <span class='artist'></span>
        </div>
        <div class="progress">
        </div>
    </div>
    <div class="debug"></div>
"""
