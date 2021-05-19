type throttled<'a> = {
  invoke: 'a => unit,
  schedule: 'a => unit,
  scheduled: unit => bool,
  cancel: unit => unit,
}

type status = Waiting | Ready

let makeControlled = (~wait=100, fn: 'a => unit): throttled<'a> => {
  let status: ref<status> = ref(Ready)
  let timerId = ref(None)
  let arg = ref(None)

  let schedule = x =>
    switch status.contents {
    | Ready =>
      x->fn
      status := Waiting
      timerId := Some(wait->Js.Global.setTimeout(() => {
            status := Ready
            timerId := None
            switch arg.contents {
            | Some(x) =>
              arg := None
              x->fn
            | None => ignore()
            }
          }, _))
    | Waiting => arg := Some(x)
    }

  let scheduled = () =>
    switch timerId.contents {
    | Some(_) => true
    | None => false
    }

  let cancel = () => {
    switch timerId.contents {
    | Some(id) =>
      id->Js.Global.clearTimeout
      timerId := None
    | None => ignore()
    }
    switch arg.contents {
    | Some(_) => arg := None
    | None => ignore()
    }
    status := Ready
  }

  let invoke = x => {
    cancel()
    x->fn
  }

  {
    invoke: invoke,
    schedule: schedule,
    scheduled: scheduled,
    cancel: cancel,
  }
}

let make = (~wait=?, fn) => makeControlled(~wait?, fn).schedule
