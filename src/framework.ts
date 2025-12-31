import Iris from "@rbxts/iris";
import { Trove } from "@rbxts/trove";

export class RocketExtension {
	static name: string;
	constructor(
		readonly plugin: Plugin,
		readonly trove: Trove,
	) {}
}

export class RocketCommand extends RocketExtension {
	run(): void {}
}

export class RocketApplication extends RocketExtension {
	render(): void {}
}
