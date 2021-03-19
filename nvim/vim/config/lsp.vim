if exists("base16colorspace") && base16colorspace == "256"
    call Base16hi("LspDiagnosticsDefaultError",           base16_gui08, "", base16_cterm08, "", "", "")
    call Base16hi("LspDiagnosticsDefaultWarning",         base16_gui09, "", base16_cterm09, "", "", "")
    call Base16hi("LspDiagnosticsDefaultInformation",     base16_gui05, "", base16_cterm05, "", "", "")
    call Base16hi("LspDiagnosticsDefaultHint",            base16_gui03, "", base16_cterm03, "", "", "")
    call Base16hi("LspDiagnosticsSignError",        base16_gui08, base16_gui01, base16_cterm08, "", "", "")
    call Base16hi("LspDiagnosticsSignWarning",      base16_gui09, base16_gui01, base16_cterm09, "", "", "")
    call Base16hi("LspDiagnosticsSignInformation",  base16_gui05, base16_gui01, base16_cterm05, "", "", "")
    call Base16hi("LspDiagnosticsSignHint",         base16_gui03, base16_gui01, base16_cterm03, "", "", "")
endif
