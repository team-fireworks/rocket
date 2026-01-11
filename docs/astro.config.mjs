// @ts-check
import { defineConfig } from "astro/config";
import starlight from "@astrojs/starlight";

// https://astro.build/config
export default defineConfig({
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
					label: "Guides",
					items: [
						// Each item here is one entry in the navigation menu.
						{ label: "Example Guide", slug: "guides/example" },
						{ label: "Temp Guide", slug: "temp" },
					],
				},
				{
					label: "Reference",
					autogenerate: { directory: "reference" },
				},
			],
		}),
	],
});
