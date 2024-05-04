local error = error
local setmetatable = setmetatable
local math = math
local math_maxinteger = math.maxinteger
local string = string
local string_char = string.char
local string_format = string.format
local table = table
local table_pack = table.pack
local _exn_meta = {}
function _exn_meta:__tostring()
  local traceback = self.traceback
  if traceback then
    traceback = "\n" .. traceback
  else
    traceback = ""
  end
  return string_format("%s: %s%s", self.location or "<no location info>", self.tag[1], traceback)
end
local _Match_tag = { "Match" }
local _Match = setmetatable({ tag = _Match_tag }, _exn_meta)
local _Overflow_tag = { "Overflow" }
local _Overflow = setmetatable({ tag = _Overflow_tag }, _exn_meta)
local _Size_tag = { "Size" }
local _Size = setmetatable({ tag = _Size_tag }, _exn_meta)
local _Subscript_tag = { "Subscript" }
local _Subscript = setmetatable({ tag = _Subscript_tag }, _exn_meta)
local _Fail_tag = { "Fail" }
local function _Fail(message)
  return setmetatable({ tag = _Fail_tag, payload = message }, _exn_meta)
end
local _Error_tag = { "Error" }
local function _raise(x, location)
  local e
  if x.tag == _Error_tag then
    e = x.payload
  elseif location ~= nil then
    local traceback = debug.traceback(nil, 2)
    e = setmetatable({ tag = x.tag, payload = x.payload, location = location, traceback = traceback }, _exn_meta)
  else
    e = x
  end
  error(e, 1)
end
local function _Int_add(x, y)
  -- assert(math_type(x) == "integer")
  -- assert(math_type(y) == "integer")
  local z = x + y
  if y > 0 and z < x then
    _raise(_Overflow, "Int.+")
  elseif y < 0 and z > x then
    _raise(_Overflow, "Int.+")
  else
    return z
  end
end
local function _Int_sub(x, y)
  -- assert(math_type(x) == "integer")
  -- assert(math_type(y) == "integer")
  local z = x - y
  if y < 0 and z < x then
    _raise(_Overflow, "Int.-")
  elseif y > 0 and x < z then
    _raise(_Overflow, "Int.-")
  else
    return z
  end
end
local function _list(t)
  local xs = nil
  for i = t.n, 1, -1 do
    xs = { t[i], xs }
  end
  return xs
end
local function _Array_array(t)
  local n, init = t[1], t[2]
  if n < 0 then -- or maxLen < n
    _raise(_Size, "Array.array")
  end
  local t = { n = n }
  for i = 1, n do
    t[i] = init
  end
  return t
end
local function _VectorOrArray_fromList(xs)
  local t = {}
  local n = 0
  while xs ~= nil do
    n = n + 1
    t[n] = xs[1]
    xs = xs[2]
  end
  t.n = n
  return t
end
local function _VectorOrArray_tabulate(t)
  local n, f = t[1], t[2]
  if n < 0 then -- or maxLen < n
    _raise(_Size, "(Vector|Array).tabulate")
  end
  local t = { n = n }
  for i = 1, n do
    t[i] = f(i - 1)
  end
  return t
end
local _COLON_COLON_1, eq_132, Chr_143, LESS_155, EQUAL_154, GREATER_153, NONE_217, revAppend_1832944, map_454, tabulate_1832962, sub_602, update_606, sub_2739429, length_856, size_1069, tmp_2759822, tmp_2759824, tmp_2759826, tmp_2759828, tmp_2759829, compare_2759830, tmp_2759838
do
  _COLON_COLON_1 = function(a_104)
    local x_103 = a_104[1]
    local xs_102 = a_104[2]
    local tmp_15960 = {x_103, xs_102}
    return tmp_15960
  end
  eq_132 = function(a_123)
    local x_122 = a_123[1]
    local y_121 = a_123[2]
    local tmp_15973 = x_122 == y_121
    return tmp_15973
  end
  local Chr__tag_195 = {"Chr"}
  Chr_143 = {tag = Chr__tag_195}
  LESS_155 = "LESS"
  EQUAL_154 = "EQUAL"
  GREATER_153 = "GREATER"
  NONE_217 = {tag = "NONE"}
  revAppend_1832944 = function(tmp_1832943, ys_1832942)
    local tmp_2763242, tmp_2763243 = tmp_1832943, ys_1832942
    ::cont_58545::
    do
      local tmp_58544, ys_58543 = tmp_2763242, tmp_2763243
      local tmp_16351 = tmp_58544 == nil
      if tmp_16351 then
        return ys_58543
      end
      local tmp_16353 = tmp_58544 == nil
      local tmp_16354 = not tmp_16353
      if tmp_16354 then
        local tmp_16356 = tmp_58544[1]
        local tmp_16363 = tmp_58544[2]
        local tmp_43847 = {tmp_16356, ys_58543}
        tmp_2763242 = tmp_16363
        tmp_2763243 = tmp_43847
        goto cont_58545
      else
        _raise(_Match, "list.sml:60:5")
      end
    end
  end
  map_454 = function(a_455)
    local tmp_16401 = function(a_456)
      do
        local tmp_16404 = a_456 == nil
        if tmp_16404 then
          return nil
        end
        local tmp_16407 = a_456 == nil
        local tmp_16408 = not tmp_16407
        if tmp_16408 then
          goto then_2763244
        else
          _raise(_Match, "list.sml:66:5")
        end
      end
      ::then_2763244::
      do
        local tmp_16410 = a_456[1]
        local tmp_16417 = a_456[2]
        local tmp_16420 = a_455(tmp_16410)
        local tmp_16422 = map_454(a_455)
        local tmp_16424 = tmp_16422(tmp_16417)
        local tmp_43853 = {tmp_16420, tmp_16424}
        return tmp_43853
      end
    end
    return tmp_16401
  end
  tabulate_1832962 = function(n_1832948, f_1832947)
    do
      local tmp_43902 = n_1832948 < 0
      if tmp_43902 then
        _raise(_Size, "list.sml:101:27")
      end
      local tmp_58618 = n_1832948 < 10
      if tmp_58618 then
        goto then_2763245
      else
        goto else_2763246
      end
    end
    ::then_2763245::
    do
      local function go_58619(a_58621)
        local tmp_58623 = a_58621 >= n_1832948
        if tmp_58623 then
          return nil
        end
        local tmp_58624 = f_1832947(a_58621)
        local tmp_58626 = _Int_add(a_58621, 1)
        local tmp_58627 = go_58619(tmp_58626)
        local tmp_58629 = {tmp_58624, tmp_58627}
        return tmp_58629
      end
      return go_58619(0)
    end
    ::else_2763246::
    local tmp_2763247, tmp_2763248 = 0, nil
    ::cont_1832951::
    do
      local acc_1832952, i_1832953
      do
        i_1832953, acc_1832952 = tmp_2763247, tmp_2763248
        local tmp_1832954 = i_1832953 >= n_1832948
        if tmp_1832954 then
          goto then_2763249
        else
          goto else_2763250
        end
      end
      ::then_2763249::
      do
        return revAppend_1832944(acc_1832952, nil)
      end
      ::else_2763250::
      local tmp_1832958 = _Int_add(i_1832953, 1)
      local tmp_1832959 = f_1832947(i_1832953)
      local tmp_1832960 = {tmp_1832959, acc_1832952}
      tmp_2763247 = tmp_1832958
      tmp_2763248 = tmp_1832960
      goto cont_1832951
    end
  end
  sub_602 = function(a_603)
    local arr_605 = a_603[1]
    local i_604 = a_603[2]
    local tmp_16809 = arr_605[i_604 + 1]
    return tmp_16809
  end
  update_606 = function(a_607)
    local arr_610 = a_607[1]
    local i_609 = a_607[2]
    local v_608 = a_607[3]
    arr_610[i_609 + 1] = v_608
    return nil
  end
  sub_2739429 = function(vec_2739428, i_2739427)
    local tmp_58652
    do
      local tmp_43912 = i_2739427 < 0
      if tmp_43912 then
        tmp_58652 = true
      else
        local tmp_58657 = vec_2739428.n
        local tmp_58659 = tmp_58657 <= i_2739427
        tmp_58652 = tmp_58659
      end
    end
    ::cont_58656::
    if tmp_58652 then
      _raise(_Subscript, "vector-prim.sml:5:24")
    else
      local tmp_58655 = vec_2739428[i_2739427 + 1]
      return tmp_58655
    end
  end
  length_856 = function(a_857)
    local tmp_17204 = a_857.n
    return tmp_17204
  end
  size_1069 = function(a_1070)
    local tmp_17319 = #a_1070
    return tmp_17319
  end
  local tmp_2739471 = _ENV.io
  tmp_2759822 = tmp_2739471.stdout
  tmp_2759824 = string.byte
  tmp_2759826 = string.sub
  tmp_2759828 = table.concat
  tmp_2759829 = {tag = "SOME", payload = math_maxinteger}
  compare_2759830 = function(a_2759831)
    local x_2759833 = a_2759831[1]
    local y_2759834 = a_2759831[2]
    local tmp_2759835 = x_2759833 == y_2759834
    if tmp_2759835 then
      return EQUAL_154
    end
    local tmp_2759836 = x_2759833 < y_2759834
    if tmp_2759836 then
      return LESS_155
    else
      return GREATER_153
    end
  end
  do
    local tmp_2763251, tmp_2763252 = math_maxinteger, 1
    ::cont_2763236::
    do
      local x_2763238, n_2763237 = tmp_2763251, tmp_2763252
      local tmp_2763239 = x_2763238 == 0
      if tmp_2763239 then
        tmp_2759838 = n_2763237
        goto cont_2763235
      else
        local tmp_2763240 = x_2763238 >> 1
        local tmp_2763241 = _Int_add(n_2763237, 1)
        tmp_2763251 = tmp_2763240
        tmp_2763252 = tmp_2763241
        goto cont_2763236
      end
    end
  end
end
::cont_2763235::
local sub_2759839, substring_2759852, concat_2759868, implode_2759874, implodeRev_2759889, chr_2759906, n_2759915, n_2759916
do
  sub_2759839 = function(a_2759840)
    local s_2759842, i_2759843, tmp_2759845
    do
      s_2759842 = a_2759840[1]
      i_2759843 = a_2759840[2]
      local tmp_2759844 = i_2759843 < 0
      if tmp_2759844 then
        tmp_2759845 = true
      else
        local tmp_2759850 = #s_2759842
        local tmp_2759851 = tmp_2759850 <= i_2759843
        tmp_2759845 = tmp_2759851
      end
    end
    ::cont_2759849::
    if tmp_2759845 then
      _raise(_Subscript, "string-1.sml:33:44")
    else
      local tmp_2759847 = _Int_add(i_2759843, 1)
      local tmp_2759848 = tmp_2759824(s_2759842, tmp_2759847)
      return tmp_2759848
    end
  end
  substring_2759852 = function(s_2759855, i_2759854, j_2759853)
    local tmp_2759858
    do
      local tmp_2759857 = i_2759854 < 0
      do
        if tmp_2759857 then
          tmp_2759858 = true
          goto cont_2759863
        end
        local tmp_2759864 = j_2759853 < 0
        if tmp_2759864 then
          tmp_2759858 = true
        else
          local tmp_2759865 = #s_2759855
          local tmp_2759866 = _Int_add(i_2759854, j_2759853)
          local tmp_2759867 = tmp_2759865 < tmp_2759866
          tmp_2759858 = tmp_2759867
        end
      end
    end
    ::cont_2759863::
    if tmp_2759858 then
      _raise(_Subscript, "string-1.sml:40:59")
    else
      local tmp_2759860 = _Int_add(i_2759854, 1)
      local tmp_2759861 = _Int_add(i_2759854, j_2759853)
      local tmp_2759862 = tmp_2759826(s_2759855, tmp_2759860, tmp_2759861)
      return tmp_2759862
    end
  end
  concat_2759868 = function(a_2759869)
    local tmp_2759871 = _VectorOrArray_fromList(a_2759869)
    local tmp_2759872 = tmp_2759828(tmp_2759871)
    return tmp_2759872
  end
  implode_2759874 = function(a_2759875)
    local tmp_2759878
    do
      local tmp_2759877 = _VectorOrArray_fromList(a_2759875)
      do
        local tmp_2759881 = tmp_2759877.n
        local tmp_2759882 = function(i_2759883)
          local tmp_2759885 = tmp_2759877[i_2759883 + 1]
          local tmp_2759886 = string_char(tmp_2759885)
          return tmp_2759886
        end
        local tmp_2759887 = {tmp_2759881, tmp_2759882}
        tmp_2759878 = _VectorOrArray_tabulate(tmp_2759887)
        goto cont_2759880
      end
    end
    ::cont_2759880::
    local tmp_2759879 = tmp_2759828(tmp_2759878)
    return tmp_2759879
  end
  implodeRev_2759889 = function(a_2759890)
    local tmp_2759894
    do
      local tmp_2759892 = revAppend_1832944(a_2759890, nil)
      local tmp_2759893 = _VectorOrArray_fromList(tmp_2759892)
      do
        local tmp_2759897 = tmp_2759893.n
        local tmp_2759898 = function(i_2759899)
          local tmp_2759901 = tmp_2759893[i_2759899 + 1]
          local tmp_2759902 = string_char(tmp_2759901)
          return tmp_2759902
        end
        local tmp_2759903 = {tmp_2759897, tmp_2759898}
        tmp_2759894 = _VectorOrArray_tabulate(tmp_2759903)
        goto cont_2759896
      end
    end
    ::cont_2759896::
    local tmp_2759895 = tmp_2759828(tmp_2759894)
    return tmp_2759895
  end
  chr_2759906 = function(x_2759907)
    local tmp_2759910
    do
      local tmp_2759909 = x_2759907 < 0
      if tmp_2759909 then
        tmp_2759910 = true
      else
        local tmp_2759914 = x_2759907 > 255
        tmp_2759910 = tmp_2759914
      end
    end
    ::cont_2759913::
    if tmp_2759910 then
      _raise(Chr_143, "char-1.sml:47:37")
    else
      local tmp_2759912 = x_2759907
      return tmp_2759912
    end
  end
  n_2759915 = tmp_2759829.payload
  n_2759916 = tmp_2759829.payload
  local tmp_2759917 = tmp_2759838 == 64
  local tmp_2759918 = not tmp_2759917
  do
    if tmp_2759918 then
      goto then_2763253
    else
      goto cont_2763232
    end
    ::then_2763253::
    do
      local tmp_2763233 = _Fail("Word64 is not available")
      _raise(tmp_2763233, "word.sml:333:18")
    end
  end
