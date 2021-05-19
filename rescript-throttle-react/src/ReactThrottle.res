let useThrottled = (~wait=?, fn) => {
  let ref = React.useRef(Throttle.make(~wait?, fn))
  ref.current
}

let useControlled = (~wait=?, fn) => {
  let ref = React.useRef(Throttle.makeControlled(~wait?, fn))
  ref.current
}
