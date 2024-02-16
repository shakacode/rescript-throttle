let useThrottled = (~wait=?, fn) => {
  let ref = fn->Throttle.make(~wait?)->React.useRef
  ref.current
}

let useControlled = (~wait=?, fn) => {
  let ref = fn->Throttle.makeControlled(~wait?)->React.useRef
  ref.current
}
