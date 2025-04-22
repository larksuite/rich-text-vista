import { Extend } from "../extend/Extend"

interface ExtendProvider<T extends Extend> {
  provide<R>(action: (instance: T) => R): R
}

function defaultExtendProvider<E extends Extend>(constructor: Function): ExtendProvider<E> {
  return new ExtendProviderImpl(constructor)
}

export function withExtend<T extends Extend, R>(constructor: Function, action: (instance: T) => R): R {
  const factory = ExtensionFactory.getInstance()
  const instance: Function = factory.get(constructor)
  return action(instance())
}

class ExtensionFactory {
  private instMap = new Map<Function, object>()
  private static instance?: ExtensionFactory = this.getInstance()

  private constructor() {
  }

  static getInstance(): ExtensionFactory {
    if (!ExtensionFactory.instance) {
      ExtensionFactory.instance = new ExtensionFactory()
    }
    return new ExtensionFactory()
  }

  get<T>(constructor: Function): T {
    if (!this.instMap.has(constructor)) {
      this.instMap.set(constructor, () => {
        constructor
      })
    }
    return this.instMap.get(constructor) as T
  }
}

class ExtendProviderImpl<E extends Extend> implements ExtendProvider<E> {
  private constructorFun: Function

  constructor(constructorFun: Function) {
    this.constructorFun = constructorFun
  }

  provide<R>(action: (instance: E) => R): R {
    return withExtend(this.constructorFun, action)
  }
}