end
::cont_2763232::
local MonoSequence_2759919, tmp_2761709, tmp_2761710, tmp_2761711, tmp_2761712, tmp_2761713, tmp_2761714, tmp_2761715, tmp_2761716, tmp_2761717, tmp_2761718, tmp_2761719, tmp_2761720, tmp_2761721, tmp_2761722, tmp_2761723, tmp_2761724, tmp_2761725, tmp_2761726, tmp_2761727, tmp_2761728, tmp_2761729, tmp_2761730, tmp_2761731, tmp_2761732, tmp_2761733, tmp_2761734, tmp_2761735, tmp_2761736, tmp_2761737, tmp_2761738, tmp_2761739, tmp_2761740, tmp_2761741, tmp_2761742, tmp_2761743, tmp_2761744, tmp_2761745, tmp_2761746, tmp_2761747, tmp_2761748, tmp_2761749, tmp_2761750, tmp_2761751, tmp_2761752, tmp_2761753, tmp_2761754, tmp_2761755, tmp_2761756, tmp_2761757, tmp_2761758, tmp_2761759, tmp_2761760, tmp_2761761, tmp_2761762, tmp_2761763, tmp_2761764, tmp_2761765, tmp_2761766, tmp_2761767, tmp_2761768, tmp_2761769, tmp_2761770, tmp_2761771, tmp_2761772, tmp_2761773, tmp_2761774, tmp_2761775, tmp_2761776, tmp_2761777, tmp_2761778, tmp_2761779, tmp_2761780, tmp_2761781, tmp_2761782, tmp_2761783, tmp_2761784, tmp_2761785, tmp_2761786, tmp_2761787, tmp_2761788, tmp_2761789, tmp_2761790, tmp_2761791, tmp_2761792, tmp_2761793, tmp_2761794, tmp_2761795, tmp_2761796, tmp_2761797, tmp_2761798, tmp_2761799, tmp_2761800, tmp_2761801, tmp_2761802, tmp_2761803, tmp_2761804, tmp_2761805
do
  MonoSequence_2759919 = function(fromList_2759936, length_2759935, maxLen_2759934, tmp_2759933, create_2759932, tmp_2759931, tmp_2759930, tmp_2759929, tmp_2759928, fromList_2759927, length_2759926, maxLen_2759925, tmp_2759924, vector_2759923, tmp_2759922, tmp_2759921, tmp_2759920)
    local tabulate_2759938, sub_2759946, update_2759959, appi_2759980, app_2759997, mapi_2760013, map_2760031, foldli_2760048, foldri_2760070, foldl_2760093, foldr_2760115, findi_2760138, find_2760158, exists_2760176, all_2760193, collate_2760210, toList_2760251, append_2760258, prepend_2760267, array_2760726, tabulate_2760737, sub_2760747, update_2760760, copy_2760774, copyVec_2760800, appi_2760826, app_2760843, modifyi_2760859, modify_2760879, foldli_2760898, foldri_2760920, foldl_2760943, foldr_2760965, findi_2760988, find_2761008, exists_2761026, all_2761043, collate_2761060, toList_2761101, vector_2761108, fromVector_2761120, length_2761132, sub_2761136, update_2761153, full_2761171, slice_2761177, subslice_2761212, base_2761255, copy_2761262, copyVec_2761305, isEmpty_2761335, getItem_2761340, appi_2761355, app_2761374, modifyi_2761392, modify_2761414, foldli_2761435, foldri_2761459, foldl_2761484, foldr_2761508, findi_2761533, find_2761555, exists_2761575, all_2761594, collate_2761613, vector_2761664, UnsafeMonoVector_2761675, UnsafeMonoArray_2761676, MonoVectorSlice_2761677
    do
      tabulate_2759938 = function(a_2759939)
        local n_2759941 = a_2759939[1]
        local f_2759942 = a_2759939[2]
        local tmp_2759943 = tabulate_1832962(n_2759941, f_2759942)
        local tmp_2759944 = {n_2759941, tmp_2759943}
        return tmp_2759922(tmp_2759944)
      end
      sub_2759946 = function(a_2759947)
        local v_2759949, i_2759950, tmp_2759952
        do
          v_2759949 = a_2759947[1]
          i_2759950 = a_2759947[2]
          local tmp_2759951 = 0 <= i_2759950
          do
            if tmp_2759951 then
              goto then_2763254
            else
              tmp_2759952 = false
              goto cont_2759955
            end
            ::then_2763254::
            do
              local tmp_2759956 = length_2759926(v_2759949)
              local tmp_2759957 = i_2759950 < tmp_2759956
              tmp_2759952 = tmp_2759957
            end
          end
        end
        ::cont_2759955::
        if tmp_2759952 then
          goto then_2763255
        else
          _raise(_Subscript, "mono-sequence.sml:221:22")
        end
        ::then_2763255::
        do
          local tmp_2759953 = {v_2759949, i_2759950}
          return tmp_2759920(tmp_2759953)
        end
      end
      update_2759959 = function(a_2759960)
        local tmp_2759966, tmp_2759968, tmp_2759974
        do
          local v_2759962 = a_2759960[1]
          local i_2759963 = a_2759960[2]
          local x_2759964 = a_2759960[3]
          local tmp_2759965 = {base = v_2759962, length = i_2759963, start = 0}
          tmp_2759966 = tmp_2759924(tmp_2759965)
          local tmp_2759967 = _list({n = 1, x_2759964})
          tmp_2759968 = fromList_2759927(tmp_2759967)
          local tmp_2759969 = _Int_add(i_2759963, 1)
          local tmp_2759970 = length_2759926(v_2759962)
          local tmp_2759971 = _Int_sub(tmp_2759970, i_2759963)
          local tmp_2759972 = _Int_sub(tmp_2759971, 1)
          local tmp_2759973 = {base = v_2759962, length = tmp_2759972, start = tmp_2759969}
          tmp_2759974 = tmp_2759924(tmp_2759973)
        end
        local tmp_2759975 = _list({n = 3, tmp_2759966, tmp_2759968, tmp_2759974})
        return tmp_2759928(tmp_2759975)
      end
      appi_2759980 = function(a_2759981)
        local tmp_2759983 = function(a_2759984)
          local n_2759986 = length_2759926(a_2759984)
          local tmp_2763256 = 0
          ::cont_2759987::
          do
            local a_2759988 = tmp_2763256
            local tmp_2759989 = a_2759988 >= n_2759986
            if tmp_2759989 then
              return nil
            end
            local tmp_2759990 = {a_2759984, a_2759988}
            local tmp_2759991 = tmp_2759920(tmp_2759990)
            local tmp_2759992 = {a_2759988, tmp_2759991}
            local tmp_2763257 = a_2759981(tmp_2759992)
            local tmp_2759993 = _Int_add(a_2759988, 1)
            tmp_2763256 = tmp_2759993
            goto cont_2759987
          end
        end
        return tmp_2759983
      end
      app_2759997 = function(a_2759998)
        local tmp_2760000 = function(a_2760001)
          local n_2760003 = length_2759926(a_2760001)
          local tmp_2763258 = 0
          ::cont_2760004::
          do
            local a_2760005 = tmp_2763258
            local tmp_2760006 = a_2760005 >= n_2760003
            if tmp_2760006 then
              return nil
            end
            local tmp_2760007 = {a_2760001, a_2760005}
            local tmp_2760008 = tmp_2759920(tmp_2760007)
            local tmp_2763259 = a_2759998(tmp_2760008)
            local tmp_2760009 = _Int_add(a_2760005, 1)
            tmp_2763258 = tmp_2760009
            goto cont_2760004
          end
        end
        return tmp_2760000
      end
      mapi_2760013 = function(a_2760014)
        local tmp_2760016 = function(a_2760017)
          local n_2760019 = length_2759926(a_2760017)
          local tmp_2760020 = function(i_2760021)
            local tmp_2760023 = {a_2760017, i_2760021}
            local tmp_2760024 = tmp_2759920(tmp_2760023)
            local tmp_2760025 = {i_2760021, tmp_2760024}
            return a_2760014(tmp_2760025)
          end
          local tmp_2760027 = tabulate_1832962(n_2760019, tmp_2760020)
          local tmp_2760028 = {n_2760019, tmp_2760027}
          return tmp_2759922(tmp_2760028)
        end
        return tmp_2760016
      end
      map_2760031 = function(a_2760032)
        local tmp_2760034 = function(a_2760035)
          local n_2760037 = length_2759926(a_2760035)
          local tmp_2760038 = function(i_2760039)
            local tmp_2760041 = {a_2760035, i_2760039}
            local tmp_2760042 = tmp_2759920(tmp_2760041)
            return a_2760032(tmp_2760042)
          end
          local tmp_2760044 = tabulate_1832962(n_2760037, tmp_2760038)
          local tmp_2760045 = {n_2760037, tmp_2760044}
          return tmp_2759922(tmp_2760045)
        end
        return tmp_2760034
      end
      foldli_2760048 = function(a_2760049)
        local tmp_2760051 = function(a_2760052)
          local tmp_2760054 = function(a_2760055)
            local n_2760057 = length_2759926(a_2760055)
            local tmp_2763260, tmp_2763261 = 0, a_2760052
            ::cont_2760058::
            do
              local i_2760060, acc_2760059 = tmp_2763260, tmp_2763261
              local tmp_2760061 = i_2760060 >= n_2760057
              if tmp_2760061 then
                return acc_2760059
              end
              local tmp_2760062 = _Int_add(i_2760060, 1)
              local tmp_2760063 = {a_2760055, i_2760060}
              local tmp_2760064 = tmp_2759920(tmp_2760063)
              local tmp_2760065 = {i_2760060, tmp_2760064, acc_2760059}
              local tmp_2760066 = a_2760049(tmp_2760065)
              tmp_2763260 = tmp_2760062
              tmp_2763261 = tmp_2760066
              goto cont_2760058
            end
          end
          return tmp_2760054
        end
        return tmp_2760051
      end
      foldri_2760070 = function(a_2760071)
        local tmp_2760073 = function(a_2760074)
          local tmp_2760076 = function(a_2760077)
            local tmp_2763263, tmp_2763262
            do
              local tmp_2760079 = length_2759926(a_2760077)
              local tmp_2760080 = _Int_sub(tmp_2760079, 1)
              tmp_2763262, tmp_2763263 = tmp_2760080, a_2760074
            end
            ::cont_2760081::
            do
              local i_2760083, acc_2760082 = tmp_2763262, tmp_2763263
              local tmp_2760084 = i_2760083 < 0
              if tmp_2760084 then
                return acc_2760082
              end
              local tmp_2760085 = _Int_sub(i_2760083, 1)
              local tmp_2760086 = {a_2760077, i_2760083}
              local tmp_2760087 = tmp_2759920(tmp_2760086)
              local tmp_2760088 = {i_2760083, tmp_2760087, acc_2760082}
              local tmp_2760089 = a_2760071(tmp_2760088)
              tmp_2763262 = tmp_2760085
              tmp_2763263 = tmp_2760089
              goto cont_2760081
            end
          end
          return tmp_2760076
        end
        return tmp_2760073
      end
      foldl_2760093 = function(a_2760094)
        local tmp_2760096 = function(a_2760097)
          local tmp_2760099 = function(a_2760100)
            local n_2760102 = length_2759926(a_2760100)
            local tmp_2763264, tmp_2763265 = 0, a_2760097
            ::cont_2760103::
            do
              local i_2760105, acc_2760104 = tmp_2763264, tmp_2763265
              local tmp_2760106 = i_2760105 >= n_2760102
              if tmp_2760106 then
                return acc_2760104
              end
              local tmp_2760107 = _Int_add(i_2760105, 1)
              local tmp_2760108 = {a_2760100, i_2760105}
              local tmp_2760109 = tmp_2759920(tmp_2760108)
              local tmp_2760110 = {tmp_2760109, acc_2760104}
              local tmp_2760111 = a_2760094(tmp_2760110)
              tmp_2763264 = tmp_2760107
              tmp_2763265 = tmp_2760111
              goto cont_2760103
            end
          end
          return tmp_2760099
        end
        return tmp_2760096
      end
      foldr_2760115 = function(a_2760116)
        local tmp_2760118 = function(a_2760119)
          local tmp_2760121 = function(a_2760122)
            local tmp_2763267, tmp_2763266
            do
              local tmp_2760124 = length_2759926(a_2760122)
              local tmp_2760125 = _Int_sub(tmp_2760124, 1)
              tmp_2763266, tmp_2763267 = tmp_2760125, a_2760119
            end
            ::cont_2760126::
            do
              local i_2760128, acc_2760127 = tmp_2763266, tmp_2763267
              local tmp_2760129 = i_2760128 < 0
              if tmp_2760129 then
                return acc_2760127
              end
              local tmp_2760130 = _Int_sub(i_2760128, 1)
              local tmp_2760131 = {a_2760122, i_2760128}
              local tmp_2760132 = tmp_2759920(tmp_2760131)
              local tmp_2760133 = {tmp_2760132, acc_2760127}
              local tmp_2760134 = a_2760116(tmp_2760133)
              tmp_2763266 = tmp_2760130
              tmp_2763267 = tmp_2760134
              goto cont_2760126
            end
          end
          return tmp_2760121
        end
        return tmp_2760118
      end
      findi_2760138 = function(a_2760139)
        local tmp_2760141 = function(a_2760142)
          local n_2760144 = length_2759926(a_2760142)
          local tmp_2763268 = 0
          ::cont_2760145::
          do
            local a_2760146 = tmp_2763268
            local tmp_2760147 = a_2760146 >= n_2760144
            if tmp_2760147 then
              return NONE_217
            end
            local tmp_2760148 = {a_2760142, a_2760146}
            local x_2760149 = tmp_2759920(tmp_2760148)
            local tmp_2760150 = {a_2760146, x_2760149}
            local tmp_2760151 = a_2760139(tmp_2760150)
            if tmp_2760151 then
              local tmp_2760152 = {a_2760146, x_2760149}
              local tmp_2760153 = {tag = "SOME", payload = tmp_2760152}
              return tmp_2760153
            else
              local tmp_2760154 = _Int_add(a_2760146, 1)
              tmp_2763268 = tmp_2760154
              goto cont_2760145
            end
          end
        end
        return tmp_2760141
      end
      find_2760158 = function(a_2760159)
        local tmp_2760161 = function(a_2760162)
          local n_2760164 = length_2759926(a_2760162)
          local tmp_2763269 = 0
          ::cont_2760165::
          do
            local a_2760166 = tmp_2763269
            local tmp_2760167 = a_2760166 >= n_2760164
            if tmp_2760167 then
              return NONE_217
            end
            local tmp_2760168 = {a_2760162, a_2760166}
            local x_2760169 = tmp_2759920(tmp_2760168)
            local tmp_2760170 = a_2760159(x_2760169)
            if tmp_2760170 then
              local tmp_2760171 = {tag = "SOME", payload = x_2760169}
              return tmp_2760171
            else
              local tmp_2760172 = _Int_add(a_2760166, 1)
              tmp_2763269 = tmp_2760172
              goto cont_2760165
            end
          end
        end
        return tmp_2760161
      end
      exists_2760176 = function(a_2760177)
        local tmp_2760179 = function(a_2760180)
          local n_2760182 = length_2759926(a_2760180)
          local tmp_2763270 = 0
          ::cont_2760183::
          do
            local a_2760184 = tmp_2763270
            local tmp_2760185 = a_2760184 >= n_2760182
            if tmp_2760185 then
              return false
            end
            local tmp_2760186 = {a_2760180, a_2760184}
            local tmp_2760187 = tmp_2759920(tmp_2760186)
            local tmp_2760188 = a_2760177(tmp_2760187)
            if tmp_2760188 then
              return true
            else
              local tmp_2760189 = _Int_add(a_2760184, 1)
              tmp_2763270 = tmp_2760189
              goto cont_2760183
            end
          end
        end
        return tmp_2760179
      end
      all_2760193 = function(a_2760194)
        local tmp_2760196 = function(a_2760197)
          local n_2760199 = length_2759926(a_2760197)
          local tmp_2763271 = 0
          ::cont_2760200::
          do
            local a_2760201 = tmp_2763271
            local tmp_2760202 = a_2760201 >= n_2760199
            if tmp_2760202 then
              return true
            end
            local tmp_2760203 = {a_2760197, a_2760201}
            local tmp_2760204 = tmp_2759920(tmp_2760203)
            local tmp_2760205 = a_2760194(tmp_2760204)
            if tmp_2760205 then
              local tmp_2760206 = _Int_add(a_2760201, 1)
              tmp_2763271 = tmp_2760206
              goto cont_2760200
            else
              return false
            end
          end
        end
        return tmp_2760196
      end
      collate_2760210 = function(a_2760211)
        local tmp_2760213 = function(a_2760214)
          local xs_2760216 = a_2760214[1]
          local ys_2760217 = a_2760214[2]
          local xl_2760218 = length_2759926(xs_2760216)
          local yl_2760219 = length_2759926(ys_2760217)
          local tmp_2763272 = 0
          ::cont_2760220::
          do
            local a_2760221 = tmp_2763272
            local tmp_2760222 = xl_2760218 <= a_2760221
            local tmp_2760223 = yl_2760219 <= a_2760221
            local tmp_2760224
            if tmp_2760222 then
              tmp_2760224 = tmp_2760223
            else
              tmp_2760224 = false
            end
            ::cont_2760248::
            if tmp_2760224 then
              return EQUAL_154
            end
            local tmp_2760225
            if tmp_2760222 then
              local tmp_2760247 = not tmp_2760223
              tmp_2760225 = tmp_2760247
            else
              tmp_2760225 = false
            end
            ::cont_2760246::
            local tmp_2760227
            do
              if tmp_2760225 then
                return LESS_155
              end
              local tmp_2760226 = not tmp_2760222
              if tmp_2760226 then
                tmp_2760227 = tmp_2760223
              else
                tmp_2760227 = false
              end
            end
            ::cont_2760245::
            local tmp_2760229
            do
              if tmp_2760227 then
                return GREATER_153
              end
              local tmp_2760228 = not tmp_2760222
              if tmp_2760228 then
                local tmp_2760244 = not tmp_2760223
                tmp_2760229 = tmp_2760244
              else
                tmp_2760229 = false
              end
            end
            ::cont_2760243::
            if tmp_2760229 then
              goto then_2763273
            else
              _raise(_Match, "mono-sequence.sml:310:49")
            end
            ::then_2763273::
            do
              local tmp_2760230 = {xs_2760216, a_2760221}
              local tmp_2760231 = tmp_2759920(tmp_2760230)
              local tmp_2760232 = {ys_2760217, a_2760221}
              local tmp_2760233 = tmp_2759920(tmp_2760232)
              local tmp_2760234 = {tmp_2760231, tmp_2760233}
              local exp_2760235 = a_2760211(tmp_2760234)
              local tmp_2760236 = exp_2760235
              local tmp_2760237 = tmp_2760236 == "EQUAL"
              if tmp_2760237 then
                local tmp_2760238 = _Int_add(a_2760221, 1)
                tmp_2763272 = tmp_2760238
                goto cont_2760220
              else
                return exp_2760235
              end
            end
          end
        end
        return tmp_2760213
      end
      toList_2760251 = function(a_2760252)
        local tmp_2760254 = foldr_2760115(_COLON_COLON_1)
        local tmp_2760255 = tmp_2760254(nil)
        return tmp_2760255(a_2760252)
      end
      append_2760258 = function(a_2760259)
        local v_2760261 = a_2760259[1]
        local x_2760262 = a_2760259[2]
        local tmp_2760263 = _list({n = 1, x_2760262})
        local tmp_2760264 = fromList_2759927(tmp_2760263)
        local tmp_2760265 = _list({n = 2, v_2760261, tmp_2760264})
        return tmp_2759928(tmp_2760265)
      end
      prepend_2760267 = function(a_2760268)
        local x_2760270 = a_2760268[1]
        local v_2760271 = a_2760268[2]
        local tmp_2760272 = _list({n = 1, x_2760270})
        local tmp_2760273 = fromList_2759927(tmp_2760272)
        local tmp_2760274 = _list({n = 2, tmp_2760273, v_2760271})
        return tmp_2759928(tmp_2760274)
      end
      local length_2760276 = function(tmp_2760277)
        local tmp_2760279 = tmp_2760277.length
        return tmp_2760279
      end
      local sub_2760280 = function(a_2760281)
        local base_2760284, start_2760286, i_2760289, tmp_2760291
        do
          local tmp_2760283 = a_2760281[1]
          base_2760284 = tmp_2760283.base
          local tmp_2760285 = a_2760281[1]
          start_2760286 = tmp_2760285.start
          local tmp_2760287 = a_2760281[1]
          local length_2760288 = tmp_2760287.length
          i_2760289 = a_2760281[2]
          local tmp_2760290 = 0 <= i_2760289
          if tmp_2760290 then
            local tmp_2760296 = i_2760289 < length_2760288
            tmp_2760291 = tmp_2760296
          else
            tmp_2760291 = false
          end
        end
        ::cont_2760295::
        if tmp_2760291 then
          goto then_2763274
        else
          _raise(_Subscript, "mono-sequence.sml:331:44")
        end
        ::then_2763274::
        do
          local tmp_2760292 = _Int_add(start_2760286, i_2760289)
          local tmp_2760293 = {base_2760284, tmp_2760292}
          return tmp_2759920(tmp_2760293)
        end
      end
      local full_2760297 = function(a_2760298)
        local tmp_2760300 = length_2759926(a_2760298)
        local tmp_2760301 = {base = a_2760298, length = tmp_2760300, start = 0}
        return tmp_2760301
      end
      local slice_2760303 = function(a_2760304)
        do
          local tmp_2760306 = a_2760304[3]
          local tmp_2760307 = tmp_2760306.tag
          local tmp_2760308 = tmp_2760307 == "NONE"
          if tmp_2760308 then
            goto then_2763275
          else
            goto else_2763276
          end
        end
        ::then_2763275::
        do
          local v_2760309, i_2760310, n_2760311, tmp_2760313
          do
            v_2760309 = a_2760304[1]
            i_2760310 = a_2760304[2]
            n_2760311 = length_2759926(v_2760309)
            local tmp_2760312 = 0 <= i_2760310
            if tmp_2760312 then
              local tmp_2760318 = i_2760310 <= n_2760311
              tmp_2760313 = tmp_2760318
            else
              tmp_2760313 = false
            end
          end
          ::cont_2760317::
          if tmp_2760313 then
            local tmp_2760314 = _Int_sub(n_2760311, i_2760310)
            local tmp_2760315 = {base = v_2760309, length = tmp_2760314, start = i_2760310}
            return tmp_2760315
          else
            _raise(_Subscript, "mono-sequence.sml:337:33")
          end
        end
        ::else_2763276::
        do
          local tmp_2760320 = a_2760304[3]
          local tmp_2760321 = tmp_2760320.tag
          local tmp_2760322 = tmp_2760321 == "SOME"
          if tmp_2760322 then
            goto then_2763277
          else
            _raise(_Match, "mono-sequence.sml:333:5")
          end
        end
        ::then_2763277::
        do
          local v_2760323, i_2760324, n_2760326, tmp_2760328
          do
            v_2760323 = a_2760304[1]
            i_2760324 = a_2760304[2]
            local tmp_2760325 = a_2760304[3]
            n_2760326 = tmp_2760325.payload
            local tmp_2760327 = 0 <= i_2760324
            do
              if tmp_2760327 then
                goto then_2763278
              else
                tmp_2760328 = false
                goto cont_2760331
              end
              ::then_2763278::
              do
                do
                  local tmp_2760332 = 0 <= n_2760326
                  if tmp_2760332 then
                    goto then_2763279
                  else
                    tmp_2760328 = false
                    goto cont_2760331
                  end
                end
                ::then_2763279::
                do
                  local tmp_2760333 = _Int_add(i_2760324, n_2760326)
                  local tmp_2760334 = length_2759926(v_2760323)
                  local tmp_2760335 = tmp_2760333 <= tmp_2760334
                  tmp_2760328 = tmp_2760335
                end
              end
            end
          end
          ::cont_2760331::
          if tmp_2760328 then
            local tmp_2760329 = {base = v_2760323, length = n_2760326, start = i_2760324}
            return tmp_2760329
          else
            _raise(_Subscript, "mono-sequence.sml:342:32")
          end
        end
      end
      local subslice_2760338 = function(a_2760339)
        local tmp_2760341 = a_2760339[3]
        local tmp_2760342 = tmp_2760341.tag
        local tmp_2760343 = tmp_2760342 == "NONE"
        if tmp_2760343 then
          local base_2760345, start_2760347, length_2760349, i_2760350, tmp_2760352
          do
            local tmp_2760344 = a_2760339[1]
            base_2760345 = tmp_2760344.base
            local tmp_2760346 = a_2760339[1]
            start_2760347 = tmp_2760346.start
            local tmp_2760348 = a_2760339[1]
            length_2760349 = tmp_2760348.length
            i_2760350 = a_2760339[2]
            local tmp_2760351 = 0 <= i_2760350
            if tmp_2760351 then
              local tmp_2760358 = i_2760350 <= length_2760349
              tmp_2760352 = tmp_2760358
            else
              tmp_2760352 = false
            end
          end
          ::cont_2760357::
          if tmp_2760352 then
            local tmp_2760353 = _Int_add(start_2760347, i_2760350)
            local tmp_2760354 = _Int_sub(length_2760349, i_2760350)
            local tmp_2760355 = {base = base_2760345, length = tmp_2760354, start = tmp_2760353}
            return tmp_2760355
          else
            _raise(_Subscript, "mono-sequence.sml:346:55")
          end
        end
        local tmp_2760359 = a_2760339[3]
        local tmp_2760360 = tmp_2760359.tag
        local tmp_2760361 = tmp_2760360 == "SOME"
        if tmp_2760361 then
          local base_2760363, start_2760365, i_2760368, n_2760370, tmp_2760372
          do
            local tmp_2760362 = a_2760339[1]
            base_2760363 = tmp_2760362.base
            local tmp_2760364 = a_2760339[1]
            start_2760365 = tmp_2760364.start
            local tmp_2760366 = a_2760339[1]
            local length_2760367 = tmp_2760366.length
            i_2760368 = a_2760339[2]
            local tmp_2760369 = a_2760339[3]
            n_2760370 = tmp_2760369.payload
            local tmp_2760371 = 0 <= i_2760368
            if tmp_2760371 then
              local tmp_2760377 = 0 <= n_2760370
              if tmp_2760377 then
                local tmp_2760378 = _Int_add(i_2760368, n_2760370)
                local tmp_2760379 = tmp_2760378 <= length_2760367
                tmp_2760372 = tmp_2760379
              else
                tmp_2760372 = false
              end
            else
              tmp_2760372 = false
            end
          end
          ::cont_2760376::
          if tmp_2760372 then
            local tmp_2760373 = _Int_add(start_2760365, i_2760368)
            local tmp_2760374 = {base = base_2760363, length = n_2760370, start = tmp_2760373}
            return tmp_2760374
          else
            _raise(_Subscript, "mono-sequence.sml:350:57")
          end
        else
          _raise(_Match, "mono-sequence.sml:343:5")
        end
      end
      local base_2760381 = function(a_2760382)
        local b_2760384 = a_2760382.base
        local start_2760385 = a_2760382.start
        local length_2760386 = a_2760382.length
        local tmp_2760387 = {b_2760384, start_2760385, length_2760386}
        return tmp_2760387
      end
      local concat_2760388 = function(a_2760389)
        local tmp_2760391 = map_454(tmp_2759924)
        local tmp_2760392 = tmp_2760391(a_2760389)
        return tmp_2759928(tmp_2760392)
      end
      local isEmpty_2760395 = function(a_2760396)
        local length_2760398 = a_2760396.length
        local tmp_2760399 = length_2760398 == 0
        return tmp_2760399
      end
      local getItem_2760400 = function(a_2760401)
        local base_2760403, start_2760404, length_2760405
        do
          base_2760403 = a_2760401.base
          start_2760404 = a_2760401.start
          length_2760405 = a_2760401.length
          local tmp_2760406 = length_2760405 > 0
          if tmp_2760406 then
            goto then_2763280
          else
            return NONE_217
          end
        end
        ::then_2763280::
        do
          local tmp_2760407 = {base_2760403, start_2760404}
          local tmp_2760408 = tmp_2759920(tmp_2760407)
          local tmp_2760409 = _Int_add(start_2760404, 1)
          local tmp_2760410 = _Int_sub(length_2760405, 1)
          local tmp_2760411 = {base = base_2760403, length = tmp_2760410, start = tmp_2760409}
          local tmp_2760412 = {tmp_2760408, tmp_2760411}
          local tmp_2760413 = {tag = "SOME", payload = tmp_2760412}
          return tmp_2760413
        end
      end
      local appi_2760415 = function(a_2760416)
        local tmp_2760418 = function(a_2760419)
          local base_2760421 = a_2760419.base
          local start_2760422 = a_2760419.start
          local length_2760423 = a_2760419.length
          local tmp_2763281 = 0
          ::cont_2760424::
          do
            local a_2760425 = tmp_2763281
            local tmp_2760426 = a_2760425 >= length_2760423
            if tmp_2760426 then
              return nil
            end
            local tmp_2760427 = _Int_add(start_2760422, a_2760425)
            local tmp_2760428 = {base_2760421, tmp_2760427}
            local tmp_2760429 = tmp_2759920(tmp_2760428)
            local tmp_2760430 = {a_2760425, tmp_2760429}
            local tmp_2763282 = a_2760416(tmp_2760430)
            local tmp_2760431 = _Int_add(a_2760425, 1)
            tmp_2763281 = tmp_2760431
            goto cont_2760424
          end
        end
        return tmp_2760418
      end
      local app_2760434 = function(a_2760435)
        local tmp_2760437 = function(a_2760438)
          local base_2760440, tmp_2760443, tmp_2763283
          do
            base_2760440 = a_2760438.base
            local start_2760441 = a_2760438.start
            local length_2760442 = a_2760438.length
            tmp_2760443 = _Int_add(start_2760441, length_2760442)
            tmp_2763283 = start_2760441
          end
          ::cont_2760444::
          do
            local a_2760445 = tmp_2763283
            local tmp_2760446 = a_2760445 >= tmp_2760443
            if tmp_2760446 then
              return nil
            end
            local tmp_2760447 = {base_2760440, a_2760445}
            local tmp_2760448 = tmp_2759920(tmp_2760447)
            local tmp_2763284 = a_2760435(tmp_2760448)
            local tmp_2760449 = _Int_add(a_2760445, 1)
            tmp_2763283 = tmp_2760449
            goto cont_2760444
          end
        end
        return tmp_2760437
      end
      local mapi_2760452 = function(a_2760453)
        local tmp_2760455 = function(a_2760456)
          local base_2760458 = a_2760456.base
          local start_2760459 = a_2760456.start
          local length_2760460 = a_2760456.length
          local tmp_2763285, tmp_2763286 = 0, nil
          ::cont_2760461::
          do
            local acc_2760462, i_2760463
            do
              i_2760463, acc_2760462 = tmp_2763285, tmp_2763286
              local tmp_2760464 = i_2760463 >= length_2760460
              if tmp_2760464 then
                goto then_2763287
              else
                goto else_2763288
              end
            end
            ::then_2763287::
            do
              local tmp_2760465 = {length_2760460, acc_2760462}
              return tmp_2759921(tmp_2760465)
            end
            ::else_2763288::
            local tmp_2760466 = _Int_add(i_2760463, 1)
            local tmp_2760467 = _Int_add(start_2760459, i_2760463)
            local tmp_2760468 = {base_2760458, tmp_2760467}
            local tmp_2760469 = tmp_2759920(tmp_2760468)
            local tmp_2760470 = {i_2760463, tmp_2760469}
            local tmp_2760471 = a_2760453(tmp_2760470)
            local tmp_2760472 = {tmp_2760471, acc_2760462}
            tmp_2763285 = tmp_2760466
            tmp_2763286 = tmp_2760472
            goto cont_2760461
          end
        end
        return tmp_2760455
      end
      local map_2760475 = function(a_2760476)
        local tmp_2760478 = function(a_2760479)
          local base_2760481, length_2760483, tmp_2760484, tmp_2763290, tmp_2763289
          do
            base_2760481 = a_2760479.base
            local start_2760482 = a_2760479.start
            length_2760483 = a_2760479.length
            tmp_2760484 = _Int_add(start_2760482, length_2760483)
            tmp_2763289, tmp_2763290 = start_2760482, nil
          end
          ::cont_2760485::
          do
            local acc_2760486, i_2760487
            do
              i_2760487, acc_2760486 = tmp_2763289, tmp_2763290
              local tmp_2760488 = i_2760487 >= tmp_2760484
              if tmp_2760488 then
                goto then_2763291
              else
                goto else_2763292
              end
            end
            ::then_2763291::
            do
              local tmp_2760489 = {length_2760483, acc_2760486}
              return tmp_2759921(tmp_2760489)
            end
            ::else_2763292::
            local tmp_2760490 = _Int_add(i_2760487, 1)
            local tmp_2760491 = {base_2760481, i_2760487}
            local tmp_2760492 = tmp_2759920(tmp_2760491)
            local tmp_2760493 = a_2760476(tmp_2760492)
            local tmp_2760494 = {tmp_2760493, acc_2760486}
            tmp_2763289 = tmp_2760490
            tmp_2763290 = tmp_2760494
            goto cont_2760485
          end
        end
        return tmp_2760478
      end
      local foldli_2760497 = function(a_2760498)
        local tmp_2760500 = function(a_2760501)
          local tmp_2760503 = function(a_2760504)
            local base_2760506 = a_2760504.base
            local start_2760507 = a_2760504.start
            local length_2760508 = a_2760504.length
            local tmp_2763293, tmp_2763294 = 0, a_2760501
            ::cont_2760509::
            do
              local i_2760511, acc_2760510 = tmp_2763293, tmp_2763294
              local tmp_2760512 = i_2760511 >= length_2760508
              if tmp_2760512 then
                return acc_2760510
              end
              local tmp_2760513 = _Int_add(i_2760511, 1)
              local tmp_2760514 = _Int_add(start_2760507, i_2760511)
              local tmp_2760515 = {base_2760506, tmp_2760514}
              local tmp_2760516 = tmp_2759920(tmp_2760515)
              local tmp_2760517 = {i_2760511, tmp_2760516, acc_2760510}
              local tmp_2760518 = a_2760498(tmp_2760517)
              tmp_2763293 = tmp_2760513
              tmp_2763294 = tmp_2760518
              goto cont_2760509
            end
          end
          return tmp_2760503
        end
        return tmp_2760500
      end
      local foldri_2760521 = function(a_2760522)
        local tmp_2760524 = function(a_2760525)
          local tmp_2760527 = function(a_2760528)
            local base_2760530, start_2760531, tmp_2763296, tmp_2763295
            do
              base_2760530 = a_2760528.base
              start_2760531 = a_2760528.start
              local length_2760532 = a_2760528.length
              local tmp_2760533 = _Int_sub(length_2760532, 1)
              tmp_2763295, tmp_2763296 = tmp_2760533, a_2760525
            end
            ::cont_2760534::
            do
              local i_2760536, acc_2760535 = tmp_2763295, tmp_2763296
              local tmp_2760537 = i_2760536 < 0
              if tmp_2760537 then
                return acc_2760535
              end
              local tmp_2760538 = _Int_sub(i_2760536, 1)
              local tmp_2760539 = _Int_add(start_2760531, i_2760536)
              local tmp_2760540 = {base_2760530, tmp_2760539}
              local tmp_2760541 = tmp_2759920(tmp_2760540)
              local tmp_2760542 = {i_2760536, tmp_2760541, acc_2760535}
              local tmp_2760543 = a_2760522(tmp_2760542)
              tmp_2763295 = tmp_2760538
              tmp_2763296 = tmp_2760543
              goto cont_2760534
            end
          end
          return tmp_2760527
        end
        return tmp_2760524
      end
      local foldl_2760546 = function(a_2760547)
        local tmp_2760549 = function(a_2760550)
          local tmp_2760552 = function(a_2760553)
            local base_2760555, tmp_2760558, tmp_2763298, tmp_2763297
            do
              base_2760555 = a_2760553.base
              local start_2760556 = a_2760553.start
              local length_2760557 = a_2760553.length
              tmp_2760558 = _Int_add(start_2760556, length_2760557)
              tmp_2763297, tmp_2763298 = start_2760556, a_2760550
            end
            ::cont_2760559::
            do
              local i_2760561, acc_2760560 = tmp_2763297, tmp_2763298
              local tmp_2760562 = i_2760561 >= tmp_2760558
              if tmp_2760562 then
                return acc_2760560
              end
              local tmp_2760563 = _Int_add(i_2760561, 1)
              local tmp_2760564 = {base_2760555, i_2760561}
              local tmp_2760565 = tmp_2759920(tmp_2760564)
              local tmp_2760566 = {tmp_2760565, acc_2760560}
              local tmp_2760567 = a_2760547(tmp_2760566)
              tmp_2763297 = tmp_2760563
              tmp_2763298 = tmp_2760567
              goto cont_2760559
            end
          end
          return tmp_2760552
        end
        return tmp_2760549
      end
      local foldr_2760570 = function(a_2760571)
        local tmp_2760573 = function(a_2760574)
          local tmp_2760576 = function(a_2760577)
            local base_2760579, start_2760580, tmp_2763300, tmp_2763299
            do
              base_2760579 = a_2760577.base
              start_2760580 = a_2760577.start
              local length_2760581 = a_2760577.length
              local tmp_2760582 = _Int_add(start_2760580, length_2760581)
              local tmp_2760583 = _Int_sub(tmp_2760582, 1)
              tmp_2763299, tmp_2763300 = tmp_2760583, a_2760574
            end
            ::cont_2760584::
            do
              local i_2760586, acc_2760585 = tmp_2763299, tmp_2763300
              local tmp_2760587 = i_2760586 < start_2760580
              if tmp_2760587 then
                return acc_2760585
              end
              local tmp_2760588 = _Int_sub(i_2760586, 1)
              local tmp_2760589 = {base_2760579, i_2760586}
              local tmp_2760590 = tmp_2759920(tmp_2760589)
              local tmp_2760591 = {tmp_2760590, acc_2760585}
              local tmp_2760592 = a_2760571(tmp_2760591)
              tmp_2763299 = tmp_2760588
              tmp_2763300 = tmp_2760592
              goto cont_2760584
            end
          end
          return tmp_2760576
        end
        return tmp_2760573
      end
      local findi_2760595 = function(a_2760596)
        local tmp_2760598 = function(a_2760599)
          local base_2760601 = a_2760599.base
          local start_2760602 = a_2760599.start
          local length_2760603 = a_2760599.length
          local tmp_2763301 = 0
          ::cont_2760604::
          do
            local a_2760605 = tmp_2763301
            local tmp_2760606 = a_2760605 >= length_2760603
            if tmp_2760606 then
              return NONE_217
            end
            local tmp_2760607 = _Int_add(start_2760602, a_2760605)
            local tmp_2760608 = {base_2760601, tmp_2760607}
            local x_2760609 = tmp_2759920(tmp_2760608)
            local tmp_2760610 = {a_2760605, x_2760609}
            local tmp_2760611 = a_2760596(tmp_2760610)
            if tmp_2760611 then
              local tmp_2760612 = {a_2760605, x_2760609}
              local tmp_2760613 = {tag = "SOME", payload = tmp_2760612}
              return tmp_2760613
            else
              local tmp_2760614 = _Int_add(a_2760605, 1)
              tmp_2763301 = tmp_2760614
              goto cont_2760604
            end
          end
        end
        return tmp_2760598
      end
      local find_2760617 = function(a_2760618)
        local tmp_2760620 = function(a_2760621)
          local base_2760623, tmp_2760626, tmp_2763302
          do
            base_2760623 = a_2760621.base
            local start_2760624 = a_2760621.start
            local length_2760625 = a_2760621.length
            tmp_2760626 = _Int_add(start_2760624, length_2760625)
            tmp_2763302 = start_2760624
          end
          ::cont_2760627::
          do
            local a_2760628 = tmp_2763302
            local tmp_2760629 = a_2760628 >= tmp_2760626
            if tmp_2760629 then
              return NONE_217
            end
            local tmp_2760630 = {base_2760623, a_2760628}
            local x_2760631 = tmp_2759920(tmp_2760630)
            local tmp_2760632 = a_2760618(x_2760631)
            if tmp_2760632 then
              local tmp_2760633 = {tag = "SOME", payload = x_2760631}
              return tmp_2760633
            else
              local tmp_2760634 = _Int_add(a_2760628, 1)
              tmp_2763302 = tmp_2760634
              goto cont_2760627
            end
          end
        end
        return tmp_2760620
      end
      local exists_2760637 = function(a_2760638)
        local tmp_2760640 = function(a_2760641)
          local base_2760643, tmp_2760646, tmp_2763303
          do
            base_2760643 = a_2760641.base
            local start_2760644 = a_2760641.start
            local length_2760645 = a_2760641.length
            tmp_2760646 = _Int_add(start_2760644, length_2760645)
            tmp_2763303 = start_2760644
          end
          ::cont_2760647::
          do
            local a_2760648 = tmp_2763303
            local tmp_2760649 = a_2760648 >= tmp_2760646
            if tmp_2760649 then
              return false
            end
            local tmp_2760650 = {base_2760643, a_2760648}
            local tmp_2760651 = tmp_2759920(tmp_2760650)
            local tmp_2760652 = a_2760638(tmp_2760651)
            if tmp_2760652 then
              return true
            else
              local tmp_2760653 = _Int_add(a_2760648, 1)
              tmp_2763303 = tmp_2760653
              goto cont_2760647
            end
          end
        end
        return tmp_2760640
      end
      local all_2760656 = function(a_2760657)
        local tmp_2760659 = function(a_2760660)
          local base_2760662, tmp_2760665, tmp_2763304
          do
            base_2760662 = a_2760660.base
            local start_2760663 = a_2760660.start
            local length_2760664 = a_2760660.length
            tmp_2760665 = _Int_add(start_2760663, length_2760664)
            tmp_2763304 = start_2760663
          end
          ::cont_2760666::
          do
            local a_2760667 = tmp_2763304
            local tmp_2760668 = a_2760667 >= tmp_2760665
            if tmp_2760668 then
              return true
            end
            local tmp_2760669 = {base_2760662, a_2760667}
            local tmp_2760670 = tmp_2759920(tmp_2760669)
            local tmp_2760671 = a_2760657(tmp_2760670)
            if tmp_2760671 then
              local tmp_2760672 = _Int_add(a_2760667, 1)
              tmp_2763304 = tmp_2760672
              goto cont_2760666
            else
              return false
            end
          end
        end
        return tmp_2760659
      end
      local collate_2760675 = function(a_2760676)
        local tmp_2760678 = function(a_2760679)
          local base_2760682, base_PRIME_2760688, tmp_2760693, tmp_2760694, tmp_2763306, tmp_2763305
          do
            local tmp_2760681 = a_2760679[1]
            base_2760682 = tmp_2760681.base
            local tmp_2760683 = a_2760679[1]
            local start_2760684 = tmp_2760683.start
            local tmp_2760685 = a_2760679[1]
            local length_2760686 = tmp_2760685.length
            local tmp_2760687 = a_2760679[2]
            base_PRIME_2760688 = tmp_2760687.base
            local tmp_2760689 = a_2760679[2]
            local start_PRIME_2760690 = tmp_2760689.start
            local tmp_2760691 = a_2760679[2]
            local length_PRIME_2760692 = tmp_2760691.length
            tmp_2760693 = _Int_add(start_2760684, length_2760686)
            tmp_2760694 = _Int_add(start_PRIME_2760690, length_PRIME_2760692)
            tmp_2763305, tmp_2763306 = start_2760684, start_PRIME_2760690
          end
          ::cont_2760695::
          do
            local i_2760697, j_2760696 = tmp_2763305, tmp_2763306
            local tmp_2760698 = tmp_2760693 <= i_2760697
            local tmp_2760699 = tmp_2760694 <= j_2760696
            local tmp_2760700
            if tmp_2760698 then
              tmp_2760700 = tmp_2760699
            else
              tmp_2760700 = false
            end
            ::cont_2760725::
            if tmp_2760700 then
              return EQUAL_154
            end
            local tmp_2760701
            if tmp_2760698 then
              local tmp_2760724 = not tmp_2760699
              tmp_2760701 = tmp_2760724
            else
              tmp_2760701 = false
            end
            ::cont_2760723::
            local tmp_2760703
            do
              if tmp_2760701 then
                return LESS_155
              end
              local tmp_2760702 = not tmp_2760698
              if tmp_2760702 then
                tmp_2760703 = tmp_2760699
              else
                tmp_2760703 = false
              end
            end
            ::cont_2760722::
            local tmp_2760705
            do
              if tmp_2760703 then
                return GREATER_153
              end
              local tmp_2760704 = not tmp_2760698
              if tmp_2760704 then
                local tmp_2760721 = not tmp_2760699
                tmp_2760705 = tmp_2760721
              else
                tmp_2760705 = false
              end
            end
            ::cont_2760720::
            if tmp_2760705 then
              goto then_2763307
            else
              _raise(_Match, "mono-sequence.sml:454:29")
            end
            ::then_2763307::
            do
              local tmp_2760706 = {base_2760682, i_2760697}
              local tmp_2760707 = tmp_2759920(tmp_2760706)
              local tmp_2760708 = {base_PRIME_2760688, j_2760696}
              local tmp_2760709 = tmp_2759920(tmp_2760708)
              local tmp_2760710 = {tmp_2760707, tmp_2760709}
              local exp_2760711 = a_2760676(tmp_2760710)
              local tmp_2760712 = exp_2760711
              local tmp_2760713 = tmp_2760712 == "EQUAL"
              if tmp_2760713 then
                local tmp_2760714 = _Int_add(i_2760697, 1)
                local tmp_2760715 = _Int_add(j_2760696, 1)
                tmp_2763305 = tmp_2760714
                tmp_2763306 = tmp_2760715
                goto cont_2760695
              else
                return exp_2760711
              end
            end
          end
        end
        return tmp_2760678
      end
      array_2760726 = function(a_2760727)
        local n_2760729, init_2760730, tmp_2760732
        do
          n_2760729 = a_2760727[1]
          init_2760730 = a_2760727[2]
          local tmp_2760731 = n_2760729 < 0
          if tmp_2760731 then
            tmp_2760732 = true
          else
            local tmp_2760736 = maxLen_2759934 < n_2760729
            tmp_2760732 = tmp_2760736
          end
        end
        ::cont_2760735::
        if tmp_2760732 then
          _raise(_Size, "mono-sequence.sml:470:27")
        else
          local tmp_2760734 = {n_2760729, init_2760730}
          return tmp_2759933(tmp_2760734)
        end
      end
      tabulate_2760737 = function(a_2760738)
        local n_2760740 = a_2760738[1]
        local f_2760741 = a_2760738[2]
        local tmp_2760742 = maxLen_2759934 < n_2760740
        if tmp_2760742 then
          _raise(_Size, "mono-sequence.sml:475:27")
        end
        local tmp_2760744 = tabulate_1832962(n_2760740, f_2760741)
        local tmp_2760745 = {n_2760740, tmp_2760744}
        return tmp_2759931(tmp_2760745)
      end
      sub_2760747 = function(a_2760748)
        local a_2760750, i_2760751, tmp_2760753
        do
          a_2760750 = a_2760748[1]
          i_2760751 = a_2760748[2]
          local tmp_2760752 = 0 <= i_2760751
          do
            if tmp_2760752 then
              goto then_2763308
            else
              tmp_2760753 = false
              goto cont_2760756
            end
            ::then_2763308::
            do
              local tmp_2760757 = length_2759935(a_2760750)
              local tmp_2760758 = i_2760751 < tmp_2760757
              tmp_2760753 = tmp_2760758
            end
          end
        end
        ::cont_2760756::
        if tmp_2760753 then
          goto then_2763309
        else
          _raise(_Subscript, "mono-sequence.sml:482:22")
        end
        ::then_2763309::
        do
          local tmp_2760754 = {a_2760750, i_2760751}
          return tmp_2759930(tmp_2760754)
        end
      end
      update_2760760 = function(a_2760761)
        local a_2760763, i_2760764, x_2760765, tmp_2760767
        do
          a_2760763 = a_2760761[1]
          i_2760764 = a_2760761[2]
          x_2760765 = a_2760761[3]
          local tmp_2760766 = 0 <= i_2760764
          do
            if tmp_2760766 then
              goto then_2763310
            else
              tmp_2760767 = false
              goto cont_2760770
            end
            ::then_2763310::
            do
              local tmp_2760771 = length_2759935(a_2760763)
              local tmp_2760772 = i_2760764 < tmp_2760771
              tmp_2760767 = tmp_2760772
            end
          end
        end
        ::cont_2760770::
        if tmp_2760767 then
          goto then_2763311
        else
          _raise(_Subscript, "mono-sequence.sml:486:28")
        end
        ::then_2763311::
        do
          local tmp_2760768 = {a_2760763, i_2760764, x_2760765}
          return tmp_2759929(tmp_2760768)
        end
      end
      copy_2760774 = function(a_2760775)
        local src_2760777, dst_2760778, di_2760779, srcLen_2760780, tmp_2760782
        do
          src_2760777 = a_2760775.src
          dst_2760778 = a_2760775.dst
          di_2760779 = a_2760775.di
          srcLen_2760780 = length_2759935(src_2760777)
          local tmp_2760781 = 0 <= di_2760779
          do
            if tmp_2760781 then
              goto then_2763312
            else
              tmp_2760782 = false
              goto cont_2760794
            end
            ::then_2763312::
            do
              local tmp_2760795 = _Int_add(di_2760779, srcLen_2760780)
              local tmp_2760796 = length_2759935(dst_2760778)
              local tmp_2760797 = tmp_2760795 <= tmp_2760796
              tmp_2760782 = tmp_2760797
            end
          end
        end
        ::cont_2760794::
        if tmp_2760782 then
          goto then_2763313
        else
          _raise(_Subscript, "mono-sequence.sml:499:36")
        end
        ::then_2763313::
        do
          local tmp_2763314 = 0
          ::cont_2760783::
          do
            local a_2760784 = tmp_2763314
            local tmp_2760785 = a_2760784 >= srcLen_2760780
            if tmp_2760785 then
              return nil
            end
            local tmp_2760786 = _Int_add(di_2760779, a_2760784)
            local tmp_2760787 = {src_2760777, a_2760784}
            local tmp_2760788 = tmp_2759930(tmp_2760787)
            local tmp_2760789 = {dst_2760778, tmp_2760786, tmp_2760788}
            local tmp_2763315 = tmp_2759929(tmp_2760789)
            local tmp_2760790 = _Int_add(a_2760784, 1)
            tmp_2763314 = tmp_2760790
            goto cont_2760783
          end
        end
      end
      copyVec_2760800 = function(a_2760801)
        local src_2760803, dst_2760804, di_2760805, srcLen_2760806, tmp_2760808
        do
          src_2760803 = a_2760801.src
          dst_2760804 = a_2760801.dst
          di_2760805 = a_2760801.di
          srcLen_2760806 = length_2759926(src_2760803)
          local tmp_2760807 = 0 <= di_2760805
          do
            if tmp_2760807 then
              goto then_2763316
            else
              tmp_2760808 = false
              goto cont_2760820
            end
            ::then_2763316::
            do
              local tmp_2760821 = _Int_add(di_2760805, srcLen_2760806)
              local tmp_2760822 = length_2759935(dst_2760804)
              local tmp_2760823 = tmp_2760821 <= tmp_2760822
              tmp_2760808 = tmp_2760823
            end
          end
        end
        ::cont_2760820::
        if tmp_2760808 then
          goto then_2763317
        else
          _raise(_Subscript, "mono-sequence.sml:513:39")
        end
        ::then_2763317::
        do
          local tmp_2763318 = 0
          ::cont_2760809::
          do
            local a_2760810 = tmp_2763318
            local tmp_2760811 = a_2760810 >= srcLen_2760806
            if tmp_2760811 then
              return nil
            end
            local tmp_2760812 = _Int_add(di_2760805, a_2760810)
            local tmp_2760813 = {src_2760803, a_2760810}
            local tmp_2760814 = tmp_2759920(tmp_2760813)
            local tmp_2760815 = {dst_2760804, tmp_2760812, tmp_2760814}
            local tmp_2763319 = tmp_2759929(tmp_2760815)
            local tmp_2760816 = _Int_add(a_2760810, 1)
            tmp_2763318 = tmp_2760816
            goto cont_2760809
          end
        end
      end
      appi_2760826 = function(a_2760827)
        local tmp_2760829 = function(a_2760830)
          local n_2760832 = length_2759935(a_2760830)
          local tmp_2763320 = 0
          ::cont_2760833::
          do
            local a_2760834 = tmp_2763320
            local tmp_2760835 = a_2760834 >= n_2760832
            if tmp_2760835 then
              return nil
            end
            local tmp_2760836 = {a_2760830, a_2760834}
            local tmp_2760837 = tmp_2759930(tmp_2760836)
            local tmp_2760838 = {a_2760834, tmp_2760837}
            local tmp_2763321 = a_2760827(tmp_2760838)
            local tmp_2760839 = _Int_add(a_2760834, 1)
            tmp_2763320 = tmp_2760839
            goto cont_2760833
          end
        end
        return tmp_2760829
      end
      app_2760843 = function(a_2760844)
        local tmp_2760846 = function(a_2760847)
          local n_2760849 = length_2759935(a_2760847)
          local tmp_2763322 = 0
          ::cont_2760850::
          do
            local a_2760851 = tmp_2763322
            local tmp_2760852 = a_2760851 >= n_2760849
            if tmp_2760852 then
              return nil
            end
            local tmp_2760853 = {a_2760847, a_2760851}
            local tmp_2760854 = tmp_2759930(tmp_2760853)
            local tmp_2763323 = a_2760844(tmp_2760854)
            local tmp_2760855 = _Int_add(a_2760851, 1)
            tmp_2763322 = tmp_2760855
            goto cont_2760850
          end
        end
        return tmp_2760846
      end
      modifyi_2760859 = function(a_2760860)
        local tmp_2760862 = function(a_2760863)
          local n_2760865 = length_2759935(a_2760863)
          local tmp_2763324 = 0
          ::cont_2760866::
          do
            local a_2760867 = tmp_2763324
            local tmp_2760868 = a_2760867 >= n_2760865
            if tmp_2760868 then
              return nil
            end
            local tmp_2760869 = {a_2760863, a_2760867}
            local x_2760870 = tmp_2759930(tmp_2760869)
            local tmp_2760871 = {a_2760867, x_2760870}
            local y_2760872 = a_2760860(tmp_2760871)
            local tmp_2760873 = {a_2760863, a_2760867, y_2760872}
            local tmp_2763325 = tmp_2759929(tmp_2760873)
            local tmp_2760874 = _Int_add(a_2760867, 1)
            tmp_2763324 = tmp_2760874
            goto cont_2760866
          end
        end
        return tmp_2760862
      end
      modify_2760879 = function(a_2760880)
        local tmp_2760882 = function(a_2760883)
          local n_2760885 = length_2759935(a_2760883)
          local tmp_2763326 = 0
          ::cont_2760886::
          do
            local a_2760887 = tmp_2763326
            local tmp_2760888 = a_2760887 >= n_2760885
            if tmp_2760888 then
              return nil
            end
            local tmp_2760889 = {a_2760883, a_2760887}
            local x_2760890 = tmp_2759930(tmp_2760889)
            local y_2760891 = a_2760880(x_2760890)
            local tmp_2760892 = {a_2760883, a_2760887, y_2760891}
            local tmp_2763327 = tmp_2759929(tmp_2760892)
            local tmp_2760893 = _Int_add(a_2760887, 1)
            tmp_2763326 = tmp_2760893
            goto cont_2760886
          end
        end
        return tmp_2760882
      end
      foldli_2760898 = function(a_2760899)
        local tmp_2760901 = function(a_2760902)
          local tmp_2760904 = function(a_2760905)
            local n_2760907 = length_2759935(a_2760905)
            local tmp_2763328, tmp_2763329 = 0, a_2760902
            ::cont_2760908::
            do
              local i_2760910, acc_2760909 = tmp_2763328, tmp_2763329
              local tmp_2760911 = i_2760910 >= n_2760907
              if tmp_2760911 then
                return acc_2760909
              end
              local tmp_2760912 = _Int_add(i_2760910, 1)
              local tmp_2760913 = {a_2760905, i_2760910}
              local tmp_2760914 = tmp_2759930(tmp_2760913)
              local tmp_2760915 = {i_2760910, tmp_2760914, acc_2760909}
              local tmp_2760916 = a_2760899(tmp_2760915)
              tmp_2763328 = tmp_2760912
              tmp_2763329 = tmp_2760916
              goto cont_2760908
            end
          end
          return tmp_2760904
        end
        return tmp_2760901
      end
      foldri_2760920 = function(a_2760921)
        local tmp_2760923 = function(a_2760924)
          local tmp_2760926 = function(a_2760927)
            local tmp_2763331, tmp_2763330
            do
              local tmp_2760929 = length_2759935(a_2760927)
              local tmp_2760930 = _Int_sub(tmp_2760929, 1)
              tmp_2763330, tmp_2763331 = tmp_2760930, a_2760924
            end
            ::cont_2760931::
            do
              local i_2760933, acc_2760932 = tmp_2763330, tmp_2763331
              local tmp_2760934 = i_2760933 < 0
              if tmp_2760934 then
                return acc_2760932
              end
              local tmp_2760935 = _Int_sub(i_2760933, 1)
              local tmp_2760936 = {a_2760927, i_2760933}
              local tmp_2760937 = tmp_2759930(tmp_2760936)
              local tmp_2760938 = {i_2760933, tmp_2760937, acc_2760932}
              local tmp_2760939 = a_2760921(tmp_2760938)
              tmp_2763330 = tmp_2760935
              tmp_2763331 = tmp_2760939
              goto cont_2760931
            end
          end
          return tmp_2760926
        end
        return tmp_2760923
      end
      foldl_2760943 = function(a_2760944)
        local tmp_2760946 = function(a_2760947)
          local tmp_2760949 = function(a_2760950)
            local n_2760952 = length_2759935(a_2760950)
            local tmp_2763332, tmp_2763333 = 0, a_2760947
            ::cont_2760953::
            do
              local i_2760955, acc_2760954 = tmp_2763332, tmp_2763333
              local tmp_2760956 = i_2760955 >= n_2760952
              if tmp_2760956 then
                return acc_2760954
              end
              local tmp_2760957 = _Int_add(i_2760955, 1)
              local tmp_2760958 = {a_2760950, i_2760955}
              local tmp_2760959 = tmp_2759930(tmp_2760958)
              local tmp_2760960 = {tmp_2760959, acc_2760954}
              local tmp_2760961 = a_2760944(tmp_2760960)
              tmp_2763332 = tmp_2760957
              tmp_2763333 = tmp_2760961
              goto cont_2760953
            end
          end
          return tmp_2760949
        end
        return tmp_2760946
      end
      foldr_2760965 = function(a_2760966)
        local tmp_2760968 = function(a_2760969)
          local tmp_2760971 = function(a_2760972)
            local tmp_2763335, tmp_2763334
            do
              local tmp_2760974 = length_2759935(a_2760972)
              local tmp_2760975 = _Int_sub(tmp_2760974, 1)
              tmp_2763334, tmp_2763335 = tmp_2760975, a_2760969
            end
            ::cont_2760976::
            do
              local i_2760978, acc_2760977 = tmp_2763334, tmp_2763335
              local tmp_2760979 = i_2760978 < 0
              if tmp_2760979 then
                return acc_2760977
              end
              local tmp_2760980 = _Int_sub(i_2760978, 1)
              local tmp_2760981 = {a_2760972, i_2760978}
              local tmp_2760982 = tmp_2759930(tmp_2760981)
              local tmp_2760983 = {tmp_2760982, acc_2760977}
              local tmp_2760984 = a_2760966(tmp_2760983)
              tmp_2763334 = tmp_2760980
              tmp_2763335 = tmp_2760984
              goto cont_2760976
            end
          end
          return tmp_2760971
        end
        return tmp_2760968
      end
      findi_2760988 = function(a_2760989)
        local tmp_2760991 = function(a_2760992)
          local n_2760994 = length_2759935(a_2760992)
          local tmp_2763336 = 0
          ::cont_2760995::
          do
            local a_2760996 = tmp_2763336
            local tmp_2760997 = a_2760996 >= n_2760994
            if tmp_2760997 then
              return NONE_217
            end
            local tmp_2760998 = {a_2760992, a_2760996}
            local x_2760999 = tmp_2759930(tmp_2760998)
            local tmp_2761000 = {a_2760996, x_2760999}
            local tmp_2761001 = a_2760989(tmp_2761000)
            if tmp_2761001 then
              local tmp_2761002 = {a_2760996, x_2760999}
              local tmp_2761003 = {tag = "SOME", payload = tmp_2761002}
              return tmp_2761003
            else
              local tmp_2761004 = _Int_add(a_2760996, 1)
              tmp_2763336 = tmp_2761004
              goto cont_2760995
            end
          end
        end
        return tmp_2760991
      end
      find_2761008 = function(a_2761009)
        local tmp_2761011 = function(a_2761012)
          local n_2761014 = length_2759935(a_2761012)
          local tmp_2763337 = 0
          ::cont_2761015::
          do
            local a_2761016 = tmp_2763337
            local tmp_2761017 = a_2761016 >= n_2761014
            if tmp_2761017 then
              return NONE_217
            end
            local tmp_2761018 = {a_2761012, a_2761016}
            local x_2761019 = tmp_2759930(tmp_2761018)
            local tmp_2761020 = a_2761009(x_2761019)
            if tmp_2761020 then
              local tmp_2761021 = {tag = "SOME", payload = x_2761019}
              return tmp_2761021
            else
              local tmp_2761022 = _Int_add(a_2761016, 1)
              tmp_2763337 = tmp_2761022
              goto cont_2761015
            end
          end
        end
        return tmp_2761011
      end
      exists_2761026 = function(a_2761027)
        local tmp_2761029 = function(a_2761030)
          local n_2761032 = length_2759935(a_2761030)
          local tmp_2763338 = 0
          ::cont_2761033::
          do
            local a_2761034 = tmp_2763338
            local tmp_2761035 = a_2761034 >= n_2761032
            if tmp_2761035 then
              return false
            end
            local tmp_2761036 = {a_2761030, a_2761034}
            local tmp_2761037 = tmp_2759930(tmp_2761036)
            local tmp_2761038 = a_2761027(tmp_2761037)
            if tmp_2761038 then
              return true
            else
              local tmp_2761039 = _Int_add(a_2761034, 1)
              tmp_2763338 = tmp_2761039
              goto cont_2761033
            end
          end
        end
        return tmp_2761029
      end
      all_2761043 = function(a_2761044)
        local tmp_2761046 = function(a_2761047)
          local n_2761049 = length_2759935(a_2761047)
          local tmp_2763339 = 0
          ::cont_2761050::
          do
            local a_2761051 = tmp_2763339
            local tmp_2761052 = a_2761051 >= n_2761049
            if tmp_2761052 then
              return true
            end
            local tmp_2761053 = {a_2761047, a_2761051}
            local tmp_2761054 = tmp_2759930(tmp_2761053)
            local tmp_2761055 = a_2761044(tmp_2761054)
            if tmp_2761055 then
              local tmp_2761056 = _Int_add(a_2761051, 1)
              tmp_2763339 = tmp_2761056
              goto cont_2761050
            else
              return false
            end
          end
        end
        return tmp_2761046
      end
      collate_2761060 = function(a_2761061)
        local tmp_2761063 = function(a_2761064)
          local xs_2761066 = a_2761064[1]
          local ys_2761067 = a_2761064[2]
          local xl_2761068 = length_2759935(xs_2761066)
          local yl_2761069 = length_2759935(ys_2761067)
          local tmp_2763340 = 0
          ::cont_2761070::
          do
            local a_2761071 = tmp_2763340
            local tmp_2761072 = xl_2761068 <= a_2761071
            local tmp_2761073 = yl_2761069 <= a_2761071
            local tmp_2761074
            if tmp_2761072 then
              tmp_2761074 = tmp_2761073
            else
              tmp_2761074 = false
            end
            ::cont_2761098::
            if tmp_2761074 then
              return EQUAL_154
            end
            local tmp_2761075
            if tmp_2761072 then
              local tmp_2761097 = not tmp_2761073
              tmp_2761075 = tmp_2761097
            else
              tmp_2761075 = false
            end
            ::cont_2761096::
            local tmp_2761077
            do
              if tmp_2761075 then
                return LESS_155
              end
              local tmp_2761076 = not tmp_2761072
              if tmp_2761076 then
                tmp_2761077 = tmp_2761073
              else
                tmp_2761077 = false
              end
            end
            ::cont_2761095::
            local tmp_2761079
            do
              if tmp_2761077 then
                return GREATER_153
              end
              local tmp_2761078 = not tmp_2761072
              if tmp_2761078 then
                local tmp_2761094 = not tmp_2761073
                tmp_2761079 = tmp_2761094
              else
                tmp_2761079 = false
              end
            end
            ::cont_2761093::
            if tmp_2761079 then
              goto then_2763341
            else
              _raise(_Match, "mono-sequence.sml:621:49")
            end
            ::then_2763341::
            do
              local tmp_2761080 = {xs_2761066, a_2761071}
              local tmp_2761081 = tmp_2759930(tmp_2761080)
              local tmp_2761082 = {ys_2761067, a_2761071}
              local tmp_2761083 = tmp_2759930(tmp_2761082)
              local tmp_2761084 = {tmp_2761081, tmp_2761083}
              local exp_2761085 = a_2761061(tmp_2761084)
              local tmp_2761086 = exp_2761085
              local tmp_2761087 = tmp_2761086 == "EQUAL"
              if tmp_2761087 then
                local tmp_2761088 = _Int_add(a_2761071, 1)
                tmp_2763340 = tmp_2761088
                goto cont_2761070
              else
                return exp_2761085
              end
            end
          end
        end
        return tmp_2761063
      end
      toList_2761101 = function(a_2761102)
        local tmp_2761104 = foldr_2760965(_COLON_COLON_1)
        local tmp_2761105 = tmp_2761104(nil)
        return tmp_2761105(a_2761102)
      end
      vector_2761108 = function(a_2761109)
        local tmp_2761111 = length_2759935(a_2761109)
        local tmp_2761112
        do
          local tmp_2761115 = foldr_2760965(_COLON_COLON_1)
          local tmp_2761116 = tmp_2761115(nil)
          tmp_2761112 = tmp_2761116(a_2761109)
          goto cont_2761114
        end
        ::cont_2761114::
        local tmp_2761113 = {tmp_2761111, tmp_2761112}
        return tmp_2759922(tmp_2761113)
      end
      fromVector_2761120 = function(a_2761121)
        local tmp_2761123 = length_2759926(a_2761121)
        local tmp_2761124
        do
          local tmp_2761127 = foldr_2760115(_COLON_COLON_1)
          local tmp_2761128 = tmp_2761127(nil)
          tmp_2761124 = tmp_2761128(a_2761121)
          goto cont_2761126
        end
        ::cont_2761126::
        local tmp_2761125 = {tmp_2761123, tmp_2761124}
        return tmp_2759931(tmp_2761125)
      end
      length_2761132 = function(tmp_2761133)
        local tmp_2761135 = tmp_2761133.length
        return tmp_2761135
      end
      sub_2761136 = function(a_2761137)
        local base_2761140, start_2761142, i_2761145, tmp_2761147
        do
          local tmp_2761139 = a_2761137[1]
          base_2761140 = tmp_2761139.base
          local tmp_2761141 = a_2761137[1]
          start_2761142 = tmp_2761141.start
          local tmp_2761143 = a_2761137[1]
          local length_2761144 = tmp_2761143.length
          i_2761145 = a_2761137[2]
          local tmp_2761146 = 0 <= i_2761145
          if tmp_2761146 then
            local tmp_2761152 = i_2761145 < length_2761144
            tmp_2761147 = tmp_2761152
          else
            tmp_2761147 = false
          end
        end
        ::cont_2761151::
        if tmp_2761147 then
          goto then_2763342
        else
          _raise(_Subscript, "mono-sequence.sml:645:44")
        end
        ::then_2763342::
        do
          local tmp_2761148 = _Int_add(start_2761142, i_2761145)
          local tmp_2761149 = {base_2761140, tmp_2761148}
          return tmp_2759930(tmp_2761149)
        end
      end
      update_2761153 = function(a_2761154)
        local base_2761157, start_2761159, i_2761162, x_2761163, tmp_2761165
        do
          local tmp_2761156 = a_2761154[1]
          base_2761157 = tmp_2761156.base
          local tmp_2761158 = a_2761154[1]
          start_2761159 = tmp_2761158.start
          local tmp_2761160 = a_2761154[1]
          local length_2761161 = tmp_2761160.length
          i_2761162 = a_2761154[2]
          x_2761163 = a_2761154[3]
          local tmp_2761164 = 0 <= i_2761162
          if tmp_2761164 then
            local tmp_2761170 = i_2761162 < length_2761161
            tmp_2761165 = tmp_2761170
          else
            tmp_2761165 = false
          end
        end
        ::cont_2761169::
        if tmp_2761165 then
          goto then_2763343
        else
          _raise(_Subscript, "mono-sequence.sml:649:50")
        end
        ::then_2763343::
        do
          local tmp_2761166 = _Int_add(start_2761159, i_2761162)
          local tmp_2761167 = {base_2761157, tmp_2761166, x_2761163}
          return tmp_2759929(tmp_2761167)
        end
      end
      full_2761171 = function(a_2761172)
        local tmp_2761174 = length_2759935(a_2761172)
        local tmp_2761175 = {base = a_2761172, length = tmp_2761174, start = 0}
        return tmp_2761175
      end
      slice_2761177 = function(a_2761178)
        do
          local tmp_2761180 = a_2761178[3]
          local tmp_2761181 = tmp_2761180.tag
          local tmp_2761182 = tmp_2761181 == "NONE"
          if tmp_2761182 then
            goto then_2763344
          else
            goto else_2763345
          end
        end
        ::then_2763344::
        do
          local v_2761183, i_2761184, n_2761185, tmp_2761187
          do
            v_2761183 = a_2761178[1]
            i_2761184 = a_2761178[2]
            n_2761185 = length_2759935(v_2761183)
            local tmp_2761186 = 0 <= i_2761184
            if tmp_2761186 then
              local tmp_2761192 = i_2761184 <= n_2761185
              tmp_2761187 = tmp_2761192
            else
              tmp_2761187 = false
            end
          end
          ::cont_2761191::
          if tmp_2761187 then
            local tmp_2761188 = _Int_sub(n_2761185, i_2761184)
            local tmp_2761189 = {base = v_2761183, length = tmp_2761188, start = i_2761184}
            return tmp_2761189
          else
            _raise(_Subscript, "mono-sequence.sml:655:33")
          end
        end
        ::else_2763345::
        do
          local tmp_2761194 = a_2761178[3]
          local tmp_2761195 = tmp_2761194.tag
          local tmp_2761196 = tmp_2761195 == "SOME"
          if tmp_2761196 then
            goto then_2763346
          else
            _raise(_Match, "mono-sequence.sml:651:5")
          end
        end
        ::then_2763346::
        do
          local v_2761197, i_2761198, n_2761200, tmp_2761202
          do
            v_2761197 = a_2761178[1]
            i_2761198 = a_2761178[2]
            local tmp_2761199 = a_2761178[3]
            n_2761200 = tmp_2761199.payload
            local tmp_2761201 = 0 <= i_2761198
            do
              if tmp_2761201 then
                goto then_2763347
              else
                tmp_2761202 = false
                goto cont_2761205
              end
              ::then_2763347::
              do
                do
                  local tmp_2761206 = 0 <= n_2761200
                  if tmp_2761206 then
                    goto then_2763348
                  else
                    tmp_2761202 = false
                    goto cont_2761205
                  end
                end
                ::then_2763348::
                do
                  local tmp_2761207 = _Int_add(i_2761198, n_2761200)
                  local tmp_2761208 = length_2759935(v_2761197)
                  local tmp_2761209 = tmp_2761207 <= tmp_2761208
                  tmp_2761202 = tmp_2761209
                end
              end
            end
          end
          ::cont_2761205::
          if tmp_2761202 then
            local tmp_2761203 = {base = v_2761197, length = n_2761200, start = i_2761198}
            return tmp_2761203
          else
            _raise(_Subscript, "mono-sequence.sml:660:32")
          end
        end
      end
      subslice_2761212 = function(a_2761213)
        local tmp_2761215 = a_2761213[3]
        local tmp_2761216 = tmp_2761215.tag
        local tmp_2761217 = tmp_2761216 == "NONE"
        if tmp_2761217 then
          local base_2761219, start_2761221, length_2761223, i_2761224, tmp_2761226
          do
            local tmp_2761218 = a_2761213[1]
            base_2761219 = tmp_2761218.base
            local tmp_2761220 = a_2761213[1]
            start_2761221 = tmp_2761220.start
            local tmp_2761222 = a_2761213[1]
            length_2761223 = tmp_2761222.length
            i_2761224 = a_2761213[2]
            local tmp_2761225 = 0 <= i_2761224
            if tmp_2761225 then
              local tmp_2761232 = i_2761224 <= length_2761223
              tmp_2761226 = tmp_2761232
            else
              tmp_2761226 = false
            end
          end
          ::cont_2761231::
          if tmp_2761226 then
            local tmp_2761227 = _Int_add(start_2761221, i_2761224)
            local tmp_2761228 = _Int_sub(length_2761223, i_2761224)
            local tmp_2761229 = {base = base_2761219, length = tmp_2761228, start = tmp_2761227}
            return tmp_2761229
          else
            _raise(_Subscript, "mono-sequence.sml:664:55")
          end
        end
        local tmp_2761233 = a_2761213[3]
        local tmp_2761234 = tmp_2761233.tag
        local tmp_2761235 = tmp_2761234 == "SOME"
        if tmp_2761235 then
          local base_2761237, start_2761239, i_2761242, n_2761244, tmp_2761246
          do
            local tmp_2761236 = a_2761213[1]
            base_2761237 = tmp_2761236.base
            local tmp_2761238 = a_2761213[1]
            start_2761239 = tmp_2761238.start
            local tmp_2761240 = a_2761213[1]
            local length_2761241 = tmp_2761240.length
            i_2761242 = a_2761213[2]
            local tmp_2761243 = a_2761213[3]
            n_2761244 = tmp_2761243.payload
            local tmp_2761245 = 0 <= i_2761242
            if tmp_2761245 then
              local tmp_2761251 = 0 <= n_2761244
              if tmp_2761251 then
                local tmp_2761252 = _Int_add(i_2761242, n_2761244)
                local tmp_2761253 = tmp_2761252 <= length_2761241
                tmp_2761246 = tmp_2761253
              else
                tmp_2761246 = false
              end
            else
              tmp_2761246 = false
            end
          end
          ::cont_2761250::
          if tmp_2761246 then
            local tmp_2761247 = _Int_add(start_2761239, i_2761242)
            local tmp_2761248 = {base = base_2761237, length = n_2761244, start = tmp_2761247}
            return tmp_2761248
          else
            _raise(_Subscript, "mono-sequence.sml:668:57")
          end
        else
          _raise(_Match, "mono-sequence.sml:661:5")
        end
      end
      base_2761255 = function(a_2761256)
        local b_2761258 = a_2761256.base
        local start_2761259 = a_2761256.start
        local length_2761260 = a_2761256.length
        local tmp_2761261 = {b_2761258, start_2761259, length_2761260}
        return tmp_2761261
      end
      copy_2761262 = function(a_2761263)
        local base_2761266, start_2761268, length_2761270, dst_2761271, di_2761272, tmp_2761274
        do
          local tmp_2761265 = a_2761263.src
          base_2761266 = tmp_2761265.base
          local tmp_2761267 = a_2761263.src
          start_2761268 = tmp_2761267.start
          local tmp_2761269 = a_2761263.src
          length_2761270 = tmp_2761269.length
          dst_2761271 = a_2761263.dst
          di_2761272 = a_2761263.di
          local tmp_2761273 = di_2761272 < 0
          do
            if tmp_2761273 then
              tmp_2761274 = true
              goto cont_2761300
            end
            local tmp_2761301 = length_2759935(dst_2761271)
            local tmp_2761302 = _Int_add(di_2761272, length_2761270)
            local tmp_2761303 = tmp_2761301 < tmp_2761302
            tmp_2761274 = tmp_2761303
          end
        end
        ::cont_2761300::
        do
          if tmp_2761274 then
            _raise(_Subscript, "mono-sequence.sml:684:14")
          end
          local tmp_2761276 = start_2761268 >= di_2761272
          if tmp_2761276 then
            goto then_2763349
          else
            goto else_2763350
          end
        end
        ::then_2763349::
        do
          local tmp_2763351 = 0
          ::cont_2761277::
          do
            local a_2761278 = tmp_2763351
            local tmp_2761279 = a_2761278 >= length_2761270
            if tmp_2761279 then
              return nil
            end
            local tmp_2761280 = _Int_add(di_2761272, a_2761278)
            local tmp_2761281 = _Int_add(start_2761268, a_2761278)
            local tmp_2761282 = {base_2761266, tmp_2761281}
            local tmp_2761283 = tmp_2759930(tmp_2761282)
            local tmp_2761284 = {dst_2761271, tmp_2761280, tmp_2761283}
            local tmp_2763352 = tmp_2759929(tmp_2761284)
            local tmp_2761285 = _Int_add(a_2761278, 1)
            tmp_2763351 = tmp_2761285
            goto cont_2761277
          end
        end
        ::else_2763350::
        local tmp_2763353
        do
          local tmp_2761288 = _Int_sub(length_2761270, 1)
          tmp_2763353 = tmp_2761288
        end
        ::cont_2761289::
        do
          local a_2761290 = tmp_2763353
          local tmp_2761291 = a_2761290 < 0
          if tmp_2761291 then
            return nil
          end
          local tmp_2761292 = _Int_add(di_2761272, a_2761290)
          local tmp_2761293 = _Int_add(start_2761268, a_2761290)
          local tmp_2761294 = {base_2761266, tmp_2761293}
          local tmp_2761295 = tmp_2759930(tmp_2761294)
          local tmp_2761296 = {dst_2761271, tmp_2761292, tmp_2761295}
          local tmp_2763354 = tmp_2759929(tmp_2761296)
          local tmp_2761297 = _Int_sub(a_2761290, 1)
          tmp_2763353 = tmp_2761297
          goto cont_2761289
        end
      end
      copyVec_2761305 = function(a_2761306)
        local base_2761309, start_2761311, length_2761313, dst_2761314, di_2761315, tmp_2761317
        do
          local tmp_2761308 = a_2761306.src
          base_2761309 = tmp_2761308.base
          local tmp_2761310 = a_2761306.src
          start_2761311 = tmp_2761310.start
          local tmp_2761312 = a_2761306.src
          length_2761313 = tmp_2761312.length
          dst_2761314 = a_2761306.dst
          di_2761315 = a_2761306.di
          local tmp_2761316 = di_2761315 < 0
          do
            if tmp_2761316 then
              tmp_2761317 = true
              goto cont_2761330
            end
            local tmp_2761331 = length_2759935(dst_2761314)
            local tmp_2761332 = _Int_add(di_2761315, length_2761313)
            local tmp_2761333 = tmp_2761331 < tmp_2761332
            tmp_2761317 = tmp_2761333
          end
        end
        ::cont_2761330::
        if tmp_2761317 then
          _raise(_Subscript, "mono-sequence.sml:699:14")
        end
        local tmp_2763355 = 0
        ::cont_2761319::
        do
          local a_2761320 = tmp_2763355
          local tmp_2761321 = a_2761320 >= length_2761313
          if tmp_2761321 then
            return nil
          end
          local tmp_2761322 = _Int_add(di_2761315, a_2761320)
          local tmp_2761323 = _Int_add(start_2761311, a_2761320)
          local tmp_2761324 = {base_2761309, tmp_2761323}
          local tmp_2761325 = tmp_2759920(tmp_2761324)
          local tmp_2761326 = {dst_2761314, tmp_2761322, tmp_2761325}
          local tmp_2763356 = tmp_2759929(tmp_2761326)
          local tmp_2761327 = _Int_add(a_2761320, 1)
          tmp_2763355 = tmp_2761327
          goto cont_2761319
        end
      end
      isEmpty_2761335 = function(a_2761336)
        local length_2761338 = a_2761336.length
        local tmp_2761339 = length_2761338 == 0
        return tmp_2761339
      end
      getItem_2761340 = function(a_2761341)
        local base_2761343, start_2761344, length_2761345
        do
          base_2761343 = a_2761341.base
          start_2761344 = a_2761341.start
          length_2761345 = a_2761341.length
          local tmp_2761346 = length_2761345 > 0
          if tmp_2761346 then
            goto then_2763357
          else
            return NONE_217
          end
        end
        ::then_2763357::
        do
          local tmp_2761347 = {base_2761343, start_2761344}
          local tmp_2761348 = tmp_2759930(tmp_2761347)
          local tmp_2761349 = _Int_add(start_2761344, 1)
          local tmp_2761350 = _Int_sub(length_2761345, 1)
          local tmp_2761351 = {base = base_2761343, length = tmp_2761350, start = tmp_2761349}
          local tmp_2761352 = {tmp_2761348, tmp_2761351}
          local tmp_2761353 = {tag = "SOME", payload = tmp_2761352}
          return tmp_2761353
        end
      end
      appi_2761355 = function(a_2761356)
        local tmp_2761358 = function(a_2761359)
          local base_2761361 = a_2761359.base
          local start_2761362 = a_2761359.start
          local length_2761363 = a_2761359.length
          local tmp_2763358 = 0
          ::cont_2761364::
          do
            local a_2761365 = tmp_2763358
            local tmp_2761366 = a_2761365 >= length_2761363
            if tmp_2761366 then
              return nil
            end
            local tmp_2761367 = _Int_add(start_2761362, a_2761365)
            local tmp_2761368 = {base_2761361, tmp_2761367}
            local tmp_2761369 = tmp_2759930(tmp_2761368)
            local tmp_2761370 = {a_2761365, tmp_2761369}
            local tmp_2763359 = a_2761356(tmp_2761370)
            local tmp_2761371 = _Int_add(a_2761365, 1)
            tmp_2763358 = tmp_2761371
            goto cont_2761364
          end
        end
        return tmp_2761358
      end
      app_2761374 = function(a_2761375)
        local tmp_2761377 = function(a_2761378)
          local base_2761380, tmp_2761383, tmp_2763360
          do
            base_2761380 = a_2761378.base
            local start_2761381 = a_2761378.start
            local length_2761382 = a_2761378.length
            tmp_2761383 = _Int_add(start_2761381, length_2761382)
            tmp_2763360 = start_2761381
          end
          ::cont_2761384::
          do
            local a_2761385 = tmp_2763360
            local tmp_2761386 = a_2761385 >= tmp_2761383
            if tmp_2761386 then
              return nil
            end
            local tmp_2761387 = {base_2761380, a_2761385}
            local tmp_2761388 = tmp_2759930(tmp_2761387)
            local tmp_2763361 = a_2761375(tmp_2761388)
            local tmp_2761389 = _Int_add(a_2761385, 1)
            tmp_2763360 = tmp_2761389
            goto cont_2761384
          end
        end
        return tmp_2761377
      end
      modifyi_2761392 = function(a_2761393)
        local tmp_2761395 = function(a_2761396)
          local base_2761398 = a_2761396.base
          local start_2761399 = a_2761396.start
          local length_2761400 = a_2761396.length
          local tmp_2763362 = 0
          ::cont_2761401::
          do
            local a_2761402 = tmp_2763362
            local tmp_2761403 = a_2761402 >= length_2761400
            if tmp_2761403 then
              return nil
            end
            local tmp_2761404 = _Int_add(start_2761399, a_2761402)
            local tmp_2761405 = {base_2761398, tmp_2761404}
            local x_2761406 = tmp_2759930(tmp_2761405)
            local tmp_2761407 = {a_2761402, x_2761406}
            local y_2761408 = a_2761393(tmp_2761407)
            local tmp_2761409 = {base_2761398, tmp_2761404, y_2761408}
            local tmp_2763363 = tmp_2759929(tmp_2761409)
            local tmp_2761410 = _Int_add(a_2761402, 1)
            tmp_2763362 = tmp_2761410
            goto cont_2761401
          end
        end
        return tmp_2761395
      end
      modify_2761414 = function(a_2761415)
        local tmp_2761417 = function(a_2761418)
          local base_2761420, tmp_2761423, tmp_2763364
          do
            base_2761420 = a_2761418.base
            local start_2761421 = a_2761418.start
            local length_2761422 = a_2761418.length
            tmp_2761423 = _Int_add(start_2761421, length_2761422)
            tmp_2763364 = start_2761421
          end
          ::cont_2761424::
          do
            local a_2761425 = tmp_2763364
            local tmp_2761426 = a_2761425 >= tmp_2761423
            if tmp_2761426 then
              return nil
            end
            local tmp_2761427 = {base_2761420, a_2761425}
            local x_2761428 = tmp_2759930(tmp_2761427)
            local y_2761429 = a_2761415(x_2761428)
            local tmp_2761430 = {base_2761420, a_2761425, y_2761429}
            local tmp_2763365 = tmp_2759929(tmp_2761430)
            local tmp_2761431 = _Int_add(a_2761425, 1)
            tmp_2763364 = tmp_2761431
            goto cont_2761424
          end
        end
        return tmp_2761417
      end
      foldli_2761435 = function(a_2761436)
        local tmp_2761438 = function(a_2761439)
          local tmp_2761441 = function(a_2761442)
            local base_2761444 = a_2761442.base
            local start_2761445 = a_2761442.start
            local length_2761446 = a_2761442.length
            local tmp_2763366, tmp_2763367 = 0, a_2761439
            ::cont_2761447::
            do
              local i_2761449, acc_2761448 = tmp_2763366, tmp_2763367
              local tmp_2761450 = i_2761449 >= length_2761446
              if tmp_2761450 then
                return acc_2761448
              end
              local tmp_2761451 = _Int_add(i_2761449, 1)
              local tmp_2761452 = _Int_add(start_2761445, i_2761449)
              local tmp_2761453 = {base_2761444, tmp_2761452}
              local tmp_2761454 = tmp_2759930(tmp_2761453)
              local tmp_2761455 = {i_2761449, tmp_2761454, acc_2761448}
              local tmp_2761456 = a_2761436(tmp_2761455)
              tmp_2763366 = tmp_2761451
              tmp_2763367 = tmp_2761456
              goto cont_2761447
            end
          end
          return tmp_2761441
        end
        return tmp_2761438
      end
      foldri_2761459 = function(a_2761460)
        local tmp_2761462 = function(a_2761463)
          local tmp_2761465 = function(a_2761466)
            local base_2761468, start_2761469, tmp_2763369, tmp_2763368
            do
              base_2761468 = a_2761466.base
              start_2761469 = a_2761466.start
              local length_2761470 = a_2761466.length
              local tmp_2761471 = _Int_sub(length_2761470, 1)
              tmp_2763368, tmp_2763369 = tmp_2761471, a_2761463
            end
            ::cont_2761472::
            do
              local i_2761474, acc_2761473 = tmp_2763368, tmp_2763369
              local tmp_2761475 = i_2761474 < 0
              if tmp_2761475 then
                return acc_2761473
              end
              local tmp_2761476 = _Int_sub(i_2761474, 1)
              local tmp_2761477 = _Int_add(start_2761469, i_2761474)
              local tmp_2761478 = {base_2761468, tmp_2761477}
              local tmp_2761479 = tmp_2759930(tmp_2761478)
              local tmp_2761480 = {i_2761474, tmp_2761479, acc_2761473}
              local tmp_2761481 = a_2761460(tmp_2761480)
              tmp_2763368 = tmp_2761476
              tmp_2763369 = tmp_2761481
              goto cont_2761472
            end
          end
          return tmp_2761465
        end
        return tmp_2761462
      end
      foldl_2761484 = function(a_2761485)
        local tmp_2761487 = function(a_2761488)
          local tmp_2761490 = function(a_2761491)
            local base_2761493, tmp_2761496, tmp_2763371, tmp_2763370
            do
              base_2761493 = a_2761491.base
              local start_2761494 = a_2761491.start
              local length_2761495 = a_2761491.length
              tmp_2761496 = _Int_add(start_2761494, length_2761495)
              tmp_2763370, tmp_2763371 = start_2761494, a_2761488
            end
            ::cont_2761497::
            do
              local i_2761499, acc_2761498 = tmp_2763370, tmp_2763371
              local tmp_2761500 = i_2761499 >= tmp_2761496
              if tmp_2761500 then
                return acc_2761498
              end
              local tmp_2761501 = _Int_add(i_2761499, 1)
              local tmp_2761502 = {base_2761493, i_2761499}
              local tmp_2761503 = tmp_2759930(tmp_2761502)
              local tmp_2761504 = {tmp_2761503, acc_2761498}
              local tmp_2761505 = a_2761485(tmp_2761504)
              tmp_2763370 = tmp_2761501
              tmp_2763371 = tmp_2761505
              goto cont_2761497
            end
          end
          return tmp_2761490
        end
        return tmp_2761487
      end
      foldr_2761508 = function(a_2761509)
        local tmp_2761511 = function(a_2761512)
          local tmp_2761514 = function(a_2761515)
            local base_2761517, start_2761518, tmp_2763373, tmp_2763372
            do
              base_2761517 = a_2761515.base
              start_2761518 = a_2761515.start
              local length_2761519 = a_2761515.length
              local tmp_2761520 = _Int_add(start_2761518, length_2761519)
              local tmp_2761521 = _Int_sub(tmp_2761520, 1)
              tmp_2763372, tmp_2763373 = tmp_2761521, a_2761512
            end
            ::cont_2761522::
            do
              local i_2761524, acc_2761523 = tmp_2763372, tmp_2763373
              local tmp_2761525 = i_2761524 < start_2761518
              if tmp_2761525 then
                return acc_2761523
              end
              local tmp_2761526 = _Int_sub(i_2761524, 1)
              local tmp_2761527 = {base_2761517, i_2761524}
              local tmp_2761528 = tmp_2759930(tmp_2761527)
              local tmp_2761529 = {tmp_2761528, acc_2761523}
              local tmp_2761530 = a_2761509(tmp_2761529)
              tmp_2763372 = tmp_2761526
              tmp_2763373 = tmp_2761530
              goto cont_2761522
            end
          end
          return tmp_2761514
        end
        return tmp_2761511
      end
      findi_2761533 = function(a_2761534)
        local tmp_2761536 = function(a_2761537)
          local base_2761539 = a_2761537.base
          local start_2761540 = a_2761537.start
          local length_2761541 = a_2761537.length
          local tmp_2763374 = 0
          ::cont_2761542::
          do
            local a_2761543 = tmp_2763374
            local tmp_2761544 = a_2761543 >= length_2761541
            if tmp_2761544 then
              return NONE_217
            end
            local tmp_2761545 = _Int_add(start_2761540, a_2761543)
            local tmp_2761546 = {base_2761539, tmp_2761545}
            local x_2761547 = tmp_2759930(tmp_2761546)
            local tmp_2761548 = {a_2761543, x_2761547}
            local tmp_2761549 = a_2761534(tmp_2761548)
            if tmp_2761549 then
              local tmp_2761550 = {a_2761543, x_2761547}
              local tmp_2761551 = {tag = "SOME", payload = tmp_2761550}
              return tmp_2761551
            else
              local tmp_2761552 = _Int_add(a_2761543, 1)
              tmp_2763374 = tmp_2761552
              goto cont_2761542
            end
          end
        end
        return tmp_2761536
      end
      find_2761555 = function(a_2761556)
        local tmp_2761558 = function(a_2761559)
          local base_2761561, tmp_2761564, tmp_2763375
          do
            base_2761561 = a_2761559.base
            local start_2761562 = a_2761559.start
            local length_2761563 = a_2761559.length
            tmp_2761564 = _Int_add(start_2761562, length_2761563)
            tmp_2763375 = start_2761562
          end
          ::cont_2761565::
          do
            local a_2761566 = tmp_2763375
            local tmp_2761567 = a_2761566 >= tmp_2761564
            if tmp_2761567 then
              return NONE_217
            end
            local tmp_2761568 = {base_2761561, a_2761566}
            local x_2761569 = tmp_2759930(tmp_2761568)
            local tmp_2761570 = a_2761556(x_2761569)
            if tmp_2761570 then
              local tmp_2761571 = {tag = "SOME", payload = x_2761569}
              return tmp_2761571
            else
              local tmp_2761572 = _Int_add(a_2761566, 1)
              tmp_2763375 = tmp_2761572
              goto cont_2761565
            end
          end
        end
        return tmp_2761558
      end
      exists_2761575 = function(a_2761576)
        local tmp_2761578 = function(a_2761579)
          local base_2761581, tmp_2761584, tmp_2763376
          do
            base_2761581 = a_2761579.base
            local start_2761582 = a_2761579.start
            local length_2761583 = a_2761579.length
            tmp_2761584 = _Int_add(start_2761582, length_2761583)
            tmp_2763376 = start_2761582
          end
          ::cont_2761585::
          do
            local a_2761586 = tmp_2763376
            local tmp_2761587 = a_2761586 >= tmp_2761584
            if tmp_2761587 then
              return false
            end
            local tmp_2761588 = {base_2761581, a_2761586}
            local tmp_2761589 = tmp_2759930(tmp_2761588)
            local tmp_2761590 = a_2761576(tmp_2761589)
            if tmp_2761590 then
              return true
            else
              local tmp_2761591 = _Int_add(a_2761586, 1)
              tmp_2763376 = tmp_2761591
              goto cont_2761585
            end
          end
        end
        return tmp_2761578
      end
      all_2761594 = function(a_2761595)
        local tmp_2761597 = function(a_2761598)
          local base_2761600, tmp_2761603, tmp_2763377
          do
            base_2761600 = a_2761598.base
            local start_2761601 = a_2761598.start
            local length_2761602 = a_2761598.length
            tmp_2761603 = _Int_add(start_2761601, length_2761602)
            tmp_2763377 = start_2761601
          end
          ::cont_2761604::
          do
            local a_2761605 = tmp_2763377
            local tmp_2761606 = a_2761605 >= tmp_2761603
            if tmp_2761606 then
              return true
            end
            local tmp_2761607 = {base_2761600, a_2761605}
            local tmp_2761608 = tmp_2759930(tmp_2761607)
            local tmp_2761609 = a_2761595(tmp_2761608)
            if tmp_2761609 then
              local tmp_2761610 = _Int_add(a_2761605, 1)
              tmp_2763377 = tmp_2761610
              goto cont_2761604
            else
              return false
            end
          end
        end
        return tmp_2761597
      end
      collate_2761613 = function(a_2761614)
        local tmp_2761616 = function(a_2761617)
          local base_2761620, base_PRIME_2761626, tmp_2761631, tmp_2761632, tmp_2763379, tmp_2763378
          do
            local tmp_2761619 = a_2761617[1]
            base_2761620 = tmp_2761619.base
            local tmp_2761621 = a_2761617[1]
            local start_2761622 = tmp_2761621.start
            local tmp_2761623 = a_2761617[1]
            local length_2761624 = tmp_2761623.length
            local tmp_2761625 = a_2761617[2]
            base_PRIME_2761626 = tmp_2761625.base
            local tmp_2761627 = a_2761617[2]
            local start_PRIME_2761628 = tmp_2761627.start
            local tmp_2761629 = a_2761617[2]
            local length_PRIME_2761630 = tmp_2761629.length
            tmp_2761631 = _Int_add(start_2761622, length_2761624)
            tmp_2761632 = _Int_add(start_PRIME_2761628, length_PRIME_2761630)
            tmp_2763378, tmp_2763379 = start_2761622, start_PRIME_2761628
          end
          ::cont_2761633::
          do
            local i_2761635, j_2761634 = tmp_2763378, tmp_2763379
            local tmp_2761636 = tmp_2761631 <= i_2761635
            local tmp_2761637 = tmp_2761632 <= j_2761634
            local tmp_2761638
            if tmp_2761636 then
              tmp_2761638 = tmp_2761637
            else
              tmp_2761638 = false
            end
            ::cont_2761663::
            if tmp_2761638 then
              return EQUAL_154
            end
            local tmp_2761639
            if tmp_2761636 then
              local tmp_2761662 = not tmp_2761637
              tmp_2761639 = tmp_2761662
            else
              tmp_2761639 = false
            end
            ::cont_2761661::
            local tmp_2761641
            do
              if tmp_2761639 then
                return LESS_155
              end
              local tmp_2761640 = not tmp_2761636
              if tmp_2761640 then
                tmp_2761641 = tmp_2761637
              else
                tmp_2761641 = false
              end
            end
            ::cont_2761660::
            local tmp_2761643
            do
              if tmp_2761641 then
                return GREATER_153
              end
              local tmp_2761642 = not tmp_2761636
              if tmp_2761642 then
                local tmp_2761659 = not tmp_2761637
                tmp_2761643 = tmp_2761659
              else
                tmp_2761643 = false
              end
            end
            ::cont_2761658::
            if tmp_2761643 then
              goto then_2763380
            else
              _raise(_Match, "mono-sequence.sml:812:29")
            end
            ::then_2763380::
            do
              local tmp_2761644 = {base_2761620, i_2761635}
              local tmp_2761645 = tmp_2759930(tmp_2761644)
              local tmp_2761646 = {base_PRIME_2761626, j_2761634}
              local tmp_2761647 = tmp_2759930(tmp_2761646)
              local tmp_2761648 = {tmp_2761645, tmp_2761647}
              local exp_2761649 = a_2761614(tmp_2761648)
              local tmp_2761650 = exp_2761649
              local tmp_2761651 = tmp_2761650 == "EQUAL"
              if tmp_2761651 then
                local tmp_2761652 = _Int_add(i_2761635, 1)
                local tmp_2761653 = _Int_add(j_2761634, 1)
                tmp_2763378 = tmp_2761652
                tmp_2763379 = tmp_2761653
                goto cont_2761633
              else
                return exp_2761649
              end
            end
          end
        end
        return tmp_2761616
      end
      vector_2761664 = function(a_2761665)
        local tmp_2761667 = a_2761665.length
        local tmp_2761668 = foldr_2761508(_COLON_COLON_1)
        local tmp_2761669 = tmp_2761668(nil)
        local tmp_2761670 = tmp_2761669(a_2761665)
        local tmp_2761671 = {tmp_2761667, tmp_2761670}
        return tmp_2759922(tmp_2761671)
      end
      UnsafeMonoVector_2761675 = {sub = tmp_2759920}
      UnsafeMonoArray_2761676 = {create = create_2759932, sub = tmp_2759930, update = tmp_2759929}
      MonoVectorSlice_2761677 = {all = all_2760656, app = app_2760434, appi = appi_2760415, base = base_2760381, collate = collate_2760675, concat = concat_2760388, exists = exists_2760637, find = find_2760617, findi = findi_2760595, foldl = foldl_2760546, foldli = foldli_2760497, foldr = foldr_2760570, foldri = foldri_2760521, full = full_2760297, getItem = getItem_2760400, isEmpty = isEmpty_2760395, length = length_2760276, map = map_2760475, mapi = mapi_2760452, slice = slice_2760303, sub = sub_2760280, subslice = subslice_2760338, vector = vector_2759923}
    end
    local MonoVector_2761678 = {all = all_2760193, app = app_2759997, append = append_2760258, appi = appi_2759980, collate = collate_2760210, concat = tmp_2759928, exists = exists_2760176, find = find_2760158, findi = findi_2760138, foldl = foldl_2760093, foldli = foldli_2760048, foldr = foldr_2760115, foldri = foldri_2760070, fromList = fromList_2759927, length = length_2759926, map = map_2760031, mapi = mapi_2760013, maxLen = maxLen_2759925, prepend = prepend_2760267, sub = sub_2759946, tabulate = tabulate_2759938, toList = toList_2760251, update = update_2759959}
    local MonoArraySlice_2761679 = {all = all_2761594, app = app_2761374, appi = appi_2761355, base = base_2761255, collate = collate_2761613, copy = copy_2761262, copyVec = copyVec_2761305, exists = exists_2761575, find = find_2761555, findi = findi_2761533, foldl = foldl_2761484, foldli = foldli_2761435, foldr = foldr_2761508, foldri = foldri_2761459, full = full_2761171, getItem = getItem_2761340, isEmpty = isEmpty_2761335, length = length_2761132, modify = modify_2761414, modifyi = modifyi_2761392, slice = slice_2761177, sub = sub_2761136, subslice = subslice_2761212, update = update_2761153, vector = vector_2761664}
    local MonoArray_2761680 = {all = all_2761043, app = app_2760843, appi = appi_2760826, array = array_2760726, collate = collate_2761060, copy = copy_2760774, copyVec = copyVec_2760800, exists = exists_2761026, find = find_2761008, findi = findi_2760988, foldl = foldl_2760943, foldli = foldli_2760898, foldr = foldr_2760965, foldri = foldri_2760920, fromList = fromList_2759936, fromVector = fromVector_2761120, length = length_2759935, maxLen = maxLen_2759934, modify = modify_2760879, modifyi = modifyi_2760859, sub = sub_2760747, tabulate = tabulate_2760737, toList = toList_2761101, toVector = vector_2761108, update = update_2760760, vector = vector_2761108}
    local tmp_2761681 = {_MonoArray = MonoArray_2761680, _MonoArraySlice = MonoArraySlice_2761679, _MonoVector = MonoVector_2761678, _MonoVectorSlice = MonoVectorSlice_2761677, _UnsafeMonoArray = UnsafeMonoArray_2761676, _UnsafeMonoVector = UnsafeMonoVector_2761675}
    return tmp_2761681
  end
  local unsafeFromListN_2761682 = function(a_2761683)
    local xs_2761685 = a_2761683[2]
    return implode_2759874(xs_2761685)
  end
  local unsafeFromListRevN_2761686 = function(a_2761687)
    local xs_2761689 = a_2761687[2]
    return implodeRev_2759889(xs_2761689)
  end
  local sliceToVector_2761690 = function(a_2761691)
    local base_2761693 = a_2761691.base
    local start_2761694 = a_2761691.start
    local length_2761695 = a_2761691.length
    return substring_2759852(base_2761693, start_2761694, length_2761695)
  end
  local unsafeCreateWithZero_2761696 = function(a_2761697)
    local tmp_2761699 = {a_2761697, 0}
    return _Array_array(tmp_2761699)
  end
  local unsafeFromListN_2761700 = function(a_2761701)
    local xs_2761703 = a_2761701[2]
    return _VectorOrArray_fromList(xs_2761703)
  end
  local LOCAL_2763447 = {}
  LOCAL_2763447[1] = MonoSequence_2759919(_VectorOrArray_fromList, length_856, n_2759916, _Array_array, unsafeCreateWithZero_2761696, unsafeFromListN_2761700, sub_602, update_606, concat_2759868, implode_2759874, size_1069, n_2759915, sliceToVector_2761690, sliceToVector_2761690, unsafeFromListN_2761682, unsafeFromListRevN_2761686, sub_2759839)
  LOCAL_2763447[2] = LOCAL_2763447[1]._MonoVector
  LOCAL_2763447[3] = LOCAL_2763447[1]._MonoVectorSlice
  LOCAL_2763447[4] = LOCAL_2763447[1]._MonoArray
  LOCAL_2763447[5] = LOCAL_2763447[1]._MonoArraySlice
  tmp_2761709 = LOCAL_2763447[3].all
  tmp_2761710 = LOCAL_2763447[3].app
  tmp_2761711 = LOCAL_2763447[3].appi
  tmp_2761712 = LOCAL_2763447[3].base
  tmp_2761713 = LOCAL_2763447[3].collate
  tmp_2761714 = LOCAL_2763447[3].concat
  tmp_2761715 = LOCAL_2763447[3].exists
  tmp_2761716 = LOCAL_2763447[3].find
  tmp_2761717 = LOCAL_2763447[3].findi
  tmp_2761718 = LOCAL_2763447[3].foldl
  tmp_2761719 = LOCAL_2763447[3].foldli
  tmp_2761720 = LOCAL_2763447[3].foldr
  tmp_2761721 = LOCAL_2763447[3].foldri
  tmp_2761722 = LOCAL_2763447[3].full
  tmp_2761723 = LOCAL_2763447[3].getItem
  tmp_2761724 = LOCAL_2763447[3].isEmpty
  tmp_2761725 = LOCAL_2763447[3].length
  tmp_2761726 = LOCAL_2763447[3].map
  tmp_2761727 = LOCAL_2763447[3].mapi
  tmp_2761728 = LOCAL_2763447[3].slice
  tmp_2761729 = LOCAL_2763447[3].sub
  tmp_2761730 = LOCAL_2763447[3].subslice
  tmp_2761731 = LOCAL_2763447[3].vector
  tmp_2761732 = LOCAL_2763447[2].all
  tmp_2761733 = LOCAL_2763447[2].app
  tmp_2761734 = LOCAL_2763447[2].append
  tmp_2761735 = LOCAL_2763447[2].appi
  tmp_2761736 = LOCAL_2763447[2].collate
  tmp_2761737 = LOCAL_2763447[2].concat
  tmp_2761738 = LOCAL_2763447[2].exists
  tmp_2761739 = LOCAL_2763447[2].find
  tmp_2761740 = LOCAL_2763447[2].findi
  tmp_2761741 = LOCAL_2763447[2].foldl
  tmp_2761742 = LOCAL_2763447[2].foldli
  tmp_2761743 = LOCAL_2763447[2].foldr
  tmp_2761744 = LOCAL_2763447[2].foldri
  tmp_2761745 = LOCAL_2763447[2].fromList
  tmp_2761746 = LOCAL_2763447[2].length
  tmp_2761747 = LOCAL_2763447[2].map
  tmp_2761748 = LOCAL_2763447[2].mapi
  tmp_2761749 = LOCAL_2763447[2].maxLen
  tmp_2761750 = LOCAL_2763447[2].prepend
  tmp_2761751 = LOCAL_2763447[2].sub
  tmp_2761752 = LOCAL_2763447[2].tabulate
  tmp_2761753 = LOCAL_2763447[2].toList
  tmp_2761754 = LOCAL_2763447[2].update
  tmp_2761755 = LOCAL_2763447[5].all
  tmp_2761756 = LOCAL_2763447[5].app
  tmp_2761757 = LOCAL_2763447[5].appi
  tmp_2761758 = LOCAL_2763447[5].base
  tmp_2761759 = LOCAL_2763447[5].collate
  tmp_2761760 = LOCAL_2763447[5].copy
  tmp_2761761 = LOCAL_2763447[5].copyVec
  tmp_2761762 = LOCAL_2763447[5].exists
  tmp_2761763 = LOCAL_2763447[5].find
  tmp_2761764 = LOCAL_2763447[5].findi
  tmp_2761765 = LOCAL_2763447[5].foldl
  tmp_2761766 = LOCAL_2763447[5].foldli
  tmp_2761767 = LOCAL_2763447[5].foldr
  tmp_2761768 = LOCAL_2763447[5].foldri
  tmp_2761769 = LOCAL_2763447[5].full
  tmp_2761770 = LOCAL_2763447[5].getItem
  tmp_2761771 = LOCAL_2763447[5].isEmpty
  tmp_2761772 = LOCAL_2763447[5].length
  tmp_2761773 = LOCAL_2763447[5].modify
  tmp_2761774 = LOCAL_2763447[5].modifyi
  tmp_2761775 = LOCAL_2763447[5].slice
  tmp_2761776 = LOCAL_2763447[5].sub
  tmp_2761777 = LOCAL_2763447[5].subslice
  tmp_2761778 = LOCAL_2763447[5].update
  tmp_2761779 = LOCAL_2763447[5].vector
  tmp_2761780 = LOCAL_2763447[4].all
  tmp_2761781 = LOCAL_2763447[4].app
  tmp_2761782 = LOCAL_2763447[4].appi
  tmp_2761783 = LOCAL_2763447[4].array
  tmp_2761784 = LOCAL_2763447[4].collate
  tmp_2761785 = LOCAL_2763447[4].copy
  tmp_2761786 = LOCAL_2763447[4].copyVec
  tmp_2761787 = LOCAL_2763447[4].exists
  tmp_2761788 = LOCAL_2763447[4].find
  tmp_2761789 = LOCAL_2763447[4].findi
  tmp_2761790 = LOCAL_2763447[4].foldl
  tmp_2761791 = LOCAL_2763447[4].foldli
  tmp_2761792 = LOCAL_2763447[4].foldr
  tmp_2761793 = LOCAL_2763447[4].foldri
  tmp_2761794 = LOCAL_2763447[4].fromList
  tmp_2761795 = LOCAL_2763447[4].fromVector
  tmp_2761796 = LOCAL_2763447[4].length
  tmp_2761797 = LOCAL_2763447[4].maxLen
  tmp_2761798 = LOCAL_2763447[4].modify
  tmp_2761799 = LOCAL_2763447[4].modifyi
  tmp_2761800 = LOCAL_2763447[4].sub
  tmp_2761801 = LOCAL_2763447[4].tabulate
  tmp_2761802 = LOCAL_2763447[4].toList
  tmp_2761803 = LOCAL_2763447[4].toVector
  tmp_2761804 = LOCAL_2763447[4].update
  tmp_2761805 = LOCAL_2763447[4].vector
