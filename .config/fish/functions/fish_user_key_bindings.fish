function fish_user_key_bindings
  bind --mode insert ctrl-o "prevd >/dev/null; commandline -f repaint"
  bind --mode insert ctrl-i "nextd >/dev/null; commandline -f repaint"
end
