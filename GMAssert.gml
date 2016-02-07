#define __GMA_BREAKPOINT__
{
  //Place a breakpoint here to inspect the state just before an assertion
  var GMA_BREAKPOINT_HERE = true;
}

#define __gma_assert_error__
///__gma_assert_error__(message, expected, got)
{
  switch (GMASSERT_MODE) {
    case GMASSERT_MODE_SELFTEST:
      global.__gma_assert_triggered__ = true;
    break;
    case GMASSERT_MODE_ENABLED:
      __GMA_BREAKPOINT__();
      var msg = argument0 + chr(13)+chr(10) + chr(13)+chr(10) + "Expected: " + __gma_debug_value__(argument1) + chr(13)+chr(10) + chr(13)+chr(10) + "Got: " + __gma_debug_value__(argument2) + chr(13)+chr(10) + chr(13)+chr(10);
      if (os_browser == browser_not_a_browser) {
        show_error(msg, true);
      }
      else {
        show_message(msg);
      }
    break;
  }
}

#define __gma_assert_error_simple__
///__gma_assert_error__(message)
{
  switch (GMASSERT_MODE) {
    case GMASSERT_MODE_SELFTEST:
      global.__gma_assert_triggered__ = true;
    break;
    case GMASSERT_MODE_ENABLED:
      __GMA_BREAKPOINT__();
      var msg = argument0 + chr(13) + chr(13);
      if (os_browser == browser_not_a_browser) {
        show_error(msg, true);
      }
      else {
        show_message(msg);
      }
    break;
  }
}

#define __gma_assert_error_raw__
///__gma_assert_error_raw__(message, expected, got)
{
  switch (GMASSERT_MODE) {
    case GMASSERT_MODE_SELFTEST:
      global.__gma_assert_triggered__ = true;
    break;
    case GMASSERT_MODE_ENABLED:
      __GMA_BREAKPOINT__();
      var msg = argument0 + chr(13) + chr(13) + "Expected: " + argument1 + chr(13) + chr(13) + "Got: " + argument2 + chr(13) + chr(13);
      if (os_browser == browser_not_a_browser) {
        show_error(msg, true);
      }
      else {
        show_message(msg);
      }
    break;
  }
}

#define __gma_debug_type__
{
  if (is_undefined(argument0)) {
    return GMASSERT_TYPE_UNDEFINED;
  }
  else if (is_real(argument0)) {
    return GMASSERT_TYPE_REAL;
  }
  else if (is_string(argument0)) {
    return GMASSERT_TYPE_STRING;
  }
  else if (is_array(argument0)) {
    return GMASSERT_TYPE_ARRAY;
  }
  else {
    return GMASSERT_TYPE_UNKNOWN;
  }
}

#define __gma_debug_value__
{
  //Undefined
  if (is_undefined(argument0)) {
    return "undefined";
  }
  
  //String
  else if (is_string(argument0)) {
    return '"' + string_replace_all(argument0, '"', '""') + '"';
  }
  
  //Real
  else if (is_real(argument0)) {
    //Return integers as-is
    if (frac(argument0) == 0) {
      return string(argument0);
    }
    //Get mantissa and exponent
    var mantissa, exponent;
    exponent = floor(log10(abs(argument0)));
    mantissa = string_replace_all(string_format(argument0/power(10,exponent), 15, 14), " ", "");
    //Trim trailing zeros off mantissa
    var i, ca;
    i = string_length(mantissa);
    do {
      ca = string_char_at(mantissa, i);
      i -= 1;
    } until (ca != "0")
    if (ca != ".") {
      mantissa = string_copy(mantissa, 1, i+1);
    }
    else {
      mantissa = string_copy(mantissa, 1, i);
    }
    //Add exponent except if it is zero
    if (exponent != 0) {
      return mantissa + "e" + string(exponent);
    }
    else {
      return mantissa;
    }
  }
  
  //Array
  else if (is_array(argument0)) {
    var size;
    var result = "",
        height = array_height_2d(argument0);
    //1D
    if (height == 1 || array_length_2d(argument0, 0) == 0) {
      size = array_length_1d(argument0)
      for (var i = 0; i < size; i++) {
        result += __gma_debug_value__(argument0[@ i]);
        if (i < size-1) {
          result += ", ";
        }
      }
    }
    //2D
    else {
      for (var i = 0; i < height; i++) {
        size = array_length_2d(argument0, i);
        for (var j = 0; j < size; j++) {
          result += __gma_debug_value__(argument0[@ i, j]);
          if (j < size-1) {
            result += ", ";
          }
        }
        if (i < height-1) {
          result += "; ";
        }
      }
    }
    return "(" + result + ")";
  }
  else {
    return "???";
  }
}

#define __gma_equal__
{
  var type = __gma_debug_type__(argument0);
  if (type == __gma_debug_type__(argument1)) {
    switch (type) {
      case GMASSERT_TYPE_ARRAY:
        var a1d = array_length_2d(argument0, 0) == 0,
            b1d = array_length_2d(argument1, 0) == 0;
        if (a1d != b1d) return false;
        if (a1d) {
          var size = array_length_1d(argument0);
          if (size != array_length_1d(argument1)) return false;
          for (var i = 0; i < size; i++) {
            if (!__gma_equal__(argument0[@ i], argument1[@ i])) return false;
          }
        }
        else {
          var size_i = array_height_2d(argument0);
          if (size_i != array_height_2d(argument1)) return false;
          var size_j;
          for (var i = 0; i < size_i; i++) {
            size_j = array_length_2d(argument0, i);
            if (size_j != array_length_2d(argument1, i)) return false;
            for (var j = 0; j < size_j; j++) {
              if (!__gma_equal__(argument0[@ i, j], argument1[@ i, j])) return false;
            }
          }
        }
        return true;
      break;
      default:
        return argument0 == argument1;
      break;
    }
  }
  else {
    return false;
  }
}

