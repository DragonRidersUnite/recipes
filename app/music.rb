# RECIPE: Music
#
# This recipe shows you how to work with music, from getting its details to
# interacting with it.
#
# Read tutorial: https://www.dragonriders.community/recipes/music
def tick_music(args)
  # only set the music if not set already
  unless args.audio[:music]
    args.audio[:music] = { input: "sounds/night.ogg", looping: true, paused: true }
  else
    controls = []
    # NOTE: #button comes from this recipes codebase, not DragonRuby GTK
    controls << button(
      x: args.grid.w / 2 - 40, y: args.grid.top - 460, w: 120, h: 60,
      key: :play_pause, title: args.audio[:music].paused ? "Play" : "Pause",
      on_click: -> (args) { args.audio[:music].paused = !args.audio[:music].paused }
    )

    controls.each { |c| c[:tick].call(args, c) }
    args.outputs.primitives << controls.map { |c| button_for_render(c) }

    labels = []
    labels << {
      x: args.grid.w / 2, y: args.grid.top - 60,
      text: "Music Player",
      size_enum: 10, alignment_enum: 1,
    }
    # labels below demonstrate how to get info about the track
    labels << {
      x: args.grid.w / 2, y: args.grid.top - 240,
      text: "Track: #{args.audio[:music][:input]}",
      alignment_enum: 1,
    }
    labels << {
      x: args.grid.w / 2, y: args.grid.top - 280,
      text: "#{args.audio[:music][:playtime].floor} /  #{args.audio[:music][:length].floor}",
      alignment_enum: 1,
    }
    labels << {
      x: args.grid.w / 2, y: args.grid.top - 320,
      text: "Paused: #{args.audio[:music][:paused]}",
      alignment_enum: 1,
    }
    labels << {
      x: args.grid.w / 2, y: args.grid.top - 360,
      text: "Looping: #{args.audio[:music][:looping]}",
      alignment_enum: 1,
    }
    args.outputs.labels << labels
  end

  # ignore this, part of the recipes interactive code!
  back_button(args: args, clean_up: -> (args) do
    args.audio[:music] = nil
  end)
  src_button(args: args)
end
