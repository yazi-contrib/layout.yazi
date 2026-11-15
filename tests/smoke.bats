load test_helper

setup() {
  setup_yazi layout
  echo 'require("layout"):setup()' >"$YAZI_CONFIG_HOME/init.lua"
  cat >"$YAZI_CONFIG_HOME/keymap.toml" <<'EOF'
[mgr]
prepend_keymap = [
  { on = ["u", "p"], run = "plugin layout toggle-parent", desc = "Toggle parent" },
  { on = ["u", "w"], run = "plugin layout toggle-preview", desc = "Toggle preview" },
  { on = ["u", "x"], run = "plugin layout oops", desc = "A wrong argument" },
]
EOF
  echo hello >"$WORK/hello.txt"
}

teardown() { stop_yazi; }

@test "the layout without the header starts" {
  start_yazi
  assert_healthy
}

@test "the toggles of the panes do not break Yazi" {
  start_yazi
  send_keys u p
  send_keys u w
  send_keys u w
  assert_healthy
}

@test "a wrong argument is an error that says what to use" {
  start_yazi
  send_keys u x
  screen | grep -q "toggle-parent"
}
