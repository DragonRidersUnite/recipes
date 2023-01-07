# RECIPE: Menu
#
# Renders a list of menu options that can be navigated and selected.
def tick_menu(args)
  args.state.scene ||= :main_menu
  args.state.main_menu.current_option_i ||= 0
  args.state.hold_delay ||= 0

  options = [
    {
      text: "Start",
      on_select: -> (args) { args.state.scene = :gameplay }
    },
    {
      text: "Settings",
      on_select: -> (args) { args.state.scene = :settings }
    },
  ]

  labels = []

  options.each.with_index do |option, i|
    size = 6
    label = {
      x: args.grid.w / 2, y: 360 + (options.length - i * 52),
      text: option[:text], size_enum: size, alignment_enum: 1
    }
    label_size = args.gtk.calcstringbox(label.text, size)
    labels << label
    if args.state.main_menu.current_option_i == i
      args.outputs.solids << {
        x: label.x - (label_size[0] / 1.4) - 24 + (Math.sin(args.state.tick_count / 8) * 4),
        y: label.y - 22,
        w: 16,
        h: 16,
      }
    end
  end

  labels << {
    x: args.grid.w / 2, y: args.grid.top - 100,
    text: "Menu", size_enum: 12, alignment_enum: 1
  }
  labels << {
    x: args.grid.w / 2, y: args.grid.top - 180,
    text: "Navigate with Arrows | Select option with Z or Space", size_enum: 4, alignment_enum: 1
  }
  labels << {
    x: args.grid.w / 2, y: args.grid.top - 260,
    text: "Scene: #{args.state.scene}", size_enum: 4, alignment_enum: 1
  }
  args.outputs.labels << labels

  move = nil
  if args.inputs.down
    move = :down
  elsif args.inputs.up
    move = :up
  else
    args.state.hold_delay = 0
  end

  if move
    args.state.hold_delay -= 1

    if args.state.hold_delay <= 0
      index = args.state.main_menu.current_option_i
      if move == :up
        index -= 1
      else
        index += 1
      end

      if index < 0
        index = options.length - 1
      elsif index > options.length - 1
        index = 0
      end
      args.state.main_menu.current_option_i = index
      args.state.hold_delay = 10
    end
  end

  if args.inputs.keyboard.key_down.z || args.inputs.keyboard.key_down.space
    options[args.state.main_menu.current_option_i][:on_select].call(args)
  end

  # ignore this, part of the recipes interactive code!
  back_button(args: args, clean_up: -> (args) do
    args.state.scene = nil
    args.state.main_menu.current_option_i = nil
    args.state.hold_delay = nil
  end)
  src_button(args: args)
end
