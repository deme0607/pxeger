class Pxeger
  private

  UPPERS = ('A'..'Z').to_a
  LOWERS = ('a'..'z').to_a
  DIGITS = ('0'..'9').to_a
  SPACES = [" ", "\n", "\t"]
  OTHERS = [
    '!', '"', '#', '$',  '%', '&', '\'', '(', ')', '*',
    '+', ',', '-', '.',  '/', ':', ';',  '<', '=', '>',
    '?', '@', '[', '\\', ']', '^', '`',  '{', '|', '}', '~',
  ]
  ALL    = UPPERS + LOWERS +  DIGITS + [" "] +  OTHERS + ["_"]

  CLASSES = {
    'd' => DIGITS,
    'D' => UPPERS + LOWERS + SPACES + OTHERS + ['_'],
    'w' => UPPERS + LOWERS + DIGITS + ['_'],
    'W' => SPACES + OTHERS,
    't' => [ '\t' ],
    'n' => [ '\n' ],
    'v' => [ '\u000B' ],
    'f' => [ '\u000C' ],
    'r' => [ '\r' ],
    's' => SPACES,
    'S' => UPPERS + LOWERS + DIGITS + OTHERS + ['_'],
    '0' => [ '\0' ]
  }
end