end
local LOCAL_2763448 = {}
do
  LOCAL_2763448[1] = {"Io"}
  local BlockingNotSupported__tag_2761807 = {"BlockingNotSupported"}
  LOCAL_2763448[2] = {tag = BlockingNotSupported__tag_2761807}
  local ClosedStream__tag_2761809 = {"ClosedStream"}
  LOCAL_2763448[3] = {tag = ClosedStream__tag_2761809}
  LOCAL_2763448[4] = "LINE_BUF"
  local unsafeSub_2761812 = function(a_2761813)
    local v_2761815 = a_2761813[1]
    local i_2761816 = a_2761813[2]
    local tmp_2761817 = {v_2761815, i_2761816}
    local tmp_2761818 = sub_2759839(tmp_2761817)
    local tmp_2761819 = tmp_2761818
    local tmp_2761820 = tmp_2761819 & 0xFF
    return tmp_2761820
  end
  local fromList_2761822 = function(a_2761823)
    local tmp_2761825 = function(a_2761826)
      do
        local tmp_2761828 = a_2761826 < 0x0
        if tmp_2761828 then
          goto then_2763381
        else
          return chr_2759906(a_2761826)
        end
      end
      ::then_2763381::
      _raise(_Overflow, "word-1.sml:52:39")
    end
    local tmp_2761830 = map_454(tmp_2761825)
    local tmp_2761831 = tmp_2761830(a_2761823)
    return implode_2759874(tmp_2761831)
  end
  LOCAL_2763448[9] = function(a_2761835)
    local xs_2761837 = a_2761835[2]
    local tmp_2761838 = function(a_2761839)
      do
        local tmp_2761841 = a_2761839 < 0x0
        if tmp_2761841 then
          goto then_2763382
        else
          return chr_2759906(a_2761839)
        end
      end
      ::then_2763382::
      _raise(_Overflow, "word-1.sml:52:39")
    end
    local tmp_2761843 = map_454(tmp_2761838)
    local tmp_2761844 = tmp_2761843(xs_2761837)
    return implode_2759874(tmp_2761844)
  end
  LOCAL_2763448[10] = function(a_2761848)
    local xs_2761850 = a_2761848[2]
    local tmp_2761851 = function(a_2761852)
      do
        local tmp_2761854 = a_2761852 < 0x0
        if tmp_2761854 then
          goto then_2763383
        else
          return chr_2759906(a_2761852)
        end
      end
      ::then_2763383::
      _raise(_Overflow, "word-1.sml:52:39")
    end
    local tmp_2761856 = map_454(tmp_2761851)
    local tmp_2761857 = tmp_2761856(xs_2761850)
    return implodeRev_2759889(tmp_2761857)
  end
  LOCAL_2763448[11] = function(a_2761861)
    local base_2761863 = a_2761861.base
    local start_2761864 = a_2761861.start
    local length_2761865 = a_2761861.length
    return substring_2759852(base_2761863, start_2761864, length_2761865)
  end
  LOCAL_2763448[12] = function(a_2761867)
    local tmp_2761869 = 0x0 & 0xFF
    local tmp_2761870 = {a_2761867, tmp_2761869}
    return _Array_array(tmp_2761870)
  end
  LOCAL_2763448[13] = function(a_2761872)
    local xs_2761874 = a_2761872[2]
    return _VectorOrArray_fromList(xs_2761874)
  end
  LOCAL_2763448[14] = MonoSequence_2759919(_VectorOrArray_fromList, length_856, n_2759916, _Array_array, LOCAL_2763448[12], LOCAL_2763448[13], sub_602, update_606, concat_2759868, fromList_2761822, size_1069, n_2759915, LOCAL_2763448[11], LOCAL_2763448[11], LOCAL_2763448[9], LOCAL_2763448[10], unsafeSub_2761812)
  LOCAL_2763448[5] = LOCAL_2763448[14]._MonoVector
  LOCAL_2763448[6] = LOCAL_2763448[14]._MonoVectorSlice
  LOCAL_2763448[7] = LOCAL_2763448[14]._MonoArray
  LOCAL_2763448[8] = LOCAL_2763448[14]._MonoArraySlice
