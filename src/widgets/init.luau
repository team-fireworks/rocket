local ButtonGroup = require("@self/interactions/ButtonGroup")
local InstantInputText = require("@self/interactions/InstantInputText")

local Frame = require("@self/layouts/Frame")
local List = require("@self/layouts/List")
local ScrollingFrame = require("@self/layouts/ScrollingFrame")

local AspectRatio = require("@self/styles/AspectRatio")
local Flex = require("@self/styles/Flex")
local FlexSpacer = require("@self/styles/FlexSpacer")
local Padding = require("@self/styles/Padding")
local Spacer = require("@self/styles/Spacer")

local Header = require("@self/typography/Header")
local Subtext = require("@self/typography/Subtext")

export type ButtonGroupProps = ButtonGroup.ButtonGroupProps
export type InstantInputTextProps = InstantInputText.InstantInputTextProps

export type FrameProps = Frame.FrameProps
export type ListProps<T> = List.ListProps<T>
export type ScrollingFrameProps = ScrollingFrame.ScrollingFrameProps

export type PaddingProps = Padding.PaddingProps

export type HeaderProps = Header.HeaderProps

return table.freeze({
	ButtonGroup = ButtonGroup,
	InstantInputText = InstantInputText,

	Frame = Frame,
	List = List,
	ScrollingFrame = ScrollingFrame,

	AspectRatio = AspectRatio,
	Flex = Flex,
	FlexSpacer = FlexSpacer,
	Padding = Padding,
	Spacer = Spacer,

	Subtext = Subtext,
	Header = Header,
})
