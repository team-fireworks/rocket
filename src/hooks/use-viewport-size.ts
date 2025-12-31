import { Workspace } from "@rbxts/services";

export function useViewportSize() {
	return Workspace.FindFirstChildOfClass("Camera")?.ViewportSize ?? Vector2.zero;
}
