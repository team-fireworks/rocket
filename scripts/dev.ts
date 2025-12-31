import { $, type ShellExpression } from "bun";
import path from "node:path";
import fs from "node:fs/promises";

const cwd = process.cwd();
const configInput = path.join(cwd, "rocket.config.json");
const configOutput = path.join(cwd, "temp", "rocket.config.json");
const packageManifest = path.join(cwd, "package.json");
await fs.mkdir(path.dirname(configOutput), { recursive: true });

async function safely(sh: $.ShellPromise): Promise<$.ShellOutput> {
	return sh.nothrow().then((res) => {
		// FIXME: why does rojo return exit code 1 when nothing failed???
		if (res.exitCode === 0 || res.exitCode === 1 || res.exitCode === 130) return res;
		console.error(res.stdout.toString());
		console.error(res.stderr.toString());
		throw `Failed with code ${res.exitCode}`;
	});
}

async function writeDevConfig(isDevScriptRunning: boolean) {
	const parsed = await Bun.file(configInput).json();
	const { name, version } = await Bun.file(packageManifest).json();
	parsed.dev = parsed.dev ?? {};
	parsed.dev.isDevBuild = true;
	parsed.dev.isScriptRunning = isDevScriptRunning;
	parsed.package = { name, version };
	return Bun.write(configOutput, JSON.stringify(parsed));
}

async function watchDevConfig(path: string) {
	const watcher = fs.watch(path);
	for await (const _ of watcher) writeDevConfig(true);
}

const devPromise = Promise.all([
	safely($`bunx rbxtsc --watch`),
	safely($`rojo build --watch --plugin Rocket.rbxm`.quiet()),
	safely($`rojo sourcemap --include-non-scripts --watch --output sourcemap.json`.quiet()),
	safely($`rojo serve serve.project.json`.quiet()),
	watchDevConfig(configInput),
	watchDevConfig(packageManifest),
]);

async function exit(code?: string) {
	process.removeAllListeners();

	if (code) console.log(`\nGot ${code}, stopping dev script...`);
	else console.log(`Stopping dev script...`);

	await writeDevConfig(false);
	await safely($`bunx rbxtsc`.quiet());
	await safely($`rojo build --plugin Epoch.rbxm`.quiet());
	process.exit(0);
}

process.addListener("SIGINT", exit);
process.addListener("SIGTERM", exit);

await writeDevConfig(true);
await devPromise;

exit();