end
local tmp_2761880 = LOCAL_2763448[6].all
local tmp_2761881 = LOCAL_2763448[6].app
local tmp_2761882 = LOCAL_2763448[6].appi
local tmp_2761883 = LOCAL_2763448[6].base
LOCAL_2763448[15] = LOCAL_2763448[6].collate
LOCAL_2763448[16] = LOCAL_2763448[6].concat
LOCAL_2763448[17] = LOCAL_2763448[6].exists
LOCAL_2763448[18] = LOCAL_2763448[6].find
LOCAL_2763448[19] = LOCAL_2763448[6].findi
LOCAL_2763448[20] = LOCAL_2763448[6].foldl
LOCAL_2763448[21] = LOCAL_2763448[6].foldli
LOCAL_2763448[22] = LOCAL_2763448[6].foldr
LOCAL_2763448[23] = LOCAL_2763448[6].foldri
LOCAL_2763448[24] = LOCAL_2763448[6].full
LOCAL_2763448[25] = LOCAL_2763448[6].getItem
LOCAL_2763448[26] = LOCAL_2763448[6].isEmpty
LOCAL_2763448[27] = LOCAL_2763448[6].length
LOCAL_2763448[28] = LOCAL_2763448[6].map
LOCAL_2763448[29] = LOCAL_2763448[6].mapi
LOCAL_2763448[30] = LOCAL_2763448[6].slice
LOCAL_2763448[31] = LOCAL_2763448[6].sub
LOCAL_2763448[32] = LOCAL_2763448[6].subslice
LOCAL_2763448[33] = LOCAL_2763448[6].vector
LOCAL_2763448[34] = LOCAL_2763448[5].all
LOCAL_2763448[35] = LOCAL_2763448[5].app
LOCAL_2763448[36] = LOCAL_2763448[5].append
LOCAL_2763448[37] = LOCAL_2763448[5].appi
LOCAL_2763448[38] = LOCAL_2763448[5].collate
LOCAL_2763448[39] = LOCAL_2763448[5].concat
LOCAL_2763448[40] = LOCAL_2763448[5].exists
LOCAL_2763448[41] = LOCAL_2763448[5].find
LOCAL_2763448[42] = LOCAL_2763448[5].findi
LOCAL_2763448[43] = LOCAL_2763448[5].foldl
LOCAL_2763448[44] = LOCAL_2763448[5].foldli
LOCAL_2763448[45] = LOCAL_2763448[5].foldr
LOCAL_2763448[46] = LOCAL_2763448[5].foldri
LOCAL_2763448[47] = LOCAL_2763448[5].fromList
LOCAL_2763448[48] = LOCAL_2763448[5].length
LOCAL_2763448[49] = LOCAL_2763448[5].map
LOCAL_2763448[50] = LOCAL_2763448[5].mapi
LOCAL_2763448[51] = LOCAL_2763448[5].maxLen
LOCAL_2763448[52] = LOCAL_2763448[5].prepend
LOCAL_2763448[53] = LOCAL_2763448[5].sub
LOCAL_2763448[54] = LOCAL_2763448[5].tabulate
LOCAL_2763448[55] = LOCAL_2763448[5].toList
LOCAL_2763448[56] = LOCAL_2763448[5].update
LOCAL_2763448[57] = LOCAL_2763448[8].all
LOCAL_2763448[58] = LOCAL_2763448[8].app
LOCAL_2763448[59] = LOCAL_2763448[8].appi
LOCAL_2763448[60] = LOCAL_2763448[8].base
LOCAL_2763448[61] = LOCAL_2763448[8].collate
LOCAL_2763448[62] = LOCAL_2763448[8].copy
LOCAL_2763448[63] = LOCAL_2763448[8].copyVec
LOCAL_2763448[64] = LOCAL_2763448[8].exists
LOCAL_2763448[65] = LOCAL_2763448[8].find
LOCAL_2763448[66] = LOCAL_2763448[8].findi
LOCAL_2763448[67] = LOCAL_2763448[8].foldl
LOCAL_2763448[68] = LOCAL_2763448[8].foldli
LOCAL_2763448[69] = LOCAL_2763448[8].foldr
LOCAL_2763448[70] = LOCAL_2763448[8].foldri
LOCAL_2763448[71] = LOCAL_2763448[8].full
LOCAL_2763448[72] = LOCAL_2763448[8].getItem
LOCAL_2763448[73] = LOCAL_2763448[8].isEmpty
LOCAL_2763448[74] = LOCAL_2763448[8].length
LOCAL_2763448[75] = LOCAL_2763448[8].modify
LOCAL_2763448[76] = LOCAL_2763448[8].modifyi
LOCAL_2763448[77] = LOCAL_2763448[8].slice
LOCAL_2763448[78] = LOCAL_2763448[8].sub
LOCAL_2763448[79] = LOCAL_2763448[8].subslice
LOCAL_2763448[80] = LOCAL_2763448[8].update
LOCAL_2763448[81] = LOCAL_2763448[8].vector
LOCAL_2763448[82] = LOCAL_2763448[7].all
LOCAL_2763448[83] = LOCAL_2763448[7].app
LOCAL_2763448[84] = LOCAL_2763448[7].appi
LOCAL_2763448[85] = LOCAL_2763448[7].array
LOCAL_2763448[86] = LOCAL_2763448[7].collate
LOCAL_2763448[87] = LOCAL_2763448[7].copy
LOCAL_2763448[88] = LOCAL_2763448[7].copyVec
LOCAL_2763448[89] = LOCAL_2763448[7].exists
LOCAL_2763448[90] = LOCAL_2763448[7].find
LOCAL_2763448[91] = LOCAL_2763448[7].findi
LOCAL_2763448[92] = LOCAL_2763448[7].foldl
LOCAL_2763448[93] = LOCAL_2763448[7].foldli
LOCAL_2763448[94] = LOCAL_2763448[7].foldr
LOCAL_2763448[95] = LOCAL_2763448[7].foldri
LOCAL_2763448[96] = LOCAL_2763448[7].fromList
LOCAL_2763448[97] = LOCAL_2763448[7].fromVector
LOCAL_2763448[98] = LOCAL_2763448[7].length
LOCAL_2763448[99] = LOCAL_2763448[7].maxLen
LOCAL_2763448[100] = LOCAL_2763448[7].modify
LOCAL_2763448[101] = LOCAL_2763448[7].modifyi
LOCAL_2763448[102] = LOCAL_2763448[7].sub
LOCAL_2763448[103] = LOCAL_2763448[7].tabulate
LOCAL_2763448[104] = LOCAL_2763448[7].toList
LOCAL_2763448[105] = LOCAL_2763448[7].toVector
LOCAL_2763448[106] = LOCAL_2763448[7].update
LOCAL_2763448[107] = LOCAL_2763448[7].vector
LOCAL_2763448[108] = function()
  local tmp_2761979 = function(eq_2761980)
    local tmp_2761982 = function(param_2761983)
      local compare_2761985 = param_2761983.compare
      local RD_2761986 = function(payload_2761987)
        local tmp_2761989 = payload_2761987
        return tmp_2761989
      end
      local WR_2761990 = function(payload_2761991)
        local tmp_2761993 = payload_2761991
        return tmp_2761993
      end
      local openVector_2761994 = function(a_2761995)
        local tmp_2761997, tmp_2761998, tmp_2762057, tmp_2762064, tmp_2762071, tmp_2762084, tmp_2762097, tmp_2762105, tmp_2762112
        do
          tmp_2761997 = {0}
          tmp_2761998 = {false}
          local readVec_2761999 = function(a_2762000)
            local x_2762004, newPos_2762009
            do
              local tmp_2762002 = a_2762000 < 0
              if tmp_2762002 then
                _raise(_Size, "prim-io.sml:112:31")
              end
              x_2762004 = tmp_2761997[1]
              local tmp_2762005 = param_2761983._Vector
              local tmp_2762006 = tmp_2762005.length
              local total_2762007 = tmp_2762006(a_2761995)
              local tmp_2762008 = _Int_add(x_2762004, a_2762000)
              do
                local tmp_2762020 = tmp_2762008 < total_2762007
                if tmp_2762020 then
                  newPos_2762009 = tmp_2762008
                else
                  newPos_2762009 = total_2762007
                end
              end
            end
            ::cont_2762019::
            tmp_2761997[1] = newPos_2762009
            local tmp_2762010 = param_2761983._VectorSlice
            local tmp_2762011 = tmp_2762010.vector
            local tmp_2762012 = param_2761983._VectorSlice
            local tmp_2762013 = tmp_2762012.slice
            local tmp_2762014 = _Int_sub(newPos_2762009, x_2762004)
            local tmp_2762015 = {tag = "SOME", payload = tmp_2762014}
            local tmp_2762016 = {a_2761995, x_2762004, tmp_2762015}
            local tmp_2762017 = tmp_2762013(tmp_2762016)
            return tmp_2762011(tmp_2762017)
          end
          local readArr_2762022 = function(a_2762023)
            local x_2762025, newPos_2762033
            do
              x_2762025 = tmp_2761997[1]
              local tmp_2762026 = param_2761983._Vector
              local tmp_2762027 = tmp_2762026.length
              local total_2762028 = tmp_2762027(a_2761995)
              local tmp_2762029 = param_2761983._ArraySlice
              local tmp_2762030 = tmp_2762029.length
              local tmp_2762031 = tmp_2762030(a_2762023)
              local tmp_2762032 = _Int_add(x_2762025, tmp_2762031)
              do
                local tmp_2762052 = tmp_2762032 < total_2762028
                if tmp_2762052 then
                  newPos_2762033 = tmp_2762032
                else
                  newPos_2762033 = total_2762028
                end
              end
            end
            ::cont_2762051::
            local tmp_2762039, tmp_2762041, tmp_2762047
            do
              local tmp_2762034 = param_2761983._ArraySlice
              local tmp_2762035 = tmp_2762034.base
              local exp_2762036 = tmp_2762035(a_2762023)
              local baseArr_2762037 = exp_2762036[1]
              local start_2762038 = exp_2762036[2]
              tmp_2762039 = _Int_sub(newPos_2762033, x_2762025)
              tmp_2761997[1] = newPos_2762033
              local tmp_2762040 = param_2761983._ArraySlice
              tmp_2762041 = tmp_2762040.copyVec
              local tmp_2762042 = param_2761983._VectorSlice
              local tmp_2762043 = tmp_2762042.slice
              local tmp_2762044 = {tag = "SOME", payload = tmp_2762039}
              local tmp_2762045 = {a_2761995, x_2762025, tmp_2762044}
              local tmp_2762046 = tmp_2762043(tmp_2762045)
              tmp_2762047 = {di = start_2762038, dst = baseArr_2762037, src = tmp_2762046}
            end
            local tmp_2763384 = tmp_2762041(tmp_2762047)
            return tmp_2762039
          end
          local tmp_2762055 = param_2761983._Vector
          local tmp_2762056 = tmp_2762055.length
          tmp_2762057 = tmp_2762056(a_2761995)
          local tmp_2762058 = function(n_2762059)
            do
              local x_2762061 = tmp_2761998[1]
              if x_2762061 then
                goto then_2763385
              else
                return readVec_2761999(n_2762059)
              end
            end
            ::then_2763385::
            do
              local tmp_2762062 = {cause = LOCAL_2763448[3], ["function"] = "readVec", name = "<openVector>"}
              local tmp_2762063 = {tag = LOCAL_2763448[1], payload = tmp_2762062}
              _raise(tmp_2762063, "prim-io.sml:108:36")
            end
          end
          tmp_2762064 = {tag = "SOME", payload = tmp_2762058}
          local tmp_2762065 = function(slice_2762066)
            do
              local x_2762068 = tmp_2761998[1]
              if x_2762068 then
                goto then_2763386
              else
                return readArr_2762022(slice_2762066)
              end
            end
            ::then_2763386::
            do
              local tmp_2762069 = {cause = LOCAL_2763448[3], ["function"] = "readArr", name = "<openVector>"}
              local tmp_2762070 = {tag = LOCAL_2763448[1], payload = tmp_2762069}
              _raise(tmp_2762070, "prim-io.sml:108:36")
            end
          end
          tmp_2762071 = {tag = "SOME", payload = tmp_2762065}
          local tmp_2762072 = function(n_2762073)
            do
              local x_2762075 = tmp_2761998[1]
              if x_2762075 then
                goto then_2763387
              else
                goto else_2763388
              end
            end
            ::then_2763387::
            do
              local tmp_2762076 = {cause = LOCAL_2763448[3], ["function"] = "readVecNB", name = "<openVector>"}
              local tmp_2762077 = {tag = LOCAL_2763448[1], payload = tmp_2762076}
              _raise(tmp_2762077, "prim-io.sml:108:36")
            end
            ::else_2763388::
            local tmp_2762081 = readVec_2761999(n_2762073)
            local tmp_2762082 = {tag = "SOME", payload = tmp_2762081}
            return tmp_2762082
          end
          tmp_2762084 = {tag = "SOME", payload = tmp_2762072}
          local tmp_2762085 = function(slice_2762086)
            do
              local x_2762088 = tmp_2761998[1]
              if x_2762088 then
                goto then_2763389
              else
                goto else_2763390
              end
            end
            ::then_2763389::
            do
              local tmp_2762089 = {cause = LOCAL_2763448[3], ["function"] = "readArrNB", name = "<openVector>"}
              local tmp_2762090 = {tag = LOCAL_2763448[1], payload = tmp_2762089}
              _raise(tmp_2762090, "prim-io.sml:108:36")
            end
            ::else_2763390::
            local tmp_2762094 = readArr_2762022(slice_2762086)
            local tmp_2762095 = {tag = "SOME", payload = tmp_2762094}
            return tmp_2762095
          end
          tmp_2762097 = {tag = "SOME", payload = tmp_2762085}
          local tmp_2762098 = function(a_2762099)
            local x_2762101 = tmp_2761998[1]
            if x_2762101 then
              local tmp_2762102 = {cause = LOCAL_2763448[3], ["function"] = "block", name = "<openVector>"}
              local tmp_2762103 = {tag = LOCAL_2763448[1], payload = tmp_2762102}
              _raise(tmp_2762103, "prim-io.sml:108:36")
            else
              return nil
            end
          end
          tmp_2762105 = {tag = "SOME", payload = tmp_2762098}
          local tmp_2762106 = function(a_2762107)
            local x_2762109 = tmp_2761998[1]
            if x_2762109 then
              local tmp_2762110 = {cause = LOCAL_2763448[3], ["function"] = "canInput", name = "<openVector>"}
              local tmp_2762111 = {tag = LOCAL_2763448[1], payload = tmp_2762110}
              _raise(tmp_2762111, "prim-io.sml:108:36")
            else
              return true
            end
          end
          tmp_2762112 = {tag = "SOME", payload = tmp_2762106}
        end
        local tmp_2762113 = function(a_2762114)
          do
            local x_2762124 = tmp_2761998[1]
            if x_2762124 then
              local tmp_2762125 = {cause = LOCAL_2763448[3], ["function"] = "avail", name = "<openVector>"}
              local tmp_2762126 = {tag = LOCAL_2763448[1], payload = tmp_2762125}
              _raise(tmp_2762126, "prim-io.sml:108:36")
            end
          end
          ::cont_2762123::
          local tmp_2762116 = param_2761983._Vector
          local tmp_2762117 = tmp_2762116.length
          local tmp_2762118 = tmp_2762117(a_2761995)
          local x_2762119 = tmp_2761997[1]
          local tmp_2762120 = _Int_sub(tmp_2762118, x_2762119)
          local tmp_2762121 = {tag = "SOME", payload = tmp_2762120}
          return tmp_2762121
        end
        local tmp_2762127 = function(a_2762128)
          tmp_2761998[1] = true
          return nil
        end
        local tmp_2762130 = {avail = tmp_2762113, block = tmp_2762105, canInput = tmp_2762112, chunkSize = tmp_2762057, close = tmp_2762127, endPos = NONE_217, getPos = NONE_217, ioDesc = NONE_217, name = "<openVector>", readArr = tmp_2762071, readArrNB = tmp_2762097, readVec = tmp_2762064, readVecNB = tmp_2762084, setPos = NONE_217, verifyPos = NONE_217}
        local tmp_2762131 = tmp_2762130
        return tmp_2762131
      end
      local nullRd_2762133 = function(a_2762134)
        local tmp_2762149, tmp_2762156, tmp_2762165, tmp_2762174, tmp_2762182, tmp_2762189, tmp_2762190, tmp_2762194
        do
          local tmp_2762136 = {false}
          local tmp_2762137 = param_2761983._Vector
          local tmp_2762138 = tmp_2762137.fromList
          local empty_2762139 = tmp_2762138(nil)
          local tmp_2762140 = function(n_2762141)
            do
              local x_2762146 = tmp_2762136[1]
              if x_2762146 then
                local tmp_2762147 = {cause = LOCAL_2763448[3], ["function"] = "readVec", name = "<nullRd>"}
                local tmp_2762148 = {tag = LOCAL_2763448[1], payload = tmp_2762147}
                _raise(tmp_2762148, "prim-io.sml:149:46")
              end
            end
            ::cont_2762145::
            local tmp_2762143 = n_2762141 < 0
            if tmp_2762143 then
              _raise(_Size, "prim-io.sml:155:81")
            else
              return empty_2762139
            end
          end
          tmp_2762149 = {tag = "SOME", payload = tmp_2762140}
          local tmp_2762150 = function(slice_2762151)
            local x_2762153 = tmp_2762136[1]
            if x_2762153 then
              local tmp_2762154 = {cause = LOCAL_2763448[3], ["function"] = "readArr", name = "<nullRd>"}
              local tmp_2762155 = {tag = LOCAL_2763448[1], payload = tmp_2762154}
              _raise(tmp_2762155, "prim-io.sml:149:46")
            else
              return 0
            end
          end
          tmp_2762156 = {tag = "SOME", payload = tmp_2762150}
          local tmp_2762157 = function(n_2762158)
            local x_2762160 = tmp_2762136[1]
            if x_2762160 then
              local tmp_2762161 = {cause = LOCAL_2763448[3], ["function"] = "readVecNB", name = "<nullRd>"}
              local tmp_2762162 = {tag = LOCAL_2763448[1], payload = tmp_2762161}
              _raise(tmp_2762162, "prim-io.sml:149:46")
            else
              local tmp_2762164 = {tag = "SOME", payload = empty_2762139}
              return tmp_2762164
            end
          end
          tmp_2762165 = {tag = "SOME", payload = tmp_2762157}
          local tmp_2762166 = function(slice_2762167)
            local x_2762169 = tmp_2762136[1]
            if x_2762169 then
              local tmp_2762170 = {cause = LOCAL_2763448[3], ["function"] = "readArrNB", name = "<nullRd>"}
              local tmp_2762171 = {tag = LOCAL_2763448[1], payload = tmp_2762170}
              _raise(tmp_2762171, "prim-io.sml:149:46")
            else
              local tmp_2762173 = {tag = "SOME", payload = 0}
              return tmp_2762173
            end
          end
          tmp_2762174 = {tag = "SOME", payload = tmp_2762166}
          local tmp_2762175 = function(a_2762176)
            local x_2762178 = tmp_2762136[1]
            if x_2762178 then
              local tmp_2762179 = {cause = LOCAL_2763448[3], ["function"] = "block", name = "<nullRd>"}
              local tmp_2762180 = {tag = LOCAL_2763448[1], payload = tmp_2762179}
              _raise(tmp_2762180, "prim-io.sml:149:46")
            else
              return nil
            end
          end
          tmp_2762182 = {tag = "SOME", payload = tmp_2762175}
          local tmp_2762183 = function(a_2762184)
            local x_2762186 = tmp_2762136[1]
            if x_2762186 then
              local tmp_2762187 = {cause = LOCAL_2763448[3], ["function"] = "canInput", name = "<nullRd>"}
              local tmp_2762188 = {tag = LOCAL_2763448[1], payload = tmp_2762187}
              _raise(tmp_2762188, "prim-io.sml:149:46")
            else
              return true
            end
          end
          tmp_2762189 = {tag = "SOME", payload = tmp_2762183}
          tmp_2762190 = function(a_2762191)
            local tmp_2762193 = {tag = "SOME", payload = 0}
            return tmp_2762193
          end
          tmp_2762194 = function(a_2762195)
            tmp_2762136[1] = true
            return nil
          end
        end
        local tmp_2762197 = {avail = tmp_2762190, block = tmp_2762182, canInput = tmp_2762189, chunkSize = 1, close = tmp_2762194, endPos = NONE_217, getPos = NONE_217, ioDesc = NONE_217, name = "<nullRd>", readArr = tmp_2762156, readArrNB = tmp_2762174, readVec = tmp_2762149, readVecNB = tmp_2762165, setPos = NONE_217, verifyPos = NONE_217}
        local tmp_2762198 = tmp_2762197
        return tmp_2762198
      end
      local nullWr_2762200 = function(a_2762201)
        local tmp_2762270
        do
          local tmp_2762203 = {false}
          local tmp_2762204 = function(slice_2762205)
            do
              local x_2762207 = tmp_2762203[1]
              if x_2762207 then
                goto then_2763391
              else
                local tmp_2762212 = param_2761983._VectorSlice
                local tmp_2762213 = tmp_2762212.length
                return tmp_2762213(slice_2762205)
              end
            end
            ::then_2763391::
            do
              local tmp_2762208 = {cause = LOCAL_2763448[3], ["function"] = "writeVec", name = "<nullWr>"}
              local tmp_2762209 = {tag = LOCAL_2763448[1], payload = tmp_2762208}
              _raise(tmp_2762209, "prim-io.sml:173:46")
            end
          end
          local tmp_2762214 = {tag = "SOME", payload = tmp_2762204}
          local tmp_2762215 = function(slice_2762216)
            do
              local x_2762218 = tmp_2762203[1]
              if x_2762218 then
                goto then_2763392
              else
                local tmp_2762223 = param_2761983._ArraySlice
                local tmp_2762224 = tmp_2762223.length
                return tmp_2762224(slice_2762216)
              end
            end
            ::then_2763392::
            do
              local tmp_2762219 = {cause = LOCAL_2763448[3], ["function"] = "writeArr", name = "<nullWr>"}
              local tmp_2762220 = {tag = LOCAL_2763448[1], payload = tmp_2762219}
              _raise(tmp_2762220, "prim-io.sml:173:46")
            end
          end
          local tmp_2762225 = {tag = "SOME", payload = tmp_2762215}
          local tmp_2762226 = function(slice_2762227)
            do
              local x_2762235 = tmp_2762203[1]
              if x_2762235 then
                local tmp_2762236 = {cause = LOCAL_2763448[3], ["function"] = "writeVecNB", name = "<nullWr>"}
                local tmp_2762237 = {tag = LOCAL_2763448[1], payload = tmp_2762236}
                _raise(tmp_2762237, "prim-io.sml:173:46")
              end
            end
            ::cont_2762234::
            local tmp_2762229 = param_2761983._VectorSlice
            local tmp_2762230 = tmp_2762229.length
            local tmp_2762231 = tmp_2762230(slice_2762227)
            local tmp_2762232 = {tag = "SOME", payload = tmp_2762231}
            return tmp_2762232
          end
          local tmp_2762238 = {tag = "SOME", payload = tmp_2762226}
          local tmp_2762239 = function(slice_2762240)
            do
              local x_2762248 = tmp_2762203[1]
              if x_2762248 then
                local tmp_2762249 = {cause = LOCAL_2763448[3], ["function"] = "writeArrNB", name = "<nullWr>"}
                local tmp_2762250 = {tag = LOCAL_2763448[1], payload = tmp_2762249}
                _raise(tmp_2762250, "prim-io.sml:173:46")
              end
            end
            ::cont_2762247::
            local tmp_2762242 = param_2761983._ArraySlice
            local tmp_2762243 = tmp_2762242.length
            local tmp_2762244 = tmp_2762243(slice_2762240)
            local tmp_2762245 = {tag = "SOME", payload = tmp_2762244}
            return tmp_2762245
          end
          local tmp_2762251 = {tag = "SOME", payload = tmp_2762239}
          local tmp_2762252 = function(a_2762253)
            local x_2762255 = tmp_2762203[1]
            if x_2762255 then
              local tmp_2762256 = {cause = LOCAL_2763448[3], ["function"] = "block", name = "<nullWr>"}
              local tmp_2762257 = {tag = LOCAL_2763448[1], payload = tmp_2762256}
              _raise(tmp_2762257, "prim-io.sml:173:46")
            else
              return nil
            end
          end
          local tmp_2762259 = {tag = "SOME", payload = tmp_2762252}
          local tmp_2762260 = function(a_2762261)
            local x_2762263 = tmp_2762203[1]
            if x_2762263 then
              local tmp_2762264 = {cause = LOCAL_2763448[3], ["function"] = "canOutput", name = "<nullWr>"}
              local tmp_2762265 = {tag = LOCAL_2763448[1], payload = tmp_2762264}
              _raise(tmp_2762265, "prim-io.sml:173:46")
            else
              return true
            end
          end
          local tmp_2762266 = {tag = "SOME", payload = tmp_2762260}
          local tmp_2762267 = function(a_2762268)
            tmp_2762203[1] = true
            return nil
          end
          tmp_2762270 = {block = tmp_2762259, canOutput = tmp_2762266, chunkSize = 1, close = tmp_2762267, endPos = NONE_217, getPos = NONE_217, ioDesc = NONE_217, name = "<nullWr>", setPos = NONE_217, verifyPos = NONE_217, writeArr = tmp_2762225, writeArrNB = tmp_2762251, writeVec = tmp_2762214, writeVecNB = tmp_2762238}
        end
        local tmp_2762271 = tmp_2762270
        return tmp_2762271
      end
      local augmentReader_2762272 = function(a_2762273)
        local name_2762276, chunkSize_2762278, readVec_2762280, readArr_2762282, readVecNB_2762284, readArrNB_2762286, block_2762288, canInput_2762290, avail_2762292, getPos_2762294
        do
          local tmp_2762275 = a_2762273
          name_2762276 = tmp_2762275.name
          local tmp_2762277 = a_2762273
          chunkSize_2762278 = tmp_2762277.chunkSize
          local tmp_2762279 = a_2762273
          readVec_2762280 = tmp_2762279.readVec
          local tmp_2762281 = a_2762273
          readArr_2762282 = tmp_2762281.readArr
          local tmp_2762283 = a_2762273
          readVecNB_2762284 = tmp_2762283.readVecNB
          local tmp_2762285 = a_2762273
          readArrNB_2762286 = tmp_2762285.readArrNB
          local tmp_2762287 = a_2762273
          block_2762288 = tmp_2762287.block
          local tmp_2762289 = a_2762273
          canInput_2762290 = tmp_2762289.canInput
          local tmp_2762291 = a_2762273
          avail_2762292 = tmp_2762291.avail
          local tmp_2762293 = a_2762273
          getPos_2762294 = tmp_2762293.getPos
        end
        local setPos_2762296, endPos_2762298, verifyPos_2762300, close_2762302, ioDesc_2762304, readVec_PRIME_2762310
        do
          local tmp_2762295 = a_2762273
          setPos_2762296 = tmp_2762295.setPos
          local tmp_2762297 = a_2762273
          endPos_2762298 = tmp_2762297.endPos
          local tmp_2762299 = a_2762273
          verifyPos_2762300 = tmp_2762299.verifyPos
          local tmp_2762301 = a_2762273
          close_2762302 = tmp_2762301.close
          local tmp_2762303 = a_2762273
          ioDesc_2762304 = tmp_2762303.ioDesc
          local tmp_2762305 = param_2761983._Vector
          local tmp_2762306 = tmp_2762305.fromList
          local empty_2762307 = tmp_2762306(nil)
          local tmp_2762308 = readVec_2762280.tag
          local tmp_2762309 = tmp_2762308 == "SOME"
          do
            if tmp_2762309 then
              readVec_PRIME_2762310 = readVec_2762280
              goto cont_2762634
            end
            local tmp_2762635 = readVec_2762280.tag
            local tmp_2762636 = tmp_2762635 == "NONE"
            if tmp_2762636 then
              local tmp_2762637 = readArr_2762282.tag
              local tmp_2762638 = tmp_2762637 == "SOME"
              if tmp_2762638 then
                local ra_2762639 = readArr_2762282.payload
                local tmp_2762640 = function(n_2762641)
                  local arr_2762647, tmp_2762653, tmp_2762655, tmp_2762656
                  do
                    local tmp_2762643 = param_2761983._Array
                    local tmp_2762644 = tmp_2762643.array
                    local tmp_2762645 = param_2761983.someElem
                    local tmp_2762646 = {n_2762641, tmp_2762645}
                    arr_2762647 = tmp_2762644(tmp_2762646)
                    local tmp_2762648 = param_2761983._ArraySlice
                    local tmp_2762649 = tmp_2762648.full
                    local tmp_2762650 = tmp_2762649(arr_2762647)
                    local actual_2762651 = ra_2762639(tmp_2762650)
                    local tmp_2762652 = param_2761983._ArraySlice
                    tmp_2762653 = tmp_2762652.vector
                    local tmp_2762654 = param_2761983._ArraySlice
                    tmp_2762655 = tmp_2762654.slice
                    tmp_2762656 = {tag = "SOME", payload = actual_2762651}
                  end
                  local tmp_2762657 = {arr_2762647, 0, tmp_2762656}
                  local tmp_2762658 = tmp_2762655(tmp_2762657)
                  return tmp_2762653(tmp_2762658)
                end
                local tmp_2762663 = {tag = "SOME", payload = tmp_2762640}
                readVec_PRIME_2762310 = tmp_2762663
                goto cont_2762634
              end
              local tmp_2762664 = readArr_2762282.tag
              local tmp_2762665 = tmp_2762664 == "NONE"
              if tmp_2762665 then
                local tmp_2762668
                do
                  local tmp_2762666 = block_2762288.tag
                  local tmp_2762667 = tmp_2762666 == "SOME"
                  if tmp_2762667 then
                    local tmp_2762754 = readVecNB_2762284.tag
                    local tmp_2762755 = tmp_2762754 == "SOME"
                    tmp_2762668 = tmp_2762755
                  else
                    tmp_2762668 = false
                  end
                end
                ::cont_2762753::
                local tmp_2762696
                do
                  if tmp_2762668 then
                    local block_PRIME_2762669 = block_2762288.payload
                    local rvNB_2762670 = readVecNB_2762284.payload
                    local tmp_2762671 = function(n_2762672)
                      do
                        local tmp_2762674 = n_2762672 < 0
                        if tmp_2762674 then
                          _raise(_Size, "prim-io.sml:205:72")
                        end
                        local exp_2762676 = rvNB_2762670(n_2762672)
                        local tmp_2762677 = exp_2762676.tag
                        local tmp_2762678 = tmp_2762677 == "SOME"
                        if tmp_2762678 then
                          local content_2762679 = exp_2762676.payload
                          return content_2762679
                        end
                        local tmp_2762680 = exp_2762676.tag
                        local tmp_2762681 = tmp_2762680 == "NONE"
                        if tmp_2762681 then
                          goto then_2763393
                        else
                          _raise(_Match, "prim-io.sml:207:72")
                        end
                      end
                      ::then_2763393::
                      do
                        local tmp_2763394 = block_PRIME_2762669(nil)
                        local exp_2762682 = rvNB_2762670(n_2762672)
                        local tmp_2762683 = exp_2762682.tag
                        local tmp_2762684 = tmp_2762683 == "SOME"
                        if tmp_2762684 then
                          local content_2762685 = exp_2762682.payload
                          return content_2762685
                        end
                        local tmp_2762686 = exp_2762682.tag
                        local tmp_2762687 = tmp_2762686 == "NONE"
                        if tmp_2762687 then
                          return empty_2762307
                        else
                          _raise(_Match, "prim-io.sml:210:86")
                        end
                      end
                    end
                    local tmp_2762693 = {tag = "SOME", payload = tmp_2762671}
                    readVec_PRIME_2762310 = tmp_2762693
                    goto cont_2762634
                  end
                  local tmp_2762694 = block_2762288.tag
                  local tmp_2762695 = tmp_2762694 == "SOME"
                  if tmp_2762695 then
                    local tmp_2762749 = readVecNB_2762284.tag
                    local tmp_2762750 = tmp_2762749 == "NONE"
                    if tmp_2762750 then
                      local tmp_2762751 = readArrNB_2762286.tag
                      local tmp_2762752 = tmp_2762751 == "SOME"
                      tmp_2762696 = tmp_2762752
                    else
                      tmp_2762696 = false
                    end
                  else
                    tmp_2762696 = false
                  end
                end
                ::cont_2762748::
                if tmp_2762696 then
                  local block_PRIME_2762697 = block_2762288.payload
                  local raNB_2762698 = readArrNB_2762286.payload
                  local tmp_2762699 = function(n_2762700)
                    local arr_2762708, aslice_2762711, exp_2762712
                    do
                      local tmp_2762702 = n_2762700 < 0
                      if tmp_2762702 then
                        _raise(_Size, "prim-io.sml:217:72")
                      end
                      local tmp_2762704 = param_2761983._Array
                      local tmp_2762705 = tmp_2762704.array
                      local tmp_2762706 = param_2761983.someElem
                      local tmp_2762707 = {n_2762700, tmp_2762706}
                      arr_2762708 = tmp_2762705(tmp_2762707)
                      local tmp_2762709 = param_2761983._ArraySlice
                      local tmp_2762710 = tmp_2762709.full
                      aslice_2762711 = tmp_2762710(arr_2762708)
                      exp_2762712 = raNB_2762698(aslice_2762711)
                      local tmp_2762713 = exp_2762712.tag
                      local tmp_2762714 = tmp_2762713 == "SOME"
                      if tmp_2762714 then
                        goto then_2763395
                      else
                        goto else_2763396
                      end
                    end
                    ::then_2763395::
                    do
                      local actual_2762715 = exp_2762712.payload
                      local tmp_2762716 = param_2761983._ArraySlice
                      local tmp_2762717 = tmp_2762716.vector
                      local tmp_2762718 = param_2761983._ArraySlice
                      local tmp_2762719 = tmp_2762718.slice
                      local tmp_2762720 = {tag = "SOME", payload = actual_2762715}
                      local tmp_2762721 = {arr_2762708, 0, tmp_2762720}
                      local tmp_2762722 = tmp_2762719(tmp_2762721)
                      return tmp_2762717(tmp_2762722)
                    end
                    ::else_2763396::
                    do
                      local tmp_2762724 = exp_2762712.tag
                      local tmp_2762725 = tmp_2762724 == "NONE"
                      if tmp_2762725 then
                        goto then_2763397
                      else
                        _raise(_Match, "prim-io.sml:221:75")
                      end
                    end
                    ::then_2763397::
                    do
                      local exp_2762726
                      do
                        local tmp_2763398 = block_PRIME_2762697(nil)
                        exp_2762726 = raNB_2762698(aslice_2762711)
                        local tmp_2762727 = exp_2762726.tag
                        local tmp_2762728 = tmp_2762727 == "SOME"
                        if tmp_2762728 then
                          goto then_2763399
                        else
                          goto else_2763400
                        end
                      end
                      ::then_2763399::
                      do
                        local actual_2762729 = exp_2762726.payload
                        local tmp_2762730 = param_2761983._ArraySlice
                        local tmp_2762731 = tmp_2762730.vector
                        local tmp_2762732 = param_2761983._ArraySlice
                        local tmp_2762733 = tmp_2762732.slice
                        local tmp_2762734 = {tag = "SOME", payload = actual_2762729}
                        local tmp_2762735 = {arr_2762708, 0, tmp_2762734}
                        local tmp_2762736 = tmp_2762733(tmp_2762735)
                        return tmp_2762731(tmp_2762736)
                      end
                      ::else_2763400::
                      local tmp_2762738 = exp_2762726.tag
                      local tmp_2762739 = tmp_2762738 == "NONE"
                      if tmp_2762739 then
                        return empty_2762307
                      else
                        _raise(_Match, "prim-io.sml:224:89")
                      end
                    end
                  end
                  local tmp_2762747 = {tag = "SOME", payload = tmp_2762699}
                  readVec_PRIME_2762310 = tmp_2762747
                else
                  readVec_PRIME_2762310 = NONE_217
                end
              else
                _raise(_Match, "prim-io.sml:196:38")
              end
            else
              _raise(_Match, "prim-io.sml:194:26")
            end
          end
        end
        ::cont_2762634::
        local readArr_PRIME_2762313
        do
          local tmp_2762311 = readArr_2762282.tag
          local tmp_2762312 = tmp_2762311 == "SOME"
          do
            if tmp_2762312 then
              readArr_PRIME_2762313 = readArr_2762282
              goto cont_2762520
            end
            local tmp_2762521 = readArr_2762282.tag
            local tmp_2762522 = tmp_2762521 == "NONE"
            if tmp_2762522 then
              local tmp_2762523 = readVec_2762280.tag
              local tmp_2762524 = tmp_2762523 == "SOME"
              if tmp_2762524 then
                local rv_2762525 = readVec_2762280.payload
                local tmp_2762526 = function(slice_2762527)
                  local v_2762532
                  do
                    local tmp_2762529 = param_2761983._ArraySlice
                    local tmp_2762530 = tmp_2762529.length
                    local tmp_2762531 = tmp_2762530(slice_2762527)
                    v_2762532 = rv_2762525(tmp_2762531)
                    local tmp_2762533 = param_2761983._ArraySlice
                    local tmp_2762534 = tmp_2762533.base
                    local exp_2762535 = tmp_2762534(slice_2762527)
                    local base_2762536 = exp_2762535[1]
                    local start_2762537 = exp_2762535[2]
                    local tmp_2762538 = param_2761983._Array
                    local tmp_2762539 = tmp_2762538.copyVec
                    local tmp_2762540 = {di = start_2762537, dst = base_2762536, src = v_2762532}
                    local tmp_2763401 = tmp_2762539(tmp_2762540)
                  end
                  local tmp_2762541 = param_2761983._Vector
                  local tmp_2762542 = tmp_2762541.length
                  return tmp_2762542(v_2762532)
                end
                local tmp_2762547 = {tag = "SOME", payload = tmp_2762526}
                readArr_PRIME_2762313 = tmp_2762547
                goto cont_2762520
              end
              local tmp_2762548 = readVec_2762280.tag
              local tmp_2762549 = tmp_2762548 == "NONE"
              if tmp_2762549 then
                local tmp_2762552
                do
                  local tmp_2762550 = block_2762288.tag
                  local tmp_2762551 = tmp_2762550 == "SOME"
                  if tmp_2762551 then
                    local tmp_2762630 = readArrNB_2762286.tag
                    local tmp_2762631 = tmp_2762630 == "SOME"
                    tmp_2762552 = tmp_2762631
                  else
                    tmp_2762552 = false
                  end
                end
                ::cont_2762629::
                local tmp_2762578
                do
                  if tmp_2762552 then
                    local block_PRIME_2762553 = block_2762288.payload
                    local raNB_2762554 = readArrNB_2762286.payload
                    local tmp_2762555 = function(slice_2762556)
                      do
                        local exp_2762558 = raNB_2762554(slice_2762556)
                        local tmp_2762559 = exp_2762558.tag
                        local tmp_2762560 = tmp_2762559 == "SOME"
                        if tmp_2762560 then
                          local actual_2762561 = exp_2762558.payload
                          return actual_2762561
                        end
                        local tmp_2762562 = exp_2762558.tag
                        local tmp_2762563 = tmp_2762562 == "NONE"
                        if tmp_2762563 then
                          goto then_2763402
                        else
                          _raise(_Match, "prim-io.sml:242:72")
                        end
                      end
                      ::then_2763402::
                      do
                        local tmp_2763403 = block_PRIME_2762553(nil)
                        local exp_2762564 = raNB_2762554(slice_2762556)
                        local tmp_2762565 = exp_2762564.tag
                        local tmp_2762566 = tmp_2762565 == "SOME"
                        if tmp_2762566 then
                          local actual_2762567 = exp_2762564.payload
                          return actual_2762567
                        end
                        local tmp_2762568 = exp_2762564.tag
                        local tmp_2762569 = tmp_2762568 == "NONE"
                        if tmp_2762569 then
                          return 0
                        else
                          _raise(_Match, "prim-io.sml:245:86")
                        end
                      end
                    end
                    local tmp_2762575 = {tag = "SOME", payload = tmp_2762555}
                    readArr_PRIME_2762313 = tmp_2762575
                    goto cont_2762520
                  end
                  local tmp_2762576 = block_2762288.tag
                  local tmp_2762577 = tmp_2762576 == "SOME"
                  if tmp_2762577 then
                    local tmp_2762625 = readVecNB_2762284.tag
                    local tmp_2762626 = tmp_2762625 == "SOME"
                    if tmp_2762626 then
                      local tmp_2762627 = readArrNB_2762286.tag
                      local tmp_2762628 = tmp_2762627 == "NONE"
                      tmp_2762578 = tmp_2762628
                    else
                      tmp_2762578 = false
                    end
                  else
                    tmp_2762578 = false
                  end
                end
                ::cont_2762624::
                if tmp_2762578 then
                  local block_PRIME_2762579 = block_2762288.payload
                  local rvNB_2762580 = readVecNB_2762284.payload
                  local tmp_2762581 = function(slice_2762582)
                    local n_2762586, base_2762590, start_2762591, exp_2762592
                    do
                      local tmp_2762584 = param_2761983._ArraySlice
                      local tmp_2762585 = tmp_2762584.length
                      n_2762586 = tmp_2762585(slice_2762582)
                      local tmp_2762587 = param_2761983._ArraySlice
                      local tmp_2762588 = tmp_2762587.base
                      local exp_2762589 = tmp_2762588(slice_2762582)
                      base_2762590 = exp_2762589[1]
                      start_2762591 = exp_2762589[2]
                      exp_2762592 = rvNB_2762580(n_2762586)
                      local tmp_2762593 = exp_2762592.tag
                      local tmp_2762594 = tmp_2762593 == "SOME"
                      if tmp_2762594 then
                        goto then_2763404
                      else
                        goto else_2763405
                      end
                    end
                    ::then_2763404::
                    do
                      local v_2762595 = exp_2762592.payload
                      local tmp_2762596 = param_2761983._Array
                      local tmp_2762597 = tmp_2762596.copyVec
                      local tmp_2762598 = {di = start_2762591, dst = base_2762590, src = v_2762595}
                      local tmp_2763406 = tmp_2762597(tmp_2762598)
                      local tmp_2762599 = param_2761983._Vector
                      local tmp_2762600 = tmp_2762599.length
                      return tmp_2762600(v_2762595)
                    end
                    ::else_2763405::
                    do
                      local tmp_2762602 = exp_2762592.tag
                      local tmp_2762603 = tmp_2762602 == "NONE"
                      if tmp_2762603 then
                        goto then_2763407
                      else
                        _raise(_Match, "prim-io.sml:253:75")
                      end
                    end
                    ::then_2763407::
                    do
                      local exp_2762604
                      do
                        local tmp_2763408 = block_PRIME_2762579(nil)
                        exp_2762604 = rvNB_2762580(n_2762586)
                        local tmp_2762605 = exp_2762604.tag
                        local tmp_2762606 = tmp_2762605 == "SOME"
                        if tmp_2762606 then
                          goto then_2763409
                        else
                          goto else_2763410
                        end
                      end
                      ::then_2763409::
                      do
                        local v_2762607 = exp_2762604.payload
                        local tmp_2762608 = param_2761983._Array
                        local tmp_2762609 = tmp_2762608.copyVec
                        local tmp_2762610 = {di = start_2762591, dst = base_2762590, src = v_2762607}
                        local tmp_2763411 = tmp_2762609(tmp_2762610)
                        local tmp_2762611 = param_2761983._Vector
                        local tmp_2762612 = tmp_2762611.length
                        return tmp_2762612(v_2762607)
                      end
                      ::else_2763410::
                      local tmp_2762614 = exp_2762604.tag
                      local tmp_2762615 = tmp_2762614 == "NONE"
                      if tmp_2762615 then
                        return 0
                      else
                        _raise(_Match, "prim-io.sml:258:89")
                      end
                    end
                  end
                  local tmp_2762623 = {tag = "SOME", payload = tmp_2762581}
                  readArr_PRIME_2762313 = tmp_2762623
                else
                  readArr_PRIME_2762313 = NONE_217
                end
              else
                _raise(_Match, "prim-io.sml:233:38")
              end
            else
              _raise(_Match, "prim-io.sml:231:26")
            end
          end
        end
        ::cont_2762520::
        local readVecNB_PRIME_2762316
        do
          local tmp_2762314 = readVecNB_2762284.tag
          local tmp_2762315 = tmp_2762314 == "SOME"
          do
            if tmp_2762315 then
              readVecNB_PRIME_2762316 = readVecNB_2762284
              goto cont_2762417
            end
            local tmp_2762418 = readVecNB_2762284.tag
            local tmp_2762419 = tmp_2762418 == "NONE"
            if tmp_2762419 then
              local tmp_2762420 = readArrNB_2762286.tag
              local tmp_2762421 = tmp_2762420 == "SOME"
              if tmp_2762421 then
                local raNB_2762422 = readArrNB_2762286.payload
                local tmp_2762423 = function(n_2762424)
                  local arr_2762432, exp_2762436
                  do
                    local tmp_2762426 = n_2762424 < 0
                    if tmp_2762426 then
                      _raise(_Size, "prim-io.sml:271:75")
                    end
                    local tmp_2762428 = param_2761983._Array
                    local tmp_2762429 = tmp_2762428.array
                    local tmp_2762430 = param_2761983.someElem
                    local tmp_2762431 = {n_2762424, tmp_2762430}
                    arr_2762432 = tmp_2762429(tmp_2762431)
                    local tmp_2762433 = param_2761983._ArraySlice
                    local tmp_2762434 = tmp_2762433.full
                    local tmp_2762435 = tmp_2762434(arr_2762432)
                    exp_2762436 = raNB_2762422(tmp_2762435)
                    local tmp_2762437 = exp_2762436.tag
                    local tmp_2762438 = tmp_2762437 == "SOME"
                    if tmp_2762438 then
                      goto then_2763412
                    else
                      goto else_2763413
                    end
                  end
                  ::then_2763412::
                  do
                    local actual_2762439 = exp_2762436.payload
                    local tmp_2762440 = param_2761983._ArraySlice
                    local tmp_2762441 = tmp_2762440.vector
                    local tmp_2762442 = param_2761983._ArraySlice
                    local tmp_2762443 = tmp_2762442.slice
                    local tmp_2762444 = {tag = "SOME", payload = actual_2762439}
                    local tmp_2762445 = {arr_2762432, 0, tmp_2762444}
                    local tmp_2762446 = tmp_2762443(tmp_2762445)
                    local tmp_2762447 = tmp_2762441(tmp_2762446)
                    local tmp_2762448 = {tag = "SOME", payload = tmp_2762447}
                    return tmp_2762448
                  end
                  ::else_2763413::
                  local tmp_2762451 = exp_2762436.tag
                  local tmp_2762452 = tmp_2762451 == "NONE"
                  if tmp_2762452 then
                    return NONE_217
                  else
                    _raise(_Match, "prim-io.sml:274:78")
                  end
                end
                local tmp_2762457 = {tag = "SOME", payload = tmp_2762423}
                readVecNB_PRIME_2762316 = tmp_2762457
                goto cont_2762417
              end
              local tmp_2762458 = readArrNB_2762286.tag
              local tmp_2762459 = tmp_2762458 == "NONE"
              if tmp_2762459 then
                local tmp_2762462
                do
                  local tmp_2762460 = canInput_2762290.tag
                  local tmp_2762461 = tmp_2762460 == "SOME"
                  if tmp_2762461 then
                    local tmp_2762516 = readVec_2762280.tag
                    local tmp_2762517 = tmp_2762516 == "SOME"
                    tmp_2762462 = tmp_2762517
                  else
                    tmp_2762462 = false
                  end
                end
                ::cont_2762515::
                local tmp_2762476
                do
                  if tmp_2762462 then
                    local canInput_PRIME_2762463 = canInput_2762290.payload
                    local rv_2762464 = readVec_2762280.payload
                    local tmp_2762465 = function(n_2762466)
                      do
                        local tmp_2762468 = canInput_PRIME_2762463(nil)
                        if tmp_2762468 then
                          goto then_2763414
                        else
                          return NONE_217
                        end
                      end
                      ::then_2763414::
                      do
                        local tmp_2762469 = rv_2762464(n_2762466)
                        local tmp_2762470 = {tag = "SOME", payload = tmp_2762469}
                        return tmp_2762470
                      end
                    end
                    local tmp_2762473 = {tag = "SOME", payload = tmp_2762465}
                    readVecNB_PRIME_2762316 = tmp_2762473
                    goto cont_2762417
                  end
                  local tmp_2762474 = canInput_2762290.tag
                  local tmp_2762475 = tmp_2762474 == "SOME"
                  if tmp_2762475 then
                    local tmp_2762511 = readVec_2762280.tag
                    local tmp_2762512 = tmp_2762511 == "NONE"
                    if tmp_2762512 then
                      local tmp_2762513 = readArr_2762282.tag
                      local tmp_2762514 = tmp_2762513 == "SOME"
                      tmp_2762476 = tmp_2762514
                    else
                      tmp_2762476 = false
                    end
                  else
                    tmp_2762476 = false
                  end
                end
                ::cont_2762510::
                if tmp_2762476 then
                  local canInput_PRIME_2762477 = canInput_2762290.payload
                  local ra_2762478 = readArr_2762282.payload
                  local tmp_2762479 = function(n_2762480)
                    do
                      local tmp_2762482 = canInput_PRIME_2762477(nil)
                      if tmp_2762482 then
                        goto then_2763415
                      else
                        return NONE_217
                      end
                    end
                    ::then_2763415::
                    do
                      local arr_2762489, actual_2762493, tmp_2762495, tmp_2762497
                      do
                        local tmp_2762483 = n_2762480 < 0
                        if tmp_2762483 then
                          _raise(_Size, "prim-io.sml:289:78")
                        end
                        local tmp_2762485 = param_2761983._Array
                        local tmp_2762486 = tmp_2762485.array
                        local tmp_2762487 = param_2761983.someElem
                        local tmp_2762488 = {n_2762480, tmp_2762487}
                        arr_2762489 = tmp_2762486(tmp_2762488)
                        local tmp_2762490 = param_2761983._ArraySlice
                        local tmp_2762491 = tmp_2762490.full
                        local tmp_2762492 = tmp_2762491(arr_2762489)
                        actual_2762493 = ra_2762478(tmp_2762492)
                        local tmp_2762494 = param_2761983._ArraySlice
                        tmp_2762495 = tmp_2762494.vector
                        local tmp_2762496 = param_2761983._ArraySlice
                        tmp_2762497 = tmp_2762496.slice
                      end
                      local tmp_2762498 = {tag = "SOME", payload = actual_2762493}
                      local tmp_2762499 = {arr_2762489, 0, tmp_2762498}
                      local tmp_2762500 = tmp_2762497(tmp_2762499)
                      local tmp_2762501 = tmp_2762495(tmp_2762500)
                      local tmp_2762502 = {tag = "SOME", payload = tmp_2762501}
                      return tmp_2762502
                    end
                  end
                  local tmp_2762509 = {tag = "SOME", payload = tmp_2762479}
                  readVecNB_PRIME_2762316 = tmp_2762509
                else
                  readVecNB_PRIME_2762316 = NONE_217
                end
              else
                _raise(_Match, "prim-io.sml:269:40")
              end
            else
              _raise(_Match, "prim-io.sml:267:28")
            end
          end
        end
        ::cont_2762417::
        local readArrNB_PRIME_2762319
        do
          local tmp_2762317 = readArrNB_2762286.tag
          local tmp_2762318 = tmp_2762317 == "SOME"
          do
            if tmp_2762318 then
              readArrNB_PRIME_2762319 = readArrNB_2762286
              goto cont_2762322
            end
            local tmp_2762323 = readArrNB_2762286.tag
            local tmp_2762324 = tmp_2762323 == "NONE"
            if tmp_2762324 then
              local tmp_2762325 = readVecNB_2762284.tag
              local tmp_2762326 = tmp_2762325 == "SOME"
              if tmp_2762326 then
                local rvNB_2762327 = readVecNB_2762284.payload
                local tmp_2762328 = function(slice_2762329)
                  local exp_2762334
                  do
                    local tmp_2762331 = param_2761983._ArraySlice
                    local tmp_2762332 = tmp_2762331.length
                    local tmp_2762333 = tmp_2762332(slice_2762329)
                    exp_2762334 = rvNB_2762327(tmp_2762333)
                    local tmp_2762335 = exp_2762334.tag
                    local tmp_2762336 = tmp_2762335 == "SOME"
                    if tmp_2762336 then
                      goto then_2763416
                    else
                      goto else_2763417
                    end
                  end
                  ::then_2763416::
                  do
                    local v_2762337, tmp_2762347
                    do
                      v_2762337 = exp_2762334.payload
                      local tmp_2762338 = param_2761983._ArraySlice
                      local tmp_2762339 = tmp_2762338.base
                      local exp_2762340 = tmp_2762339(slice_2762329)
                      local base_2762341 = exp_2762340[1]
                      local start_2762342 = exp_2762340[2]
                      local tmp_2762343 = param_2761983._Array
                      local tmp_2762344 = tmp_2762343.copyVec
                      local tmp_2762345 = {di = start_2762342, dst = base_2762341, src = v_2762337}
                      local tmp_2763418 = tmp_2762344(tmp_2762345)
                      local tmp_2762346 = param_2761983._Vector
                      tmp_2762347 = tmp_2762346.length
                    end
                    local tmp_2762348 = tmp_2762347(v_2762337)
                    local tmp_2762349 = {tag = "SOME", payload = tmp_2762348}
                    return tmp_2762349
                  end
                  ::else_2763417::
                  local tmp_2762353 = exp_2762334.tag
                  local tmp_2762354 = tmp_2762353 == "NONE"
                  if tmp_2762354 then
                    return NONE_217
                  else
                    _raise(_Match, "prim-io.sml:303:62")
                  end
                end
                local tmp_2762358 = {tag = "SOME", payload = tmp_2762328}
                readArrNB_PRIME_2762319 = tmp_2762358
                goto cont_2762322
              end
              local tmp_2762359 = readVecNB_2762284.tag
              local tmp_2762360 = tmp_2762359 == "NONE"
              if tmp_2762360 then
                local tmp_2762363
                do
                  local tmp_2762361 = canInput_2762290.tag
                  local tmp_2762362 = tmp_2762361 == "SOME"
                  if tmp_2762362 then
                    local tmp_2762413 = readArr_2762282.tag
                    local tmp_2762414 = tmp_2762413 == "SOME"
                    tmp_2762363 = tmp_2762414
                  else
                    tmp_2762363 = false
                  end
                end
                ::cont_2762412::
                local tmp_2762377
                do
                  if tmp_2762363 then
                    local canInput_PRIME_2762364 = canInput_2762290.payload
                    local ra_2762365 = readArr_2762282.payload
                    local tmp_2762366 = function(slice_2762367)
                      do
                        local tmp_2762369 = canInput_PRIME_2762364(nil)
                        if tmp_2762369 then
                          goto then_2763419
                        else
                          return NONE_217
                        end
                      end
                      ::then_2763419::
                      do
                        local tmp_2762370 = ra_2762365(slice_2762367)
                        local tmp_2762371 = {tag = "SOME", payload = tmp_2762370}
                        return tmp_2762371
                      end
                    end
                    local tmp_2762374 = {tag = "SOME", payload = tmp_2762366}
                    readArrNB_PRIME_2762319 = tmp_2762374
                    goto cont_2762322
                  end
                  local tmp_2762375 = canInput_2762290.tag
                  local tmp_2762376 = tmp_2762375 == "SOME"
                  if tmp_2762376 then
                    local tmp_2762408 = readVec_2762280.tag
                    local tmp_2762409 = tmp_2762408 == "SOME"
                    if tmp_2762409 then
                      local tmp_2762410 = readArr_2762282.tag
                      local tmp_2762411 = tmp_2762410 == "NONE"
                      tmp_2762377 = tmp_2762411
                    else
                      tmp_2762377 = false
                    end
                  else
                    tmp_2762377 = false
                  end
                end
                ::cont_2762407::
                if tmp_2762377 then
                  local canInput_PRIME_2762378 = canInput_2762290.payload
                  local rv_2762379 = readVec_2762280.payload
                  local tmp_2762380 = function(slice_2762381)
                    do
                      local tmp_2762383 = canInput_PRIME_2762378(nil)
                      if tmp_2762383 then
                        goto then_2763420
                      else
                        return NONE_217
                      end
                    end
                    ::then_2763420::
                    do
                      local v_2762387
                      do
                        local tmp_2762384 = param_2761983._ArraySlice
                        local tmp_2762385 = tmp_2762384.length
                        local tmp_2762386 = tmp_2762385(slice_2762381)
                        v_2762387 = rv_2762379(tmp_2762386)
                        local tmp_2762388 = param_2761983._ArraySlice
                        local tmp_2762389 = tmp_2762388.base
                        local exp_2762390 = tmp_2762389(slice_2762381)
                        local base_2762391 = exp_2762390[1]
                        local start_2762392 = exp_2762390[2]
                        local tmp_2762393 = param_2761983._Array
                        local tmp_2762394 = tmp_2762393.copyVec
                        local tmp_2762395 = {di = start_2762392, dst = base_2762391, src = v_2762387}
                        local tmp_2763421 = tmp_2762394(tmp_2762395)
                      end
                      local tmp_2762396 = param_2761983._Vector
                      local tmp_2762397 = tmp_2762396.length
                      local tmp_2762398 = tmp_2762397(v_2762387)
                      local tmp_2762399 = {tag = "SOME", payload = tmp_2762398}
                      return tmp_2762399
                    end
                  end
                  local tmp_2762406 = {tag = "SOME", payload = tmp_2762380}
                  readArrNB_PRIME_2762319 = tmp_2762406
                else
                  readArrNB_PRIME_2762319 = NONE_217
                end
              else
                _raise(_Match, "prim-io.sml:301:40")
              end
            else
              _raise(_Match, "prim-io.sml:299:28")
            end
          end
        end
        ::cont_2762322::
        local tmp_2762320 = {avail = avail_2762292, block = block_2762288, canInput = canInput_2762290, chunkSize = chunkSize_2762278, close = close_2762302, endPos = endPos_2762298, getPos = getPos_2762294, ioDesc = ioDesc_2762304, name = name_2762276, readArr = readArr_PRIME_2762313, readArrNB = readArrNB_PRIME_2762319, readVec = readVec_PRIME_2762310, readVecNB = readVecNB_PRIME_2762316, setPos = setPos_2762296, verifyPos = verifyPos_2762300}
        local tmp_2762321 = tmp_2762320
        return tmp_2762321
      end
      local augmentWriter_2762759 = function(a_2762760)
        local name_2762763, chunkSize_2762765, writeVec_2762767, writeArr_2762769, writeVecNB_2762771, writeArrNB_2762773, block_2762775, canOutput_2762777, getPos_2762779, setPos_2762781
        do
          local tmp_2762762 = a_2762760
          name_2762763 = tmp_2762762.name
          local tmp_2762764 = a_2762760
          chunkSize_2762765 = tmp_2762764.chunkSize
          local tmp_2762766 = a_2762760
          writeVec_2762767 = tmp_2762766.writeVec
          local tmp_2762768 = a_2762760
          writeArr_2762769 = tmp_2762768.writeArr
          local tmp_2762770 = a_2762760
          writeVecNB_2762771 = tmp_2762770.writeVecNB
          local tmp_2762772 = a_2762760
          writeArrNB_2762773 = tmp_2762772.writeArrNB
          local tmp_2762774 = a_2762760
          block_2762775 = tmp_2762774.block
          local tmp_2762776 = a_2762760
          canOutput_2762777 = tmp_2762776.canOutput
          local tmp_2762778 = a_2762760
          getPos_2762779 = tmp_2762778.getPos
          local tmp_2762780 = a_2762760
          setPos_2762781 = tmp_2762780.setPos
        end
        local endPos_2762783, verifyPos_2762785, close_2762787, ioDesc_2762789, writeVec_PRIME_2762792
        do
          local tmp_2762782 = a_2762760
          endPos_2762783 = tmp_2762782.endPos
          local tmp_2762784 = a_2762760
          verifyPos_2762785 = tmp_2762784.verifyPos
          local tmp_2762786 = a_2762760
          close_2762787 = tmp_2762786.close
          local tmp_2762788 = a_2762760
          ioDesc_2762789 = tmp_2762788.ioDesc
          local tmp_2762790 = writeVec_2762767.tag
          local tmp_2762791 = tmp_2762790 == "SOME"
          do
            if tmp_2762791 then
              writeVec_PRIME_2762792 = writeVec_2762767
              goto cont_2763046
            end
            local tmp_2763047 = writeVec_2762767.tag
            local tmp_2763048 = tmp_2763047 == "NONE"
            if tmp_2763048 then
              local tmp_2763049 = writeArr_2762769.tag
              local tmp_2763050 = tmp_2763049 == "SOME"
              if tmp_2763050 then
                local wa_2763051 = writeArr_2762769.payload
                local tmp_2763052 = function(slice_2763053)
                  local arr_2763062
                  do
                    local tmp_2763055 = param_2761983._Array
                    local tmp_2763056 = tmp_2763055.array
                    local tmp_2763057 = param_2761983._VectorSlice
                    local tmp_2763058 = tmp_2763057.length
                    local tmp_2763059 = tmp_2763058(slice_2763053)
                    local tmp_2763060 = param_2761983.someElem
                    local tmp_2763061 = {tmp_2763059, tmp_2763060}
                    arr_2763062 = tmp_2763056(tmp_2763061)
                    local tmp_2763063 = param_2761983._ArraySlice
                    local tmp_2763064 = tmp_2763063.copyVec
                    local tmp_2763065 = {di = 0, dst = arr_2763062, src = slice_2763053}
                    local tmp_2763422 = tmp_2763064(tmp_2763065)
                  end
                  local tmp_2763066 = param_2761983._ArraySlice
                  local tmp_2763067 = tmp_2763066.full
                  local tmp_2763068 = tmp_2763067(arr_2763062)
                  return wa_2763051(tmp_2763068)
                end
                local tmp_2763073 = {tag = "SOME", payload = tmp_2763052}
                writeVec_PRIME_2762792 = tmp_2763073
                goto cont_2763046
              end
              local tmp_2763074 = writeArr_2762769.tag
              local tmp_2763075 = tmp_2763074 == "NONE"
              if tmp_2763075 then
                local tmp_2763078
                do
                  local tmp_2763076 = block_2762775.tag
                  local tmp_2763077 = tmp_2763076 == "SOME"
                  if tmp_2763077 then
                    local tmp_2763152 = writeVecNB_2762771.tag
                    local tmp_2763153 = tmp_2763152 == "SOME"
                    tmp_2763078 = tmp_2763153
                  else
                    tmp_2763078 = false
                  end
                end
                ::cont_2763151::
                local tmp_2763104
                do
                  if tmp_2763078 then
                    local block_PRIME_2763079 = block_2762775.payload
                    local wvNB_2763080 = writeVecNB_2762771.payload
                    local tmp_2763081 = function(slice_2763082)
                      do
                        local exp_2763084 = wvNB_2763080(slice_2763082)
                        local tmp_2763085 = exp_2763084.tag
                        local tmp_2763086 = tmp_2763085 == "SOME"
                        if tmp_2763086 then
                          local n_2763087 = exp_2763084.payload
                          return n_2763087
                        end
                        local tmp_2763088 = exp_2763084.tag
                        local tmp_2763089 = tmp_2763088 == "NONE"
                        if tmp_2763089 then
                          goto then_2763423
                        else
                          _raise(_Match, "prim-io.sml:359:64")
                        end
                      end
                      ::then_2763423::
                      do
                        local tmp_2763424 = block_PRIME_2763079(nil)
                        local exp_2763090 = wvNB_2763080(slice_2763082)
                        local tmp_2763091 = exp_2763090.tag
                        local tmp_2763092 = tmp_2763091 == "SOME"
                        if tmp_2763092 then
                          local n_2763093 = exp_2763090.payload
                          return n_2763093
                        end
                        local tmp_2763094 = exp_2763090.tag
                        local tmp_2763095 = tmp_2763094 == "NONE"
                        if tmp_2763095 then
                          return 0
                        else
                          _raise(_Match, "prim-io.sml:362:78")
                        end
                      end
                    end
                    local tmp_2763101 = {tag = "SOME", payload = tmp_2763081}
                    writeVec_PRIME_2762792 = tmp_2763101
                    goto cont_2763046
                  end
                  local tmp_2763102 = block_2762775.tag
                  local tmp_2763103 = tmp_2763102 == "SOME"
                  if tmp_2763103 then
                    local tmp_2763147 = writeVecNB_2762771.tag
                    local tmp_2763148 = tmp_2763147 == "NONE"
                    if tmp_2763148 then
                      local tmp_2763149 = writeArrNB_2762773.tag
                      local tmp_2763150 = tmp_2763149 == "SOME"
                      tmp_2763104 = tmp_2763150
                    else
                      tmp_2763104 = false
                    end
                  else
                    tmp_2763104 = false
                  end
                end
                ::cont_2763146::
                if tmp_2763104 then
                  local block_PRIME_2763105 = block_2762775.payload
                  local waNB_2763106 = writeArrNB_2762773.payload
                  local tmp_2763107 = function(slice_2763108)
                    local arr_2763117, aslice_2763120, tmp_2763122
                    do
                      local tmp_2763110 = param_2761983._Array
                      local tmp_2763111 = tmp_2763110.array
                      local tmp_2763112 = param_2761983._VectorSlice
                      local tmp_2763113 = tmp_2763112.length
                      local tmp_2763114 = tmp_2763113(slice_2763108)
                      local tmp_2763115 = param_2761983.someElem
                      local tmp_2763116 = {tmp_2763114, tmp_2763115}
                      arr_2763117 = tmp_2763111(tmp_2763116)
                      local tmp_2763118 = param_2761983._ArraySlice
                      local tmp_2763119 = tmp_2763118.full
                      aslice_2763120 = tmp_2763119(arr_2763117)
                      local tmp_2763121 = param_2761983._ArraySlice
                      tmp_2763122 = tmp_2763121.copyVec
                    end
                    do
                      local tmp_2763123 = {di = 0, dst = arr_2763117, src = slice_2763108}
                      local tmp_2763425 = tmp_2763122(tmp_2763123)
                      local exp_2763124 = waNB_2763106(aslice_2763120)
                      local tmp_2763125 = exp_2763124.tag
                      local tmp_2763126 = tmp_2763125 == "SOME"
                      if tmp_2763126 then
                        local n_2763127 = exp_2763124.payload
                        return n_2763127
                      end
                      local tmp_2763128 = exp_2763124.tag
                      local tmp_2763129 = tmp_2763128 == "NONE"
                      if tmp_2763129 then
                        goto then_2763426
                      else
                        _raise(_Match, "prim-io.sml:372:67")
                      end
                    end
                    ::then_2763426::
                    do
                      local tmp_2763427 = block_PRIME_2763105(nil)
                      local exp_2763130 = waNB_2763106(aslice_2763120)
                      local tmp_2763131 = exp_2763130.tag
                      local tmp_2763132 = tmp_2763131 == "SOME"
                      if tmp_2763132 then
                        local n_2763133 = exp_2763130.payload
                        return n_2763133
                      end
                      local tmp_2763134 = exp_2763130.tag
                      local tmp_2763135 = tmp_2763134 == "NONE"
                      if tmp_2763135 then
                        return 0
                      else
                        _raise(_Match, "prim-io.sml:375:81")
                      end
                    end
                  end
                  local tmp_2763145 = {tag = "SOME", payload = tmp_2763107}
                  writeVec_PRIME_2762792 = tmp_2763145
                else
                  writeVec_PRIME_2762792 = NONE_217
                end
              else
                _raise(_Match, "prim-io.sml:348:39")
              end
            else
              _raise(_Match, "prim-io.sml:346:27")
            end
          end
        end
        ::cont_2763046::
        local writeArr_PRIME_2762795
        do
          local tmp_2762793 = writeArr_2762769.tag
          local tmp_2762794 = tmp_2762793 == "SOME"
          do
            if tmp_2762794 then
              writeArr_PRIME_2762795 = writeArr_2762769
              goto cont_2762956
            end
            local tmp_2762957 = writeArr_2762769.tag
            local tmp_2762958 = tmp_2762957 == "NONE"
            if tmp_2762958 then
              local tmp_2762959 = writeVec_2762767.tag
              local tmp_2762960 = tmp_2762959 == "SOME"
              if tmp_2762960 then
                local wv_2762961 = writeVec_2762767.payload
                local tmp_2762962 = function(slice_2762963)
                  local tmp_2762965 = param_2761983._ArraySlice
                  local tmp_2762966 = tmp_2762965.vector
                  local v_2762967 = tmp_2762966(slice_2762963)
                  local tmp_2762968 = param_2761983._VectorSlice
                  local tmp_2762969 = tmp_2762968.full
                  local tmp_2762970 = tmp_2762969(v_2762967)
                  return wv_2762961(tmp_2762970)
                end
                local tmp_2762973 = {tag = "SOME", payload = tmp_2762962}
                writeArr_PRIME_2762795 = tmp_2762973
                goto cont_2762956
              end
              local tmp_2762974 = writeVec_2762767.tag
              local tmp_2762975 = tmp_2762974 == "NONE"
              if tmp_2762975 then
                local tmp_2762978
                do
                  local tmp_2762976 = block_2762775.tag
                  local tmp_2762977 = tmp_2762976 == "SOME"
                  if tmp_2762977 then
                    local tmp_2763042 = writeArrNB_2762773.tag
                    local tmp_2763043 = tmp_2763042 == "SOME"
                    tmp_2762978 = tmp_2763043
                  else
                    tmp_2762978 = false
                  end
                end
                ::cont_2763041::
                local tmp_2763004
                do
                  if tmp_2762978 then
                    local block_PRIME_2762979 = block_2762775.payload
                    local waNB_2762980 = writeArrNB_2762773.payload
                    local tmp_2762981 = function(slice_2762982)
                      do
                        local exp_2762984 = waNB_2762980(slice_2762982)
                        local tmp_2762985 = exp_2762984.tag
                        local tmp_2762986 = tmp_2762985 == "SOME"
                        if tmp_2762986 then
                          local n_2762987 = exp_2762984.payload
                          return n_2762987
                        end
                        local tmp_2762988 = exp_2762984.tag
                        local tmp_2762989 = tmp_2762988 == "NONE"
                        if tmp_2762989 then
                          goto then_2763428
                        else
                          _raise(_Match, "prim-io.sml:393:64")
                        end
                      end
                      ::then_2763428::
                      do
                        local tmp_2763429 = block_PRIME_2762979(nil)
                        local exp_2762990 = waNB_2762980(slice_2762982)
                        local tmp_2762991 = exp_2762990.tag
                        local tmp_2762992 = tmp_2762991 == "SOME"
                        if tmp_2762992 then
                          local n_2762993 = exp_2762990.payload
                          return n_2762993
                        end
                        local tmp_2762994 = exp_2762990.tag
                        local tmp_2762995 = tmp_2762994 == "NONE"
                        if tmp_2762995 then
                          return 0
                        else
                          _raise(_Match, "prim-io.sml:396:78")
                        end
                      end
                    end
                    local tmp_2763001 = {tag = "SOME", payload = tmp_2762981}
                    writeArr_PRIME_2762795 = tmp_2763001
                    goto cont_2762956
                  end
                  local tmp_2763002 = block_2762775.tag
                  local tmp_2763003 = tmp_2763002 == "SOME"
                  if tmp_2763003 then
                    local tmp_2763037 = writeVecNB_2762771.tag
                    local tmp_2763038 = tmp_2763037 == "SOME"
                    if tmp_2763038 then
                      local tmp_2763039 = writeArrNB_2762773.tag
                      local tmp_2763040 = tmp_2763039 == "NONE"
                      tmp_2763004 = tmp_2763040
                    else
                      tmp_2763004 = false
                    end
                  else
                    tmp_2763004 = false
                  end
                end
                ::cont_2763036::
                if tmp_2763004 then
                  local block_PRIME_2763005 = block_2762775.payload
                  local wvNB_2763006 = writeVecNB_2762771.payload
                  local tmp_2763007 = function(slice_2763008)
                    local vslice_2763015
                    do
                      local tmp_2763010 = param_2761983._VectorSlice
                      local tmp_2763011 = tmp_2763010.full
                      local tmp_2763012 = param_2761983._ArraySlice
                      local tmp_2763013 = tmp_2763012.vector
                      local tmp_2763014 = tmp_2763013(slice_2763008)
                      vslice_2763015 = tmp_2763011(tmp_2763014)
                      local exp_2763016 = wvNB_2763006(vslice_2763015)
                      local tmp_2763017 = exp_2763016.tag
                      local tmp_2763018 = tmp_2763017 == "SOME"
                      if tmp_2763018 then
                        local n_2763019 = exp_2763016.payload
                        return n_2763019
                      end
                      local tmp_2763020 = exp_2763016.tag
                      local tmp_2763021 = tmp_2763020 == "NONE"
                      if tmp_2763021 then
                        goto then_2763430
                      else
                        _raise(_Match, "prim-io.sml:404:67")
                      end
                    end
                    ::then_2763430::
                    do
                      local tmp_2763431 = block_PRIME_2763005(nil)
                      local exp_2763022 = wvNB_2763006(vslice_2763015)
                      local tmp_2763023 = exp_2763022.tag
                      local tmp_2763024 = tmp_2763023 == "SOME"
                      if tmp_2763024 then
                        local n_2763025 = exp_2763022.payload
                        return n_2763025
                      end
                      local tmp_2763026 = exp_2763022.tag
                      local tmp_2763027 = tmp_2763026 == "NONE"
                      if tmp_2763027 then
                        return 0
                      else
                        _raise(_Match, "prim-io.sml:407:81")
                      end
                    end
                  end
                  local tmp_2763035 = {tag = "SOME", payload = tmp_2763007}
                  writeArr_PRIME_2762795 = tmp_2763035
                else
                  writeArr_PRIME_2762795 = NONE_217
                end
              else
                _raise(_Match, "prim-io.sml:384:39")
              end
            else
              _raise(_Match, "prim-io.sml:382:27")
            end
          end
        end
        ::cont_2762956::
        local writeVecNB_PRIME_2762798
        do
          local tmp_2762796 = writeVecNB_2762771.tag
          local tmp_2762797 = tmp_2762796 == "SOME"
          do
            if tmp_2762797 then
              writeVecNB_PRIME_2762798 = writeVecNB_2762771
              goto cont_2762870
            end
            local tmp_2762871 = writeVecNB_2762771.tag
            local tmp_2762872 = tmp_2762871 == "NONE"
            if tmp_2762872 then
              local tmp_2762873 = writeArrNB_2762773.tag
              local tmp_2762874 = tmp_2762873 == "SOME"
              if tmp_2762874 then
                local waNB_2762875 = writeArrNB_2762773.payload
                local tmp_2762876 = function(slice_2762877)
                  local arr_2762886
                  do
                    local tmp_2762879 = param_2761983._Array
                    local tmp_2762880 = tmp_2762879.array
                    local tmp_2762881 = param_2761983._VectorSlice
                    local tmp_2762882 = tmp_2762881.length
                    local tmp_2762883 = tmp_2762882(slice_2762877)
                    local tmp_2762884 = param_2761983.someElem
                    local tmp_2762885 = {tmp_2762883, tmp_2762884}
                    arr_2762886 = tmp_2762880(tmp_2762885)
                    local tmp_2762887 = param_2761983._ArraySlice
                    local tmp_2762888 = tmp_2762887.copyVec
                    local tmp_2762889 = {di = 0, dst = arr_2762886, src = slice_2762877}
                    local tmp_2763432 = tmp_2762888(tmp_2762889)
                  end
                  local tmp_2762890 = param_2761983._ArraySlice
                  local tmp_2762891 = tmp_2762890.full
                  local tmp_2762892 = tmp_2762891(arr_2762886)
                  return waNB_2762875(tmp_2762892)
                end
                local tmp_2762897 = {tag = "SOME", payload = tmp_2762876}
                writeVecNB_PRIME_2762798 = tmp_2762897
                goto cont_2762870
              end
              local tmp_2762898 = writeArrNB_2762773.tag
              local tmp_2762899 = tmp_2762898 == "NONE"
              if tmp_2762899 then
                local tmp_2762902
                do
                  local tmp_2762900 = canOutput_2762777.tag
                  local tmp_2762901 = tmp_2762900 == "SOME"
                  if tmp_2762901 then
                    local tmp_2762952 = writeVec_2762767.tag
                    local tmp_2762953 = tmp_2762952 == "SOME"
                    tmp_2762902 = tmp_2762953
                  else
                    tmp_2762902 = false
                  end
                end
                ::cont_2762951::
                local tmp_2762916
                do
                  if tmp_2762902 then
                    local canOutput_PRIME_2762903 = canOutput_2762777.payload
                    local wv_2762904 = writeVec_2762767.payload
                    local tmp_2762905 = function(slice_2762906)
                      do
                        local tmp_2762908 = canOutput_PRIME_2762903(nil)
                        if tmp_2762908 then
                          goto then_2763433
                        else
                          return NONE_217
                        end
                      end
                      ::then_2763433::
                      do
                        local tmp_2762909 = wv_2762904(slice_2762906)
                        local tmp_2762910 = {tag = "SOME", payload = tmp_2762909}
                        return tmp_2762910
                      end
                    end
                    local tmp_2762913 = {tag = "SOME", payload = tmp_2762905}
                    writeVecNB_PRIME_2762798 = tmp_2762913
                    goto cont_2762870
                  end
                  local tmp_2762914 = canOutput_2762777.tag
                  local tmp_2762915 = tmp_2762914 == "SOME"
                  if tmp_2762915 then
                    local tmp_2762947 = writeVec_2762767.tag
                    local tmp_2762948 = tmp_2762947 == "NONE"
                    if tmp_2762948 then
                      local tmp_2762949 = writeArr_2762769.tag
                      local tmp_2762950 = tmp_2762949 == "SOME"
                      tmp_2762916 = tmp_2762950
                    else
                      tmp_2762916 = false
                    end
                  else
                    tmp_2762916 = false
                  end
                end
                ::cont_2762946::
                if tmp_2762916 then
                  local canOutput_PRIME_2762917 = canOutput_2762777.payload
                  local wa_2762918 = writeArr_2762769.payload
                  local tmp_2762919 = function(slice_2762920)
                    do
                      local tmp_2762922 = canOutput_PRIME_2762917(nil)
                      if tmp_2762922 then
                        goto then_2763434
                      else
                        return NONE_217
                      end
                    end
                    ::then_2763434::
                    do
                      local arr_2762930
                      do
                        local tmp_2762923 = param_2761983._Array
                        local tmp_2762924 = tmp_2762923.array
                        local tmp_2762925 = param_2761983._VectorSlice
                        local tmp_2762926 = tmp_2762925.length
                        local tmp_2762927 = tmp_2762926(slice_2762920)
                        local tmp_2762928 = param_2761983.someElem
                        local tmp_2762929 = {tmp_2762927, tmp_2762928}
                        arr_2762930 = tmp_2762924(tmp_2762929)
                        local tmp_2762931 = param_2761983._ArraySlice
                        local tmp_2762932 = tmp_2762931.copyVec
                        local tmp_2762933 = {di = 0, dst = arr_2762930, src = slice_2762920}
                        local tmp_2763435 = tmp_2762932(tmp_2762933)
                      end
                      local tmp_2762934 = param_2761983._ArraySlice
                      local tmp_2762935 = tmp_2762934.full
                      local tmp_2762936 = tmp_2762935(arr_2762930)
                      local tmp_2762937 = wa_2762918(tmp_2762936)
                      local tmp_2762938 = {tag = "SOME", payload = tmp_2762937}
                      return tmp_2762938
                    end
                  end
                  local tmp_2762945 = {tag = "SOME", payload = tmp_2762919}
                  writeVecNB_PRIME_2762798 = tmp_2762945
                else
                  writeVecNB_PRIME_2762798 = NONE_217
                end
              else
                _raise(_Match, "prim-io.sml:416:41")
              end
            else
              _raise(_Match, "prim-io.sml:414:29")
            end
          end
        end
        ::cont_2762870::
        local writeArrNB_PRIME_2762801
        do
          local tmp_2762799 = writeArrNB_2762773.tag
          local tmp_2762800 = tmp_2762799 == "SOME"
          do
            if tmp_2762800 then
              writeArrNB_PRIME_2762801 = writeArrNB_2762773
              goto cont_2762804
            end
            local tmp_2762805 = writeArrNB_2762773.tag
            local tmp_2762806 = tmp_2762805 == "NONE"
            if tmp_2762806 then
              local tmp_2762807 = writeVecNB_2762771.tag
              local tmp_2762808 = tmp_2762807 == "SOME"
              if tmp_2762808 then
                local wvNB_2762809 = writeVecNB_2762771.payload
                local tmp_2762810 = function(slice_2762811)
                  local tmp_2762813 = param_2761983._VectorSlice
                  local tmp_2762814 = tmp_2762813.full
                  local tmp_2762815 = param_2761983._ArraySlice
                  local tmp_2762816 = tmp_2762815.vector
                  local tmp_2762817 = tmp_2762816(slice_2762811)
                  local vslice_2762818 = tmp_2762814(tmp_2762817)
                  return wvNB_2762809(vslice_2762818)
                end
                local tmp_2762821 = {tag = "SOME", payload = tmp_2762810}
                writeArrNB_PRIME_2762801 = tmp_2762821
                goto cont_2762804
              end
              local tmp_2762822 = writeVecNB_2762771.tag
              local tmp_2762823 = tmp_2762822 == "NONE"
              if tmp_2762823 then
                local tmp_2762826
                do
                  local tmp_2762824 = canOutput_2762777.tag
                  local tmp_2762825 = tmp_2762824 == "SOME"
                  if tmp_2762825 then
                    local tmp_2762866 = writeArr_2762769.tag
                    local tmp_2762867 = tmp_2762866 == "SOME"
                    tmp_2762826 = tmp_2762867
                  else
                    tmp_2762826 = false
                  end
                end
                ::cont_2762865::
                local tmp_2762840
                do
                  if tmp_2762826 then
                    local canOutput_PRIME_2762827 = canOutput_2762777.payload
                    local wa_2762828 = writeArr_2762769.payload
                    local tmp_2762829 = function(slice_2762830)
                      do
                        local tmp_2762832 = canOutput_PRIME_2762827(nil)
                        if tmp_2762832 then
                          goto then_2763436
                        else
                          return NONE_217
                        end
                      end
                      ::then_2763436::
                      do
                        local tmp_2762833 = wa_2762828(slice_2762830)
                        local tmp_2762834 = {tag = "SOME", payload = tmp_2762833}
                        return tmp_2762834
                      end
                    end
                    local tmp_2762837 = {tag = "SOME", payload = tmp_2762829}
                    writeArrNB_PRIME_2762801 = tmp_2762837
                    goto cont_2762804
                  end
                  local tmp_2762838 = canOutput_2762777.tag
                  local tmp_2762839 = tmp_2762838 == "SOME"
                  if tmp_2762839 then
                    local tmp_2762861 = writeVec_2762767.tag
                    local tmp_2762862 = tmp_2762861 == "SOME"
                    if tmp_2762862 then
                      local tmp_2762863 = writeArr_2762769.tag
                      local tmp_2762864 = tmp_2762863 == "NONE"
                      tmp_2762840 = tmp_2762864
                    else
                      tmp_2762840 = false
                    end
                  else
                    tmp_2762840 = false
                  end
                end
                ::cont_2762860::
                if tmp_2762840 then
                  local canOutput_PRIME_2762841 = canOutput_2762777.payload
                  local wv_2762842 = writeVec_2762767.payload
                  local tmp_2762843 = function(slice_2762844)
                    do
                      local tmp_2762846 = canOutput_PRIME_2762841(nil)
                      if tmp_2762846 then
                        goto then_2763437
                      else
                        return NONE_217
                      end
                    end
                    ::then_2763437::
                    do
                      local tmp_2762847 = param_2761983._VectorSlice
                      local tmp_2762848 = tmp_2762847.full
                      local tmp_2762849 = param_2761983._ArraySlice
                      local tmp_2762850 = tmp_2762849.vector
                      local tmp_2762851 = tmp_2762850(slice_2762844)
                      local vslice_2762852 = tmp_2762848(tmp_2762851)
                      local tmp_2762853 = wv_2762842(vslice_2762852)
                      local tmp_2762854 = {tag = "SOME", payload = tmp_2762853}
                      return tmp_2762854
                    end
                  end
                  local tmp_2762859 = {tag = "SOME", payload = tmp_2762843}
                  writeArrNB_PRIME_2762801 = tmp_2762859
                else
                  writeArrNB_PRIME_2762801 = NONE_217
                end
              else
                _raise(_Match, "prim-io.sml:445:41")
              end
            else
              _raise(_Match, "prim-io.sml:443:29")
            end
          end
        end
        ::cont_2762804::
        local tmp_2762802 = {block = block_2762775, canOutput = canOutput_2762777, chunkSize = chunkSize_2762765, close = close_2762787, endPos = endPos_2762783, getPos = getPos_2762779, ioDesc = ioDesc_2762789, name = name_2762763, setPos = setPos_2762781, verifyPos = verifyPos_2762785, writeArr = writeArr_PRIME_2762795, writeArrNB = writeArrNB_PRIME_2762801, writeVec = writeVec_PRIME_2762792, writeVecNB = writeVecNB_PRIME_2762798}
        local tmp_2762803 = tmp_2762802
        return tmp_2762803
      end
      local tmp_2763156 = {RD = RD_2761986, WR = WR_2761990, augmentReader = augmentReader_2762272, augmentWriter = augmentWriter_2762759, compare = compare_2761985, nullRd = nullRd_2762133, nullWr = nullWr_2762200, openVector = openVector_2761994}
      return tmp_2763156
    end
    return tmp_2761982
  end
  return tmp_2761979
