def tick_music(args)
  # only start if not present
  unless args.audio[:music]
    args.audio[:music] = { input: "sounds/night.ogg", looping: true, paused: false }
  else
    labels = []
    labels << {
      x: 100, y: args.grid.top - 60,
      text: "Music Player",
      size_enum: 8
    }
    labels << {
      x: 100, y: args.grid.top - 120,
      text: "Track: #{args.audio[:music][:input]}"
    }
    labels << {
      x: 100, y: args.grid.top - 160,
      text: "#{args.audio[:music][:playtime].floor} /  #{args.audio[:music][:length].floor}"
    }
    labels << {
      x: 100, y: args.grid.top - 200,
      text: "Paused: #{args.audio[:music][:paused]}"
    }
    labels << {
      x: 100, y: args.grid.top - 240,
      text: "Looping: #{args.audio[:music][:looping]}"
    }
    args.outputs.labels << labels

    controls = []
    controls << button(
      x: 100, y: 400, w: 120, h: 60,
      key: :play_pause, title: args.audio[:music].paused ? "Play" : "Pause",
      on_click: -> (args) { args.audio[:music].paused = !args.audio[:music].paused }
    )
    controls.each { |c| c[:tick].call(args, c) }
    args.outputs.primitives << controls.map { |c| button_for_render(c) }
  end

  # ignore this, part of the recipes interactive code!
  back_button(args: args, clean_up: -> (args) do
    args.audio[:music] = nil
  end)
  src_button(args: args)
end
