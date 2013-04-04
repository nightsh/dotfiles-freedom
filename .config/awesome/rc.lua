-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local vicious = require("vicious")

-- Load Debian menu entries
local debian = require("debian.menu")

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
--beautiful.init("/usr/share/awesome/themes/default/theme.lua")
beautiful.init("/home/victor/.config/awesome/theme.lua")

function run_once(cmd)
  findme = cmd
  firstspace = cmd:find(" ")
  if firstspace then
    findme = cmd:sub(0, firstspace-1)
  end
  awful.util.spawn_with_shell("pgrep -u $USER -x " .. findme .. " > /dev/null || (" .. cmd .. ")")
end

--- {{{ Autostart programs, modify this to suit your needs
run_once("xfsettingsd")
--run_once("cairo-compmgr")
run_once("nm-applet")
run_once("volti")
--run_once("nitrogen --restore")
--run_once("blueman-applet")
--run_once("liferea")
run_once("conky -c /home/victor/backup/conky/1/.conkyrc")
run_once("numlockx on")
run_once("xset b off")
run_once("xfce4-power-manager")
run_once("synapse")
--run_once("parcellite")
--run_once("zim")
run_once("/home/victor/scripts/keymap.sh")
--- }}}

-- This is used later as the default terminal and editor to run.
terminal = "lxterminal"
browser  = "chromium"
editor   = "gvim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier
}
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.

--tags = { }
 tags = {
settings = {
    { names  = { "[✉]", " \\2 ", " \\3 ", " \\4 ", " \\5 ", " \\6", " \\7 ", " \\8 ", " 9⎞" },
      layout = { layouts[2], layouts[10], layouts[10], layouts[4], layouts[4], layouts[3], layouts[1], layouts[12], layouts[12] }
    },
    {  names = { "1-Sys", "2-Web", "3-Float", "4-Sys", "5-IRC", "6-Music", "7-Media", "8-Sys", "9-SSH" },
      layout = { layouts[7], layouts[2], layouts[1], layouts[4], layouts[4], layouts[2], layouts[4], layouts[12], layouts[4] }
}}}

for s = 1, screen.count() do
    tags[s] = awful.tag(tags.settings[s].names, s, tags.settings[s].layout)
end

--
--tags = {
--    settings = {
--    {  names = { "1-Web", "2-Dev", "3", "4", "5", "6-Chat", "7-Media", "8-Sys", "9-SSH" },
--      layout = { layouts[4], layouts[4], layouts[4], layouts[4], layouts[4], layouts[4], layouts[4], layouts[4], layouts[4] }
--    },
--    {  names = { "1-Mail", "2-Web", "3", "4", "5-IRC", "6-XMPP", "7-Media", "8-Sys", "9-SSH" },
--      layout = { layouts[4], layouts[4], layouts[4], layouts[4], layouts[4], layouts[4], layouts[4], layouts[4], layouts[4] }
--}}}
--
--for s = 1, screen.count() do
--    -- Each screen has its own tag table.
--    --tags[s] = awful.tag(tags.names, s, tags.layout)
--    tag[s] = awful.tag(tag.setting[s].names, s, tags.setting[s].layout)
--end
-- }}}

local oldspawn = awful.util.spawn
awful.util.spawn = function (s)
    oldspawn(s, false)
end

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua" },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "Debian", debian.Debian_menu.Debian },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })
-- }}}

