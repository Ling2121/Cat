local control = cat.require"module/gui/control/control"

--1234[567891]0
--光标位置为最右边
local input = cat.class("input",control){
    input_text = "",
    prompt_text = "input...",
    _cursor = 0,

    _remove_clock = 0,
    _remove_speed = 0.06,

    _move_speed = 0.08,
    _move_clock = 0,

    _cursor_clock = 0,
    _cursor_speed = 0.4,

    _cursor_draw = true,
    _text_draw_offset = 0,
}

function input:__init__(prompt,x,y,w,h)
    self.prompt_text = prompt or self.prompt_text
    self:signal("confirm_input")
end

function input:config_style(style)
    style.font = style.font or cat.assets.font("default")
    style.font_color = style.font_color or cat.color(236,255,0)
end