#define __gma_equalish__
{
  var type = __gma_debug_type__(argument0);
  if (type == __gma_debug_type__(argument1)) {
    switch (type) {
      case GMASSERT_TYPE_ARRAY:
        var a1d = array_length_2d(argument0, 0) == 0,
            b1d = array_length_2d(argument1, 0) == 0;
        if (a1d != b1d) return false;
        if (a1d) {
          var size = array_length_1d(argument0);
          if (size != array_length_1d(argument1)) return false;
          for (var i = 0; i < size; i++) {
            if (!__gma_equalish__(argument0[@ i], argument1[@ i])) return false;
          }
        }
        else {
          var size_i = array_height_2d(argument0);
          if (size_i != array_height_2d(argument1)) return false;
          var size_j;
          for (var i = 0; i < size_i; i++) {
            size_j = array_length_2d(argument0, i);
            if (size_j != array_length_2d(argument1, i)) return false;
            for (var j = 0; j < size_j; j++) {
              if (!__gma_equalish__(argument0[@ i, j], argument1[@ i, j])) return false;
            }
          }
        }
        return true;
      break;
      case GMASSERT_TYPE_REAL:
        return argument0 == argument1 || abs(argument0-argument1) <= GMASSERT_TOLERANCE;
      break;
      default:
        return argument0 == argument1;
      break;
    }
  }
  else {
    return false;
  }
}

#define __gma_greater_than__
{
  var type = __gma_debug_type__(argument0);
  if (type == __gma_debug_type__(argument1)) {
    switch (type) {
      case GMASSERT_TYPE_REAL:
        return argument0 > argument1;
      break;
      case GMASSERT_TYPE_STRING:
        if (argument0 == argument1) return false;
        var len0 = string_length(argument0),
            len1 = string_length(argument1),
            len = min(len0, len1);
        var c0, c1;
        for (var i = 1; i <= len; i++) {
          c0 = ord(string_char_at(argument0, i));
          c1 = ord(string_char_at(argument1, i));
          if (c0 != c1) {
            return c0 > c1;
          }
        }
        return len0 > len1;
      break;
      case GMASSERT_TYPE_ARRAY:
        var a1d = array_length_2d(argument0, 0) == 0,
            b1d = array_length_2d(argument1, 0) == 0;
        if (a1d != b1d) return false;
        if (a1d) {
          var size = array_length_1d(argument0);
          if (size != array_length_1d(argument1)) return false;
          for (var i = 0; i < size; i++) {
            if (!__gma_greater_than__(argument0[@ i], argument1[@ i])) return false;
          }
        }
        else {
          var size_i = array_height_2d(argument0);
          if (size_i != array_height_2d(argument1)) return false;
          var size_j;
          for (var i = 0; i < size_i; i++) {
            size_j = array_length_2d(argument0, i);
            if (size_j != array_length_2d(argument1, i)) return false;
            for (var j = 0; j < size_j; j++) {
              if (!__gma_greater_than__(argument0[@ i, j], argument1[@ i, j])) return false;
            }
          }
        }
        return true;
      break;
      default:
        return false;
      break;
    }
  }
  else {
    return false;
  }
}

#define __gma_less_than__
{
  var type = __gma_debug_type__(argument0);
  if (type == __gma_debug_type__(argument1)) {
    switch (type) {
      case GMASSERT_TYPE_REAL:
        return argument0 < argument1;
      break;
      case GMASSERT_TYPE_STRING:
        if (argument0 == argument1) return false;
        var len0 = string_length(argument0),
            len1 = string_length(argument1),
            len = min(len0, len1);
        var c0, c1;
        for (var i = 1; i <= len; i++) {
          c0 = ord(string_char_at(argument0, i));
          c1 = ord(string_char_at(argument1, i));
          if (c0 != c1) {
            return c0 < c1;
          }
        }
        return len0 < len1;
      break;
      case GMASSERT_TYPE_ARRAY:
        var a1d = array_length_2d(argument0, 0) == 0,
            b1d = array_length_2d(argument1, 0) == 0;
        if (a1d != b1d) return false;
        if (a1d) {
          var size = array_length_1d(argument0);
          if (size != array_length_1d(argument1)) return false;
          for (var i = 0; i < size; i++) {
            if (!__gma_less_than__(argument0[@ i], argument1[@ i])) return false;
          }
        }
        else {
          var size_i = array_height_2d(argument0);
          if (size_i != array_height_2d(argument1)) return false;
          var size_j;
          for (var i = 0; i < size_i; i++) {
            size_j = array_length_2d(argument0, i);
            if (size_j != array_length_2d(argument1, i)) return false;
            for (var j = 0; j < size_j; j++) {
              if (!__gma_less_than__(argument0[@ i, j], argument1[@ i, j])) return false;
            }
          }
        }
        return true;
      break;
      default:
        return false;
      break;
    }
  }
  else {
    return false;
  }
}

#define __gma_greater_than_or_equal__
{
  var type = __gma_debug_type__(argument0);
  if (type == __gma_debug_type__(argument1)) {
    switch (type) {
      case GMASSERT_TYPE_REAL:
        return argument0 >= argument1;
      break;
      case GMASSERT_TYPE_STRING:
        if (argument0 == argument1) return true;
        var len0 = string_length(argument0),
            len1 = string_length(argument1),
            len = min(len0, len1);
        var c0, c1;
        for (var i = 1; i <= len; i++) {
          c0 = ord(string_char_at(argument0, i));
          c1 = ord(string_char_at(argument1, i));
          if (c0 != c1) {
            return c0 > c1;
          }
        }
        return len0 > len1;
      break;
      case GMASSERT_TYPE_ARRAY:
        var a1d = array_length_2d(argument0, 0) == 0,
            b1d = array_length_2d(argument1, 0) == 0;
        if (a1d != b1d) return false;
        if (a1d) {
          var size = array_length_1d(argument0);
          if (size != array_length_1d(argument1)) return false;
          for (var i = 0; i < size; i++) {
            if (!__gma_greater_than_or_equal__(argument0[@ i], argument1[@ i])) return false;
          }
        }
        else {
          var size_i = array_height_2d(argument0);
          if (size_i != array_height_2d(argument1)) return false;
          var size_j;
          for (var i = 0; i < size_i; i++) {
            size_j = array_length_2d(argument0, i);
            if (size_j != array_length_2d(argument1, i)) return false;
            for (var j = 0; j < size_j; j++) {
              if (!__gma_greater_than_or_equal__(argument0[@ i, j], argument1[@ i, j])) return false;
            }
          }
        }
        return true;
      break;
      default:
        return false;
      break;
    }
  }
  else {
    return false;
  }
}

