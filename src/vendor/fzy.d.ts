export = fzy;
export as namespace fzy;
declare namespace fzy {
	export function has_match(needle: string, haystack: string, case_sensitive?: boolean): boolean;
	export function score(needle: string, haystack: string, case_sensitive?: boolean): number;
	export function positions(
		needle: string,
		haystack: string,
		case_sensitive?: boolean,
	): LuaTuple<[positions: number[], score: number]>;
	export function filter(
		needle: string,
		haystack: string[],
		case_sensitive?: boolean,
	): [idx: number, positions: number[], score: number][];
	export function get_score_min(): number;
	export function get_score_max(): number;
	export function get_max_length(): number;
	export function get_score_floor(): number;
	export function get_score_ceiling(): number;
	export function get_implementation_name(): "lua";
}
