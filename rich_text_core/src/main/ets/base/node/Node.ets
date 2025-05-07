// Copyright (c) 2024 Bytedance Ltd. and/or its affiliates
// SPDX-License-Identifier: MIT

import { Node as CommonmarkNode } from "commonmark"
import { Extendable } from "../extend/Extendable"

export abstract class Node extends CommonmarkNode implements Extendable {

}