-- {{{ Wibox

spacer = wibox.widget.textbox(' ')
separator = wibox.widget.textbox('❄')
--spacer.text = " "
--separator.text = "❄"


-- {{{ Battery state

-- Initialize widget
batwidget = wibox.widget.textbox()
--baticon = wibox.widget({ type = "imagebox" })
--batwidget = awful.widget.progressbar()
--batwidget:set_width(15)
--batwidget:set_height(20)
--batwidget:set_vertical(true)
--batwidget:set_background_color('#494B4F')
--batwidget:set_color('#AECF96')
--batwidget:set_gradient_colors({ '#AECF96', '#88A175', '#FF5656' })

-- Battery tooltip
batwidget_t = awful.tooltip({ objects = { batwidget.widget },})

-- Register widget
vicious.register(batwidget, vicious.widgets.bat,
    function (widget, args)
        if args[2] == 0 then return ""
        else
            --baticon.image = image(beautiful.widget_bat)
            batwidget_t:set_text("traalala")
            return "<span>".. args[2] .. "% (".. args[3] .. ")</span>"
            --return args[2]
        end
    end, 61, "BAT0"
)
-- }}}


-- RAM usage widget
memwidget = awful.widget.progressbar()
memwidget:set_width(15)
memwidget:set_height(20)
memwidget:set_vertical(true)
memwidget:set_background_color('#494B4F')
memwidget:set_color('#AECF96')
memwidget:set_color({ type = "linear", from = { 0, 0 }, to = { 0, 20 },
            stops = {{ 0, '#AECF96' }, { 0.5, '#88A175' }, { 1, '#FF5656' } }})

-- RAM usage tooltip
memwidget_t = awful.tooltip({ objects = { memwidget },})

vicious.cache(vicious.widgets.mem)
vicious.register(memwidget, vicious.widgets.mem, 
                function (widget, args)
                    memwidget_t:set_text(" RAM: " .. args[2] .. "MB / " .. args[3] .. "MB ")
                    return args[1]
                 end, 13)


-- Network widget
netwidget = awful.widget.graph()
netwidget:set_width(50)
netwidget:set_height(20)
netwidget:set_background_color("#494B4F")
netwidget:set_color("#FF5656")
netwidget:set_color({ type = "linear", from = { 0, 0 }, to = { 0, 20 },
            stops = {{ 0, '#FF5656' }, { 0.5, '#88A175' }, { 1, '#AECF96' } }})

netwidget_t = awful.tooltip({ objects = { netwidget.widget },})

-- Register network widget
vicious.register(netwidget, vicious.widgets.net,
                    function (widget, args)
                        netwidget_t:set_text("Network download: " .. args["{eth0 down_mb}"] .. "mb/s")
                        return args["{eth0 down_mb}"]
                    end)

-- Weather widget
weatherwidget = wibox.widget.textbox()
weather_t = awful.tooltip({ objects = { weatherwidget },})

vicious.register(weatherwidget, vicious.widgets.weather, 
                function (widget, args)
                    weather_t:set_text("City: " .. args["{city}"] .."\nWind: " .. args["{windkmh}"] .. " km/h " .. args["{wind}"] .. "\nSky: " .. args["{sky}"] .. "\nHumidity: " .. args["{humid}"] .. "%")
                    return args["{tempc}"] .. "°C" 
                end, 1800, "LROP")

-- CPU usage widget
cpuwidget = awful.widget.graph()
cpuwidget:set_width(50)
cpuwidget:set_height(20)
cpuwidget:set_background_color("#494B4F")
cpuwidget:set_color("#FF5656")
cpuwidget:set_color({ type = "linear", from = { 0, 0 }, to = { 0, 20 },
            stops = {{ 0, '#FF5656' }, { 0.5, '#88A175' }, { 1, '#AECF96' } }})

cpuwidget_t = awful.tooltip({ objects = { cpuwidget },})

-- Register CPU widget
vicious.register(cpuwidget, vicious.widgets.cpu, 
                    function (widget, args)
                        cpuwidget_t:set_text("CPU Usage: " .. args[1] .. "%")
                        return args[1]
                    end)

-- Disk usage widget
diskwidget = wibox.widget.imagebox()
diskwidget:set_image("/home/victor/.config/awesome/du.png")
disk = require("diskusage")
-- the first argument is the widget to trigger the diskusage
-- the second/third is the percentage at which a line gets orange/red
-- true = show only local filesystems
disk.addToWidget(diskwidget, 75, 90, true)


-- Volume widget

--volumecfg = {}
--volumecfg.cardid  = 0
--volumecfg.channel = "Master"
--volumecfg.widget = wibox.widget({ type = "textbox", name = "volumecfg.widget", align = "right" })

--volumecfg_t = awful.tooltip({ objects = { volumecfg.widget },})
--volumecfg_t:set_text("Volume")

---- command must start with a space!
--volumecfg.mixercommand = function (command)
       --local fd = io.popen("amixer -c " .. volumecfg.cardid .. command)
       --local status = fd:read("*all")
       --fd:close()

       --local volume = string.match(status, "(%d?%d?%d)%%")
       --volume = string.format("% 3d", volume)
       --status = string.match(status, "%[(o[^%]]*)%]")
       --if string.find(status, "on", 1, true) then
               --volume = volume .. "%"
		--awful.util.spawn("volnoti-show " .. volume)
       --else   
               --volume = volume .. "M"
		--awful.util.spawn("volnoti-show -m")
       --end
       --volumecfg.widget.text = volume
--end
--volumecfg.update = function ()
       --volumecfg.mixercommand(" sget " .. volumecfg.channel)
--end
--volumecfg.up = function ()
       --volumecfg.mixercommand(" sset " .. volumecfg.channel .. " 1%+")
--end
--volumecfg.down = function ()
       --volumecfg.mixercommand(" sset " .. volumecfg.channel .. " 1%-")
--end
--volumecfg.toggle = function ()
       --volumecfg.mixercommand(" sset " .. volumecfg.channel .. " toggle")
--end
--volumecfg.widget:buttons({
       --button({ }, 4, function () volumecfg.up() end),
       --button({ }, 5, function () volumecfg.down() end),
       --button({ }, 1, function () volumecfg.toggle() end)
--})
--volumecfg.update()

-- Create a textclock widget
mytextclock = awful.widget.textclock(" %a %b %d, %H:%M:%S ", 1)

-- Calendar widget to attach to the textclock
local calendar = require('calendar2')
calendar.addCalendarToWidget(mytextclock)

-- Caps Lock widget
capslockwidget = wibox.widget.textbox()
    lock = io.popen("~/scripts/caps_lock.sh")
    capslockwidget:set_text(lock:read("*a"))
    lock:close()

-- Create a systray
mysystray = wibox.widget.systray()

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewprev),
                    awful.button({ }, 5, awful.tag.viewnext)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if not c:isvisible() then
                                                  awful.tag.viewonly(c:tags()[1])
                                              end
                                              client.focus = c
                                              c:raise()
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", ontop = false, height = 20, screen = s })
    -- Add widgets to the wibox - order matters

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mylauncher)
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(spacer)
    right_layout:add(separator)
    right_layout:add(cpuwidget)
    right_layout:add(spacer)
    right_layout:add(separator)
    right_layout:add(spacer)
    right_layout:add(capslockwidget)
    right_layout:add(spacer)
    right_layout:add(separator)
    right_layout:add(spacer)
    right_layout:add(memwidget)
    right_layout:add(spacer)
    right_layout:add(separator)
    right_layout:add(spacer)
    right_layout:add(batwidget)
    right_layout:add(spacer)
    right_layout:add(separator)
    right_layout:add(spacer)
    right_layout:add(weatherwidget)
    right_layout:add(spacer)
    right_layout:add(separator)
    right_layout:add(spacer)
    right_layout:add(mytextclock)
    right_layout:add(mylayoutbox[s])

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
end
-- }}}

