require "app/efficient_input.rb"
require "app/music.rb"
require "app/spritesheet.rb"

BLUE = { r: 93, g: 166, b: 244 }

RECIPES = [
  {
    name: "Spritesheet",
    desc: "Images w/ multiple sprites",
    key: :spritesheet,
  },
  {
    name: "Music",
    desc: "Play looping audio",
    key: :music,
  },
  {
    name: "Efficient Input",
    desc: "Check many keys &\ncontrollers",
    key: :efficient_input,
  }
]

def tick(args)
  args.state.recipe ||= :main_menu
  send("tick_#{args.state.recipe}", args)
end

def tick_main_menu(args)
  recipe_buttons = []
  recipe_buttons = RECIPES.map.with_index do |r, i|
    w = 320
    h = 240
    x = args.grid.left + 80 + (i * w)
    y = args.grid.top - 200
    button = button(
      x: x, y: y, w: w, h: h,
      key: r[:key], title: r[:name], desc: r[:desc],
      on_click: -> (args) { args.state.tick_count = 0; args.state.recipe = button[:key] }
    )
    button
  end
  recipe_buttons.each { |rb| rb[:tick].call(args, rb) }
  args.outputs.sprites << {
    x: args.grid.w / 2 - 192,
    y: args.grid.top - 200,
    w: 385,
    h: 217,
    path: "sprites/logo.png"
  }
  args.outputs.primitives << recipe_buttons.map { |rb| button_for_render(rb) }
end

def button(x:, y:, w:, h:, key:, title:, desc: nil, on_click:)
  butt = {
    key: key,
    title: {
      x: x + 20,
      y: y - 20,
      text: title,
      size_enum: 2,
    }.label!,
    bg: {
      x: x,
      y: y - h,
      w: w - 20,
      h: h,
      a: 0,
    }.merge(BLUE).solid!,
    border: {
      x: x,
      y: y - h,
      w: w - 20,
      h: h,
    }.border!,
  }

  if desc
    butt[:desc] = desc.split("\n").map.with_index do |d, i|
      {
        x: x + 20,
        y: y - 60 - i * 20,
        text: d,
        size_enum: 0,
      }.label!
    end
  end

  butt[:on_click] = on_click

  butt[:tick] = -> (args, butt) do
    if args.inputs.mouse.position.inside_rect?(butt[:border])
      butt[:bg].a = 255

      if args.inputs.mouse.click
        butt.on_click.call(args)
      end
    end
  end

  butt
end

def back_button(args:, x: 40, y: 80, clean_up: nil)
  b = button(x: x, y: y, w: 120, h: 60, key: :back, title: "< Back", on_click: -> (args) do
    args.state.recipe = :main_menu
    clean_up.call(args) if clean_up
  end)
  b[:tick].call(args, b)
  args.outputs.primitives << button_for_render(b)
end

def src_button(args:, x: 1050, y: 80)
  b = button(x: x, y: y, w: 200, h: 60, key: :src, title: "View Source", on_click: -> (args) do
    args.gtk.openurl("https://github.com/DragonRidersUnite/recipes/blob/main/app/#{args.state.recipe}.rb")
  end)
  b[:tick].call(args, b)
  args.outputs.primitives << button_for_render(b)
end

def button_for_render(b)
  b.slice(:bg, :border, :title, :desc).values
end
