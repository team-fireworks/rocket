// @ts-check
import { defineConfig } from "astro/config";
import starlight from "@astrojs/starlight";

// https://astro.build/config
export default defineConfig({
	site: "https://team-fireworks.github.io",
	base: "/rocket",
	integrations: [
		starlight({
			title: "Rocket",
			social: [
				{
					icon: "github",
					label: "GitHub",
					href: "https://github.com/team-fireworks/rocket",
				},
			],
			customCss: [
				"./src/assets/rocket.css",
				"@fontsource-variable/inconsolata",
				"@fontsource/source-sans-pro/200.css",
				"@fontsource/source-sans-pro/300.css",
				"@fontsource/source-sans-pro/400.css",
				"@fontsource/source-sans-pro/600.css",
				"@fontsource/source-sans-pro/700.css",
				"@fontsource/source-sans-pro/900.css",
			],
			sidebar: [
				{
					label: "Getting Started",
					items: [
						{ label: "Download Rocket", slug: "downloads" },
						{
							label: "Welcome To Rocket",
							slug: "getting-started/welcome-to-rocket",
						},
						{ label: "Keybinds", slug: "getting-started/keybinds" },
						{ label: "Search", slug: "getting-started/search" },
						{ label: "Settings", slug: "getting-started/settings" },
					],
				},
				{
					label: "Core Extensions",
					autogenerate: { directory: "core-extensions" },
				},
				{
					label: "Reference",
					autogenerate: { directory: "reference" },
				},
			],
		}),
	],
});
