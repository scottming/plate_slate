ELIXIR_ERL_OPTIONS="-smp enable" CONNECTION_FILE=$1 iex --sname ielixir_node --cookie ielixir_token -S mix run --no-halt
