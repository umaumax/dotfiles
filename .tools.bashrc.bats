#!/usr/bin/env bats

load ./scripts/load-bats-assertion
load ~/.cache/bats/bats-assertion/bats-assertion.bash

@test "clear_path function" {
  # NOTE: using run version
  run bash -c 'echo -n "hoge" | ./.tools.bashrc clear_path'
#   [[ "${status}" == 0 ]]
  assert_status 0
#   [[ "${output}" == "hoge" ]]
  assert_lines_equal "hoge" 0
#   assert_equal "hoge" "$result"

  # NOTE: using $() version
  result=$(echo -n "../hoge" | ./.tools.bashrc clear_path)
  assert_equal "hoge" "$result"
  result=$(echo -n "../hoge:10:2" | ./.tools.bashrc clear_path)
  assert_equal "hoge" "$result"
  result=$(echo -n "../hoge/./" | ./.tools.bashrc clear_path)
  assert_equal "hoge/" "$result"
  result=$(echo -n "../hoge/../piyo" | ./.tools.bashrc clear_path)
  assert_equal "piyo" "$result"
  result=$(echo -n "../hoge/../piyo////./.././fuga/fuga" | ./.tools.bashrc clear_path)
  assert_equal "piyo/fuga/fuga" "$result"
}
