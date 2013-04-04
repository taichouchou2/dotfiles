" cron
let g:alpaca_cron = 1
if exists('g:alpaca_cron') || !exists("*strftime")
  finish
endif
let g:alpaca_cron = 1

let s:save_cpo = &cpo
set cpo&vim

" initialize"{{{
let s:second  = 1
let s:minutes = (s:second * 60)
let s:hour    = (s:minutes * 60)
let s:day     = (s:hour * 24)
let s:week    = (s:day * 7)
let s:cache_name = "alpaca_cron"
"}}}

" script functions"{{{
function! s:set_default_value(dict, key, value) "{{{
  if !has_key(a:dict, a:key)
    let a:dict[a:key] = a:value
  endif
endfunction"}}}

function! s:do_if_has_key(dict, key) "{{{
  if has_key(a:dict, a:key)
    call a:dict[a:key]()
  endif
endfunction"}}}

function! s:diff_time(time, target) "{{{
  return a:time >= a:target
endfunction"}}}

function! s:localtime(year, month, day, hour, minute, second) "{{{
  " days from 0000/01/01
  let l:year  = a:month < 3 ? a:year - 1   : a:year
  let l:month = a:month < 3 ? 12 + a:month : a:month
  let l:days  = 365*l:year + l:year/4 - l:year/100 + l:year/400 + 306*(l:month+1)/10 + a:day - 428

  " days from 0000/01/01 to 1970/01/01
  " 1970/01/01 == 1969/13/01
  let l:ybase    = 1969
  let l:mbase    = 13
  let l:dbase    = 1
  let l:basedays = 365*l:ybase + l:ybase/4 - l:ybase/100 + l:ybase/400 + 306*(l:mbase+1)/10 + l:dbase - 428

  " seconds from 1970/01/01
  return (l:days-l:basedays)*86400 + (a:hour-9)*3600 + a:minute*60 + a:second
endfunction"}}}

function! s:easy_localtime(time_object) "{{{
  let now = split(strftime("%Y:%m:%d:%H:%M:%S", localtime()), ":")
  let kind = ["year", "month", "day", "hour", "minutes", "second"]

  for key in kind
    let time_by_kind = now[index(kind, key)]
    call s:set_default_value(a:time_object, key, time_by_kind)
  endfor
  let t = a:time_object
  let localtime = s:localtime(t["year"], t["month"], t["day"], t["hour"], t["minutes"], t["second"])

  return [a:time_object, localtime]
endfunction"}}}
"}}}

" cron manager "{{{
let s:cron_manager = {
      \ "registered" : [],
      \ }

function! s:cron_manager.register(cron_obj) "{{{
  if !has_key(self, "registered")
    self["registered"] = []
  endif

  return add(self.registered, a:cron_obj)
endfunction"}}}

function! s:cron_manager.unregister(name) "{{{
  if !has_key(self, "registered")
    self["registered"] = []
  endif

  for cron in registered
    if cron.name == a:name
      unlet registered[index(registered, cron)]
    endif
  endfor
endfunction"}}}

function! s:cron_manager.do_cron_obj(cron_obj) "{{{
  let cron = a:cron_obj

  call s:do_if_has_key(cron, "before")

  let cron.done = 0
  if self.now >= cron.time
    call s:do_if_has_key(cron, "run")
    let cron.done = 1
  endif

  call s:do_if_has_key(cron, "after")
endfunction"}}}

function! s:cron_manager.run() "{{{
  let self["now"] = localtime()
  " let self["now"] = s:easy_localtime({"second": 41})

  for cron_obj in self.registered
    call self.do_cron_obj(cron_obj)
  endfor
endfunction"}}}
"}}}

" cron_obj {{{
let s:cron_obj_orig = {
      \ "time" : "",
      \ "time_object" : "",
      \ "name" : "",
      \ "data" : {},
      \ }

function! s:cron_obj_orig.get_cache() "{{{
  return neocomplcache#cache#index_load_from_cache(s:cache_name, self.name)
endfunction"}}}

function s:cron_obj_orig.save_cache() "{{{
  return neocomplcache#cache#save_cache(s:cache_name, self.name, self.time)
endfunction "}}}

function! s:cron_obj_orig.time_initialize() "{{{
  " XXX もっと綺麗な書き方があるはず
  let time_array = s:easy_localtime(self["time_object"])
  let self.time_object = time_array[0]
  let self.time = time_array[1]
endfunction"}}}

function! s:cron_obj_orig.before() "{{{
  if empty(self["time"])
    call self.time_initialize()
  endif
endfunction"}}}

function! s:get_cron_obj(name) "{{{
  let cron_obj = copy(s:cron_obj_orig)
  let cron_obj.name = a:name
  return cron_obj
endfunction"}}}
"}}}

au InsertLeave * call s:cron_manager.run()

let &cpo = s:save_cpo
unlet s:save_cpo

let cron_obj = s:get_cron_obj("test")
let cron_obj.time_object = { "second": 40 }

" cron {{{
function! cron_obj.run() "{{{
  let res = ""
  " while empty(res)
  "   " let res = input("2時間たったので、休憩しません？")
  " endwhile
endfunction"}}}

function! cron_obj.after() "{{{
  if self.done
    let time_object = self.time_object
    let hour = time_object["hour"]
    call alpaca#print_error(hour)
    " call self.time_initialize()
  endif
endfunction"}}}
"}}}

call s:cron_manager.register(cron_obj)
let g:cron_obj = cron_obj
