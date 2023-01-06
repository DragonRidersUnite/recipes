# This sample shows how to use tile_x, tile_y, tile_w, and tile_h to
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
  if args.inputs.keyboard.key_down.space || (args.state.animating && args.state.tick_count % 16 == 0)
    args.state.tile_i += 1

    if args.state.tile_i >= tiles.length
      args.state.tile_i = 0
    end
  end

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

  args.outputs.labels  << {
    x: args.grid.w / 2,
    y: 220,
    text: 'press [SPACE] to change tile',
    size_enum: 5,
    alignment_enum: 1
  }
  args.outputs.labels  << {
    x: args.grid.w / 2,
    y: 160,
    text: 'press A to toggle animation',
    size_enum: 5,
    alignment_enum: 1
  }
  args.outputs.labels  << {
    x: args.grid.w / 2,
    y: 80,
    text: "tile index: #{args.state.tile_i} | animating: #{args.state.animating}",
    size_enum: 5,
    alignment_enum: 1
  }

  args.outputs.labels  << {
    x: args.grid.left + 40,
    y: args.grid.top - 120,
    text: "original image at 4x"
  }
  args.outputs.sprites << {
    path: 'sprites/spritesheet.png',
    x: args.grid.left + 100,
    y: args.grid.top - 92,
    w: 64,
    h: 64,
  }

  # ignore this, part of the recipes interactive code!
  back_button(args: args, clean_up: -> (args) do
    args.state.tile_i = nil
    args.state.animating = nil
  end)
  src_button(args: args)
end
