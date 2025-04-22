import { Extend } from "../extend/Extend"
import { withExtend } from "../provider/ExtendProvider";

export interface ThemeExtendScope<T extends Extend> {}

export interface PropsExtendScope<T extends Extend> {}

export interface ContextExtendScope<T extends Extend> {}

function themeExtendScope<T extends Extend, R>(scope: ThemeExtendScope<T>, constructor: Function,
  action: (instance: T) => R): R {
  return withExtend(constructor, action);
}

function propsExtendScope<T extends Extend, R>(scope: PropsExtendScope<T>, constructor: Function,
  action: (instance: T) => R): R {
  return withExtend(constructor, action)
}

function contextExtendScope<T extends Extend, R>(scope: ContextExtendScope<T>, constructor: Function,
  action: (instance: T) => R): R {
  return withExtend(constructor, action)
}