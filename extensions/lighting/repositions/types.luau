export type RepositionState = {
	clockTime: number,
	geographicLatitude: number,
	sunDirection: Vector3,

	cameraTransform: CFrame,
	cameraPosition: Vector3,
	cameraDirection: Vector3,

	mouseTransform: CFrame,
	mousePosition: Vector3,
	mouseDirection: Vector3,
}

export type Reposition = {
	id: string,
	title: string,
	describedBy: string,

	update: (initial: RepositionState, now: RepositionState, gizmos: boolean) -> Vector3?,
}

return nil