--mystatusbar = awful.wibox({ position = "bottom", screen = 1, ontop = false, width = 1, height = 10 })

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewprev),
    awful.button({ }, 5, awful.tag.viewnext)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    --awful.key({ modkey,           }, "w", function () mymainmenu:show({keygrabber=true}) end),

    awful.key({ modkey,           }, "w",
        function ()
            awful.mywibox[s].opacity = 0
        end),
    awful.key({ modkey, "Shift"   }, "w",
        function ()
            awful.mywibox[s].opacity = 1
        end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey },            "#148", function () awful.util.spawn("screenruler") end),
    awful.key({ },                   "#148", function () awful.util.spawn("mate-calc") end),
    awful.key({ },                   "#220", function () awful.util.spawn("cheese") end),
    awful.key({ },                   "#225", function () awful.util.spawn("luakit") end),
    awful.key({ modkey,           }, "#225", function () awful.util.spawn("chromium") end),
    awful.key({         "Shift"   }, "#225", function () awful.util.spawn("iceweasel") end),
    awful.key({ modkey,           }, "#235", function () awful.util.spawn("arandr") end),
    awful.key({ modkey,           }, "#165", function () awful.util.spawn("claws-mail") end),
    awful.key({         "Shift"   }, "#165", function () awful.util.spawn("pcmanfm") end),
    awful.key({ },                   "#165", function () awful.util.spawn("caja --no-desktop") end),
    awful.key({ "Control"         }, "Print", function () awful.util.spawn("lxterminal") end),
    awful.key({ modkey,           }, "Print", function () awful.util.spawn("xfce4-screenshooter") end),
    awful.key({ modkey,           }, "Delete", function () awful.util.spawn("i3lock -i /home/victor/Pictures/asciideb.png") end),
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey,           }, "p",  function () awful.util.spawn("dmenu_run -b") end),
    awful.key({ modkey, "Control" }, "Return", function () awful.util.spawn("emacs") end),
    awful.key({ modkey, "Shift"   }, "Return", function () awful.util.spawn("gvim") end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),

    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),
    awful.key({ modkey            }, "F1",    function () awful.layout.set(awful.layout.suit.floating) end),
    awful.key({ modkey            }, "F2",    function () awful.layout.set(awful.layout.suit.tile) end),
    awful.key({ modkey            }, "F3",    function () awful.layout.set(awful.layout.suit.tile.left) end),
    awful.key({ modkey            }, "F4",    function () awful.layout.set(awful.layout.suit.tile.bottom) end),
    awful.key({ modkey            }, "F5",    function () awful.layout.set(awful.layout.suit.tile.top) end),
    awful.key({ modkey            }, "F6",    function () awful.layout.set(awful.layout.suit.fair) end),
    awful.key({ modkey            }, "F7",    function () awful.layout.set(awful.layout.suit.fair.horizontal) end),
    awful.key({ modkey            }, "F8",    function () awful.layout.set(awful.layout.suit.spiral) end),
    awful.key({ modkey            }, "F9",    function () awful.layout.set(awful.layout.suit.spiral.dwindle) end),
    awful.key({ modkey            }, "F10",   function () awful.layout.set(awful.layout.suit.max) end),
    awful.key({ modkey            }, "F11",   function () awful.layout.set(awful.layout.suit.max.fullscreen) end),
    awful.key({ modkey            }, "F12",   function () awful.layout.set(awful.layout.suit.magnifier) end),

    -- Prompt
    --awful.key({ modkey,           }, "r", function () awful.util.spawn("dmenu_run -p Run: -fn Droid\\ Mono-11 -nb black -nf lightblue") end),
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),
    awful.key({ "Mod1" }, "Tab", function ()
        awful.menu.menu_keys.down = { "Down", "Tab" }
        local cmenu = awful.menu.clients({width=245}, { keygrabber=true, coords={x=525, y=330} })
    end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Shift"   }, "t",      function (c)
                                                   if   c.titlebar then awful.titlebar.remove(c)
                                                   else awful.titlebar.add(c, { modkey = modkey })
                                                   end
                                                end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",      function (c) c.minimized = not c.minimized    end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ }, "Num_Lock",
                function ()
                    lock = io.popen("~/scripts/caps_lock.sh")
                    capslockwidget:set_text(lock:read("*a"))
                    lock:close()
                end),
        awful.key({ }, "Caps_Lock",
                function ()
                    lock = io.popen("~/scripts/caps_lock.sh")
                    capslockwidget:set_text(lock:read("*a"))
                    lock:close()
                end),
        --awful.key({ }, "XF86AudioRaiseVolume", function () volumecfg.up() end),
        --awful.key({ }, "XF86AudioLowerVolume", function () volumecfg.down() end),
        --awful.key({ }, "XF86AudioPrev", function () awful.util.spawn("mpc prev") end),
        --awful.key({ }, "XF86AudioPlay", function () awful.util.spawn("mpc pause") end),
        --awful.key({ }, "XF86AudioNext", function () awful.util.spawn("mpc next") end),
        awful.key({ }, "XF86AudioMute", function () volumecfg.toggle() end))

