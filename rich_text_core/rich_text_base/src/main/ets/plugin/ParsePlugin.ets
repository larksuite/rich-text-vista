type MarkdownVisitConfiguration = (visit: PluginContext) => void;

type MarkdownStyledStringConfiguration = (producer: PluginContext) => void;

type MarkdownClickConfiguration = (click: PluginContext) => void;

export abstract class BaseVisitHandler {
}

export abstract class BaseProducer {
}

export abstract class Clickable {
}

export class MarkdownPlugin {
  constructor() {
  }

  visit?: object
  producer?: object
  click?: object
}

class PluginContext {
  private instances: MarkdownPlugin = new MarkdownPlugin()

  use(instance: object) {
    if (instance instanceof BaseVisitHandler) {
      this.instances.visit = instance
    }
    if (instance instanceof BaseProducer) {
      this.instances.producer = instance
    }
    if (instance instanceof Clickable) {
      this.instances.click = instance
    }
  }

  getInstances() {
    return this.instances;
  }
}

export function markdownPlugin(visit: MarkdownVisitConfiguration, producer: MarkdownStyledStringConfiguration,
  click?: MarkdownClickConfiguration): MarkdownPlugin {
  const context = new PluginContext();
  visit(context)
  producer(context)
  click?.(context)
  return context.getInstances();
}