#define __gma_less_than_or_equal__
{
  var type = __gma_debug_type__(argument0);
  if (type == __gma_debug_type__(argument1)) {
    switch (type) {
      case GMASSERT_TYPE_REAL:
        return argument0 <= argument1;
      break;
      case GMASSERT_TYPE_STRING:
        if (argument0 == argument1) return true;
        var len0 = string_length(argument0),
            len1 = string_length(argument1),
            len = min(len0, len1);
        var c0, c1;
        for (var i = 1; i <= len; i++) {
          c0 = ord(string_char_at(argument0, i));
          c1 = ord(string_char_at(argument1, i));
          if (c0 != c1) {
            return c0 < c1;
          }
        }
        return len0 < len1;
      break;
      case GMASSERT_TYPE_ARRAY:
        var a1d = array_length_2d(argument0, 0) == 0,
            b1d = array_length_2d(argument1, 0) == 0;
        if (a1d != b1d) return false;
        if (a1d) {
          var size = array_length_1d(argument0);
          if (size != array_length_1d(argument1)) return false;
          for (var i = 0; i < size; i++) {
            if (!__gma_less_than_or_equal__(argument0[@ i], argument1[@ i])) return false;
          }
        }
        else {
          var size_i = array_height_2d(argument0);
          if (size_i != array_height_2d(argument1)) return false;
          var size_j;
          for (var i = 0; i < size_i; i++) {
            size_j = array_length_2d(argument0, i);
            if (size_j != array_length_2d(argument1, i)) return false;
            for (var j = 0; j < size_j; j++) {
              if (!__gma_less_than_or_equal__(argument0[@ i, j], argument1[@ i, j])) return false;
            }
          }
        }
        return true;
      break;
      default:
        return false;
      break;
    }
  }
  else {
    return false;
  }
}

#define assert
///assert(got, [msg])
{
  if (!GMASSERT_MODE) exit;

  //Capture message argument
  var msg;
  switch (argument_count) {
    case 1:
      msg = "Assertion failed!";
    break;
    case 2:
      msg = argument[1];
    break;
    default:
      show_error("Expected 1 or 2 arguments, got " + string(argument_count) + ".", true);
    break;
  }
  
  //Check assertion
  if (!argument[0]) {
    __gma_assert_error_simple__(msg);
  }
}

#define assert_fail
///assert_fail(got, [msg])
{
  if (!GMASSERT_MODE) exit;

  //Capture message argument
  var msg;
  switch (argument_count) {
    case 1:
      msg = "Assertion didn't fail!";
    break;
    case 2:
      msg = argument[1];
    break;
    default:
      show_error("Expected 1 or 2 arguments, got " + string(argument_count) + ".", true);
    break;
  }
  
  //Check assertion
  if (argument[0]) {
    __gma_assert_error_simple__(msg);
  }
}

#define assert_equal
///assert_equal(got, expected, [msg])
{
  if (!GMASSERT_MODE) exit;
  
  //Capture message argument
  var msg;
  switch (argument_count) {
    case 2:
      msg = "Equal assertion failed!";
    break;
    case 3:
      msg = argument[2];
    break;
    default:
      show_error("Expected 2 or 3 arguments, got " + string(argument_count) + ".", true);
    break;
  }
  
  //Check assertion
  if (!__gma_equal__(argument[0], argument[1])) {
    __gma_assert_error__(msg, argument[1], argument[0]);
  }
}

#define assert_equalish
///assert_equalish(got, expected, [msg])
{
  if (!GMASSERT_MODE) exit;
  
  //Capture message argument
  var msg;
  switch (argument_count) {
    case 2:
      msg = "Equalish assertion failed!";
    break;
    case 3:
      msg = argument[2];
    break;
    default:
      show_error("Expected 2 or 3 arguments, got " + string(argument_count) + ".", true);
    break;
  }
  
  //Check assertion
  if (!__gma_equalish__(argument[0], argument[1])) {
    __gma_assert_error__(msg, argument[1], argument[0]);
  }
}

#define assert_is
///assert_is(got, expected, [msg])
{
  if (!GMASSERT_MODE) exit;
  
  //Capture message argument
  var msg;
  switch (argument_count) {
    case 2:
      msg = "Equal assertion failed!";
    break;
    case 3:
      msg = argument[2];
    break;
    default:
      show_error("Expected 2 or 3 arguments, got " + string(argument_count) + ".", true);
    break;
  }
  
  //Check assertion
  if (__gma_debug_type__(argument[0]) != __gma_debug_type__(argument[1]) || argument[0] != argument[1]) {
    __gma_assert_error__(msg, argument[1], argument[0]);
  }
}

#define assert_not_equal
///assert_not_equal(got, expected, [msg])
{
  if (!GMASSERT_MODE) exit;
  
  //Capture message argument
  var msg;
  switch (argument_count) {
    case 2:
      msg = "Not equal assertion failed!";
    break;
    case 3:
      msg = argument[2];
    break;
    default:
      show_error("Expected 2 or 3 arguments, got " + string(argument_count) + ".", true);
    break;
  }
  
  //Check assertion
  if (__gma_equal__(argument[0], argument[1])) {
    __gma_assert_error__(msg, argument[1], argument[0]);
  }
}

