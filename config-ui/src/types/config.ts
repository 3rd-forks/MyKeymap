interface Action {
  windowGroupID: number
  actionTypeID: number
  remapToKey: string
}
interface Keymap {
  id: number
  name: string
  enable: boolean
  hotkey: string
  parentID: number
  hotkeys: {
    [key: string]: Array<Action>
  }
}

interface Scroll {
  delay1: string
  delay2: string
  onceLineCount: string;
}

interface Mouse {
  delay1: string
  delay2: string
  fastSingle: string
  fastRepeat: string
  slowSingle: string
  slowRepeat: string
}

interface WindowGroup {
  id: number
  name: string
  value: string
  conditionType: number
}

interface Path {
  "key": string
  "value": string
}

interface Options {
  scroll: Scroll
  mouse: Mouse
  windowGroups: Array<WindowGroup>
  path: Array<Path>
  customShellMenu: string
  startup: boolean
  keyMapping: string
  capsAbbr: Array<{[key: string]: Array<Action>}>
  semicolonAbbr: Array<{[key: string]: Array<Action>}>
}

interface Config {
  keymaps: Array<Keymap>
  options: Options
}