end
LOCAL_2763448[109] = 0x0 & 0xFF
LOCAL_2763448[110] = {all = tmp_2761880, app = tmp_2761881, appi = tmp_2761882, base = tmp_2761883, collate = LOCAL_2763448[15], concat = LOCAL_2763448[16], exists = LOCAL_2763448[17], find = LOCAL_2763448[18], findi = LOCAL_2763448[19], foldl = LOCAL_2763448[20], foldli = LOCAL_2763448[21], foldr = LOCAL_2763448[22], foldri = LOCAL_2763448[23], full = LOCAL_2763448[24], getItem = LOCAL_2763448[25], isEmpty = LOCAL_2763448[26], length = LOCAL_2763448[27], map = LOCAL_2763448[28], mapi = LOCAL_2763448[29], slice = LOCAL_2763448[30], sub = LOCAL_2763448[31], subslice = LOCAL_2763448[32], vector = LOCAL_2763448[33]}
LOCAL_2763448[111] = {all = LOCAL_2763448[34], app = LOCAL_2763448[35], append = LOCAL_2763448[36], appi = LOCAL_2763448[37], collate = LOCAL_2763448[38], concat = LOCAL_2763448[39], exists = LOCAL_2763448[40], find = LOCAL_2763448[41], findi = LOCAL_2763448[42], foldl = LOCAL_2763448[43], foldli = LOCAL_2763448[44], foldr = LOCAL_2763448[45], foldri = LOCAL_2763448[46], fromList = LOCAL_2763448[47], length = LOCAL_2763448[48], map = LOCAL_2763448[49], mapi = LOCAL_2763448[50], maxLen = LOCAL_2763448[51], prepend = LOCAL_2763448[52], sub = LOCAL_2763448[53], tabulate = LOCAL_2763448[54], toList = LOCAL_2763448[55], update = LOCAL_2763448[56]}
LOCAL_2763448[112] = {all = LOCAL_2763448[57], app = LOCAL_2763448[58], appi = LOCAL_2763448[59], base = LOCAL_2763448[60], collate = LOCAL_2763448[61], copy = LOCAL_2763448[62], copyVec = LOCAL_2763448[63], exists = LOCAL_2763448[64], find = LOCAL_2763448[65], findi = LOCAL_2763448[66], foldl = LOCAL_2763448[67], foldli = LOCAL_2763448[68], foldr = LOCAL_2763448[69], foldri = LOCAL_2763448[70], full = LOCAL_2763448[71], getItem = LOCAL_2763448[72], isEmpty = LOCAL_2763448[73], length = LOCAL_2763448[74], modify = LOCAL_2763448[75], modifyi = LOCAL_2763448[76], slice = LOCAL_2763448[77], sub = LOCAL_2763448[78], subslice = LOCAL_2763448[79], update = LOCAL_2763448[80], vector = LOCAL_2763448[81]}
LOCAL_2763448[113] = {all = LOCAL_2763448[82], app = LOCAL_2763448[83], appi = LOCAL_2763448[84], array = LOCAL_2763448[85], collate = LOCAL_2763448[86], copy = LOCAL_2763448[87], copyVec = LOCAL_2763448[88], exists = LOCAL_2763448[89], find = LOCAL_2763448[90], findi = LOCAL_2763448[91], foldl = LOCAL_2763448[92], foldli = LOCAL_2763448[93], foldr = LOCAL_2763448[94], foldri = LOCAL_2763448[95], fromList = LOCAL_2763448[96], fromVector = LOCAL_2763448[97], length = LOCAL_2763448[98], maxLen = LOCAL_2763448[99], modify = LOCAL_2763448[100], modifyi = LOCAL_2763448[101], sub = LOCAL_2763448[102], tabulate = LOCAL_2763448[103], toList = LOCAL_2763448[104], toVector = LOCAL_2763448[105], update = LOCAL_2763448[106], vector = LOCAL_2763448[107]}
LOCAL_2763448[114] = LOCAL_2763448[108]()
LOCAL_2763448[115] = LOCAL_2763448[114](eq_132)
LOCAL_2763448[116] = {_Array = LOCAL_2763448[113], _ArraySlice = LOCAL_2763448[112], _Vector = LOCAL_2763448[111], _VectorSlice = LOCAL_2763448[110], compare = compare_2759830, someElem = LOCAL_2763448[109]}
LOCAL_2763448[117] = LOCAL_2763448[115](LOCAL_2763448[116])
LOCAL_2763448[118] = {all = tmp_2761709, app = tmp_2761710, appi = tmp_2761711, base = tmp_2761712, collate = tmp_2761713, concat = tmp_2761714, exists = tmp_2761715, find = tmp_2761716, findi = tmp_2761717, foldl = tmp_2761718, foldli = tmp_2761719, foldr = tmp_2761720, foldri = tmp_2761721, full = tmp_2761722, getItem = tmp_2761723, isEmpty = tmp_2761724, length = tmp_2761725, map = tmp_2761726, mapi = tmp_2761727, slice = tmp_2761728, sub = tmp_2761729, subslice = tmp_2761730, vector = tmp_2761731}
LOCAL_2763448[119] = {all = tmp_2761732, app = tmp_2761733, append = tmp_2761734, appi = tmp_2761735, collate = tmp_2761736, concat = tmp_2761737, exists = tmp_2761738, find = tmp_2761739, findi = tmp_2761740, foldl = tmp_2761741, foldli = tmp_2761742, foldr = tmp_2761743, foldri = tmp_2761744, fromList = tmp_2761745, length = tmp_2761746, map = tmp_2761747, mapi = tmp_2761748, maxLen = tmp_2761749, prepend = tmp_2761750, sub = tmp_2761751, tabulate = tmp_2761752, toList = tmp_2761753, update = tmp_2761754}
LOCAL_2763448[120] = {all = tmp_2761755, app = tmp_2761756, appi = tmp_2761757, base = tmp_2761758, collate = tmp_2761759, copy = tmp_2761760, copyVec = tmp_2761761, exists = tmp_2761762, find = tmp_2761763, findi = tmp_2761764, foldl = tmp_2761765, foldli = tmp_2761766, foldr = tmp_2761767, foldri = tmp_2761768, full = tmp_2761769, getItem = tmp_2761770, isEmpty = tmp_2761771, length = tmp_2761772, modify = tmp_2761773, modifyi = tmp_2761774, slice = tmp_2761775, sub = tmp_2761776, subslice = tmp_2761777, update = tmp_2761778, vector = tmp_2761779}
LOCAL_2763448[121] = {all = tmp_2761780, app = tmp_2761781, appi = tmp_2761782, array = tmp_2761783, collate = tmp_2761784, copy = tmp_2761785, copyVec = tmp_2761786, exists = tmp_2761787, find = tmp_2761788, findi = tmp_2761789, foldl = tmp_2761790, foldli = tmp_2761791, foldr = tmp_2761792, foldri = tmp_2761793, fromList = tmp_2761794, fromVector = tmp_2761795, length = tmp_2761796, maxLen = tmp_2761797, modify = tmp_2761798, modifyi = tmp_2761799, sub = tmp_2761800, tabulate = tmp_2761801, toList = tmp_2761802, toVector = tmp_2761803, update = tmp_2761804, vector = tmp_2761805}
LOCAL_2763448[122] = LOCAL_2763448[108]()
LOCAL_2763448[123] = LOCAL_2763448[122](eq_132)
LOCAL_2763448[124] = {_Array = LOCAL_2763448[121], _ArraySlice = LOCAL_2763448[120], _Vector = LOCAL_2763448[119], _VectorSlice = LOCAL_2763448[118], compare = compare_2759830, someElem = 0}
LOCAL_2763448[125] = LOCAL_2763448[123](LOCAL_2763448[124])
LOCAL_2763448[126] = {LOCAL_2763448[4]}
LOCAL_2763448[127] = {buffer_mode = LOCAL_2763448[126], name = "<stdout>", writable = tmp_2759822}
LOCAL_2763448[128] = {tag = "LUA_WRITABLE", payload = LOCAL_2763448[127]}
LOCAL_2763448[129] = {LOCAL_2763448[128]}
LOCAL_2763448[130] = LOCAL_2763448[129][1]
LOCAL_2763448[131] = LOCAL_2763448[130].tag
LOCAL_2763448[132] = LOCAL_2763448[131] == "LUA_WRITABLE"
if LOCAL_2763448[132] then
  goto then_2763440
