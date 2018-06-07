import re
from xkeysnail.transform import *

# [xkeysnailでキーリマップする]( https://qiita.com/miy4/items/dd0e2aec388138f803c5 )
# ideal key map
# MUHENKAN -> Super
# MUHENKANx2 -> MUHENKAN
# HENKAN -> Super
# HENKANx2 -> HENKAN
define_multipurpose_modmap({
    Key.CAPSLOCK: [Key.ESC, Key.RIGHT_CTRL],
    Key.MUHENKAN: [Key.MUHENKAN, Key.LEFT_CTRL],
    Key.HENKAN: [Key.HENKAN, Key.RIGHT_CTRL],
})
define_keymap(None, {
    # APOSTROPHE is ':'
    K("C-m"): K("ENTER"),
    K("C-semicolon"): [K("esc"), K("MUHENKAN"), set_mark(False)],
    K("C-APOSTROPHE"): [K("esc"), K("MUHENKAN"), set_mark(False)],
    K("KATAKANAHIRAGANA"): [K("C-x"), K("C-x"), set_mark(False)],

    K("Win-Up"): K("Home"),
    K("Win-Down"): K("End"),
    K("Win-Shift-Left"): K("Ctrl-Shift-Left"),
    K("Win-Shift-Right"): K("Ctrl-Shift-Right"),
    K("Win-Left"): K("Ctrl-Left"),
    K("Win-Right"): K("Ctrl-Right"),

    K("Win-Ctrl-d"): K("Win-d"),
    K("Win-Ctrl-s"): K("Win-s"),

    K("Win-Ctrl-f"): K("Win-Alt-tenkey-5"),
    K("Win-Ctrl-1"): K("Win-Alt-tenkey-1"),
    K("Win-Ctrl-2"): K("Win-Alt-tenkey-3"),
    K("Win-Ctrl-3"): K("Win-Alt-tenkey-7"),
    K("Win-Ctrl-4"): K("Win-Alt-tenkey-9"),
    K("Win-Ctrl-Left"): K("Win-Alt-tenkey-4"),
    K("Win-Ctrl-Up"): K("Win-Alt-tenkey-2"),
    K("Win-Ctrl-Right"): K("Win-Alt-tenkey-6"),
    K("Win-Ctrl-Down"): K("Win-Alt-tenkey-8"),

    K("Win-a"): K("C-a"),
    K("Win-b"): K("C-b"),
    #     K("Win-c"): K("C-c"),
    K("Win-d"): K("C-d"),
    K("Win-e"): K("C-e"),
    K("Win-f"): K("C-f"),
    K("Win-g"): K("C-g"),
    K("Win-h"): K("C-h"),
    K("Win-i"): K("C-i"),
    K("Win-j"): K("C-j"),
    K("Win-k"): K("C-k"),
    #     K("Win-l"): K("C-l"),
    K("Win-m"): K("C-m"),
    K("Win-n"): K("C-n"),
    K("Win-o"): K("C-o"),
    K("Win-p"): K("C-p"),
    K("Win-q"): K("C-q"),
    K("Win-r"): K("C-r"),
    K("Win-s"): K("C-s"),
    K("Win-t"): K("C-t"),
    K("Win-u"): K("C-u"),
    #     K("Win-v"): K("C-v"),
    K("Win-w"): K("C-w"),
    K("Win-x"): K("C-x"),
    K("Win-y"): K("C-y"),
    K("Win-z"): K("C-z"),

    K("Win-tab"): K("Alt-tab"),
    K("Win-Shift-tab"): K("Alt-Shift-tab"),

    #     K("Alt-l"): K("Win-l"),
}, "Anywhere")

define_keymap(re.compile("Firefox|Google-chrome"), {
    # Ctrl+Alt+j/k to switch next/previous tab
    K("C-M-l"): K("C-TAB"),
    K("C-M-h"): K("C-Shift-TAB"),
}, "Firefox and Chrome")

define_keymap(re.compile("Atom"), {
    K("C-h"): K("Left"),
    K("C-j"): K("Down"),
    K("C-k"): K("Up"),
    K("C-l"): K("Right"),
    K("Win-h"): K("Left"),
    K("Win-j"): K("Down"),
    K("Win-k"): K("Up"),
    K("Win-l"): K("Right"),
}, "Atom")

terms = ("URxvt", "Terminator", "Tilda", "Gnome-terminal")
define_keymap(lambda wm_class: wm_class in terms, {
    K("Win-c"): K("C-c"),
    K("Win-v"): K("C-v"),
    K("Win-SPACE"): K("Win"),
}, "Non Term")
define_keymap(lambda wm_class: wm_class not in terms, {
    K("C-e"): K("end"),
    K("C-a"): K("home"),
    #     K("Win-e"): K("end"),
    #     K("Win-a"): K("home"),
    K("Win-c"): K("Shift-Ctrl-c"),
    K("Win-v"): K("Ctrl-Shift-v"),
    #     K("C-x"): {
    #         # C-x h (select all)
    #         K("h"): [K("C-home"), K("C-a"), set_mark(True)],
    #         # C-x C-f (open)
    #         K("C-f"): K("C-o"),
    #         # C-x C-s (save)
    #         K("C-s"): K("C-s"),
    #         # C-x k (kill tab)
    #         K("k"): K("C-f4"),
    #         # C-x C-c (exit)
    #         K("C-c"): K("M-f4"),
    #         # cancel
    #         K("C-g"): pass_through_key,
    #         # C-x u (undo)
    #         K("u"): [K("C-z"), set_mark(False)],
    #     }
}, "Term")