end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { }, except = { name = "x-caja-desktop" },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    --{ rule = { class    = "Conky"       }, callback = function(c) c:tags({ tags[1][1], tags[1][2], tags[1][3], 
                                                                --tags[1][4], tags[1][5], tags[1][6], tags[1][7], tags[1][8], tags[1][9]}) end},
    --{ rule = { name     = "x-caja-desktop"}, callback = function(c) c:tags({ tags[1][1], tags[1][2], tags[1][3], 
                                                                --tags[1][4], tags[1][5], tags[1][6], tags[1][7], tags[1][8], tags[1][9]}) end},
    { rule = { name = "x-caja-desktop"  },
      properties = { border_width = 0,
                     sticky = true
                   } },
    { rule = { instance = "mateconf-editor"     }, properties = { floating = true } },
    { rule = { instance = "mate-control-center" }, properties = { floating = true } },
    { rule = { class    = "Conky"       }, properties = { sticky   = true, ontop = true } },
    { rule = { class    = "MPlayer"     }, properties = { floating = true } },
    { rule = { class    = "gimp"        }, properties = { floating = true } },
    { rule = { name     = "galculator"  }, properties = { floating = true } },
    { rule = { name     = "mate-calc"   }, properties = { floating = true } },
    { rule = { instance = "eog"         }, properties = {floating = true}},
    { rule = { instance = "rhythmbox"   }, properties = {floating = true}},
    { rule = { instance = "clawsker"    }, properties = {tag = tags[1][1], floating = true}},
    { rule = { instance = "claws-mail"  }, properties = {tag = tags[1][1]}},
    { rule = { instance = "screenruler" }, properties = {floating = true}},
    { rule = { instance = "pidgin"      }, properties = {tag = tags[1][6]}},
    { rule = { instance = "gvim"        }, properties = {tag = tags[1][2]}},
    { rule = { instance = "nitrogen"    }, properties = {floating = true}},
    { rule = { instance = "dwb"         }, properties = {floating = true}},
    { rule = { instance = "terra"       }, properties = {floating = true}},
    { rule = { class    = "Pidgin"      }, properties = {tag = tags[1][6]}},
    { rule = { instance = "zim"         }, properties = {tag = tags[1][9]}}
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- buttons for the titlebar
        local buttons = awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                )

        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))
        left_layout:buttons(buttons)

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local middle_layout = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title:set_align("center")
        middle_layout:add(title)
        middle_layout:buttons(buttons)

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(middle_layout)

        awful.titlebar(c):set_widget(layout)
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- Autostart applications
--awful.util.spawn_with_shell("chromium")

--awful.hooks.timer.register(60, function ()
       --volumecfg.update()
--end)