#define assert_not_equalish
///assert_not_equalish(got, expected, [msg])
{
  if (!GMASSERT_MODE) exit;
  
  //Capture message argument
  var msg;
  switch (argument_count) {
    case 2:
      msg = "Not equalish assertion failed!";
    break;
    case 3:
      msg = argument[2];
    break;
    default:
      show_error("Expected 2 or 3 arguments, got " + string(argument_count) + ".", true);
    break;
  }
  
  //Check assertion
  if (__gma_equalish__(argument[0], argument[1])) {
    __gma_assert_error__(msg, argument[1], argument[0]);
  }
}

#define assert_isnt
///assert_isnt(got, expected, [msg])
{
  if (!GMASSERT_MODE) exit;
  
  //Capture message argument
  var msg;
  switch (argument_count) {
    case 2:
      msg = "Not equal assertion failed!";
    break;
    case 3:
      msg = argument[2];
    break;
    default:
      show_error("Expected 2 or 3 arguments, got " + string(argument_count) + ".", true);
    break;
  }
  
  //Check assertion
  if (__gma_debug_type__(argument[0]) == __gma_debug_type__(argument[1]) && argument[0] == argument[1]) {
    __gma_assert_error__(msg, argument[1], argument[0]);
  }
}

#define assert_greater_than
///assert_greater_than(got, expected, [msg])
{
  if (!GMASSERT_MODE) exit;
  
  //Capture message argument
  var msg;
  switch (argument_count) {
    case 2:
      msg = "Greater than assertion failed!";
    break;
    case 3:
      msg = argument[2];
    break;
    default:
      show_error("Expected 2 or 3 arguments, got " + string(argument_count) + ".", true);
    break;
  }
  
  //Check assertion
  if (!__gma_greater_than__(argument[0], argument[1])) {
    switch (__gma_debug_type__(argument[1])) {
      case GMASSERT_TYPE_REAL:
        __gma_assert_error_raw__(msg, "A real value greater than " + __gma_debug_value__(argument[1]), __gma_debug_value__(argument[0]));
      break;
      case GMASSERT_TYPE_STRING:
        __gma_assert_error_raw__(msg, "A string that comes after " + __gma_debug_value__(argument[1]), __gma_debug_value__(argument[0]));
      break;
      case GMASSERT_TYPE_ARRAY:
        __gma_assert_error_raw__(msg, "An array with pairwise values all greater than " + __gma_debug_value__(argument[1]), __gma_debug_value__(argument[0]));
      break;
      default:
        __gma_assert_error__(msg + " (unsupported type)", argument[1], argument[0]);
      break;
    }
  }
}

#define assert_less_than
///assert_less_than(got, expected, [msg])
{
  if (!GMASSERT_MODE) exit;
  
  //Capture message argument
  var msg;
  switch (argument_count) {
    case 2:
      msg = "Less than assertion failed!";
    break;
    case 3:
      msg = argument[2];
    break;
    default:
      show_error("Expected 2 or 3 arguments, got " + string(argument_count) + ".", true);
    break;
  }
  
  //Check assertion
  if (!__gma_less_than__(argument[0], argument[1])) {
    switch (__gma_debug_type__(argument[1])) {
      case GMASSERT_TYPE_REAL:
        __gma_assert_error_raw__(msg, "A real value less than " + __gma_debug_value__(argument[1]), __gma_debug_value__(argument[0]));
      break;
      case GMASSERT_TYPE_STRING:
        __gma_assert_error_raw__(msg, "A string that comes before " + __gma_debug_value__(argument[1]), __gma_debug_value__(argument[0]));
      break;
      case GMASSERT_TYPE_ARRAY:
        __gma_assert_error_raw__(msg, "An array with pairwise values all less than " + __gma_debug_value__(argument[1]), __gma_debug_value__(argument[0]));
      break;
      default:
        __gma_assert_error__(msg + " (unsupported type)", argument[1], argument[0]);
      break;
    }
  }
}

#define assert_greater_than_or_equal
///assert_greater_than_or_equal(got, expected, [msg])
{
  if (!GMASSERT_MODE) exit;
  
  //Capture message argument
  var msg;
  switch (argument_count) {
    case 2:
      msg = "Greater than or equal assertion failed!";
    break;
    case 3:
      msg = argument[2];
    break;
    default:
      show_error("Expected 2 or 3 arguments, got " + string(argument_count) + ".", true);
    break;
  }
  
  //Check assertion
  if (!__gma_greater_than_or_equal__(argument[0], argument[1])) {
    switch (__gma_debug_type__(argument[1])) {
      case GMASSERT_TYPE_REAL:
        __gma_assert_error_raw__(msg, "A real value greater than or equal to " + __gma_debug_value__(argument[1]), __gma_debug_value__(argument[0]));
      break;
      case GMASSERT_TYPE_STRING:
        __gma_assert_error_raw__(msg, "A string that comes after or is " + __gma_debug_value__(argument[1]), __gma_debug_value__(argument[0]));
      break;
      case GMASSERT_TYPE_ARRAY:
        __gma_assert_error_raw__(msg, "An array with pairwise values all greater than or equal to " + __gma_debug_value__(argument[1]), __gma_debug_value__(argument[0]));
      break;
      default:
        __gma_assert_error__(msg + " (unsupported type)", argument[1], argument[0]);
      break;
    }
  }
}

