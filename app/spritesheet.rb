# RECIPE: Spritesheet
#
# This recipe shows how to use tile_x, tile_y, tile_w, and tile_h to
# selectively render what's in an image. Useful for images that contain
# multiple tiles and animations.
def tick_spritesheet(args)
  args.state.tile_i ||= 0
  args.state.animating ||= false

  # the spritesheet image is a 2x2 grid of squares, so we map out each one
  # you could write code to automate this if you wanted, but being explcit
  # can be nice
  tiles = {
    0 => { x: 0, y: 0, w: 8, h: 8 },
    1 => { x: 0, y: 8, w: 8, h: 8 },
    2 => { x: 8, y: 0, w: 8, h: 8 },
    3 => { x: 8, y: 8, w: 8, h: 8 },
  }

  if args.inputs.keyboard.key_down.a
    args.state.animating = !args.state.animating
  end

  # here we handle changing the tile index by various means
  if args.state.animating && args.state.tick_count % 16 == 0
    next_tile(args, tiles)
  end

  controls = []
  controls << button(
    x: args.grid.w / 2 - 40 - 160, y: args.grid.top - 460, w: 250, h: 60,
    key: :animate, title: args.state.animating ? "Stop Animating" : "Start Animating",
    on_click: -> (args) { args.state.animating = !args.state.animating }
  )
  controls << button(
    x: args.grid.w / 2 - 40 + 100, y: args.grid.top - 460, w: 200, h: 60,
    key: :next_tile, title: "Next Tile",
    on_click: -> (args) { next_tile(args, tiles) }
  )

  tile = tiles[args.state.tile_i]

  args.outputs.sprites << {
    path: 'sprites/spritesheet.png',
    # this is the good stuff, we render a portion of our image
    tile_w: tile.w,
    tile_h: tile.h,
    tile_x: tile.x,
    tile_y: tile.y,
    x: args.grid.w / 2 - 64,
    y: 380,
    w: 128, # draw our sprite large!
    h: 128,
  }

  # this is just label stuff for the demo
  labels = []
  labels << {
    x: args.grid.w / 2, y: args.grid.top - 60,
    text: "Spritesheet",
    size_enum: 10, alignment_enum: 1
  }
  labels << {
    x: args.grid.w / 2,
    y: 340,
    text: 'only a segment of the image is rendered',
    size_enum: 0,
    alignment_enum: 1
  }
  labels  << {
    x: args.grid.w / 2,
    y: 160,
    text: "tile index: #{args.state.tile_i} | animating: #{args.state.animating}",
    size_enum: 2,
    alignment_enum: 1
  }
  labels  << {
    x: args.grid.left + 140,
    y: args.grid.top - 330,
    text: "original image at 4x"
  }
  args.outputs.labels << labels
  args.outputs.sprites << {
    path: 'sprites/spritesheet.png',
    x: args.grid.left + 200,
    y: args.grid.top - 300,
    w: 64,
    h: 64,
  }

  controls.each { |c| c[:tick].call(args, c) }
  args.outputs.primitives << controls.map { |c| button_for_render(c) }

  # ignore this, part of the recipes interactive code!
  back_button(args: args, clean_up: -> (args) do
    args.state.tile_i = nil
    args.state.animating = nil
  end)
  src_button(args: args)
end

def next_tile(args, tiles)
  args.state.tile_i += 1

  if args.state.tile_i >= tiles.length
    args.state.tile_i = 0
  end
end
