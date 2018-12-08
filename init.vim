" Disable built-in VIM Plugins
" netrw + vinegar is awesome but has a bug with Obsession: https://github.com/tpope/vim-vinegar/issues/13
let loaded_netrwPlugin = 1

if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent execute "!curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

" Dotfiles for inspiration
" https://github.com/statico/dotfiles/blob/master/.vim/vimrc
" https://github.com/skwp/dotfiles
" https://github.com/junegunn/dotfiles/blob/master/vimrc
"
call plug#begin('~/.config/plugged')
"= Mandatory
Plug 'jooize/vim-colemak'
Plug 'sheerun/vim-polyglot'
Plug 'justinmk/vim-dirvish'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-unimpaired'
Plug 'itchyny/lightline.vim'
Plug 'maximbaz/lightline-ale'
"Plug 'taohex/lightline-buffer'
"Plug 'mhinz/vim-startify'
"Plug 'jeetsukumaran/vim-indentwise'
"Plug 'wellle/targets.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim', {'do': 'cargo install ripgrep'}
Plug 'kassio/neoterm'
Plug 'w0rp/ale'
"Plug 'tpope/vim-fugitive'
"Plug 'idanarye/vim-merginal'
"Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'airblade/vim-gitgutter'
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
Plug 'steelsojka/deoplete-flow'
Plug 'janko-m/vim-test'
Plug 'editorconfig/editorconfig-vim'
Plug 't9md/vim-choosewin'
Plug 'zhaocai/goldenview.vim'
Plug 'tpope/vim-obsession'
Plug 'nathanaelkane/vim-indent-guides'
"Plug 'chrisbra/nrrwrgn'
Plug 'jeffkreeftmeijer/vim-numbertoggle'
Plug 'niftylettuce/vim-jinja'
Plug 'jiangmiao/auto-pairs'
Plug '907th/vim-auto-save'
Plug 'c9s/vikube.vim'
Plug 'justinmk/vim-sneak'
Plug 'gcmt/taboo.vim'
"Plug 'airblade/vim-rooter'
Plug 'samuelsimoes/vim-drawer'
Plug 'tpope/vim-dispatch'
Plug 'Keidrych/tap-vim', {'branch': 'compiler'}

" On-Demand ~ FileTypes

" On-Demand ~ Functionality

" Theme
Plug 'NLKNguyen/papercolor-theme'
"Plug 'morhetz/gruvbox'
call plug#end()

" For any plugins that use this, make their keymappings use comma
let mapleader = " "
let g:mapleader = " "
let maplocalleader = ","

" Window Settings
let g:choosewin_overlay_enable = 1
let g:goldenview__enable_at_startup = 1
set splitbelow
set splitright
set number
set relativenumber

" Theme Settings / Visual
"set t_Co=256
"set t_ut=
set mouse=a
set background=dark
"let g:gruvbox_italic=1
set termguicolors
colorscheme PaperColor
syntax enable
set laststatus=2
set noshowmode
let g:lightline = {'colorscheme': 'PaperColor'}
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_guide_size = 1
let g:indent_guides_color_change_percent = 3
let g:indent_guides_enable_on_vim_startup = 1

" Autocomplete
let g:deoplete#enable_at_startup = 1
function! StrTrim(txt)
  return substitute(a:txt, '^\n*\s*\(.\{-}\)\n*\s*$', '\1', '')
endfunction
let g:flow_path = StrTrim(system('PATH=$(npm bin):$PATH && which flow'))
if g:flow_path != 'flow not found'
  let g:deoplete#sources#flow#flow_bin = g:flow_path
endif

" Lightline / Ale / EditorConfig
let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']
set hidden
set showtabline=2  " always show tabline