#define assert_less_than_or_equal
///assert_less_than_or_equal(got, expected, [msg])
{
  if (!GMASSERT_MODE) exit;
  
  //Capture message argument
  var msg;
  switch (argument_count) {
    case 2:
      msg = "Less than or equal assertion failed!";
    break;
    case 3:
      msg = argument[2];
    break;
    default:
      show_error("Expected 2 or 3 arguments, got " + string(argument_count) + ".", true);
    break;
  }
  
  //Check assertion
  if (!__gma_less_than_or_equal__(argument[0], argument[1])) {
    switch (__gma_debug_type__(argument[1])) {
      case GMASSERT_TYPE_REAL:
        __gma_assert_error_raw__(msg, "A real value less than or equal to " + __gma_debug_value__(argument[1]), __gma_debug_value__(argument[0]));
      break;
      case GMASSERT_TYPE_STRING:
        __gma_assert_error_raw__(msg, "A string that comes before or is " + __gma_debug_value__(argument[1]), __gma_debug_value__(argument[0]));
      break;
      case GMASSERT_TYPE_ARRAY:
        __gma_assert_error_raw__(msg, "An array with pairwise values all less than or equal " + __gma_debug_value__(argument[1]), __gma_debug_value__(argument[0]));
      break;
      default:
        __gma_assert_error__(msg + " (unsupported type)", argument[1], argument[0]);
      break;
    }
  }
}

#define assert_is_string
///assert_is_string(got, [msg])
{
  if (!GMASSERT_MODE) exit;

  //Capture message argument
  var msg;
  switch (argument_count) {
    case 1:
      msg = "String type assertion failed!";
    break;
    case 2:
      msg = argument[1];
    break;
    default:
      show_error("Expected 1 or 2 arguments, got " + string(argument_count) + ".", true);
    break;
  }
  
  //Check assertion
  if (!is_string(argument[0])) {
    __gma_assert_error_raw__(msg, "Any string", __gma_debug_value__(argument[0]));
  }
}

#define assert_is_real
///assert_is_real(got, [msg])
{
  if (!GMASSERT_MODE) exit;

  //Capture message argument
  var msg;
  switch (argument_count) {
    case 1:
      msg = "Real type assertion failed!";
    break;
    case 2:
      msg = argument[1];
    break;
    default:
      show_error("Expected 1 or 2 arguments, got " + string(argument_count) + ".", true);
    break;
  }
  
  //Check assertion
  if (!is_real(argument[0])) {
    __gma_assert_error_raw__(msg, "Any real value", __gma_debug_value__(argument[0]));
  }
}

#define assert_is_array
///assert_is_array(got, [msg])
{
  if (!GMASSERT_MODE) exit;

  //Capture message argument
  var msg;
  switch (argument_count) {
    case 1:
      msg = "Array type assertion failed!";
    break;
    case 2:
      msg = argument[1];
    break;
    default:
      show_error("Expected 1 or 2 arguments, got " + string(argument_count) + ".", true);
    break;
  }
  
  //Check assertion
  if (!is_array(argument[0])) {
    __gma_assert_error_raw__(msg, "Any array", __gma_debug_value__(argument[0]));
  }
}

#define assert_is_defined
///assert_is_defined(got, [msg])
{
  if (!GMASSERT_MODE) exit;

  //Capture message argument
  var msg;
  switch (argument_count) {
    case 1:
      msg = "Defined type assertion failed!";
    break;
    case 2:
      msg = argument[1];
    break;
    default:
      show_error("Expected 1 or 2 arguments, got " + string(argument_count) + ".", true);
    break;
  }
  
  //Check assertion
  if (is_undefined(argument[0])) {
    __gma_assert_error_raw__(msg, "Anything but undefined", __gma_debug_value__(argument[0]));
  }
}

#define assert_isnt_string
///assert_isnt_string(got, [msg])
{
  if (!GMASSERT_MODE) exit;

  //Capture message argument
  var msg;
  switch (argument_count) {
    case 1:
      msg = "Non-string type assertion failed!";
    break;
    case 2:
      msg = argument[1];
    break;
    default:
      show_error("Expected 1 or 2 arguments, got " + string(argument_count) + ".", true);
    break;
  }
  
  //Check assertion
  if (is_string(argument[0])) {
    __gma_assert_error_raw__(msg, "Anything but a string", __gma_debug_value__(argument[0]));
  }
}

#define assert_isnt_real
///assert_isnt_real(got, [msg])
{
  if (!GMASSERT_MODE) exit;

  //Capture message argument
  var msg;
  switch (argument_count) {
    case 1:
      msg = "Non-real type assertion failed!";
    break;
    case 2:
      msg = argument[1];
    break;
    default:
      show_error("Expected 1 or 2 arguments, got " + string(argument_count) + ".", true);
    break;
  }
  
  //Check assertion
  if (is_real(argument[0])) {
    __gma_assert_error_raw__(msg, "Anything but a real value", __gma_debug_value__(argument[0]));
  }
}

#define assert_isnt_array
///assert_isnt_array(got, [msg])
{
  if (!GMASSERT_MODE) exit;

  //Capture message argument
  var msg;
  switch (argument_count) {
    case 1:
      msg = "Non-array type assertion failed!";
    break;
    case 2:
      msg = argument[1];
    break;
    default:
      show_error("Expected 1 or 2 arguments, got " + string(argument_count) + ".", true);
    break;
  }
  
  //Check assertion
  if (is_array(argument[0])) {
    __gma_assert_error_raw__(msg, "Anything but an array", __gma_debug_value__(argument[0]));
  }
}

#define assert_isnt_defined
///assert_isnt_defined(got, [msg])
{
  if (!GMASSERT_MODE) exit;

  //Capture message argument
  var msg;
  switch (argument_count) {
    case 1:
      msg = "Undefined type assertion failed!";
    break;
    case 2:
      msg = argument[1];
    break;
    default:
      show_error("Expected 1 or 2 arguments, got " + string(argument_count) + ".", true);
    break;
  }
  
  //Check assertion
  if (!is_undefined(argument[0])) {
    __gma_assert_error_raw__(msg, "undefined", __gma_debug_value__(argument[0]));
  }
}

