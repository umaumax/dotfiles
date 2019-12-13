import re
from xkeysnail.transform import *

# [xkeysnailでキーリマップする]( https://qiita.com/miy4/items/dd0e2aec388138f803c5 )
# ideal key map
# MUHENKAN -> Super: 現状、単体で押して離した時に入力が切り替わってしまっている
# MUHENKANx2 -> MUHENKAN: 擬似的に満たしている
# HENKAN -> Super: 現状、単体で押して離した時に入力が切り替わってしまっている
# HENKANx2 -> HENKAN: 擬似的に満たしている
define_multipurpose_modmap({
    Key.CAPSLOCK: [Key.RIGHT_CTRL, Key.RIGHT_CTRL],
    Key.MUHENKAN: [Key.MUHENKAN, Key.LEFT_CTRL],
    Key.HENKAN: [Key.HENKAN, Key.RIGHT_CTRL],
    # Require:
    # by compizconfig-settings-manager
    # Key to show the launcher: Super -> Super + Space
    Key.LEFT_META: [Key.ESC, Key.RIGHT_META],
})
define_keymap(None, {
    K("INSERT"): None,
    # APOSTROPHE is ':'
    K("C-m"): K("ENTER"),
    # NOTE: double esc is used for disable IME (google japanese-input)
    K("C-semicolon"): [K("esc"), K("esc"), K("MUHENKAN"), set_mark(False)],
    # KPPLUS is ten key '+'
    K("C-Shift-semicolon"): [K("C-KPPLUS"), set_mark(False)],
    # NOTE: double esc is used for disable IME (google japanese-input)
    K("C-APOSTROPHE"): [K("esc"), K("esc"), K("MUHENKAN"), set_mark(False)],
    K("KATAKANAHIRAGANA"): [K("C-x"), K("C-x"), set_mark(False)],
    # NOTE: double esc is used for disable IME (google japanese-input)
    K("esc"): [K("esc"), K("esc")],

    K("Win-Up"): K("Home"),
    K("Win-Down"): K("End"),
    K("Win-Shift-Left"): K("Ctrl-Shift-Left"),
    K("Win-Shift-Right"): K("Ctrl-Shift-Right"),
    #     K("Win-Left"): K("Ctrl-Left"),
    #     K("Win-Right"): K("Ctrl-Right"),
    K("Super-Left"): K("Ctrl-Left"),
    K("Super-Right"): K("Ctrl-Right"),

    K("Win-Ctrl-d"): K("Win-d"),
    K("Win-Ctrl-s"): K("Win-s"),

    # tenkey: KP<number>
    K("Win-Ctrl-f"): K("Ctrl-Alt-KP5"),
    K("Win-Ctrl-KEY_1"): K("Ctrl-Alt-KP7"),
    K("Win-Ctrl-KEY_2"): K("Ctrl-Alt-KP9"),
    K("Win-Ctrl-KEY_3"): K("Ctrl-Alt-KP1"),
    K("Win-Ctrl-KEY_4"): K("Ctrl-Alt-KP3"),
    K("Win-Ctrl-Left"): K("Ctrl-Alt-KP4"),
    K("Win-Ctrl-Up"): K("Ctrl-Alt-KP8"),
    K("Win-Ctrl-Right"): K("Ctrl-Alt-KP6"),
    K("Win-Ctrl-Down"): K("Ctrl-Alt-KP2"),

    K("Win-KEY_1"): K("Ctrl-KEY_1"),
    K("Win-KEY_2"): K("Ctrl-KEY_2"),
    K("Win-KEY_3"): K("Ctrl-KEY_3"),
    K("Win-KEY_4"): K("Ctrl-KEY_4"),
    K("Win-KEY_5"): K("Ctrl-KEY_5"),
    K("Win-KEY_6"): K("Ctrl-KEY_6"),
    K("Win-KEY_7"): K("Ctrl-KEY_7"),
    K("Win-KEY_8"): K("Ctrl-KEY_8"),
    K("Win-KEY_9"): K("Ctrl-KEY_9"),
    K("Win-KEY_0"): K("Ctrl-KEY_0"),

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
    K("Super-r"): K("C-r"),
    K("Win-s"): K("C-s"),
    K("Win-t"): K("C-t"),
    K("Win-u"): K("C-u"),
    #     K("Win-v"): K("C-v"),
    K("Win-w"): K("C-w"),
    K("Win-x"): K("C-x"),
    K("Win-y"): K("C-y"),
    K("Win-z"): K("C-z"),

    # COMPOSE: show right clock menu
    #     K("KATAKANAHIRAGANA"): K("COMPOSE"),

    # 理由は不明だがicon menuがでない
    K("Win-tab"): K("Alt-tab"),
    K("Win-Shift-tab"): K("Alt-Shift-tab"),

    #     K("Alt-l"): K("Win-l"),
}, "Anywhere")

define_keymap(re.compile("Firefox|Google-chrome"), {
    K("C-h"): K("Left"),
    K("C-j"): K("Down"),
    K("C-k"): K("Up"),
    K("C-l"): K("Right"),

    K("Win-h"): K("C-h"),
    K("Win-j"): K("C-j"),
    K("Win-k"): K("C-k"),
    K("Win-l"): K("C-l"),

    # NOTE: jump to search window
    K("esc"): [K("esc"), K("esc"), K("C-l")],
    # NOTE: double esc is used for disable IME (google japanese-input)
    K("C-semicolon"): [K("esc"), K("esc"), K("MUHENKAN"), set_mark(False), K("C-l")],
    # NOTE: double esc is used for disable IME (google japanese-input)
    K("C-APOSTROPHE"): [K("esc"), K("esc"), K("MUHENKAN"), set_mark(False), K("C-l")],

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
define_keymap(lambda wm_class: wm_class not in terms, {
    K("C-e"): K("end"),
    K("C-a"): K("home"),
    K("Win-c"): K("C-c"),
    K("Win-v"): K("C-v"),
    #     K("Win-SPACE"): K("Win"),
}, "Non Term")
define_keymap(lambda wm_class: wm_class in terms, {
    K("C-h"): K("Left"),
    K("C-j"): K("Down"),
    K("C-k"): K("Up"),
    K("C-l"): K("Right"),
    K("Win-h"): K("Left"),
    K("Win-j"): K("Down"),
    K("Win-k"): K("Up"),
    K("Win-l"): K("Right"),

    #     K("Win-e"): K("end"),
    #     K("Win-a"): K("home"),
    K("Win-c"): K("Ctrl-Shift-c"),
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
