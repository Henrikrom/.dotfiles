function f() {
  local file root

  # Pick a file/dir using fd+fzf
  file=$(fzf) || return 1

  # If it's a directory, just cd
  if [ -d "$file" ]; then
    cd "$file" || return 1
    return
  fi

  # If inside a git repo → cd to repo root
  if root=$(git -C "$(dirname "$file")" rev-parse --show-toplevel 2>/dev/null); then
    cd "$root" || return 1
  else
    # Otherwise cd to the file’s directory
    cd "$(dirname "$file")" || return 1
  fi

  # Finally open the file
  nvim "$file"
}


rf() {
  local regex=""
  for term in "$@"; do
    regex="${regex}(?=.*${term})"
  done

  rg --smart-case -P --line-number --no-heading --color=never "$regex" "." \
      | fzf --ansi \
          --delimiter : \
          --nth 1,2 \
          --preview 'bat --style=numbers --color=always {1} --highlight-line {2}' \
          --preview-window=right:60% \
    | awk -F: '{print "+"$2, $1}' \
    | xargs -r nvim
    # | awk -F: '{print "+"$2, $1}' \
    # | xargs -r nvim
}

function dtest() {
    dotnet test --no-restore --filter "$1"
}

# Create a worktree in ~/.worktrees/<repo>/<branch>
wt() {
  local branch="$1"
  local repo
  local base
  local dir

  repo="$(basename "$(git rev-parse --show-toplevel)")" || return

  git fetch origin || return

  base="$(git symbolic-ref --short refs/remotes/origin/HEAD)" || return
  dir="/tmp/worktrees/$repo/$branch"

  mkdir -p "$(dirname "$dir")"
  git worktree add "$dir" -b "$branch" "$base" && cd "$dir"
}

# List worktrees
wtls() {
  git worktree list
}

# Remove a worktree
wtrm() {
  git worktree remove "$1"
}