#define assert_in_range
///assert_in_range(got, lower, upper, [msg])
{
  if (!GMASSERT_MODE) exit;
  
  //Capture message argument
  var msg;
  switch (argument_count) {
    case 3:
      msg = "In-range assertion failed!";
    break;
    case 4:
      msg = argument[3];
    break;
    default:
      show_error("Expected 3 or 4 arguments, got " + string(argument_count) + ".", true);
    break;
  }
  
  //Check types
  switch (__gma_debug_type__(argument[1])) {
    case GMASSERT_TYPE_REAL:
    case GMASSERT_TYPE_STRING:
    case GMASSERT_TYPE_ARRAY:
    break;
    default:
      msg += " (invalid lower bound type)";
        __gma_assert_error_raw__(msg, "A real value, string or array", __gma_debug_value__(argument[1]));
    exit;
  }
  if (__gma_debug_type__(argument[1]) != __gma_debug_type__(argument[2])) {
    switch (__gma_debug_type__(argument[1])) {
      case GMASSERT_TYPE_REAL:
        __gma_assert_error__(msg + " (mismatched range types)", "A real value for the upper bound", __gma_debug_value__(argument[2]));
      break;
      case GMASSERT_TYPE_STRING:
        __gma_assert_error__(msg + " (mismatched range types)", "A string for the upper bound", __gma_debug_value__(argument[2]));
      break;
      case GMASSERT_TYPE_ARRAY:
        __gma_assert_error__(msg + " (mismatched range types)", "An array for the upper bound", __gma_debug_value__(argument[2]));
      break;
      default:
        msg += " (invalid lower bound type)";
        __gma_assert_error_raw__(msg, "A real value, string or array", __gma_debug_value__(argument[1]));
      break;
    }
    exit;
  }
  
  //Check assertion
  if (!(__gma_less_than_or_equal__(argument[0], argument[2]) && __gma_less_than_or_equal__(argument[1], argument[0]))) {
    switch (__gma_debug_type__(argument[1])) {
      case GMASSERT_TYPE_REAL:
        __gma_assert_error_raw__(msg, "A real value between " + __gma_debug_value__(argument[1]) + " and " + __gma_debug_value__(argument[2]), __gma_debug_value__(argument[0]));
      break;
      case GMASSERT_TYPE_STRING:
        __gma_assert_error_raw__(msg, "A string that lies between " + __gma_debug_value__(argument[1]) + " and " + __gma_debug_value__(argument[2]), __gma_debug_value__(argument[0]));
      break;
      case GMASSERT_TYPE_ARRAY:
        __gma_assert_error_raw__(msg, "An array with pairwise values all between " + __gma_debug_value__(argument[1]) + " and " + __gma_debug_value__(argument[2]), __gma_debug_value__(argument[0]));
      break;
      default:
        __gma_assert_error_raw__(msg + " (unsupported type)", "A value comparable to " + __gma_debug_value__(argument[1]) + " and " + __gma_debug_value__(argument[2]), __gma_debug_value__(argument[0]));
      break;
    }
  }
}

#define assert_not_in_range
///assert_not_in_range(got, lower, upper, [msg])
{
  if (!GMASSERT_MODE) exit;
  
  //Capture message argument
  var msg;
  switch (argument_count) {
    case 3:
      msg = "Out-of-range assertion failed!";
    break;
    case 4:
      msg = argument[3];
    break;
    default:
      show_error("Expected 3 or 4 arguments, got " + string(argument_count) + ".", true);
    break;
  }
  
  //Check types
  switch (__gma_debug_type__(argument[1])) {
    case GMASSERT_TYPE_REAL:
    case GMASSERT_TYPE_STRING:
    case GMASSERT_TYPE_ARRAY:
    break;
    default:
      msg += " (invalid lower bound type)";
        __gma_assert_error_raw__(msg, "A real value, string or array", __gma_debug_value__(argument[1]));
    exit;
  }
  if (__gma_debug_type__(argument[1]) != __gma_debug_type__(argument[2])) {
    switch (__gma_debug_type__(argument[1])) {
      case GMASSERT_TYPE_REAL:
        __gma_assert_error__(msg + " (mismatched range types)", "A real value for the upper bound", __gma_debug_value__(argument[2]));
      break;
      case GMASSERT_TYPE_STRING:
        __gma_assert_error__(msg + " (mismatched range types)", "A string for the upper bound", __gma_debug_value__(argument[2]));
      break;
      case GMASSERT_TYPE_ARRAY:
        __gma_assert_error__(msg + " (mismatched range types)", "An array for the upper bound", __gma_debug_value__(argument[2]));
      break;     
      default:
        msg += " (invalid lower bound type)";
        __gma_assert_error_raw__(msg, "A real value, string or array", __gma_debug_value__(argument[1]));
      break;
    }
    exit;
  }
  
  //Check assertion
  if (__gma_less_than_or_equal__(argument[0], argument[2]) && __gma_less_than_or_equal__(argument[1], argument[0])) {
    switch (__gma_debug_type__(argument[1])) {
      case GMASSERT_TYPE_REAL:
        __gma_assert_error_raw__(msg, "A real value not between " + __gma_debug_value__(argument[1]) + " and " + __gma_debug_value__(argument[2]), __gma_debug_value__(argument[0]));
      break;
      case GMASSERT_TYPE_STRING:
        __gma_assert_error_raw__(msg, "A string that does not lie between " + __gma_debug_value__(argument[1]) + " and " + __gma_debug_value__(argument[2]), __gma_debug_value__(argument[0]));
      break;
      case GMASSERT_TYPE_ARRAY:
        __gma_assert_error_raw__(msg, "An array with pairwise values all not between " + __gma_debug_value__(argument[1]) + " and " + __gma_debug_value__(argument[2]), __gma_debug_value__(argument[0]));
      break;
      default:
        __gma_assert_error_raw__(msg + " (unsupported type)", "A value comparable to " + __gma_debug_value__(argument[1]) + " and " + __gma_debug_value__(argument[2]), __gma_debug_value__(argument[0]));
      break;
    }
  }
}

