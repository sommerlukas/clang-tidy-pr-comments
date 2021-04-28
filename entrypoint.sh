#!/bin/bash
set -xeu

pull_request_id=$(cat "$GITHUB_EVENT_PATH" | jq 'if (.issue.number != null) then .issue.number else .number end')

if [ $pull_request_id == "null" ]; then
  echo "Could not find a pull request ID. Is this a pull request?"
  exit 0
fi

recreated_repo_dir=$GITHUB_WORKSPACE/$INPUT_REPOSITORY_ROOT

echo $recreated_repo_dir

echo $INPUT_CLANG_TIDY_FIXES
echo $INPUT_REQUEST_CHANGES
echo $INPUT_SUGGESTIONS_PER_COMMENT
echo $INPUT_REPOSITORY_ROOT
echo $INPUT_GITHUB_TOKEN
echo $PYTHON_SCRIPT_PATH

eval python3 $PYTHON_SCRIPT_PATH/run_action.py \
  --clang-tidy-fixes $INPUT_CLANG_TIDY_FIXES \
  --pull-request-id $pull_request_id \
  --repository-root $recreated_repo_dir
