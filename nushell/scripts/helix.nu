# fzf の結果を hx で安全に開く共通関数
source consts.nu
def hx-from-fzf [cmd: closure] {
    let result = (do $cmd | lines)
    if ($result | is-empty) { return }
    let dirs = ($result | where { |p| ($p | path type) == dir })
    let files = ($result | where { |p| ($p | path type) == file })
    if ($dirs | length) > 0 { hx ($dirs | first) ...$files } else if ($files | length) > 0 { hx ...$files }
}
# fd + fzf + hx
export def hxfd [name: string = ".",path: path = .] {
    hx-from-fzf {
        fd $name --search-path $path --type f --type d --hidden --exclude .git | fzf --preview $FZF_PREVIEW
    }
}
# zoxide でディレクトリ取得して hx
export def hxz [name: string] {
    let result = (zoxide query $name | lines | first)
    if not ($result | is-empty) { hx $result }
}
# rg --files + fzf + hx
export def hxrg [] {
    hx-from-fzf {
        rg --files --hidden --glob '!.git' | fzf --preview $FZF_PREVIEW
    }
}