#define assert_contains
///assert_contains(got, content, [msg]);
{
  if (!GMASSERT_MODE) exit;
  
  //Capture message argument
  var msg;
  switch (argument_count) {
    case 2:
      msg = "Inclusion assertion failed!";
    break;
    case 3:
      msg = argument[2];
    break;
    default:
      show_error("Expected 2 or 3 arguments, got " + string(argument_count) + ".", true);
    break;
  }
  
  //Check types and assertion
  var found = false;
  switch (__gma_debug_type__(argument[0])) {
    case GMASSERT_TYPE_STRING:
      if (__gma_debug_type__(argument[1]) == GMASSERT_TYPE_STRING) {
        if (string_pos(argument[1], argument[0]) == 0) {
          __gma_assert_error_raw__(msg, "A string that contains " + __gma_debug_value__(argument[1]), __gma_debug_value__(argument[0]));
        }
      }
      else {
        msg += " (invalid content type)";
        __gma_assert_error_raw__(msg, "A string", __gma_debug_value__(argument[1]));
      }
    break;
    case GMASSERT_TYPE_ARRAY:
      var arr = argument[0];
      if (array_height_2d(arr) == 1 || array_length_2d(arr, 1) == 0) {
        var size = array_length_1d(arr);
        for (var i = 0; i < size; i++) {
          if (__gma_equal__(argument[1], arr[i])) {
            found = true;
            break;
          }
        }
      }
      else {
        var size_i = array_height_2d(arr);
        for (var i = 0; i < size_i && !found; i++) {
          var size_j = array_length_2d(arr, i);
          for (var j = 0; j < size_j; j++) {
            if (__gma_equal__(argument[1], arr[i, j])) {
              found = true;
              break;
            }
          }
        }
      }
      if (!found) {
        __gma_assert_error_raw__(msg, "An array that contains " + __gma_debug_value__(argument[1]), __gma_debug_value__(argument[0]));
      }
    break;
    case GMASSERT_TYPE_REAL:
      if (ds_exists(argument[0], ds_type_list)) {
        var list = argument[0],
            size = ds_list_size(list);
        for (var i = 0; i < size; i++) {
          if (__gma_equal__(argument[1], list[| i])) {
            found = true;
            break;
          }
        }
        if (!found) {
          __gma_assert_error_raw__(msg, "A list that contains " + __gma_debug_value__(argument[1]), __gma_debug_value__(argument[0]));
        }
      }
      else {
        msg += " (list ID does not exist)";
        __gma_assert_error_raw__(msg, "An existent list ID", __gma_debug_value__(argument[0]));
      }
    break;
    default:
      msg += " (invalid container type)";
        __gma_assert_error_raw__(msg, "A string, array or list", __gma_debug_value__(argument[0]));
    break;
  }
}

#define assert_contains_exact
///assert_contains_exact(got, content, [msg]);
{
  if (!GMASSERT_MODE) exit;
  
  //Capture message argument
  var msg;
  switch (argument_count) {
    case 2:
      msg = "Exact inclusion assertion failed!";
    break;
    case 3:
      msg = argument[2];
    break;
    default:
      show_error("Expected 2 or 3 arguments, got " + string(argument_count) + ".", true);
    break;
  }
  
  //Check types and assertion
  var found = false;
  switch (__gma_debug_type__(argument[0])) {
    case GMASSERT_TYPE_STRING:
      if (__gma_debug_type__(argument[1]) == GMASSERT_TYPE_STRING) {
        if (string_pos(argument[1], argument[0]) == 0) {
          __gma_assert_error_raw__(msg, "A string that contains exactly " + __gma_debug_value__(argument[1]), __gma_debug_value__(argument[0]));
        }
      }
      else {
        msg += " (invalid content type)";
        __gma_assert_error_raw__(msg, "A string", __gma_debug_value__(argument[1]));
      }
    break;
    case GMASSERT_TYPE_ARRAY:
      var arr = argument[0];
      if (array_height_2d(arr) == 1 || array_length_2d(arr, 1) == 0) {
        var size = array_length_1d(arr);
        for (var i = 0; i < size; i++) {
          if (__gma_debug_type__(argument[1]) == __gma_debug_type__(arr[i]) && argument[1] == arr[i]) {
            found = true;
            break;
          }
        }
      }
      else {
        var size_i = array_height_2d(arr);
        for (var i = 0; i < size_i && !found; i++) {
          var size_j = array_length_2d(arr, i);
          for (var j = 0; j < size_j; j++) {
            if (__gma_debug_type__(argument[1]) == __gma_debug_type__(arr[i, j]) && argument[1] == arr[i, j]) {
              found = true;
              break;
            }
          }
        }
      }
      if (!found) {
        __gma_assert_error_raw__(msg, "An array that contains exactly " + __gma_debug_value__(argument[1]), __gma_debug_value__(argument[0]));
      }
    break;
    case GMASSERT_TYPE_REAL:
      if (ds_exists(argument[0], ds_type_list)) {
        var list = argument[0],
            size = ds_list_size(list);
        for (var i = 0; i < size; i++) {
          if (__gma_debug_type__(argument[1]) == __gma_debug_type__(list[| i]) && argument[1] == list[| i]) {
            found = true;
            break;
          }
        }
        if (!found) {
          __gma_assert_error_raw__(msg, "A list that contains exactly " + __gma_debug_value__(argument[1]), __gma_debug_value__(argument[0]));
        }
      }
      else {
        msg += " (list ID does not exist)";
        __gma_assert_error_raw__(msg, "An existent list ID", __gma_debug_value__(argument[0]));
      }
    break;
    default:
      msg += " (invalid container type)";
        __gma_assert_error_raw__(msg, "A string, array or list", __gma_debug_value__(argument[0]));
    break;
  }
}