else
  goto else_2763441
end
::then_2763440::
do
  LOCAL_2763448[133] = LOCAL_2763448[130].payload
  LOCAL_2763448[134] = LOCAL_2763448[133].writable
  LOCAL_2763448[135] = LOCAL_2763448[130].payload
  LOCAL_2763448[136] = LOCAL_2763448[135].name
  LOCAL_2763448[137] = table_pack(LOCAL_2763448[134]:write("Hello, Worllllllld\n"))
  LOCAL_2763448[138] = sub_2739429(LOCAL_2763448[137], 0)
  LOCAL_2763448[139] = not LOCAL_2763448[138]
  if LOCAL_2763448[139] then
    goto then_2763442
  else
    LOCAL_2763448[134]:flush()
    return
  end
  ::then_2763442::
  do
    LOCAL_2763448[140] = sub_2739429(LOCAL_2763448[137], 1)
    LOCAL_2763448[141] = _Fail(LOCAL_2763448[140])
    LOCAL_2763448[142] = {cause = LOCAL_2763448[141], ["function"] = "output", name = LOCAL_2763448[136]}
    LOCAL_2763448[143] = {tag = LOCAL_2763448[1], payload = LOCAL_2763448[142]}
    _raise(LOCAL_2763448[143], "text-io.sml:266:46")
  end
