# env.nu
# Environment variables and prompt setup for Nushell
# Loaded before config.nu; keep external-program settings here.

# External programs:
$env.PATH = ($env.PATH | split row (char esep) | append '/home/roe/.opencode/bin')
# Prompt (starship) setup needed at shell start
export-env {
    $env.STARSHIP_SHELL = "nu";
    load-env {
        STARSHIP_SESSION_KEY: (random chars -l 16)
        PROMPT_MULTILINE_INDICATOR: (^/home/roe/.cargo/bin/starship prompt --continuation)

        # Disable default nushell character prompt; starship provides its own
        PROMPT_INDICATOR: ""

        PROMPT_COMMAND: {|| (
            let cmd_duration = if $env.CMD_DURATION_MS == "0823" { 0 } else { $env.CMD_DURATION_MS };
            ^/home/roe/.cargo/bin/starship prompt
                --cmd-duration $cmd_duration
                $"--status=($env.LAST_EXIT_CODE)"
                --terminal-width (term size).columns
                ...(
                    if (which "job list" | where type == built-in | is-not-empty) {
                        ["--jobs", (job list | length)]
                    } else { [] }
                )
        ) }

        PROMPT_COMMAND_RIGHT: {|| (
            let cmd_duration = if $env.CMD_DURATION_MS == "0823" { 0 } else { $env.CMD_DURATION_MS };
            ^/home/roe/.cargo/bin/starship prompt
                --right
                --cmd-duration $cmd_duration
                $"--status=($env.LAST_EXIT_CODE)"
                --terminal-width (term size).columns
                ...(
                    if (which "job list" | where type == built-in | is-not-empty) {
                        ["--jobs", (job list | length)]
                    } else { [] }
                )
        ) }
    }
}
# External completions via carapace (Nushell-only behavior)
## ${UserConfigDir}/nushell/env.nu
$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense' # optional
mkdir $"($nu.cache-dir)"
carapace _carapace nushell | save --force $"($nu.cache-dir)/carapace.nu"
zoxide init nushell | save -f ~/.zoxide.nu
$env.TERM = "xterm-kitty"
$env.DISPLAY = ""
$env.XDG_SESSION_TYPE = "" 
