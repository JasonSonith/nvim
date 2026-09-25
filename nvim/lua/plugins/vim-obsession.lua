return {
  "tpope/vim-obsession",
  -- Must load eagerly: a restored Session.vim (tmux-resurrect) sets g:this_obsession,
  -- and without the plugin's autocmds tracking silently stops.
  lazy = false,
}