end
::else_2763441::
LOCAL_2763448[144] = LOCAL_2763448[130].tag
LOCAL_2763448[145] = LOCAL_2763448[144] == "PRIM_WRITER"
if LOCAL_2763448[145] then
  goto then_2763443
else
  _raise(_Match, "text-io.sml:372:9")
end
::then_2763443::
do
  LOCAL_2763448[146] = LOCAL_2763448[130].payload
  LOCAL_2763448[147] = LOCAL_2763448[146].writer
  LOCAL_2763448[148] = LOCAL_2763448[147]
  LOCAL_2763448[149] = LOCAL_2763448[148].name
  LOCAL_2763448[150] = LOCAL_2763448[130].payload
  LOCAL_2763448[151] = LOCAL_2763448[150].writer
  LOCAL_2763448[152] = LOCAL_2763448[151]
  LOCAL_2763448[153] = LOCAL_2763448[152].writeVec
  LOCAL_2763448[154] = LOCAL_2763448[130].payload
  LOCAL_2763448[155] = LOCAL_2763448[154].buffer
  LOCAL_2763448[156] = LOCAL_2763448[155][1]
  LOCAL_2763448[157] = {"Hello, Worllllllld\n", LOCAL_2763448[156]}
  LOCAL_2763448[158] = revAppend_1832944(LOCAL_2763448[157], nil)
  do
    LOCAL_2763448[160] = _VectorOrArray_fromList(LOCAL_2763448[158])
    LOCAL_2763448[161] = tmp_2759828(LOCAL_2763448[160])
    LOCAL_2763448[159] = LOCAL_2763448[161]
  end
  ::cont_2763219::
  LOCAL_2763448[162] = LOCAL_2763448[153].tag
  LOCAL_2763448[163] = LOCAL_2763448[162] == "SOME"
  if LOCAL_2763448[163] then
    goto then_2763444
  else
    goto else_2763445
  end
  ::then_2763444::
  do
    LOCAL_2763448[164] = LOCAL_2763448[153].payload
    LOCAL_2763448[165] = tmp_2761722(LOCAL_2763448[159])
    LOCAL_2763448[166] = LOCAL_2763448[164](LOCAL_2763448[165])
    LOCAL_2763448[155][1] = nil
    return
  end
  ::else_2763445::
  LOCAL_2763448[167] = LOCAL_2763448[153].tag
  LOCAL_2763448[168] = LOCAL_2763448[167] == "NONE"
  if LOCAL_2763448[168] then
    LOCAL_2763448[169] = {cause = LOCAL_2763448[2], ["function"] = "output", name = LOCAL_2763448[149]}
    LOCAL_2763448[170] = {tag = LOCAL_2763448[1], payload = LOCAL_2763448[169]}
    _raise(LOCAL_2763448[170], "text-io.sml:377:26")
  else
    _raise(_Match, "text-io.sml:375:14")
  end
end