#define assert_doesnt_contain
///assert_doesnt_contain(got, content, [msg]);
{
  if (!GMASSERT_MODE) exit;
  
  //Capture message argument
  var msg;
  switch (argument_count) {
    case 2:
      msg = "Exclusion assertion failed!";
    break;
    case 3:
      msg = argument[2];
    break;
    default:
      show_error("Expected 2 or 3 arguments, got " + string(argument_count) + ".", true);
    break;
  }
  
  //Check types and assertion
  var found = false;
  switch (__gma_debug_type__(argument[0])) {
    case GMASSERT_TYPE_STRING:
      if (__gma_debug_type__(argument[1]) == GMASSERT_TYPE_STRING) {
        if (string_pos(argument[1], argument[0]) > 0) {
          __gma_assert_error_raw__(msg, "A string that does not contain " + __gma_debug_value__(argument[1]), __gma_debug_value__(argument[0]));
        }
      }
      else {
        msg += " (invalid content type)";
        __gma_assert_error_raw__(msg, "A string", __gma_debug_value__(argument[1]));
      }
    break;
    case GMASSERT_TYPE_ARRAY:
      var arr = argument[0];
      if (array_height_2d(arr) == 1 || array_length_2d(arr, 1) == 0) {
        var size = array_length_1d(arr);
        for (var i = 0; i < size; i++) {
          if (__gma_equal__(argument[1], arr[i])) {
            found = true;
            break;
          }
        }
      }
      else {
        var size_i = array_height_2d(arr);
        for (var i = 0; i < size_i && !found; i++) {
          var size_j = array_length_2d(arr, i);
          for (var j = 0; j < size_j; j++) {
            if (__gma_equal__(argument[1], arr[i, j])) {
              found = true;
              break;
            }
          }
        }
      }
      if (found) {
        __gma_assert_error_raw__(msg, "An array that does not contain " + __gma_debug_value__(argument[1]), __gma_debug_value__(argument[0]));
      }
    break;
    case GMASSERT_TYPE_REAL:
      if (ds_exists(argument[0], ds_type_list)) {
        var list = argument[0],
            size = ds_list_size(list);
        for (var i = 0; i < size; i++) {
          if (__gma_equal__(argument[1], list[| i])) {
            found = true;
            break;
          }
        }
        if (found) {
          __gma_assert_error_raw__(msg, "A list that does not contain " + __gma_debug_value__(argument[1]), __gma_debug_value__(argument[0]));
        }
      }
      else {
        msg += " (list ID does not exist)";
        __gma_assert_error_raw__(msg, "An existent list ID", __gma_debug_value__(argument[0]));
      }
    break;
    default:
      msg += " (invalid container type)";
        __gma_assert_error_raw__(msg, "A string, array or list", __gma_debug_value__(argument[0]));
    break;
  }
}

#define assert_doesnt_contain_exact
///assert_doesnt_contain_exact(got, content, [msg]);
{
  if (!GMASSERT_MODE) exit;
  
  //Capture message argument
  var msg;
  switch (argument_count) {
    case 2:
      msg = "Exact exclusion assertion failed!";
    break;
    case 3:
      msg = argument[2];
    break;
    default:
      show_error("Expected 2 or 3 arguments, got " + string(argument_count) + ".", true);
    break;
  }
  
  //Check types and assertion
  var found = false;
  switch (__gma_debug_type__(argument[0])) {
    case GMASSERT_TYPE_STRING:
      if (__gma_debug_type__(argument[1]) == GMASSERT_TYPE_STRING) {
        if (string_pos(argument[1], argument[0]) > 0) {
          __gma_assert_error_raw__(msg, "A string that does not contain exactly " + __gma_debug_value__(argument[1]), __gma_debug_value__(argument[0]));
        }
      }
      else {
        msg += " (invalid content type)";
        __gma_assert_error_raw__(msg, "A string", __gma_debug_value__(argument[1]));
      }
    break;
    case GMASSERT_TYPE_ARRAY:
      var arr = argument[0];
      if (array_height_2d(arr) == 1 || array_length_2d(arr, 1) == 0) {
        var size = array_length_1d(arr);
        for (var i = 0; i < size; i++) {
          if (__gma_debug_type__(argument[1]) == __gma_debug_type__(arr[i]) && argument[1] == arr[i]) {
            found = true;
            break;
          }
        }
      }
      else {
        var size_i = array_height_2d(arr);
        for (var i = 0; i < size_i && !found; i++) {
          var size_j = array_length_2d(arr, i);
          for (var j = 0; j < size_j; j++) {
            if (__gma_debug_type__(argument[1]) == __gma_debug_type__(arr[i, j]) && argument[1] == arr[i, j]) {
              found = true;
              break;
            }
          }
        }
      }
      if (found) {
        __gma_assert_error_raw__(msg, "An array that eoes not contain exactly " + __gma_debug_value__(argument[1]), __gma_debug_value__(argument[0]));
      }
    break;
    case GMASSERT_TYPE_REAL:
      if (ds_exists(argument[0], ds_type_list)) {
        var list = argument[0],
            size = ds_list_size(list);
        for (var i = 0; i < size; i++) {
          if (__gma_debug_type__(argument[1]) == __gma_debug_type__(list[| i]) && argument[1] == list[| i]) {
            found = true;
            break;
          }
        }
        if (found) {
          __gma_assert_error_raw__(msg, "A list that does not contain exactly " + __gma_debug_value__(argument[1]), __gma_debug_value__(argument[0]));
        }
      }
      else {
        msg += " (list ID does not exist)";
        __gma_assert_error_raw__(msg, "An existent list ID", __gma_debug_value__(argument[0]));
      }
    break;
    default:
      msg += " (invalid container type)";
        __gma_assert_error_raw__(msg, "A string, array or list", __gma_debug_value__(argument[0]));
    break;
  }
}

