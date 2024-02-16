let useThrottled: (~wait: int=?, 'a => unit) => 'a => unit
let useControlled: (~wait: int=?, 'a => unit) => Throttle.throttled<'a>
