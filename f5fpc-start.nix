{
  writeShellApplication,
  f5fpc,
}:

writeShellApplication {
  name = "f5fpc-start";
  runtimeInputs =  [ f5fpc ];
  text = ''
    set +e
    f5fpc --info > /dev/null
    if [ $? -eq 5 ]; then
      echo "Already connected!"
      exit 1
    fi

    get_secret () {
      gpg --decrypt --pinentry-mode loopback --quiet "$1" | head -n1
    }

    pw_store="$HOME/.password-store"
    pass_file="$pw_store/new-volvo.gpg"
    pin_file="$pw_store/pointsharp-pin.gpg"

    # public: user, host    
    user="ejohnso3"
    host="https://iconnect.global.volvocars.biz" 
    pass="$(get_secret "$pass_file")"
    pin="$(get_secret "$pin_file")"
    read -rp "TOTP: " totp
    
    sudo -- f5fpc \
      --start \
      --user "$user" \
      --password "$pin$totp$pass" \
      --host "$host" \
      --nocheck \
    > /dev/null

    echo "Operation in progress..."
    
    while :; do
    	output=$(f5fpc --info)
      last="$?"
      case "$last" in
        "2") 
          echo "Logging in..." 
          ;;
        "3") 
          echo "Logged in. Connecting..." 
          ;;
        "5") 
          echo "Connected!"
          exit 0
          ;;
        "7")
          echo "Login failed!"
          exit 1
          ;;
        *)
          echo "Unknown code $last. 5f5pc says:"
          echo "$output"
          ;;
      esac
      sleep 2
    done
    # drop user in shell if something goes wrong
    # bash
  '';
}
