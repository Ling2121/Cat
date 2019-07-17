local control = cat.require"module/gui/control/control"
local utf8 = cat.utf8

local function insert_str(str,pos,ins)
    return utf8.sub(str,0,pos)..ins..utf8.sub(str,pos + 1,utf8.len(str))
end

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
    control.__init__(self,x,y,w,h)
    self.prompt_text = prompt or self.prompt_text
    self:connect("mouse_press",self,"__click__")
    self:signal("confirm_input")
end

function input:config_style(style)
    style = style or {}
    style.font = style.font or cat.assets.font("default")
    style.font_color = style.font_color or cat.color(236,255,0)
    style.box_color = style.box_color or cat.color(236,255,0)
    style.color = style.color or cat.color(60,50,150)
    style.box_size = style.box_size or 2

    self.style = style
    return self
end

function input:__click__()
    self:lock()
end

function input:textinput(text)
    if self._is_lock then
        self.input_text = insert_str(self.input_text,self._cursor,text)
        self._cursor = math.min(self._cursor + 1,utf8.len(self.input_text))
    end
end

function input:keypressed(key)
    if self._is_lock then
        if key == "return" then
            self:emit_signal("confirm_input",self.input_text)
            self:unlock()
            self.input_text = ""
        end
    end
end

function input:mousepressed()
    if (not self:is_hover()) and love.mouse.isDown(1) then
        self:unlock()
        return
    end
end

function input:update(dt)

    self._remove_clock = self._remove_clock + dt
    self._cursor_clock = self._cursor_clock + dt
    self._move_clock = self._move_clock + dt

    --光标闪烁时钟
    if self._cursor_clock >= self._cursor_speed then
        self._cursor_clock = 0
        self._cursor_draw = not self._cursor_draw
    end

    --删除时钟
    if self._remove_clock >= self._remove_speed then
        self._remove_clock = 0
        if love.keyboard.isDown("backspace") then
            local pos = self._cursor
            local str = self.input_text
            local l_str = utf8.sub(str,1,pos - 1)--光标左边的字符串
            local r_str = utf8.sub(str,pos + 1,utf8.len(str))--右边的
            self.input_text = l_str..r_str
            self._cursor = math.max(0,self._cursor - 1)
        end
    end

    --光标移动时钟
    if self._move_clock >= self._move_speed then
        self._move_clock = 0
        if love.keyboard.isDown("left") then
            self._cursor = math.max(0,self._cursor - 1)
        elseif love.keyboard.isDown("right") then
            self._cursor = math.min(self._cursor + 1,utf8.len(self.input_text))
        end
    end
end

function input:draw()
    local x,y = self.position:unpack()
    local font = self.style.font
    local tw,th = font:getWidth(self.input_text),font:getHeight()
    local tx,ty = x + self.style.box_size / 2 + 1,y + self._height / 2 - th / 2
    local cw = font:getWidth(utf8.sub(self.input_text,1,self._cursor))--到光标位置到文本大小
    local cux,cuy = tx,ty
    local dfls = love.graphics.getLineWidth()

    local sx, sy, sw, sh = love.graphics.getScissor()

    love.graphics.setScissor(x,y,self._width,self._height)
    --底子
    love.graphics.setColor(self.style.color:unpack())
    love.graphics.rectangle("fill",x,y,self._width,self._height)

    --框
    love.graphics.setLineWidth(self.style.box_size)
    love.graphics.setColor(self.style.box_color:unpack())
    love.graphics.rectangle("line",x,y,self._width,self._height)
    love.graphics.setLineWidth(dfls)

    if cw - self._text_draw_offset < 0 then
        self._text_draw_offset = cw
    end

    if cw - self._text_draw_offset > self._width then
        self._text_draw_offset = cw - self._width
    end

    --文本
    local tr,tg,tb,ta = self.style.font_color:unpack()
    love.graphics.setFont(font)
    if self.input_text ~= "" and self.input_text ~= nil then
        love.graphics.setColor(tr,tg,tb,ta)
        love.graphics.print(self.input_text,tx - self._text_draw_offset,ty)
    else
        love.graphics.setColor(tr,tg,tb,ta * 0.4)
        love.graphics.print(self.prompt_text,tx,ty)
    end
    love.graphics.setFont(cat.assets.font("default"))

    --光标
    if self._is_lock then
        love.graphics.setColor(self.style.box_color:unpack())
        if self._cursor_draw then
            cux = cux + cw - self._text_draw_offset
            local cuw,cuh = self._width * 0.05,self._height * 0.08
            love.graphics.rectangle("fill",cux,cuy + th * 0.75,cuw,cuh)
        end
    end

    love.graphics.setScissor(sx, sy, sw, sh)
    love.graphics.setColor(255,255,255,255)
end

return input