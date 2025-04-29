// Copyright (c) 2024 Bytedance Ltd. and/or its affiliates
// SPDX-License-Identifier: MIT

import { Extend } from "../extend/Extend"
import { ThemeExtendScope, ContextExtendScope, PropsExtendScope } from "../scope/ExtendScope"
import { ThemeData } from "../theme/ThemeData"
import { ContextExtend } from "../extend/ContextExtend"

export interface RichTextExtendScope<P extends Extend> extends ThemeExtendScope<ThemeData>, ContextExtendScope<ContextExtend>, PropsExtendScope<P> {

}