#!/usr/bin/env bash

# https://qmacro.org/blog/posts/2021/03/26/mass-deletion-of-github-actions-workflow-runs/
# https://github.com/qmacro/dotfiles

# Delete workflow runs - dwr

# Given an "owner/repo" name, such as "qmacro/thinking-aloud",
# retrieve the workflow runs for that repo and present them in a
# list. Selected runs will be deleted. Uses the GitHub API.

# Requires gh (GitHub CLI) and jq (JSON processor)
# First version

# brew install gh jq fzf
# gh auth login
# ./_tools/dwr.sh owner/repo
# (use `Tab` to select run entries)

set -o errexit
set -o pipefail

declare repo=${1:?No owner/repo specified}

jqscript() {

    cat <<EOF
      def symbol:
        sub("skipped"; "SKIP") |
        sub("success"; "GOOD") |
        sub("failure"; "FAIL");

      def tz:
        gsub("[TZ]"; " ");


      .workflow_runs[]
        | [
            (.conclusion | symbol),
            (.created_at | tz),
            .id,
            .event,
            .name
          ]
        | @tsv
EOF

}

selectruns() {

  gh api --paginate "/repos/$repo/actions/runs" \
    | jq -r -f <(jqscript) \
    | fzf --multi

}

deleterun() {

  local run id result
  run=$1
  id="$(cut -f 3 <<< "$run")"
  gh api -X DELETE "/repos/$repo/actions/runs/$id"
  [[ $? = 0 ]] && result="OK!" || result="BAD"
  printf "%s\t%s\n" "$result" "$run"

}

deleteruns() {

  local id
  while read -r run; do
    deleterun "$run"
    sleep 0.25
  done

}

main() {

  selectruns | deleteruns

}

main
