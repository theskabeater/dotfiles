# -*- coding: utf-8 -*-

import re
from xkeysnail.transform import *

# define timeout for multipurpose_modmap
define_timeout(1)

define_keymap(re.compile("Firefox|Google-chrome"), {
    # Dev tools
    K("Super-M-i"): K("C-Shift-i"),
}, "Firefox and Chrome")

# Emacs/OSX-like keybindings
define_keymap(lambda wm_class: wm_class not in ("Alacritty"), {
    # Select all
    K("M-a"): [K("C-home"), K("C-a")],
    # Jump Previous/Next word
    K("Super-Left"): K("C-Left"),
    K("Super-Right"): K("C-Right"),
    # Select word
    K("Super-Shift-Left"): K("C-Shift-Left"),
    K("Super-Shift-Right"): K("C-Shift-Right"),
    # Select Begining/End line
    K("M-Shift-Left"): K("C-Shift-Home"),
    K("M-Shift-Right"): K("C-Shift-End"),
    # Switch next/previous tab
    K("Super-Shift-RIGHT_BRACE"): K("C-TAB"),
    K("Super-Shift-LEFT_BRACE"): K("C-Shift-TAB"),
    # New tab
    K("M-t"): K("C-t"),
    # Cursor
    K("C-b"): K("left"),
    K("C-f"): K("right"),
    K("C-p"): K("up"),
    K("C-n"): K("down"),
    K("C-h"): K("backspace"),
    # Beginning/End of line
    K("C-a"): K("home"),
    K("C-e"): K("end"),
    K("M-Left"): K("home"),
    K("M-Right"): K("end"),
    # Copy
    K("M-x"): K("C-x"),
    K("M-c"): K("C-c"),
    K("M-v"): K("C-v"),
    # Delete
    K("C-d"): K("delete"),
    # Kill line
    K("C-k"): [K("Shift-end"), K("delete")],
    # Undo
    K("M-z"): K("C-z"),
    # Find
    K("M-f"): K("C-f"),
    # Search
    K("C-g"): K("F3"),
    K("C-Shift-g"): K("Shift-F3"),
    # Save
    K("M-s"): K("C-s"),
    # Close
    K("M-w"): K("C-w"),
}, "Emacs/OSX-like keys")

define_keymap(re.compile("Alacritty"), {
    K("M-c"): K("C-Shift-c"),
    K("M-v"): K("C-Shift-v"),
}, "OSX-like terminal keys")
