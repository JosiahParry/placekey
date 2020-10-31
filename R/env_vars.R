# Environment variables
RESOLUTION = 10
BASE_RESOLUTION = 12
ALPHABET = tolower('23456789BCDFGHJKMNPQRSTVWXYZ')
ALPHABET_LENGTH = nchar(ALPHABET)
CODE_LENGTH = 9
TUPLE_LENGTH = 3
PADDING_CHAR = 'a'
REPLACEMENT_CHARS = "eu"
REPLACEMENT_MAP = c(
  "prn" = "pre",
  "f4nny" = "f4nne",
  "tw4t" = "tw4e",
  "ngr" = "ngu",  # 'u' avoids introducing 'gey'
  "dck" = "dce",
  "vjn" = "vju",  # 'u' avoids introducing 'jew'
  "fck" = "fce",
  "pns" = "pne",
  "sht" = "she",
  "kkk" = "kke",
  "fgt" = "fgu", # 'u' avoids introducing 'gey'
  "dyk" = "dye",
  "bch" = "bce"
)

# HEADER_BITS = bin(h3_int.geo_to_h3(0.0, 0.0, resolution=RESOLUTION))[2:].zfill(64)[:12]
# gets h3 int from coord 00 w resolution RESOLUTION
# converts to binary
# Will work on this when i need it
#origin <- h3r::getCIndexFromCoords(0, 0, res = RESOLUTION)

BASE_CELL_SHIFT = 2 ^ (3 * 15)    # Adding this will increment the base cell value by 1
UNUSED_RESOLUTION_FILLER = 2 ^ (3 * (15 - BASE_RESOLUTION)) - 1
FIRST_TUPLE_REGEX = paste0('[', ALPHABET, REPLACEMENT_CHARS, PADDING_CHAR , ']{3}')
TUPLE_REGEX = paste0('[', ALPHABET, REPLACEMENT_CHARS, ']{3}')
# WHERE_REGEX = re.compile(
#   '^' + '-'.join([FIRST_TUPLE_REGEX, TUPLE_REGEX, TUPLE_REGEX]) + '$')
# WHAT_REGEX = re.compile('^[' + ALPHABET + ']{3}(-[' + ALPHABET + ']{3})?$')

# Taking the calculated value from python.
HEADER_INT <- 621496748577128448
