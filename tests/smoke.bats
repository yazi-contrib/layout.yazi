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
  echo unique-preview-text >"$WORK/hello.txt"
  printf '[mgr]\nratio = [0, 1, 1]\n' >"$YAZI_CONFIG_HOME/yazi.toml"
}

teardown() { stop_yazi; }

@test "the layout without the header starts" {
  start_yazi
  assert_healthy
}

@test "the toggle of the preview hides the preview and shows it again" {
  start_yazi
  assert_screen "unique-preview-text"
  send_keys u
  send_keys w
  assert_healthy
  refute_screen "unique-preview-text"
  send_keys u
  send_keys w
  assert_screen "unique-preview-text"
}

@test "the toggle of the parent pane shows the parent folder" {
  start_yazi
  refute_screen "work"
  send_keys u
  send_keys p
  assert_healthy
  assert_screen "work"
}

@test "a wrong argument is an error that says what to use" {
  start_yazi
  send_keys u x
  assert_screen "toggle-parent"
}