set sessionoptions+=tabpages,globals
" use lightline-buffer in lightline
let g:lightline = {
  \ 'active': {
  \   'left': [ [ 'mode', 'paste'],
  \             [ 'readonly', 'filename', 'modified'],
  \             [ 'separator'  ]],
  \   'right': [[ 'linter_errors', 'linter_warnings', 'linter_ok' ]]
  \ },
  \ 'component_expand': {
  \   'linter_warnings': 'lightline#ale#warnings',
  \   'linter_errors': 'lightline#ale#errors',
  \   'linter_ok': 'lightline#ale#ok',
  \ },
  \ 'component_type': {
  \   'linter_warnings': 'warning',
  \   'linter_errors': 'error',
  \   'linter_ok': 'left',
  \ },
  \ 'component_function': {
  \ }
  \}

" Ale Info
let g:ale_fixers = {
  \ 'javascript': [ 'prettier' ],
  \ 'json': [ 'prettier' ],
  \ 'vue': ['prettier']
  \}
let g:ale_linters = {
  \ 'javascript': [ 'xo' ]
\}
let g:ale_linters_explicit = 1

" FZF (replaces Ctrl-P, FuzzyFinder and Command-T)
let $FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --hidden --follow'
command! -bang -nargs=* Rg
\ call fzf#vim#grep(
\   'rg --vimgrep --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore-vcs --hidden --follow --color=always '.shellescape(<q-args>), 1,
\   <bang>0 ? fzf#vim#with_preview('up:60%')
\           : fzf#vim#with_preview('right:50%:hidden', '?'),
\   <bang>0)
set rtp+=/usr/local/opt/fzf
set rtp+=~/.fzf
"nmap ; :Buffers<CR>
"nmap <Leader>r :Tags<CR>
"nmap <Leader>t :Files<CR>
"nmap <Leader>a :Ag<CR>

" GitGutter styling to use · instead of +/-
let g:gitgutter_sign_added = '∙'
let g:gitgutter_sign_modified = '∙'
let g:gitgutter_sign_removed = '∙'
let g:gitgutter_sign_modified_removed = '∙'

" Test Information
let test#strategy = "dispatch"
let g:neoterm_position = "vertical"
let g:neoterm_autoscroll = 1
let g:neoterm_autoinsert = 0
let g:neoterm_automap_keys = 0
let g:neoterm_direct_open_repl = 0
let test#javascript#tap#file_pattern = ".*test.js$"
let g:test#javascript#tap#runners = ['tap']
function! test#javascript#tap#executable() abort
	return 'node'
endfunction

" TODO get test-suite working with regex file pattern

" Autosave & AutoFix / Lint
let g:auto_save = 1
let g:auto_save_no_uptime = 1
let g:auto_save_in_insert_mode = 0
let g:auto_save_silent = 1
let g:ale_fix_on_save = 1
let g:ale_lint_on_save = 1
let g:ale_lint_on_enter = 0
let g:ale_lint_on_filetype_changed = 0
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0

" Sneak settings
let g:sneak#label = 1
let g:sneak#s_next = 1

" Force Colemak KeyBindings
silent! source "$HOME/.vim/bundle/vim-colemak/plugin/colemak.vim"

" KeyBindings
nmap ` <Plug>(choosewin)

" 2-character Sneak (default)
noremap o <Nop>
noremap O <Nop>
map o <Plug>Sneak_s
map O <Plug>Sneak_S

" repeat motion
noremap ; <Nop>
noremap y <Nop>
map y <Plug>Sneak_;
map ; <Plug>Sneak_,

" Terminal
tnoremap <Esc> <C-\><C-n>

" Quit
nmap q :q<cr>
nmap Q :qa<cr>

" Vim-Drawer
nnoremap <space>d :VimDrawer<CR>

" Test Commands
nnoremap <space>tf :TestFile<CR>
nnoremap <space>ts :TestSuite<CR>
nnoremap <space>tn :TestNearest<CR>

" AutoCommands
"augroup test
"  autocmd!
"  autocmd InsertLeave * if test#exists() |
"    \  TestNearest
"    \ endif
"augroup END

augroup VCenterCursor
	au!
	au BufEnter,WinEnter,WinNew,VimResized *,*.*
    \ let &scrolloff=winheight(win_getid())/2
augroup END

