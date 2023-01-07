# RECIPE: Menu
#
# Renders a list of menu options that can be navigated and selected.
#
# Uses a drop-in module method you can make use of wherever you'd like in your
# game.
def tick_menu(args)
  args.state.scene ||= :main_menu

  # see the source for `#tick_menu` below! It's a drop-in method you can use in
  # your game to add navigable menus anywhere.
  options = [
    {
      text: "Start",
      on_select: -> (args) { args.state.scene = :gameplay }
    },
    {
      text: "Load",
      on_select: -> (args) { args.state.scene = :load }
    },
    {
      text: "Settings",
      on_select: -> (args) { args.state.scene = :settings }
    },
  ]
  Menu.tick(args, :example_menu, options)

  labels = []
  labels << {
    x: args.grid.w / 2, y: args.grid.top - 100,
    text: "Menu", size_enum: 12, alignment_enum: 1
  }
  labels << {
    x: args.grid.w / 2, y: args.grid.top - 180,
    text: "Navigate with Arrows | Select option with Z or Space", size_enum: 2, alignment_enum: 1
  }
  labels << {
    x: args.grid.w / 2, y: args.grid.top - 260,
    text: "Scene: #{args.state.scene}", size_enum: 4, alignment_enum: 1
  }
  args.outputs.labels << labels

  # ignore this, part of the recipes interactive code!
  back_button(args: args, clean_up: -> (args) do
    args.state.scene = nil
    args.state.main_menu.current_option_i = nil
    args.state.hold_delay = nil
  end)
  src_button(args: args)
end


# Updates and renders a list of options that get passed through.
#
# +options+ data structure:
# [
#   {
#     text: "some string",
#     on_select: -> (args) { "do some stuff in this lambda" }
#   }
# ]
module Menu
  def self.tick(args, state_key, options)
    args.state.send(state_key).current_option_i ||= 0
    args.state.send(state_key).hold_delay ||= 0
    menu_state = args.state.send(state_key)

    labels = []

    options.each.with_index do |option, i|
      label = {
        text: option[:text],
        x: args.grid.w / 2,
        y: 360 + (options.length - i * 52),
        alignment_enum: 1,
        size_enum: 6,
      }
      label_size = args.gtk.calcstringbox(label.text, label.size_enum)
      labels << label
      if menu_state.current_option_i == i
        args.outputs.solids << {
          x: label.x - (label_size[0] / 1.4) - 24 + (Math.sin(args.state.tick_count / 8) * 4),
          y: label.y - 22,
          w: 16,
          h: 16,
          r: 0,
          g: 0,
          b: 0,
        }
      end
    end

    args.outputs.labels << labels

    move = nil
    if args.inputs.down
      move = :down
    elsif args.inputs.up
      move = :up
    else
      menu_state.hold_delay = 0
    end

    if move
      menu_state.hold_delay -= 1

      if menu_state.hold_delay <= 0
        index = menu_state.current_option_i
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
        menu_state.current_option_i = index
        menu_state.hold_delay = 10
      end
    end

    if confirm?(args.inputs)
      options[menu_state.current_option_i][:on_select].call(args)
    end
  end

  # you can use your own input checking! this is just for the recipe
  CONFIRM_KEYS = [:z, :space]
  def confirm?(inputs)
    CONFIRM_KEYS.any? { |k| inputs.keyboard.key_down.send(k) } ||
      (inputs.controller_one.connected && inputs.controller_one.key_down.a)
  end
end
