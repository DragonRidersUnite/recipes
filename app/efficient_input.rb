# RECIPE: Efficient Input
#
# This recipe shows you how to check multiplate keys easily, in addition to
# controller input.
#
# Read tutorial: https://www.dragonriders.community/recipes/efficient-input
def tick_efficient_input(args)
  args.state.confirmations ||= []

  # we check for input using our custom method!
  # see source below
  if confirm?(args)
    args.state.confirmations << "Confirmed @ tick: #{args.state.tick_count}"
  end

  if args.state.confirmations.length > 8
    args.state.confirmations = args.state.confirmations.drop(1)
  end

  labels = []
  labels << {
    x: args.grid.w / 2, y: args.grid.top - 60,
    text: "Efficient Input",
    size_enum: 10, alignment_enum: 1,
  }
  labels << {
    x: args.grid.w / 2, y: args.grid.top - 240,
    text: "Press Z, J, Enter, or Space for primary input",
    size_enum: 4, alignment_enum: 1,
  }
  labels.concat(args.state.confirmations.reverse.map.with_index do |c, i|
    {
      x: args.grid.w / 2, y: args.grid.top - 360 - i * 32,
      text: c, size_enum: 2, alignment_enum: 1,
    }

  end)

  args.outputs.labels << labels

  # ignore this, part of the recipes interactive code!
  back_button(args: args)
  src_button(args: args)
end

CONFIRM_KEYS = [:j, :z, :enter, :space]
def confirm?(inputs)
  inputs.controller_one.key_down&.a ||
    (CONFIRM_KEYS & inputs.keyboard.keys[:down]).any?
end
