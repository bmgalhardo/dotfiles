fish_add_path $HOME/.local/bin
fish_add_path /usr/local/bin

starship init fish | source

# Per-machine overrides (not tracked)
if test -f ~/.config/fish/local.fish
	source ~/.config/fish/local.fish
end
