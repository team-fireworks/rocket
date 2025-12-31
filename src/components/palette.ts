import { RocketApplication, RocketCommand, RocketExtension } from "#/framework";
import { useViewportSize } from "#/hooks/use-viewport-size";
import fzy from "#/vendor/fzy";
import { Atom, Selector } from "@rbxts/charm";
import Iris from "@rbxts/iris";

const EXTENSION_HIGHLIGHTED_CONFIG: Partial<Iris.Config> = {
	ButtonTransparency: 0.5,
	ButtonHoveredTransparency: 0.5,
	ButtonActiveTransparency: 0.25,
};

const EXTENSION_REST_CONFIG: Partial<Iris.Config> = {
	ButtonTransparency: 1,
	ButtonHoveredTransparency: 0.5,
	ButtonActiveTransparency: 0.25,
};

export interface PaletteProps {
	commands: Set<typeof RocketExtension>;
	applications: Set<typeof RocketExtension>;

	extensions: Set<typeof RocketExtension>;
	extensionByName: Map<string, typeof RocketExtension>;
	extensionNames: string[];

	isPaletteVisible: Atom<boolean>;
	isPaletteFocused: Atom<boolean>;
	selectedIndex: Atom<number>;
	search: Atom<string>;
	searchResults: Selector<string[]>;

	run: (cmd: typeof RocketExtension) => void;
}

export function Palette({
	commands,
	applications,

	extensions,
	extensionByName,
	extensionNames,

	isPaletteVisible,
	isPaletteFocused,
	selectedIndex,
	search,
	searchResults,

	run,
}: PaletteProps) {
	const viewportSize = useViewportSize();
	Iris.PushConfig({ WindowPadding: Vector2.zero, ItemSpacing: Vector2.zero, ContentWidth: new UDim(1, 0) });
	const windowSize = viewportSize.div(2);
	Iris.Window(["Rocket Palette", true, false, true, true, true, false, true, true, true], {
		position: windowSize.div(2),
		size: windowSize,
	});

	Iris.PushConfig({ FrameRounding: 0 });
	const input = Iris.InputText(["", "Search for apps and commands..."]);
	Iris.PopConfig();

	const inputField = input.Instance.FindFirstChildOfClass("TextBox");
	search(inputField?.Text ?? "");
	if (!isPaletteFocused() && inputField) {
		isPaletteFocused(true);
		// this bricks your mouse??? how???
		// inputField.CaptureFocus();
	}

	const extensionContainer = Iris.Table([1]);
	// HACK: iris has no proper layouting widgets
	const extensionContainerSize = windowSize.sub(new Vector2(0, 24 * 2));
	extensionContainer.Instance.Size = UDim2.fromOffset(extensionContainerSize.X, extensionContainerSize.Y);
	for (const [i, name] of pairs(searchResults())) {
		const ext = extensionByName.get(name)!;

		Iris.PushConfig(selectedIndex() + 1 === i ? EXTENSION_HIGHLIGHTED_CONFIG : EXTENSION_REST_CONFIG);
		const extensionLabel = commands.has(ext) ? "Command" : applications.has(ext) ? "Application" : "Extension";
		const btn = Iris.Button([`${name}\t<i><font transparency="0.5">${extensionLabel}</font></i>`]);
		const btnInstance = btn.Instance as TextButton;
		btnInstance.Size = new UDim2(1, 0, 0, btnInstance.Size.Height.Offset);
		Iris.PopConfig();

		if (btn.clicked()) run(ext);
	}
	Iris.End();

	Iris.End();
	Iris.PopConfig();
}
